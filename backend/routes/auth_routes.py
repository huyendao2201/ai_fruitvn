from flask import Blueprint, request, jsonify, session
from backend.models.database import db, User

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
        
        # Lưu thông tin vào session
        session['user_id'] = user.id
        session['username'] = user.username
        session['role'] = user.role
        
        print(f'✅ [Auth] Login successful for user: {username} (ID: {user.id})')
        
        return jsonify({
            'message': 'Đăng nhập thành công',
            'user': user.to_dict()
        }), 200
        
    except Exception as e:
        return jsonify({'error': f'Đăng nhập thất bại: {str(e)}'}), 500

@auth_bp.route('/logout_admin', methods=['POST'])
def logout_admin():
    """
    Đăng xuất quản trị viên
    """
    session.clear()
    return jsonify({'message': 'Đăng xuất thành công'}), 200

@auth_bp.route('/verify_session', methods=['GET'])
def verify_session():
    """Xác thực session có hợp lệ không"""
    if 'user_id' not in session:
        return jsonify({'error': 'Chưa đăng nhập'}), 401
    
    user_id = session.get('user_id')
    user = User.query.get(user_id)
    
    if not user:
        return jsonify({'error': 'Người dùng không tồn tại'}), 404
    
    return jsonify({
        'valid': True,
        'user': user.to_dict()
    }), 200
