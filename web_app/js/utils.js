/**
 * Utility Functions for Fruit Recognition Web App
 */

// ==========================================
// FRUIT NAMES MAPPING
// ==========================================

const FruitNames = {
  'buoi_da_xanh': 'Bưởi Da Xanh',
  'cam_sanh_ha_giang': 'Cam Sành Hà Giang',
  'chom_chom_long_khanh': 'Chôm Chôm Long Khánh',
  'mang_cut_lai_thieu': 'Măng Cụt Lái Thiêu',
  'nhan_long_hung_yen': 'Nhãn Lồng Hưng Yên',
  'sau_rieng_ri6': 'Sầu Riêng Ri6',
  'thanh_long_binh_thuan': 'Thanh Long Bình Thuận',
  'vai_thieu_luc_ngan': 'Vải Thiều Lục Ngạn',
  'vu_sua_lo_ren': 'Vú Sữa Lò Rèn',
  'xoai_cat_hoa_loc': 'Xoài Cát Hòa Lộc'
};

const FruitEmojis = {
  'buoi_da_xanh': '🍊',
  'cam_sanh_ha_giang': '🍊',
  'chom_chom_long_khanh': '🍇',
  'mang_cut_lai_thieu': '🍇',
  'nhan_long_hung_yen': '🍇',
  'sau_rieng_ri6': '🥭',
  'thanh_long_binh_thuan': '🐉',
  'vai_thieu_luc_ngan': '🍒',
  'vu_sua_lo_ren': '🍐',
  'xoai_cat_hoa_loc': '🥭'
};

/**
 * Lấy tên tiếng Việt của trái cây
 */
function getVietnameseName(key) {
  return FruitNames[key] || key;
}

/**
 * Lấy emoji của trái cây
 */
function getFruitEmoji(key) {
  return FruitEmojis[key] || '🍎';
}

/**
 * Lấy danh sách tất cả trái cây
 */
function getAllFruits() {
  return Object.keys(FruitNames).map(key => ({
    key: key,
    name: FruitNames[key],
    emoji: FruitEmojis[key]
  }));
}

// ==========================================
// DATE & TIME FORMATTING
// ==========================================

/**
 * Format datetime thành chuỗi đẹp
 */
