from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt, get_jwt_identity
from backend.models.database import db, Prediction, Feedback, TrainingLog, User
from backend.utils.timezone import get_current_time
from sqlalchemy import func, desc
from datetime import datetime, timedelta
import os
import shutil
from PIL import Image

admin_bp = Blueprint('admin', __name__)

def admin_required():
    """Kiểm tra quyền quản trị viên"""
    claims = get_jwt()
    if claims.get('role') != 'admin':
        return jsonify({'error': 'Không đủ quyền, cần quyền quản trị viên'}), 403
    return None

@admin_bp.route('/dashboard', methods=['GET'])
@jwt_required()
def dashboard():
    """
    Bảng điều khiển quản trị viên - Trả về dữ liệu thống kê
    """
    # Kiểm tra quyền quản trị viên
    current_user_id = get_jwt_identity()
    print(f'🔍 [Admin] Dashboard request from user ID: {current_user_id}')
    
    auth_error = admin_required()
    if auth_error:
        print(f'❌ [Admin] Authorization failed')
        return auth_error
    
    print(f'✅ [Admin] Authorization successful')
    
    try:
        # Tổng số dự đoán
        total_predictions = Prediction.query.count()
        
        # Tổng số phản hồi
        total_feedback = Feedback.query.count()
        
        # Thống kê phản hồi đúng/sai
        correct_feedback = Feedback.query.filter_by(is_correct=True).count()
        incorrect_feedback = Feedback.query.filter_by(is_correct=False).count()
        
        # Độ chính xác (trả về dạng 0-100)
        accuracy = (correct_feedback / total_feedback * 100) if total_feedback > 0 else 0
        
        # Số lượng dự đoán cho mỗi loại trái cây
        fruit_stats = db.session.query(
            Prediction.predicted_label,
            func.count(Prediction.id).label('count')
        ).group_by(Prediction.predicted_label).all()
        
        fruit_distribution = [
            {'label': label, 'count': count}
            for label, count in fruit_stats
        ]
        
        # Sắp xếp theo số lượng dự đoán
        fruit_distribution.sort(key=lambda x: x['count'], reverse=True)
        
        # Xu hướng dự đoán 7 ngày gần đây
        seven_days_ago = get_current_time() - timedelta(days=7)
        recent_predictions = db.session.query(
            func.date(Prediction.created_at).label('date'),
            func.count(Prediction.id).label('count')
        ).filter(Prediction.created_at >= seven_days_ago)\
         .group_by(func.date(Prediction.created_at))\
         .order_by(desc('date'))\
         .all()
        
        prediction_trend = [
            {'date': str(date), 'count': count}
            for date, count in recent_predictions
        ]
        
        # Độ tin cậy trung bình (confidence trong DB đã là 0-1, nhân 100 để thành %)
        avg_confidence = db.session.query(
            func.avg(Prediction.confidence)
        ).scalar() or 0
        avg_confidence = float(avg_confidence) * 100
        
        # Nhật ký huấn luyện mới nhất
        latest_training = TrainingLog.query.order_by(desc(TrainingLog.date_trained)).first()
        
        return jsonify({
            'total_predictions': total_predictions,
            'total_feedback': total_feedback,
            'correct_feedback': correct_feedback,
            'incorrect_feedback': incorrect_feedback,
            'accuracy': round(accuracy, 2),
            'avg_confidence': round(avg_confidence, 2),
            'fruit_distribution': fruit_distribution,
            'prediction_trend': prediction_trend,
            'latest_training': latest_training.to_dict() if latest_training else None
        }), 200
        
    except Exception as e:
        return jsonify({'error': f'Lấy dữ liệu bảng điều khiển thất bại: {str(e)}'}), 500

@admin_bp.route('/history', methods=['GET'])
@jwt_required()
def history_admin():
    """
    Lấy tất cả lịch sử dự đoán
    Query params:
        - page: Số trang (mặc định 1)
        - per_page: Số lượng mỗi trang (mặc định 20)
        - label: Lọc theo nhãn (tùy chọn)
    """
    # Kiểm tra quyền quản trị viên
    auth_error = admin_required()
    if auth_error:
        return auth_error
    
    try:
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        label_filter = request.args.get('label', None)
        
        # Xây dựng truy vấn
        query = Prediction.query
        
        if label_filter:
            query = query.filter_by(predicted_label=label_filter)
        
        # Phân trang
        pagination = query.order_by(desc(Prediction.created_at)).paginate(
            page=page,
            per_page=per_page,
            error_out=False
        )
        
        predictions = [pred.to_dict() for pred in pagination.items]
        
        return jsonify({
            'predictions': predictions,
            'total': pagination.total,
            'page': page,
            'per_page': per_page,
            'total_pages': pagination.pages
        }), 200
        
    except Exception as e:
        return jsonify({'error': f'Lấy lịch sử thất bại: {str(e)}'}), 500

