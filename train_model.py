"""
Script huấn luyện mô hình CNN
Dùng để huấn luyện mô hình nhận diện trái cây Việt Nam
"""
import os
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import ModelCheckpoint, EarlyStopping, ReduceLROnPlateau
from sklearn.metrics import classification_report, confusion_matrix
import json

# Cấu hình
IMG_HEIGHT = 224
IMG_WIDTH = 224
BATCH_SIZE = 32
EPOCHS = 50
LEARNING_RATE = 0.001

# Đường dẫn dữ liệu
DATA_DIR = 'data'
TRAIN_DIR = os.path.join(DATA_DIR, 'train')
VALIDATION_DIR = os.path.join(DATA_DIR, 'validation')
TEST_DIR = os.path.join(DATA_DIR, 'test')

# Đường dẫn lưu mô hình
MODEL_SAVE_PATH = 'models/fruit_classifier.h5'
HISTORY_SAVE_PATH = 'models/training_history.json'

# Các loại trái cây
FRUIT_CLASSES = [
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

def create_data_generators():
    """Tạo data generators"""
    print("📊 Tạo data generators...")
    
    # Tăng cường dữ liệu huấn luyện
    train_datagen = ImageDataGenerator(
        rescale=1./255,
        rotation_range=20,
        width_shift_range=0.2,
        height_shift_range=0.2,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True,
        fill_mode='nearest'
    )
    
    # Dữ liệu validation và test chỉ chuẩn hóa
    val_test_datagen = ImageDataGenerator(rescale=1./255)
    
    # Generator dữ liệu huấn luyện
    train_generator = train_datagen.flow_from_directory(
        TRAIN_DIR,
        target_size=(IMG_HEIGHT, IMG_WIDTH),
        batch_size=BATCH_SIZE,
        class_mode='categorical',
        shuffle=True,
        classes=FRUIT_CLASSES
    )
    
    # Generator dữ liệu validation
    validation_generator = val_test_datagen.flow_from_directory(
        VALIDATION_DIR,
        target_size=(IMG_HEIGHT, IMG_WIDTH),
        batch_size=BATCH_SIZE,
        class_mode='categorical',
        shuffle=False,
        classes=FRUIT_CLASSES
    )
    
    # Generator dữ liệu test
    test_generator = val_test_datagen.flow_from_directory(
        TEST_DIR,
        target_size=(IMG_HEIGHT, IMG_WIDTH),
        batch_size=BATCH_SIZE,
        class_mode='categorical',
        shuffle=False,
        classes=FRUIT_CLASSES
    )
    
    print(f"✅ Số mẫu huấn luyện: {train_generator.samples}")
    print(f"✅ Số mẫu validation: {validation_generator.samples}")
    print(f"✅ Số mẫu test: {test_generator.samples}")
    print(f"✅ Số lớp: {len(FRUIT_CLASSES)}")
    
    return train_generator, validation_generator, test_generator

def create_model(num_classes):
    """
    Tạo mô hình CNN
    Sử dụng transfer learning - MobileNetV2
    """
    print("🏗️  Tạo mô hình CNN...")
    
    # Sử dụng MobileNetV2 đã được huấn luyện trước làm mô hình cơ sở
    base_model = keras.applications.MobileNetV2(
        input_shape=(IMG_HEIGHT, IMG_WIDTH, 3),
        include_top=False,
        weights='imagenet'
    )
    
    # Đóng băng trọng số của mô hình cơ sở
    base_model.trainable = False
    
    # Xây dựng mô hình hoàn chỉnh
    model = keras.Sequential([
        base_model,
        layers.GlobalAveragePooling2D(),
        layers.Dropout(0.3),
        layers.Dense(256, activation='relu'),
        layers.Dropout(0.3),
        layers.Dense(num_classes, activation='softmax')
    ])
    
    # Biên dịch mô hình
    model.compile(
        optimizer=keras.optimizers.Adam(learning_rate=LEARNING_RATE),
        loss='categorical_crossentropy',
        metrics=['accuracy']
    )
    
    print("✅ Tạo mô hình thành công!")
    model.summary()
    
    return model

def train_model(model, train_gen, val_gen):
    """Huấn luyện mô hình"""
    print("\n🚀 Bắt đầu huấn luyện mô hình...")
    
    # Tạo thư mục models
    os.makedirs('models', exist_ok=True)
    
    # Hàm callback
    callbacks = [
        # Lưu mô hình tốt nhất
        ModelCheckpoint(
            MODEL_SAVE_PATH,
            monitor='val_accuracy',
            save_best_only=True,
            verbose=1,
            mode='max'
        ),
        # 早停
        EarlyStopping(
            monitor='val_loss',
            patience=10,
            verbose=1,
            restore_best_weights=True
        ),
        # Giảm learning rate
        ReduceLROnPlateau(
            monitor='val_loss',
            factor=0.5,
            patience=5,
            verbose=1,
            min_lr=1e-7
        )
    ]
    
    # 训练
    history = model.fit(
        train_gen,
        epochs=EPOCHS,
        validation_data=val_gen,
        callbacks=callbacks,
        verbose=1
    )
    
    print("\n✅ Hoàn thành huấn luyện mô hình!")
    
    return history

def evaluate_model(model, test_gen):
    """Đánh giá mô hình"""
    print("\n📊 Đánh giá mô hình...")
    
    # Đánh giá
    test_loss, test_accuracy = model.evaluate(test_gen, verbose=1)
    
    print(f"\nLoss trên tập test: {test_loss:.4f}")
    print(f"Accuracy trên tập test: {test_accuracy:.4f}")
    
    # Lấy kết quả dự đoán
    predictions = model.predict(test_gen, verbose=1)
    predicted_classes = np.argmax(predictions, axis=1)
    true_classes = test_gen.classes
    
    # Báo cáo phân loại
    print("\n📈 Báo cáo phân loại:")
    print(classification_report(
        true_classes,
        predicted_classes,
        target_names=FRUIT_CLASSES
    ))
    
    # Ma trận nhầm lẫn
    cm = confusion_matrix(true_classes, predicted_classes)
    
    return test_accuracy, test_loss, cm

def plot_training_history(history):
    """Vẽ biểu đồ lịch sử huấn luyện"""
    print("\n📊 Tạo biểu đồ lịch sử huấn luyện...")
    
    fig, axes = plt.subplots(1, 2, figsize=(15, 5))
    
    # Độ chính xác
    axes[0].plot(history.history['accuracy'], label='Accuracy huấn luyện')
    axes[0].plot(history.history['val_accuracy'], label='Accuracy validation')
    axes[0].set_title('Độ chính xác mô hình')
    axes[0].set_xlabel('Epoch')
    axes[0].set_ylabel('Accuracy')
    axes[0].legend()
    axes[0].grid(True)
    
    # Loss
    axes[1].plot(history.history['loss'], label='Loss huấn luyện')
    axes[1].plot(history.history['val_loss'], label='Loss validation')
    axes[1].set_title('Loss mô hình')
    axes[1].set_xlabel('Epoch')
    axes[1].set_ylabel('Loss')
    axes[1].legend()
    axes[1].grid(True)
    
    plt.tight_layout()
    plt.savefig('models/training_history.png', dpi=300, bbox_inches='tight')
    print("✅ Đã lưu biểu đồ lịch sử huấn luyện: models/training_history.png")
    
def plot_confusion_matrix(cm):
    """Vẽ ma trận nhầm lẫn"""
    print("\n📊 Tạo biểu đồ ma trận nhầm lẫn...")
    
    plt.figure(figsize=(12, 10))
    sns.heatmap(
        cm,
        annot=True,
        fmt='d',
        cmap='Blues',
        xticklabels=FRUIT_CLASSES,
        yticklabels=FRUIT_CLASSES
    )
    plt.title('Ma trận nhầm lẫn')
    plt.ylabel('Nhãn thực tế')
    plt.xlabel('Nhãn dự đoán')
    plt.xticks(rotation=45, ha='right')
    plt.yticks(rotation=0)
    plt.tight_layout()
    plt.savefig('models/confusion_matrix.png', dpi=300, bbox_inches='tight')
    print("✅ Đã lưu biểu đồ ma trận nhầm lẫn: models/confusion_matrix.png")

def save_training_info(history, test_accuracy, test_loss):
    """Lưu thông tin huấn luyện"""
    print("\n💾 Lưu thông tin huấn luyện...")
    
    training_info = {
        'model_version': datetime.now().strftime('%Y%m%d_%H%M%S'),
        'timestamp': datetime.now().isoformat(),
        'epochs_trained': len(history.history['accuracy']),
        'final_train_accuracy': float(history.history['accuracy'][-1]),
        'final_val_accuracy': float(history.history['val_accuracy'][-1]),
        'final_train_loss': float(history.history['loss'][-1]),
        'final_val_loss': float(history.history['val_loss'][-1]),
        'test_accuracy': float(test_accuracy),
        'test_loss': float(test_loss),
        'num_classes': len(FRUIT_CLASSES),
        'classes': FRUIT_CLASSES,
        'image_size': [IMG_HEIGHT, IMG_WIDTH],
        'batch_size': BATCH_SIZE
    }
    
    with open(HISTORY_SAVE_PATH, 'w', encoding='utf-8') as f:
        json.dump(training_info, f, indent=2, ensure_ascii=False)
    
    print(f"✅ Đã lưu thông tin huấn luyện: {HISTORY_SAVE_PATH}")

def main():
    """Hàm chính"""
    print("=" * 60)
    print("🍉 Huấn luyện mô hình CNN Nhận diện Trái cây Việt Nam")
    print("=" * 60)
    
    # Kiểm tra GPU
    print(f"\n🔍 Phiên bản TensorFlow: {tf.__version__}")
    print(f"🔍 GPU khả dụng: {len(tf.config.list_physical_devices('GPU')) > 0}")
    
    # Tạo data generators
    train_gen, val_gen, test_gen = create_data_generators()
    
    # Tạo mô hình
    model = create_model(num_classes=len(FRUIT_CLASSES))
    
    # Huấn luyện mô hình
    history = train_model(model, train_gen, val_gen)
    
    # Đánh giá mô hình
    test_accuracy, test_loss, cm = evaluate_model(model, test_gen)
    
    # Vẽ biểu đồ
    plot_training_history(history)
    plot_confusion_matrix(cm)
    
    # Lưu thông tin huấn luyện
    save_training_info(history, test_accuracy, test_loss)
    
    print("\n" + "=" * 60)
    print("🎉 Hoàn thành huấn luyện!")
    print(f"📁 Đã lưu mô hình: {MODEL_SAVE_PATH}")
    print(f"📊 Accuracy trên tập test: {test_accuracy * 100:.2f}%")
    print("=" * 60)

if __name__ == '__main__':
    main()


