"""
Routes package initialization
Đăng ký tất cả các routes cho ứng dụng Flask
"""

def register_routes(app):
    """Đăng ký tất cả các routes"""
    from .auth_routes import auth_bp
    from .prediction_routes import prediction_bp
    from .admin_routes import admin_bp
    
    # Đăng ký blueprints
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(prediction_bp, url_prefix='/api')
    app.register_blueprint(admin_bp, url_prefix='/api/admin')
    
    print("[OK] Da dang ky tat ca routes thanh cong!")

