#!/usr/bin/env python3
"""
Script tạo icon tạm thời cho ứng dụng Nhận Diện Trái Cây VN
Sử dụng PIL để tạo icon với emoji và gradient
"""

try:
    from PIL import Image, ImageDraw, ImageFont
    import os
    
    def create_gradient_background(size, color1, color2):
        """Tạo gradient background"""
        base = Image.new('RGB', (size, size), color1)
        draw = ImageDraw.Draw(base)
        
        for i in range(size):
            # Linear gradient từ trên xuống
            r = int(color1[0] + (color2[0] - color1[0]) * i / size)
            g = int(color1[1] + (color2[1] - color1[1]) * i / size)
            b = int(color1[2] + (color2[2] - color1[2]) * i / size)
            draw.line([(0, i), (size, i)], fill=(r, g, b))
        
        return base
    
    def create_app_icon():
        """Tạo icon chính 1024x1024"""
        size = 1024
        
        # Tạo gradient xanh lá
        color1 = (76, 175, 80)   # #4CAF50
        color2 = (129, 199, 132) # #81C784
        
        img = create_gradient_background(size, color1, color2)
        draw = ImageDraw.Draw(img)
        
        # Vẽ hình tròn trắng ở giữa
        circle_size = 700
        circle_pos = (size - circle_size) // 2
        draw.ellipse(
            [circle_pos, circle_pos, circle_pos + circle_size, circle_pos + circle_size],
            fill=(255, 255, 255, 255)
        )
        
        # Thêm text emoji (nếu có font hỗ trợ)
        try:
            # Thử dùng font hệ thống
            font_size = 400
            font = ImageFont.truetype("seguiemj.ttf", font_size)  # Windows emoji font
            text = "🍎"
            
            # Tính vị trí để center text
            bbox = draw.textbbox((0, 0), text, font=font)
            text_width = bbox[2] - bbox[0]
            text_height = bbox[3] - bbox[1]
            text_x = (size - text_width) // 2
            text_y = (size - text_height) // 2 - 50
            
            draw.text((text_x, text_y), text, font=font, fill=(76, 175, 80))
        except:
            # Nếu không có font emoji, vẽ hình đơn giản
            # Vẽ quả táo stylized
            apple_color = (76, 175, 80)
            
            # Thân táo (2 hình tròn)
            draw.ellipse([300, 350, 550, 650], fill=apple_color)
            draw.ellipse([474, 350, 724, 650], fill=apple_color)
            
            # Lá
            draw.ellipse([450, 250, 550, 350], fill=(56, 142, 60))
            
            # Cuống
            draw.rectangle([480, 300, 520, 380], fill=(101, 67, 33))
        
        # Lưu file
        output_path = os.path.join(os.path.dirname(__file__), 'assets', 'icons', 'app_icon.png')
        img.save(output_path, 'PNG')
        print(f"✅ Đã tạo {output_path}")
        
        return img
    
    def create_foreground_icon():
        """Tạo foreground icon 1024x1024 (chỉ phần icon, nền trong suốt)"""
        size = 1024
        
        # Tạo ảnh với nền trong suốt
        img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        
        # Vẽ hình tròn trắng
        circle_size = 600
        circle_pos = (size - circle_size) // 2
        draw.ellipse(
            [circle_pos, circle_pos, circle_pos + circle_size, circle_pos + circle_size],
            fill=(255, 255, 255, 255)
        )
        
        # Thêm emoji hoặc hình vẽ
        try:
            font_size = 350
            font = ImageFont.truetype("seguiemj.ttf", font_size)
            text = "🍎"
            
            bbox = draw.textbbox((0, 0), text, font=font)
            text_width = bbox[2] - bbox[0]
            text_height = bbox[3] - bbox[1]
            text_x = (size - text_width) // 2
            text_y = (size - text_height) // 2 - 40
            
            draw.text((text_x, text_y), text, font=font, fill=(76, 175, 80))
        except:
            # Vẽ hình đơn giản
            apple_color = (76, 175, 80, 255)
            draw.ellipse([350, 400, 550, 650], fill=apple_color)
            draw.ellipse([474, 400, 674, 650], fill=apple_color)
            draw.ellipse([475, 320, 550, 420], fill=(56, 142, 60, 255))
            draw.rectangle([490, 350, 520, 420], fill=(101, 67, 33, 255))
        
        # Lưu file
        output_path = os.path.join(os.path.dirname(__file__), 'assets', 'icons', 'app_icon_foreground.png')
        img.save(output_path, 'PNG')
        print(f"✅ Đã tạo {output_path}")
        
        return img
    
    if __name__ == '__main__':
        print("🎨 Đang tạo icon cho ứng dụng...")
        print("=" * 60)
        
        # Tạo thư mục nếu chưa có
        icons_dir = os.path.join(os.path.dirname(__file__), 'assets', 'icons')
        os.makedirs(icons_dir, exist_ok=True)
        
        # Tạo icons
        create_app_icon()
        create_foreground_icon()
        
        print("=" * 60)
        print("✅ Hoàn thành! Các file icon đã được tạo.")
        print("\nBước tiếp theo:")
        print("1. cd flutter_app")
        print("2. flutter pub get")
        print("3. flutter pub run flutter_launcher_icons")
        print("\n💡 Tip: Bạn có thể thay thế icon này bằng icon đẹp hơn sau!")
        print("    Xem hướng dẫn tại: assets/icons/ICON_GUIDE.md")

except ImportError:
    print("❌ Lỗi: Chưa cài đặt thư viện Pillow")
    print("\nVui lòng cài đặt:")
    print("  pip install Pillow")
    print("\nHoặc sử dụng icon có sẵn từ:")
    print("  - https://www.flaticon.com")
    print("  - https://www.canva.com")
    print("\nĐọc hướng dẫn chi tiết tại: assets/icons/ICON_GUIDE.md")

