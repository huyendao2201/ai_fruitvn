import numpy as np
from PIL import Image
import io
import os
from tensorflow import keras
from backend.config import Config

class FruitClassifier:
    """Lớp công cụ phân loại trái cây"""
    
    def __init__(self, model_path=None):
        self.model_path = model_path or Config.MODEL_PATH
        self.model = None
        self.img_height = Config.IMG_HEIGHT
        self.img_width = Config.IMG_WIDTH
        self.class_names = Config.FRUIT_CLASSES
        self.fruit_names_vn = Config.FRUIT_NAMES_VN
        
    def load_model(self):
        """Tải mô hình đã huấn luyện"""
        if not os.path.exists(self.model_path):
            raise FileNotFoundError(f"File mô hình không tồn tại: {self.model_path}")
        
        self.model = keras.models.load_model(self.model_path)
        print(f"Tải mô hình thành công: {self.model_path}")
        return self.model
    
    def preprocess_image(self, image_data):
        """
        Tiền xử lý hình ảnh
        
        Args:
            image_data: Dữ liệu hình ảnh (bytes hoặc đối tượng PIL Image)
            
        Returns:
            Mảng hình ảnh đã được tiền xử lý
        """
        # Nếu là bytes, chuyển đổi sang PIL Image
        if isinstance(image_data, bytes):
            image = Image.open(io.BytesIO(image_data))
        elif isinstance(image_data, str):  # Đường dẫn file
            image = Image.open(image_data)
        else:
            image = image_data
        
        # Chuyển đổi sang RGB (nếu là RGBA hoặc định dạng khác)
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Điều chỉnh kích thước
        image = image.resize((self.img_width, self.img_height))
        
        # Chuyển đổi sang mảng numpy và chuẩn hóa
        img_array = np.array(image)
        img_array = img_array.astype('float32') / 255.0
        
        # Thêm chiều batch
        img_array = np.expand_dims(img_array, axis=0)
        
        return img_array
    
    def predict(self, image_data):
        """
        Dự đoán loại hình ảnh
        
        Args:
            image_data: Dữ liệu hình ảnh
            
        Returns:
            dict: {
                'label': Loại dự đoán,
                'label_vn': Tên tiếng Việt,
                'confidence': Độ tin cậy,
                'all_predictions': Xác suất của tất cả các loại
            }
        """
        if self.model is None:
            self.load_model()
        
        # Tiền xử lý hình ảnh
        processed_image = self.preprocess_image(image_data)
        
        # Dự đoán
        predictions = self.model.predict(processed_image, verbose=0)
        predicted_class_idx = np.argmax(predictions[0])
        confidence = float(predictions[0][predicted_class_idx])
        
        # Lấy nhãn dự đoán
        predicted_label = self.class_names[predicted_class_idx]
        predicted_label_vn = self.fruit_names_vn.get(predicted_label, predicted_label)
        
        # Kết quả dự đoán của tất cả các loại
        all_predictions = [
            {
                'label': self.class_names[i],
                'label_vn': self.fruit_names_vn.get(self.class_names[i], self.class_names[i]),
                'confidence': float(predictions[0][i])
            }
            for i in range(len(self.class_names))
        ]
        
        # Sắp xếp theo độ tin cậy
        all_predictions.sort(key=lambda x: x['confidence'], reverse=True)
        
        return {
            'label': predicted_label,
            'label_vn': predicted_label_vn,
            'confidence': confidence,
            'all_predictions': all_predictions
        }
    
    def batch_predict(self, image_list):
        """Dự đoán hàng loạt nhiều hình ảnh"""
        results = []
        for image_data in image_list:
            try:
                result = self.predict(image_data)
                results.append(result)
            except Exception as e:
                results.append({'error': str(e)})
        return results

# Instance phân loại toàn cục
classifier = FruitClassifier()



import io
import os
from tensorflow import keras
from backend.config import Config

class FruitClassifier:
    """Lớp công cụ phân loại trái cây"""
    
    def __init__(self, model_path=None):
        self.model_path = model_path or Config.MODEL_PATH
        self.model = None
        self.img_height = Config.IMG_HEIGHT
        self.img_width = Config.IMG_WIDTH
        self.class_names = Config.FRUIT_CLASSES
        self.fruit_names_vn = Config.FRUIT_NAMES_VN
        
    def load_model(self):
        """Tải mô hình đã huấn luyện"""
        if not os.path.exists(self.model_path):
            raise FileNotFoundError(f"File mô hình không tồn tại: {self.model_path}")
        
        self.model = keras.models.load_model(self.model_path)
        print(f"Tải mô hình thành công: {self.model_path}")
        return self.model
    
    def preprocess_image(self, image_data):
        """
        Tiền xử lý hình ảnh
        
        Args:
            image_data: Dữ liệu hình ảnh (bytes hoặc đối tượng PIL Image)
            
        Returns:
            Mảng hình ảnh đã được tiền xử lý
        """
        # Nếu là bytes, chuyển đổi sang PIL Image
        if isinstance(image_data, bytes):
            image = Image.open(io.BytesIO(image_data))
        elif isinstance(image_data, str):  # Đường dẫn file
            image = Image.open(image_data)
        else:
            image = image_data
        
        # Chuyển đổi sang RGB (nếu là RGBA hoặc định dạng khác)
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Điều chỉnh kích thước
        image = image.resize((self.img_width, self.img_height))
        
        # Chuyển đổi sang mảng numpy và chuẩn hóa
        img_array = np.array(image)
        img_array = img_array.astype('float32') / 255.0
        
        # Thêm chiều batch
        img_array = np.expand_dims(img_array, axis=0)
        
        return img_array
    
    def predict(self, image_data):
        """
        Dự đoán loại hình ảnh
        
        Args:
            image_data: Dữ liệu hình ảnh
            
        Returns:
            dict: {
                'label': Loại dự đoán,
                'label_vn': Tên tiếng Việt,
                'confidence': Độ tin cậy,
                'all_predictions': Xác suất của tất cả các loại
            }
        """
        if self.model is None:
            self.load_model()
        
        # Tiền xử lý hình ảnh
        processed_image = self.preprocess_image(image_data)
        
        # Dự đoán
        predictions = self.model.predict(processed_image, verbose=0)
        predicted_class_idx = np.argmax(predictions[0])
        confidence = float(predictions[0][predicted_class_idx])
        
        # Lấy nhãn dự đoán
        predicted_label = self.class_names[predicted_class_idx]
        predicted_label_vn = self.fruit_names_vn.get(predicted_label, predicted_label)
        
        # Kết quả dự đoán của tất cả các loại
        all_predictions = [
            {
                'label': self.class_names[i],
                'label_vn': self.fruit_names_vn.get(self.class_names[i], self.class_names[i]),
                'confidence': float(predictions[0][i])
            }
            for i in range(len(self.class_names))
        ]
        
        # Sắp xếp theo độ tin cậy
        all_predictions.sort(key=lambda x: x['confidence'], reverse=True)
        
        return {
            'label': predicted_label,
            'label_vn': predicted_label_vn,
            'confidence': confidence,
            'all_predictions': all_predictions
        }
    
    def batch_predict(self, image_list):
        """Dự đoán hàng loạt nhiều hình ảnh"""
        results = []
        for image_data in image_list:
            try:
                result = self.predict(image_data)
                results.append(result)
            except Exception as e:
                results.append({'error': str(e)})
        return results

# Instance phân loại toàn cục
classifier = FruitClassifier()


