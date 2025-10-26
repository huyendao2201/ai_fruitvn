from flask import Blueprint, request, jsonify, send_from_directory, current_app
from backend.models.database import db, Prediction, Feedback
from backend.utils.model_utils import classifier
from backend.utils.file_utils import allowed_file, save_upload_file, get_file_url
from werkzeug.utils import secure_filename
import os

prediction_bp = Blueprint('prediction', __name__)

@prediction_bp.route('/predict', methods=['POST'])
def predict():
    """
    Dự đoán loại trái cây
    Form Data:
        - image: File hình ảnh
        - user_id: ID người dùng (tùy chọn)
    """
    try:
        # Kiểm tra có file không
        if 'image' not in request.files:
            return jsonify({'error': 'Chưa tải lên hình ảnh'}), 400
        
        file = request.files['image']
        
        if file.filename == '':
            return jsonify({'error': 'Chưa chọn file'}), 400
        
        if not allowed_file(file.filename):
            return jsonify({'error': 'Định dạng file không được hỗ trợ, vui lòng tải lên hình ảnh PNG, JPG, JPEG hoặc GIF'}), 400
        
        # Lưu file
        file_path = save_upload_file(file)
        
        # Thực hiện dự đoán
        result = classifier.predict(file_path)
        
        # Lấy ID người dùng (nếu có)
        user_id = request.form.get('user_id', None)
        if user_id:
            user_id = int(user_id)
        
        # Lưu bản ghi dự đoán vào cơ sở dữ liệu
        prediction_record = Prediction(
            user_id=user_id,
            image_path=file_path,
            predicted_label=result['label'],
            confidence=result['confidence']
        )
        db.session.add(prediction_record)
        db.session.commit()
        
        # Tạo URL hình ảnh
        image_url = get_file_url(file_path, base_url='/api/uploads')
        
        return jsonify({
            'prediction_id': prediction_record.id,
            'label': result['label'],
            'label_vn': result['label_vn'],
            'confidence': result['confidence'],
            'image_url': image_url,
            'all_predictions': result['all_predictions'][:5]  # Trả về 5 kết quả dự đoán đầu tiên
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': f'Dự đoán thất bại: {str(e)}'}), 500

@prediction_bp.route('/feedback_user', methods=['POST'])
def feedback_user():
    """
    Người dùng gửi phản hồi
    Body: {
        "prediction_id": 1,
        "is_correct": true,
        "comment": "Nhận diện chính xác"
    }
    """
    try:
        data = request.get_json()
        
        if not data or 'prediction_id' not in data or 'is_correct' not in data:
            return jsonify({'error': 'Thiếu tham số bắt buộc'}), 400
        
        prediction_id = data['prediction_id']
        is_correct = data['is_correct']
        comment = data.get('comment', '')
        
        # Kiểm tra bản ghi dự đoán có tồn tại không
        prediction = Prediction.query.get(prediction_id)
        if not prediction:
            return jsonify({'error': 'Bản ghi dự đoán không tồn tại'}), 404
        
        # Tạo bản ghi phản hồi
        feedback = Feedback(
            prediction_id=prediction_id,
            is_correct=is_correct,
            comment=comment
        )
        db.session.add(feedback)
        db.session.commit()
        
        return jsonify({
            'message': 'Gửi phản hồi thành công',
            'feedback': feedback.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': f'Gửi phản hồi thất bại: {str(e)}'}), 500

@prediction_bp.route('/uploads/<path:filename>', methods=['GET'])
def serve_upload(filename):
    """Cung cấp truy cập hình ảnh đã tải lên"""
    upload_folder = current_app.config.get('UPLOAD_FOLDER', 'uploads')
    return send_from_directory(upload_folder, filename)


