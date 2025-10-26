import os
import uuid
from werkzeug.utils import secure_filename
from backend.config import Config

def allowed_file(filename):
    """Kiểm tra phần mở rộng file có được phép không"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in Config.ALLOWED_EXTENSIONS

def save_upload_file(file, upload_folder=None):
    """
    Lưu file đã tải lên
    
    Args:
        file: Đối tượng FileStorage
        upload_folder: Đường dẫn thư mục tải lên
        
    Returns:
        str: Đường dẫn tương đối của file đã lưu
    """
    if upload_folder is None:
        upload_folder = Config.UPLOAD_FOLDER
    
    # Đảm bảo thư mục tải lên tồn tại
    os.makedirs(upload_folder, exist_ok=True)
    
    # Tạo tên file duy nhất
    original_filename = secure_filename(file.filename)
    file_ext = original_filename.rsplit('.', 1)[1].lower() if '.' in original_filename else 'jpg'
    unique_filename = f"{uuid.uuid4().hex}.{file_ext}"
    
    # Lưu file
    file_path = os.path.join(upload_folder, unique_filename)
    file.save(file_path)
    
    return file_path

def delete_file(file_path):
    """Xóa file"""
    try:
        if os.path.exists(file_path):
            os.remove(file_path)
            return True
    except Exception as e:
        print(f"Xóa file thất bại: {e}")
    return False

def get_file_url(file_path, base_url=''):
    """Lấy URL truy cập của file"""
    if not file_path:
        return None
    return f"{base_url}/{file_path.replace(os.sep, '/')}"



from werkzeug.utils import secure_filename
from backend.config import Config

def allowed_file(filename):
    """Kiểm tra phần mở rộng file có được phép không"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in Config.ALLOWED_EXTENSIONS

def save_upload_file(file, upload_folder=None):
    """
    Lưu file đã tải lên
    
    Args:
        file: Đối tượng FileStorage
        upload_folder: Đường dẫn thư mục tải lên
        
    Returns:
        str: Đường dẫn tương đối của file đã lưu
    """
    if upload_folder is None:
        upload_folder = Config.UPLOAD_FOLDER
    
    # Đảm bảo thư mục tải lên tồn tại
    os.makedirs(upload_folder, exist_ok=True)
    
    # Tạo tên file duy nhất
    original_filename = secure_filename(file.filename)
    file_ext = original_filename.rsplit('.', 1)[1].lower() if '.' in original_filename else 'jpg'
    unique_filename = f"{uuid.uuid4().hex}.{file_ext}"
    
    # Lưu file
    file_path = os.path.join(upload_folder, unique_filename)
    file.save(file_path)
    
    return file_path

def delete_file(file_path):
    """Xóa file"""
    try:
        if os.path.exists(file_path):
            os.remove(file_path)
            return True
    except Exception as e:
        print(f"Xóa file thất bại: {e}")
    return False

def get_file_url(file_path, base_url=''):
    """Lấy URL truy cập của file"""
    if not file_path:
        return None
    return f"{base_url}/{file_path.replace(os.sep, '/')}"


