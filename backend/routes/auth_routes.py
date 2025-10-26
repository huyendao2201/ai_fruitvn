from flask import Blueprint, request, jsonify
from flask_jwt_extended import (
    create_access_token, 
    create_refresh_token,
    jwt_required, 
    get_jwt_identity,
    get_jwt
)
from backend.models.database import db, User
from datetime import timedelta

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register_admin', methods=['POST'])
def register_admin():
    """
    Đăng ký tài khoản quản trị viên
    Body: {
        "username": "admin",
        "password": "password123"
    }
    """
    try:
        data = request.get_json()
        
        if not data or 'username' not in data or 'password' not in data:
            return jsonify({'error': 'Thiếu tên người dùng hoặc mật khẩu'}), 400
        
        username = data['username']
        password = data['password']
        
        # Kiểm tra người dùng đã tồn tại chưa
        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            return jsonify({'error': 'Tên người dùng đã tồn tại'}), 400
        
        # Tạo người dùng quản trị viên
        new_admin = User(username=username, password=password, role='admin')
        db.session.add(new_admin)
        db.session.commit()
        
        return jsonify({
            'message': 'Tạo tài khoản quản trị viên thành công',
            'user': new_admin.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': f'Đăng ký thất bại: {str(e)}'}), 500

@auth_bp.route('/login_admin', methods=['POST'])
def login_admin():
    """
    Đăng nhập quản trị viên
    Body: {
        "username": "admin",
        "password": "password123"
    }
    """
    try:
        data = request.get_json()
        
        if not data or 'username' not in data or 'password' not in data:
            return jsonify({'error': 'Thiếu tên người dùng hoặc mật khẩu'}), 400
        
        username = data['username']
        password = data['password']
        
        # Tìm người dùng
        user = User.query.filter_by(username=username).first()
        
        if not user or not user.check_password(password):
            return jsonify({'error': 'Tên người dùng hoặc mật khẩu không đúng'}), 401
        
        # Kiểm tra có phải quản trị viên không
        if user.role != 'admin':
            return jsonify({'error': 'Không đủ quyền, chỉ quản trị viên mới có thể đăng nhập'}), 403
        
        # Tạo access token và refresh token
        access_token = create_access_token(
            identity=user.id,
            additional_claims={'role': user.role},
            expires_delta=timedelta(hours=24)
        )
        
        refresh_token = create_refresh_token(
            identity=user.id,
            additional_claims={'role': user.role},
            expires_delta=timedelta(days=30)
        )
        
        print(f'✅ [Auth] Login successful for user: {username} (ID: {user.id})')
        print(f'🔑 [Auth] Access token created: {access_token[:20]}...')
        print(f'🔄 [Auth] Refresh token created: {refresh_token[:20]}...')
        
        return jsonify({
            'message': 'Đăng nhập thành công',
            'access_token': access_token,
            'refresh_token': refresh_token,
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        return jsonify({'error': f'Đăng nhập thất bại: {str(e)}'}), 500

@auth_bp.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    """
    Làm mới access token bằng refresh token
    Header: Authorization: Bearer <refresh_token>
    """
    try:
        current_user_id = get_jwt_identity()
        claims = get_jwt()
        
        # Tạo access token mới
        new_access_token = create_access_token(
            identity=current_user_id,
            additional_claims={'role': claims.get('role')},
            expires_delta=timedelta(hours=24)
        )
        
        print(f'🔄 [Auth] Token refreshed for user ID: {current_user_id}')
        print(f'🔑 [Auth] New access token: {new_access_token[:20]}...')
        
        return jsonify({
            'access_token': new_access_token
        }), 200
        
    except Exception as e:
        return jsonify({'error': f'Làm mới token thất bại: {str(e)}'}), 500

@auth_bp.route('/logout_admin', methods=['POST'])
@jwt_required()
def logout_admin():
    """
    Đăng xuất quản trị viên
    Lưu ý: JWT là stateless, thực tế không cần xử lý phía server
    Client chỉ cần xóa token
    """
    return jsonify({'message': 'Đăng xuất thành công'}), 200

@auth_bp.route('/verify_token', methods=['GET'])
@jwt_required()
def verify_token():
    """Xác thực token có hợp lệ không"""
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    if not user:
        return jsonify({'error': 'Người dùng không tồn tại'}), 404
    
    return jsonify({
        'valid': True,
        'user': user.to_dict()
    }), 200
