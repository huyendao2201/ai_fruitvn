import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Lớp cấu hình cơ bản"""
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'jwt-secret-key-change-in-production')
    
    # Cấu hình cơ sở dữ liệu
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = int(os.getenv('DB_PORT', 3306))
    DB_USER = os.getenv('DB_USER', 'root')
    DB_PASSWORD = os.getenv('DB_PASSWORD', '')
    DB_NAME = os.getenv('DB_NAME', 'fruit_recognition_db')
    
    SQLALCHEMY_DATABASE_URI = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Cấu hình tải file lên
    UPLOAD_FOLDER = os.getenv('UPLOAD_FOLDER', 'uploads')
    MAX_CONTENT_LENGTH = int(os.getenv('MAX_CONTENT_LENGTH', 16 * 1024 * 1024))  # 16MB
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
    
    # Cấu hình mô hình
    MODEL_PATH = os.getenv('MODEL_PATH', 'models/fruit_classifier.h5')
    IMG_HEIGHT = 224
    IMG_WIDTH = 224
    
    # Các loại trái cây
    FRUIT_CLASSES = [
        'buoi_da_xanh',           # Bưởi Da Xanh
        'cam_sanh_ha_giang',      # Cam Sành Hà Giang
        'chom_chom_long_khanh',   # Chôm Chôm Long Khánh
        'mang_cut_lai_thieu',     # Măng Cụt Lái Thiêu
        'nhan_long_hung_yen',     # Nhãn Lồng Hưng Yên
        'sau_rieng_ri6',          # Sầu Riêng Ri6
        'thanh_long_binh_thuan',  # Thanh Long Bình Thuận
        'vai_thieu_luc_ngan',     # Vải Thiều Lục Ngạn
        'vu_sua_lo_ren',          # Vú Sữa Lò Rèn
        'xoai_cat_hoa_loc'        # Xoài Cát Hòa Lộc
    ]
    
    # Ánh xạ tên hiển thị tiếng Việt
    FRUIT_NAMES_VN = {
        'buoi_da_xanh': 'Bưởi Da Xanh Bến Tre',
        'cam_sanh_ha_giang': 'Cam Sành Hà Giang',
        'chom_chom_long_khanh': 'Chôm Chôm Long Khánh',
        'mang_cut_lai_thieu': 'Măng Cụt Lái Thiêu',
        'nhan_long_hung_yen': 'Nhãn Lồng Hưng Yên',
        'sau_rieng_ri6': 'Sầu Riêng Ri6',
        'thanh_long_binh_thuan': 'Thanh Long Bình Thuận',
        'vai_thieu_luc_ngan': 'Vải Thiều Lục Ngạn',
        'vu_sua_lo_ren': 'Vú Sữa Lò Rèn',
        'xoai_cat_hoa_loc': 'Xoài Cát Hòa Lộc'
    }
    
    # Cấu hình JWT
    JWT_ACCESS_TOKEN_EXPIRES = 24 * 60 * 60  # 24 giờ

class DevelopmentConfig(Config):
    """Cấu hình môi trường phát triển"""
    DEBUG = True
    TESTING = False

class ProductionConfig(Config):
    """Cấu hình môi trường sản xuất"""
    DEBUG = False
    TESTING = False

class TestingConfig(Config):
    """Cấu hình môi trường kiểm thử"""
    DEBUG = True
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///test.db'

# Từ điển cấu hình
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}




load_dotenv()

class Config:
    """Lớp cấu hình cơ bản"""
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'jwt-secret-key-change-in-production')
    
    # Cấu hình cơ sở dữ liệu
    DB_HOST = os.getenv('DB_HOST', 'localhost')
    DB_PORT = int(os.getenv('DB_PORT', 3306))
    DB_USER = os.getenv('DB_USER', 'root')
    DB_PASSWORD = os.getenv('DB_PASSWORD', '')
    DB_NAME = os.getenv('DB_NAME', 'fruit_recognition_db')
    
    SQLALCHEMY_DATABASE_URI = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Cấu hình tải file lên
    UPLOAD_FOLDER = os.getenv('UPLOAD_FOLDER', 'uploads')
    MAX_CONTENT_LENGTH = int(os.getenv('MAX_CONTENT_LENGTH', 16 * 1024 * 1024))  # 16MB
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
    
    # Cấu hình mô hình
    MODEL_PATH = os.getenv('MODEL_PATH', 'models/fruit_classifier.h5')
    IMG_HEIGHT = 224
    IMG_WIDTH = 224
    
    # Các loại trái cây
    FRUIT_CLASSES = [
        'buoi_da_xanh',           # Bưởi Da Xanh
        'cam_sanh_ha_giang',      # Cam Sành Hà Giang
        'chom_chom_long_khanh',   # Chôm Chôm Long Khánh
        'mang_cut_lai_thieu',     # Măng Cụt Lái Thiêu
        'nhan_long_hung_yen',     # Nhãn Lồng Hưng Yên
        'sau_rieng_ri6',          # Sầu Riêng Ri6
        'thanh_long_binh_thuan',  # Thanh Long Bình Thuận
        'vai_thieu_luc_ngan',     # Vải Thiều Lục Ngạn
        'vu_sua_lo_ren',          # Vú Sữa Lò Rèn
        'xoai_cat_hoa_loc'        # Xoài Cát Hòa Lộc
    ]
    
    # Ánh xạ tên hiển thị tiếng Việt
    FRUIT_NAMES_VN = {
        'buoi_da_xanh': 'Bưởi Da Xanh Bến Tre',
        'cam_sanh_ha_giang': 'Cam Sành Hà Giang',
        'chom_chom_long_khanh': 'Chôm Chôm Long Khánh',
        'mang_cut_lai_thieu': 'Măng Cụt Lái Thiêu',
        'nhan_long_hung_yen': 'Nhãn Lồng Hưng Yên',
        'sau_rieng_ri6': 'Sầu Riêng Ri6',
        'thanh_long_binh_thuan': 'Thanh Long Bình Thuận',
        'vai_thieu_luc_ngan': 'Vải Thiều Lục Ngạn',
        'vu_sua_lo_ren': 'Vú Sữa Lò Rèn',
        'xoai_cat_hoa_loc': 'Xoài Cát Hòa Lộc'
    }
    
    # Cấu hình JWT
    JWT_ACCESS_TOKEN_EXPIRES = 24 * 60 * 60  # 24 giờ

class DevelopmentConfig(Config):
    """Cấu hình môi trường phát triển"""
    DEBUG = True
    TESTING = False

class ProductionConfig(Config):
    """Cấu hình môi trường sản xuất"""
    DEBUG = False
    TESTING = False

class TestingConfig(Config):
    """Cấu hình môi trường kiểm thử"""
    DEBUG = True
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///test.db'

# Từ điển cấu hình
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}