function formatDateTime(dateString) {
  if (!dateString) return '';
  
  const date = new Date(dateString);
  const now = new Date();
  const diffMs = now - date;
  const diffMins = Math.floor(diffMs / 60000);
  const diffHours = Math.floor(diffMs / 3600000);
  const diffDays = Math.floor(diffMs / 86400000);
  
  // Nếu trong vòng 1 phút
  if (diffMins < 1) {
    return 'Vừa xong';
  }
  
  // Nếu trong vòng 1 giờ
  if (diffMins < 60) {
    return `${diffMins} phút trước`;
  }
  
  // Nếu trong vòng 24 giờ
  if (diffHours < 24) {
    return `${diffHours} giờ trước`;
  }
  
  // Nếu trong vòng 7 ngày
  if (diffDays < 7) {
    return `${diffDays} ngày trước`;
  }
  
  // Ngày tháng năm đầy đủ
  return date.toLocaleDateString('vi-VN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  });
}

/**
 * Format date only
 */
function formatDate(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('vi-VN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  });
}

/**
 * Format time only
 */
function formatTime(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleTimeString('vi-VN', {
    hour: '2-digit',
    minute: '2-digit'
  });
}

// ==========================================
// IMAGE HANDLING
// ==========================================

/**
 * Lấy URL đầy đủ của image từ backend
 */
function getImageUrl(imagePath) {
  if (!imagePath) return '';
  
  // Nếu đã là URL đầy đủ
  if (imagePath.startsWith('http')) {
    return imagePath;
  }
  
  // Nếu là đường dẫn tương đối
  const baseUrl = apiService.baseUrl;
  return `${baseUrl}/${imagePath}`;
}

/**
 * Validate file ảnh
 */
function validateImageFile(file) {
  const validTypes = ['image/jpeg', 'image/jpg', 'image/png'];
  const maxSize = 10 * 1024 * 1024; // 10MB
  
  if (!validTypes.includes(file.type)) {
    throw new Error('Chỉ chấp nhận file JPG, JPEG, PNG');
  }
  
  if (file.size > maxSize) {
    throw new Error('Kích thước file không được vượt quá 10MB');
  }
  
  return true;
}

/**
 * Preview image từ file
 */
function previewImage(file, imgElement) {
  const reader = new FileReader();
  reader.onload = (e) => {
    imgElement.src = e.target.result;
  };
  reader.readAsDataURL(file);
}

// ==========================================
// UI HELPERS
// ==========================================

/**
 * Hiển thị loading overlay
 */
function showLoading(message = 'Đang xử lý...') {
  const overlay = document.createElement('div');
  overlay.id = 'loading-overlay';
  overlay.className = 'loading-overlay';
  overlay.innerHTML = `
    <div class="card" style="padding: 30px; text-align: center;">
      <div class="spinner" style="margin: 0 auto 20px;"></div>
      <div>${message}</div>
    </div>
  `;
  document.body.appendChild(overlay);
}

/**
 * Ẩn loading overlay
 */
function hideLoading() {
  const overlay = document.getElementById('loading-overlay');
  if (overlay) {
    overlay.remove();
  }
}

/**
 * Hiển thị alert
 */
function showAlert(message, type = 'info') {
  const alertDiv = document.createElement('div');
  alertDiv.className = `alert alert-${type}`;
  alertDiv.style.cssText = 'position: fixed; top: 80px; right: 20px; z-index: 9999; min-width: 300px; animation: slideIn 0.3s ease;';
  
  const icon = {
    success: '✓',
    error: '✗',
    warning: '⚠',
    info: 'ℹ'
  }[type] || 'ℹ';
  
  alertDiv.innerHTML = `
    <span style="font-size: 20px; margin-right: 10px;">${icon}</span>
    <span>${message}</span>
  `;
  
  document.body.appendChild(alertDiv);
  
  // Tự động ẩn sau 4 giây
  setTimeout(() => {
    alertDiv.style.animation = 'slideOut 0.3s ease';
    setTimeout(() => alertDiv.remove(), 300);
  }, 4000);
}

/**
 * Confirm dialog
 */
function showConfirm(message, onConfirm, onCancel = null) {
  const overlay = document.createElement('div');
  overlay.className = 'loading-overlay';
  overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
  
  overlay.innerHTML = `
    <div class="card" style="max-width: 400px; padding: 30px;">
      <h3 style="margin-bottom: 20px;">Xác nhận</h3>
      <p style="margin-bottom: 30px;">${message}</p>
      <div style="display: flex; gap: 10px; justify-content: flex-end;">
        <button class="btn btn-outline" id="cancel-btn">Hủy</button>
        <button class="btn btn-primary" id="confirm-btn">Xác nhận</button>
      </div>
    </div>
  `;
  
  document.body.appendChild(overlay);
  
  document.getElementById('confirm-btn').onclick = () => {
    overlay.remove();
    if (onConfirm) onConfirm();
  };
  
  document.getElementById('cancel-btn').onclick = () => {
    overlay.remove();
    if (onCancel) onCancel();
  };
}

// ==========================================
// VALIDATION
// ==========================================

/**
 * Validate email
 */
function validateEmail(email) {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(email);
}

/**
 * Validate username
 */
function validateUsername(username) {
  return username.length >= 3 && username.length <= 50;
}

/**
 * Validate password
 */
function validatePassword(password) {
  return password.length >= 6;
}

// ==========================================
// AUTH GUARDS
// ==========================================

/**
 * Kiểm tra đã đăng nhập, nếu chưa redirect về login
 */
function requireAuth() {
  if (!apiService.isAuthenticated()) {
    window.location.href = 'login.html';
    return false;
  }
  return true;
}

/**
 * Kiểm tra phải admin, nếu không redirect về home
 */
function requireAdmin() {
  if (!apiService.isAdmin()) {
    showAlert('Bạn không có quyền truy cập trang này', 'error');
    setTimeout(() => {
      window.location.href = 'index.html';
    }, 2000);
    return false;
  }
  return true;
}

/**
 * Redirect về home nếu đã đăng nhập (cho trang login/register)
 */
function redirectIfAuthenticated() {
  if (apiService.isAuthenticated()) {
    window.location.href = 'index.html';
  }
}

// ==========================================
// PAGINATION
// ==========================================

/**
 * Tạo HTML cho pagination
 */
function createPagination(currentPage, totalPages, onPageChange) {
  const container = document.createElement('div');
  container.className = 'pagination';
  container.style.cssText = 'display: flex; gap: 5px; justify-content: center; margin-top: 20px;';
  
  // Previous button
  const prevBtn = document.createElement('button');
  prevBtn.className = 'btn btn-sm';
  prevBtn.textContent = '← Trước';
  prevBtn.disabled = currentPage === 1;
  prevBtn.onclick = () => onPageChange(currentPage - 1);
  container.appendChild(prevBtn);
  
  // Page numbers
  const maxVisible = 5;
  let startPage = Math.max(1, currentPage - Math.floor(maxVisible / 2));
  let endPage = Math.min(totalPages, startPage + maxVisible - 1);
  
  if (endPage - startPage < maxVisible - 1) {
    startPage = Math.max(1, endPage - maxVisible + 1);
  }
  
  for (let i = startPage; i <= endPage; i++) {
    const pageBtn = document.createElement('button');
    pageBtn.className = `btn btn-sm ${i === currentPage ? 'btn-primary' : 'btn-outline'}`;
    pageBtn.textContent = i;
    pageBtn.onclick = () => onPageChange(i);
    container.appendChild(pageBtn);
  }
  
  // Next button
  const nextBtn = document.createElement('button');
  nextBtn.className = 'btn btn-sm';
  nextBtn.textContent = 'Sau →';
  nextBtn.disabled = currentPage === totalPages;
  nextBtn.onclick = () => onPageChange(currentPage + 1);
  container.appendChild(nextBtn);
  
  return container;
}

// ==========================================
// ANIMATIONS
// ==========================================

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
  @keyframes slideIn {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }
  
  @keyframes slideOut {
    from {
      transform: translateX(0);
      opacity: 1;
    }
    to {
      transform: translateX(100%);
      opacity: 0;
    }
  }
  
  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }
  
  .fade-in {
    animation: fadeIn 0.3s ease;
  }
`;
document.head.appendChild(style);

 * Utility Functions for Fruit Recognition Web App
 */

// ==========================================
// FRUIT NAMES MAPPING
// ==========================================

const FruitNames = {
  'buoi_da_xanh': 'Bưởi Da Xanh',
  'cam_sanh_ha_giang': 'Cam Sành Hà Giang',
  'chom_chom_long_khanh': 'Chôm Chôm Long Khánh',
  'mang_cut_lai_thieu': 'Măng Cụt Lái Thiêu',
  'nhan_long_hung_yen': 'Nhãn Lồng Hưng Yên',
  'sau_rieng_ri6': 'Sầu Riêng Ri6',
  'thanh_long_binh_thuan': 'Thanh Long Bình Thuận',
  'vai_thieu_luc_ngan': 'Vải Thiều Lục Ngạn',
  'vu_sua_lo_ren': 'Vú Sữa Lò Rèn',
  'xoai_cat_hoa_loc': 'Xoài Cát Hòa Lộc'
};

const FruitEmojis = {
  'buoi_da_xanh': '🍊',
  'cam_sanh_ha_giang': '🍊',
  'chom_chom_long_khanh': '🍇',
  'mang_cut_lai_thieu': '🍇',
  'nhan_long_hung_yen': '🍇',
  'sau_rieng_ri6': '🥭',
  'thanh_long_binh_thuan': '🐉',
  'vai_thieu_luc_ngan': '🍒',
  'vu_sua_lo_ren': '🍐',
  'xoai_cat_hoa_loc': '🥭'
};

/**
 * Lấy tên tiếng Việt của trái cây
 */
function getVietnameseName(key) {
  return FruitNames[key] || key;
}

/**
 * Lấy emoji của trái cây
 */
function getFruitEmoji(key) {
  return FruitEmojis[key] || '🍎';
}

/**
 * Lấy danh sách tất cả trái cây
 */
function getAllFruits() {
  return Object.keys(FruitNames).map(key => ({
    key: key,
    name: FruitNames[key],
    emoji: FruitEmojis[key]
  }));
}

// ==========================================
// DATE & TIME FORMATTING
// ==========================================

/**
 * Format datetime thành chuỗi đẹp
 */
function formatDateTime(dateString) {
  if (!dateString) return '';
  
  const date = new Date(dateString);
  const now = new Date();
  const diffMs = now - date;
  const diffMins = Math.floor(diffMs / 60000);
  const diffHours = Math.floor(diffMs / 3600000);
  const diffDays = Math.floor(diffMs / 86400000);
  
  // Nếu trong vòng 1 phút
  if (diffMins < 1) {
    return 'Vừa xong';
  }
  
  // Nếu trong vòng 1 giờ
  if (diffMins < 60) {
    return `${diffMins} phút trước`;
  }
  
  // Nếu trong vòng 24 giờ
  if (diffHours < 24) {
    return `${diffHours} giờ trước`;
  }
  
  // Nếu trong vòng 7 ngày
  if (diffDays < 7) {
    return `${diffDays} ngày trước`;
  }
  
  // Ngày tháng năm đầy đủ
  return date.toLocaleDateString('vi-VN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  });
}

/**
 * Format date only
 */
function formatDate(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('vi-VN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  });
}

/**
 * Format time only
 */
function formatTime(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleTimeString('vi-VN', {
    hour: '2-digit',
    minute: '2-digit'
  });
}

// ==========================================
// IMAGE HANDLING
// ==========================================

/**
 * Lấy URL đầy đủ của image từ backend
 */
function getImageUrl(imagePath) {
  if (!imagePath) return '';
  
  // Nếu đã là URL đầy đủ
  if (imagePath.startsWith('http')) {
    return imagePath;
  }
  
  // Nếu là đường dẫn tương đối
  const baseUrl = apiService.baseUrl;
  return `${baseUrl}/${imagePath}`;
}

/**
 * Validate file ảnh
 */
function validateImageFile(file) {
  const validTypes = ['image/jpeg', 'image/jpg', 'image/png'];
  const maxSize = 10 * 1024 * 1024; // 10MB
  
  if (!validTypes.includes(file.type)) {
    throw new Error('Chỉ chấp nhận file JPG, JPEG, PNG');
  }
  
  if (file.size > maxSize) {
    throw new Error('Kích thước file không được vượt quá 10MB');
  }
  
  return true;
}

/**
 * Preview image từ file
 */
function previewImage(file, imgElement) {
  const reader = new FileReader();
  reader.onload = (e) => {
    imgElement.src = e.target.result;
  };
  reader.readAsDataURL(file);
}

// ==========================================
// UI HELPERS
// ==========================================

/**
 * Hiển thị loading overlay
 */
function showLoading(message = 'Đang xử lý...') {
  const overlay = document.createElement('div');
  overlay.id = 'loading-overlay';
  overlay.className = 'loading-overlay';
  overlay.innerHTML = `
    <div class="card" style="padding: 30px; text-align: center;">
      <div class="spinner" style="margin: 0 auto 20px;"></div>
      <div>${message}</div>
    </div>
  `;
  document.body.appendChild(overlay);
}

/**
 * Ẩn loading overlay
 */
function hideLoading() {
  const overlay = document.getElementById('loading-overlay');
  if (overlay) {
    overlay.remove();
  }
}

/**
 * Hiển thị alert
 */
function showAlert(message, type = 'info') {
  const alertDiv = document.createElement('div');
  alertDiv.className = `alert alert-${type}`;
  alertDiv.style.cssText = 'position: fixed; top: 80px; right: 20px; z-index: 9999; min-width: 300px; animation: slideIn 0.3s ease;';
  
  const icon = {
    success: '✓',
    error: '✗',
    warning: '⚠',
    info: 'ℹ'
  }[type] || 'ℹ';
  
  alertDiv.innerHTML = `
    <span style="font-size: 20px; margin-right: 10px;">${icon}</span>
    <span>${message}</span>
  `;
  
  document.body.appendChild(alertDiv);
  
  // Tự động ẩn sau 4 giây
  setTimeout(() => {
    alertDiv.style.animation = 'slideOut 0.3s ease';
    setTimeout(() => alertDiv.remove(), 300);
  }, 4000);
}

/**
 * Confirm dialog
 */
function showConfirm(message, onConfirm, onCancel = null) {
  const overlay = document.createElement('div');
  overlay.className = 'loading-overlay';
  overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
  
  overlay.innerHTML = `
    <div class="card" style="max-width: 400px; padding: 30px;">
      <h3 style="margin-bottom: 20px;">Xác nhận</h3>
      <p style="margin-bottom: 30px;">${message}</p>
      <div style="display: flex; gap: 10px; justify-content: flex-end;">
        <button class="btn btn-outline" id="cancel-btn">Hủy</button>
        <button class="btn btn-primary" id="confirm-btn">Xác nhận</button>
      </div>
    </div>
  `;
  
  document.body.appendChild(overlay);
  
  document.getElementById('confirm-btn').onclick = () => {
    overlay.remove();
    if (onConfirm) onConfirm();
  };
  
  document.getElementById('cancel-btn').onclick = () => {
    overlay.remove();
    if (onCancel) onCancel();
  };
}

// ==========================================
// VALIDATION
// ==========================================

/**
 * Validate email
 */
function validateEmail(email) {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(email);
}

/**
 * Validate username
 */
function validateUsername(username) {
  return username.length >= 3 && username.length <= 50;
}

/**
 * Validate password
 */
function validatePassword(password) {
  return password.length >= 6;
}

// ==========================================
// AUTH GUARDS
// ==========================================

/**
 * Kiểm tra đã đăng nhập, nếu chưa redirect về login
 */
function requireAuth() {
  if (!apiService.isAuthenticated()) {
    window.location.href = 'login.html';
    return false;
  }
  return true;
}

/**
 * Kiểm tra phải admin, nếu không redirect về home
 */
function requireAdmin() {
  if (!apiService.isAdmin()) {
    showAlert('Bạn không có quyền truy cập trang này', 'error');
    setTimeout(() => {
      window.location.href = 'index.html';
    }, 2000);
    return false;
  }
  return true;
}

/**
 * Redirect về home nếu đã đăng nhập (cho trang login/register)
 */
function redirectIfAuthenticated() {
  if (apiService.isAuthenticated()) {
    window.location.href = 'index.html';
  }
}

// ==========================================
// PAGINATION
// ==========================================

/**
 * Tạo HTML cho pagination
 */
function createPagination(currentPage, totalPages, onPageChange) {
  const container = document.createElement('div');
  container.className = 'pagination';
  container.style.cssText = 'display: flex; gap: 5px; justify-content: center; margin-top: 20px;';
  
  // Previous button
  const prevBtn = document.createElement('button');
  prevBtn.className = 'btn btn-sm';
  prevBtn.textContent = '← Trước';
  prevBtn.disabled = currentPage === 1;
  prevBtn.onclick = () => onPageChange(currentPage - 1);
  container.appendChild(prevBtn);
  
  // Page numbers
  const maxVisible = 5;
  let startPage = Math.max(1, currentPage - Math.floor(maxVisible / 2));
  let endPage = Math.min(totalPages, startPage + maxVisible - 1);
  
  if (endPage - startPage < maxVisible - 1) {
    startPage = Math.max(1, endPage - maxVisible + 1);
  }
  
  for (let i = startPage; i <= endPage; i++) {
    const pageBtn = document.createElement('button');
    pageBtn.className = `btn btn-sm ${i === currentPage ? 'btn-primary' : 'btn-outline'}`;
    pageBtn.textContent = i;
    pageBtn.onclick = () => onPageChange(i);
    container.appendChild(pageBtn);
  }
  
  // Next button
  const nextBtn = document.createElement('button');
  nextBtn.className = 'btn btn-sm';
  nextBtn.textContent = 'Sau →';
  nextBtn.disabled = currentPage === totalPages;
  nextBtn.onclick = () => onPageChange(currentPage + 1);
  container.appendChild(nextBtn);
  
  return container;
}

// ==========================================
// ANIMATIONS
// ==========================================

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
  @keyframes slideIn {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }
  
  @keyframes slideOut {
    from {
      transform: translateX(0);
      opacity: 1;
    }
    to {
      transform: translateX(100%);
      opacity: 0;
    }
  }
  
  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }
  
  .fade-in {
    animation: fadeIn 0.3s ease;
  }
`;
document.head.appendChild(style);



