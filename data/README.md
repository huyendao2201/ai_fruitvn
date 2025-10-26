# 📊 Dataset VietFruitNet

## Cấu trúc thư mục

```
data/
├── train/           # Ảnh huấn luyện (70%)
├── validation/      # Ảnh validation (15%)
└── test/           # Ảnh test (15%)
```

## Các loại trái cây được hỗ trợ

### 🥭 Xoài Cát Hòa Lộc
- **Thư mục:** `xoai_cat_hoa_loc/`
- **Đặc điểm:** Vỏ vàng, thịt ngọt, hạt nhỏ
- **Nguồn gốc:** Cát Hòa Lộc, Đồng Tháp

### 🍈 Sầu riêng Ri6
- **Thư mục:** `sau_rieng_ri6/`
- **Đặc điểm:** Vỏ xanh, thịt vàng, mùi thơm đặc trưng
- **Nguồn gốc:** Tây Ninh, Bình Phước

### 🐉 Thanh long Bình Thuận
- **Thư mục:** `thanh_long_binh_thuan/`
- **Đặc điểm:** Vỏ đỏ, ruột trắng/đỏ, vị ngọt thanh
- **Nguồn gốc:** Bình Thuận

### 🌺 Chôm chôm Long Khánh
- **Thư mục:** `chom_chom_long_khanh/`
- **Đặc điểm:** Vỏ đỏ có gai, thịt trắng ngọt
- **Nguồn gốc:** Long Khánh, Đồng Nai

### 🥛 Vú sữa Lò Rèn
- **Thư mục:** `vu_sua_lo_ren/`
- **Đặc điểm:** Vỏ xanh, thịt trắng sữa, vị ngọt
- **Nguồn gốc:** Cần Thơ

### 🍇 Măng cụt Lái Thiêu
- **Thư mục:** `mang_cut_lai_thieu/`
- **Đặc điểm:** Vỏ tím, thịt trắng, vị chua ngọt
- **Nguồn gốc:** Lái Thiêu, Bình Dương

### 🍒 Vải thiều Lục Ngạn
- **Thư mục:** `vai_thieu_luc_ngan/`
- **Đặc điểm:** Vỏ đỏ, thịt trắng, vị ngọt
- **Nguồn gốc:** Lục Ngạn, Bắc Giang

### 🍊 Bưởi da xanh
- **Thư mục:** `buoi_da_xanh/`
- **Đặc điểm:** Vỏ xanh, thịt hồng, vị ngọt thanh
- **Nguồn gốc:** Bến Tre, Vĩnh Long

### 🥜 Nhãn lồng Hưng Yên
- **Thư mục:** `nhan_long_hung_yen/`
- **Đặc điểm:** Vỏ nâu, thịt trắng, vị ngọt đậm
- **Nguồn gốc:** Hưng Yên

### 🍊 Cam sành Hà Giang
- **Thư mục:** `cam_sanh_ha_giang/`
- **Đặc điểm:** Vỏ xanh, thịt cam, vị chua ngọt
- **Nguồn gốc:** Hà Giang

## Hướng dẫn thêm dữ liệu

### 1. Chuẩn bị ảnh
- **Định dạng:** JPG, JPEG, PNG
- **Kích thước:** Tối thiểu 224x224 pixels
- **Chất lượng:** Ảnh rõ nét, ánh sáng tốt
- **Góc chụp:** Nhiều góc độ khác nhau

### 2. Phân chia dữ liệu
- **Train (70%):** Ảnh để huấn luyện mô hình
- **Validation (15%):** Ảnh để đánh giá trong quá trình train
- **Test (15%):** Ảnh để đánh giá cuối cùng

### 3. Cấu trúc thư mục
```
data/
├── train/
│   ├── xoai_cat_hoa_loc/
│   │   ├── xoai_001.jpg
│   │   ├── xoai_002.jpg
│   │   └── ...
│   ├── sau_rieng_ri6/
│   └── ...
├── validation/
│   ├── xoai_cat_hoa_loc/
│   ├── sau_rieng_ri6/
│   └── ...
└── test/
    ├── xoai_cat_hoa_loc/
    ├── sau_rieng_ri6/
    └── ...
```

## Nguồn dữ liệu gợi ý

### Dataset công khai
- **Fruits-360:** https://www.kaggle.com/moltean/fruits
- **UIT-VinaFruit20:** https://www.kaggle.com/datasets/uitvinafruit20
- **Fruit Images:** https://www.kaggle.com/datasets/kritikseth/fruit-and-vegetable-image-recognition

### Thu thập dữ liệu
- Chụp ảnh thực tế tại các chợ, siêu thị
- Sử dụng Google Images (có bản quyền)
- Hợp tác với nông dân, thương lái
- Crowdsourcing từ cộng đồng

## Chất lượng dữ liệu

### Tiêu chí đánh giá
- **Độ rõ nét:** Ảnh không bị mờ, nhòe
- **Ánh sáng:** Đủ sáng, không quá tối/sáng
- **Góc chụp:** Đa dạng (trước, sau, bên, cắt ngang)
- **Trạng thái:** Trái cây tươi, không bị hỏng
- **Nền:** Nền đơn giản, không gây nhiễu

### Data Augmentation
Script sẽ tự động áp dụng:
- Xoay ảnh (rotation)
- Lật ngang (horizontal flip)
- Zoom in/out
- Thay đổi độ sáng
- Shear transformation

## Lưu ý quan trọng

⚠️ **Bản quyền:** Đảm bảo có quyền sử dụng ảnh
⚠️ **Chất lượng:** Kiểm tra kỹ trước khi thêm vào dataset
⚠️ **Cân bằng:** Mỗi loại trái cây nên có số lượng ảnh tương đương
⚠️ **Đa dạng:** Nên có ảnh từ nhiều nguồn khác nhau

## Hỗ trợ

Nếu cần hỗ trợ về dataset, vui lòng:
1. Tạo issue trên GitHub
2. Liên hệ qua email
3. Tham gia Discord community

---

**📊 VietFruitNet Dataset - Chất lượng cao cho AI phân loại trái cây Việt Nam**