@admin_bp.route('/feedback', methods=['GET'])
@jwt_required()
def feedback_admin():
    """
    Lấy tất cả phản hồi người dùng
    Query params:
        - page: Số trang (mặc định 1)
        - per_page: Số lượng mỗi trang (mặc định 20)
        - is_correct: Lọc đúng/sai (true/false, tùy chọn)
        - is_read: Lọc đã xem/chưa xem (true/false, tùy chọn)
    """
    # Kiểm tra quyền quản trị viên
    auth_error = admin_required()
    if auth_error:
        return auth_error
    
    try:
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        is_correct_filter = request.args.get('is_correct', None)
        is_read_filter = request.args.get('is_read', None)
        
        # Xây dựng truy vấn
        query = Feedback.query
        
        if is_correct_filter is not None:
            is_correct = is_correct_filter.lower() == 'true'
            query = query.filter_by(is_correct=is_correct)
        
        if is_read_filter is not None:
            is_read = is_read_filter.lower() == 'true'
            query = query.filter_by(is_read=is_read)
        
        # Phân trang
        pagination = query.order_by(desc(Feedback.created_at)).paginate(
            page=page,
            per_page=per_page,
            error_out=False
        )
        
        feedbacks = [fb.to_dict() for fb in pagination.items]
        
        # Thống kê số lượng đã xem/chưa xem
        total_unread = Feedback.query.filter_by(is_read=False).count()
        
        return jsonify({
            'feedbacks': feedbacks,
            'total': pagination.total,
            'total_unread': total_unread,
            'page': page,
            'per_page': per_page,
            'total_pages': pagination.pages
        }), 200
        
    except Exception as e:
        return jsonify({'error': f'Lấy phản hồi thất bại: {str(e)}'}), 500

@admin_bp.route('/training_logs', methods=['GET'])
@jwt_required()
def training_logs():
    """Lấy tất cả nhật ký huấn luyện"""
    # Kiểm tra quyền quản trị viên
    auth_error = admin_required()
    if auth_error:
        return auth_error
    
    try:
        logs = TrainingLog.query.order_by(desc(TrainingLog.date_trained)).all()
        return jsonify({
            'training_logs': [log.to_dict() for log in logs]
        }), 200
    except Exception as e:
        return jsonify({'error': f'Lấy nhật ký huấn luyện thất bại: {str(e)}'}), 500

