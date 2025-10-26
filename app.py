"""
File ứng dụng Flask chính
Backend Hệ thống Nhận diện Trái cây Việt Nam
"""
from flask import Flask, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from backend.config import config
from backend.models.database import db, init_db, create_default_admin
from backend.routes import register_routes
import os

def create_app(config_name='development'):
    """Tạo ứng dụng Flask"""
    app = Flask(__name__)
    
    # Tải cấu hình
    app.config.from_object(config[config_name])
    
    # Bật CORS
    CORS(app, resources={r"/api/*": {"origins": "*"}})
    
    # Khởi tạo JWT
    jwt = JWTManager(app)
    
    # Khởi tạo cơ sở dữ liệu
    init_db(app)
    
    # Đăng ký routes
    register_routes(app)
    
    # Tạo thư mục tải lên
    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
    
    # Endpoint kiểm tra sức khỏe
    @app.route('/api/health', methods=['GET'])
    def health_check():
        return jsonify({
            'status': 'healthy',
            'message': 'API Hệ thống Nhận diện Trái cây Việt Nam đang hoạt động bình thường'
        }), 200
    
    # Đường dẫn gốc
    @app.route('/', methods=['GET'])
    def index():
        return jsonify({
            'name': 'API Hệ thống Nhận diện Trái cây Việt Nam',
            'version': '1.0.0',
            'endpoints': {
                'health': '/api/health',
                'predict': '/api/predict',
                'feedback': '/api/feedback_user',
                'auth': {
                    'register_admin': '/api/auth/register_admin',
                    'login_admin': '/api/auth/login_admin',
                    'logout_admin': '/api/auth/logout_admin'
                },
                'admin': {
                    'dashboard': '/api/admin/dashboard',
                    'history': '/api/admin/history',
                    'feedback': '/api/admin/feedback',
                    'training_logs': '/api/admin/training_logs'
                }
            }
        }), 200
    
    # Xử lý lỗi
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Endpoint không tồn tại'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Lỗi máy chủ nội bộ'}), 500
    
    @jwt.invalid_token_loader
    def invalid_token_callback(error):
        return jsonify({'error': 'Token truy cập không hợp lệ'}), 401
    
    @jwt.expired_token_loader
    def expired_token_callback(jwt_header, jwt_data):
        return jsonify({'error': 'Token truy cập đã hết hạn'}), 401
    
    @jwt.unauthorized_loader
    def missing_token_callback(error):
        return jsonify({'error': 'Thiếu token truy cập'}), 401
    
    return app

if __name__ == '__main__':
    app = create_app()
    
    # Tạo tài khoản quản trị viên mặc định
    with app.app_context():
        create_default_admin(app)
    
    print("=" * 60)
    print("🍉 Đang khởi động API Hệ thống Nhận diện Trái cây Việt Nam...")
    print("=" * 60)
    print(f"📍 Địa chỉ máy chủ: http://localhost:5000")
    print(f"📚 Tài liệu API: http://localhost:5000/")
    print(f"💚 Kiểm tra sức khỏe: http://localhost:5000/api/health")
    print("=" * 60)
    
    app.run(host='0.0.0.0', port=5000, debug=True)


