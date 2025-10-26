from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()

class User(db.Model):
    """Bảng người dùng"""
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False, index=True)
    password = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(20), default='user', nullable=False)  # 'user' hoặc 'admin'
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    
    # Quan hệ
    predictions = db.relationship('Prediction', backref='user', lazy=True, cascade='all, delete-orphan')
    
    def __init__(self, username, password, role='user'):
        self.username = username
        self.password = generate_password_hash(password)
        self.role = role
    
    def check_password(self, password):
        """Xác thực mật khẩu"""
        return check_password_hash(self.password, password)
    
    def to_dict(self):
        """Chuyển đổi sang dictionary"""
        return {
            'id': self.id,
            'username': self.username,
            'role': self.role,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }

class Prediction(db.Model):
    """Bảng bản ghi dự đoán"""
    __tablename__ = 'predictions'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)  # Cho phép người dùng ẩn danh
    image_path = db.Column(db.String(500), nullable=False)
    predicted_label = db.Column(db.String(100), nullable=False)
    confidence = db.Column(db.Float, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)
    
    # Quan hệ
    feedbacks = db.relationship('Feedback', backref='prediction', lazy=True, cascade='all, delete-orphan')
    
    def to_dict(self):
        """Chuyển đổi sang dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'image_path': self.image_path,
            'predicted_label': self.predicted_label,
            'confidence': float(self.confidence),
            'created_at': self.created_at.isoformat() if self.created_at else None
        }

class Feedback(db.Model):
    """Bảng phản hồi người dùng"""
    __tablename__ = 'feedback'
    
    id = db.Column(db.Integer, primary_key=True)
    prediction_id = db.Column(db.Integer, db.ForeignKey('predictions.id'), nullable=False)
    comment = db.Column(db.Text, nullable=True)
    is_correct = db.Column(db.Boolean, nullable=False)
    is_read = db.Column(db.Boolean, default=False, nullable=False, index=True)  # Trạng thái đã xem
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)
    
    # Trường mới cho training dataset
    added_to_training = db.Column(db.Boolean, default=False, nullable=False, index=True)  # Đã thêm vào training chưa
    training_label = db.Column(db.String(100), nullable=True)  # Label đúng khi thêm vào training
    added_to_training_at = db.Column(db.DateTime, nullable=True)  # Thời gian thêm vào training
    
    def to_dict(self):
        """Chuyển đổi sang dictionary"""
        return {
            'id': self.id,
            'prediction_id': self.prediction_id,
            'comment': self.comment,
            'is_correct': self.is_correct,
            'is_read': self.is_read,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'prediction': self.prediction.to_dict() if self.prediction else None,
            'added_to_training': self.added_to_training,
            'training_label': self.training_label,
            'added_to_training_at': self.added_to_training_at.isoformat() if self.added_to_training_at else None
        }

class TrainingLog(db.Model):
    """Bảng nhật ký huấn luyện mô hình"""
    __tablename__ = 'training_logs'
    
    id = db.Column(db.Integer, primary_key=True)
    model_version = db.Column(db.String(50), nullable=False)
    accuracy = db.Column(db.Float, nullable=False)
    loss = db.Column(db.Float, nullable=False)
    val_accuracy = db.Column(db.Float, nullable=True)
    val_loss = db.Column(db.Float, nullable=True)
    epochs = db.Column(db.Integer, nullable=True)
    date_trained = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    notes = db.Column(db.Text, nullable=True)
    
    def to_dict(self):
        """Chuyển đổi sang dictionary"""
        return {
            'id': self.id,
            'model_version': self.model_version,
            'accuracy': float(self.accuracy),
            'loss': float(self.loss),
            'val_accuracy': float(self.val_accuracy) if self.val_accuracy else None,
            'val_loss': float(self.val_loss) if self.val_loss else None,
            'epochs': self.epochs,
            'date_trained': self.date_trained.isoformat() if self.date_trained else None,
            'notes': self.notes
        }

def init_db(app):
    """Khởi tạo cơ sở dữ liệu"""
    db.init_app(app)
    with app.app_context():
        db.create_all()
        print("Database tables created successfully!")

def create_default_admin(app):
    """Tạo tài khoản quản trị viên mặc định"""
    with app.app_context():
        admin = User.query.filter_by(username='admin').first()
        if not admin:
            admin = User(username='admin', password='admin123', role='admin')
            db.session.add(admin)
            db.session.commit()
            print("Default admin account created! Username: admin, Password: admin123")
        else:
            print("Admin account already exists")