@admin_bp.route('/feedback/<int:feedback_id>/mark_read', methods=['PUT'])
@jwt_required()
def mark_feedback_read(feedback_id):
    """
    Đánh dấu feedback đã xem/chưa xem
    Body: {
        "is_read": true/false
    }
    """
    # Kiểm tra quyền quản trị viên
    auth_error = admin_required()
    if auth_error:
        return auth_error
    
    try:
        data = request.get_json()
        if data is None or 'is_read' not in data:
            return jsonify({'error': 'Thiếu tham số is_read'}), 400
        
        feedback = Feedback.query.get(feedback_id)
        if not feedback:
            return jsonify({'error': 'Không tìm thấy phản hồi'}), 404
        
        feedback.is_read = data['is_read']
        db.session.commit()
        
        return jsonify({
            'message': 'Cập nhật trạng thái thành công',
            'feedback': feedback.to_dict()
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': f'Cập nhật trạng thái thất bại: {str(e)}'}), 500

@admin_bp.route('/feedback/mark_all_read', methods=['PUT'])
@jwt_required()
def mark_all_feedback_read():
    """Đánh dấu tất cả feedback là đã xem"""
    # Kiểm tra quyền quản trị viên
    auth_error = admin_required()
    if auth_error:
        return auth_error
    
    try:
        Feedback.query.filter_by(is_read=False).update({'is_read': True})
        db.session.commit()
        
        return jsonify({
            'message': 'Đã đánh dấu tất cả phản hồi là đã xem'
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': f'Cập nhật trạng thái thất bại: {str(e)}'}), 500

@admin_bp.route('/users', methods=['GET'])
@jwt_required()
def get_users():
    """Lấy danh sách tất cả người dùng"""
    # Kiểm tra quyền quản trị viên
    auth_error = admin_required()
    if auth_error:
        return auth_error
    
    try:
        users = User.query.all()
        return jsonify({
            'users': [user.to_dict() for user in users]
        }), 200
    except Exception as e:
        return jsonify({'error': f'Lấy danh sách người dùng thất bại: {str(e)}'}), 500

@admin_bp.route('/feedback/<int:feedback_id>/add_to_training', methods=['POST'])
@jwt_required()
def add_image_to_training(feedback_id):
    """
    Thêm hình ảnh từ feedback vào training dataset
    Body: {
        "correct_label": "tên_loại_trái_cây"  # Label đúng để lưu vào thư mục tương ứng
    }
    """
    # Kiểm tra quyền quản trị viên
    auth_error = admin_required()
    if auth_error:
        return auth_error
    
    try:
        data = request.get_json()
        if not data or 'correct_label' not in data:
            return jsonify({'error': 'Thiếu tham số correct_label'}), 400
        
        correct_label = data['correct_label']
        
        # Danh sách các loại trái cây hợp lệ
        VALID_LABELS = [
            'buoi_da_xanh',
            'cam_sanh_ha_giang',
            'chom_chom_long_khanh',
            'mang_cut_lai_thieu',
            'nhan_long_hung_yen',
            'sau_rieng_ri6',
            'thanh_long_binh_thuan',
            'vai_thieu_luc_ngan',
            'vu_sua_lo_ren',
            'xoai_cat_hoa_loc'
        ]
        
        if correct_label not in VALID_LABELS:
            return jsonify({'error': f'Label không hợp lệ. Phải là một trong: {", ".join(VALID_LABELS)}'}), 400
        
        # Lấy feedback
        feedback = Feedback.query.get(feedback_id)
        if not feedback:
            return jsonify({'error': 'Không tìm thấy phản hồi'}), 404
        
        # Lấy prediction liên quan
        prediction = feedback.prediction
        if not prediction or not prediction.image_path:
            return jsonify({'error': 'Không tìm thấy hình ảnh'}), 404
        
        # Đường dẫn hình ảnh gốc
        source_image_path = prediction.image_path
        if not os.path.exists(source_image_path):
            return jsonify({'error': 'File hình ảnh không tồn tại'}), 404
        
        # Tạo thư mục đích (data/train/correct_label/)
        train_dir = os.path.join('data', 'train', correct_label)
        os.makedirs(train_dir, exist_ok=True)
        
        # Tạo tên file mới với timestamp để tránh trùng lặp
        timestamp = get_current_time().strftime('%Y%m%d_%H%M%S')
        file_extension = os.path.splitext(source_image_path)[1]
        new_filename = f'user_feedback_{feedback_id}_{timestamp}{file_extension}'
        dest_image_path = os.path.join(train_dir, new_filename)
        
        # Kiểm tra và resize ảnh nếu cần (để đảm bảo chất lượng đồng nhất)
        try:
            img = Image.open(source_image_path)
            
            # Chuyển đổi sang RGB nếu cần (xử lý PNG với alpha channel)
            if img.mode in ('RGBA', 'LA', 'P'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'P':
                    img = img.convert('RGBA')
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            # Lưu ảnh với chất lượng cao
            img.save(dest_image_path, 'JPEG', quality=95)
            
        except Exception as img_error:
            # Nếu xử lý ảnh thất bại, copy trực tiếp
            shutil.copy2(source_image_path, dest_image_path)
        
        # Cập nhật feedback để đánh dấu đã thêm vào training
        feedback.added_to_training = True
        feedback.training_label = correct_label
        feedback.added_to_training_at = get_current_time()
        db.session.commit()
        
        # Đếm số lượng ảnh hiện tại trong thư mục
        image_count = len([f for f in os.listdir(train_dir) 
                          if f.lower().endswith(('.jpg', '.jpeg', '.png'))])
        
        return jsonify({
            'message': 'Đã thêm hình ảnh vào training dataset thành công',
            'feedback_id': feedback_id,
            'correct_label': correct_label,
            'saved_path': dest_image_path,
            'total_images_in_category': image_count
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': f'Thêm hình ảnh thất bại: {str(e)}'}), 500


