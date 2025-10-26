/**
 * API Service for Fruit Recognition Web App
 * Tương tự như Flutter API Service
 */

class ApiService {
  constructor() {
    // Lấy từ localStorage hoặc mặc định
    this.baseUrl = localStorage.getItem('apiBaseUrl') || 'http://192.168.1.36:5000';
    this.accessToken = localStorage.getItem('accessToken');
    this.refreshToken = localStorage.getItem('refreshToken');
  }

  /**
   * Tạo headers cho request
   */
  _getHeaders(includeAuth = false, isFormData = false) {
    const headers = {};
    
    if (!isFormData) {
      headers['Content-Type'] = 'application/json';
    }
    
    if (includeAuth && this.accessToken) {
      headers['Authorization'] = `Bearer ${this.accessToken}`;
    }
    
    return headers;
  }

  /**
   * Xử lý response
   */
  async _handleResponse(response) {
    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.error || data.message || 'Có lỗi xảy ra');
    }
    
    return data;
  }

  /**
   * Refresh access token
   */
  async refreshAccessToken() {
    try {
      const response = await fetch(`${this.baseUrl}/api/auth/refresh`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.refreshToken}`
        }
      });
      
      const data = await this._handleResponse(response);
      this.accessToken = data.access_token;
      localStorage.setItem('accessToken', data.access_token);
      
      return data.access_token;
    } catch (error) {
      // Refresh token hết hạn, logout
      this.logout();
      throw error;
    }
  }

  /**
   * Thực hiện request với auto-retry khi token hết hạn
   */
  async _request(url, options = {}) {
    try {
      const response = await fetch(url, options);
      
      // Nếu 401 và có refresh token, thử refresh
      if (response.status === 401 && this.refreshToken) {
        await this.refreshAccessToken();
        
        // Retry request với token mới
        options.headers['Authorization'] = `Bearer ${this.accessToken}`;
        const retryResponse = await fetch(url, options);
        return await this._handleResponse(retryResponse);
      }
      
      return await this._handleResponse(response);
    } catch (error) {
      throw error;
    }
  }

  // ==========================================
  // AUTH ENDPOINTS
  // ==========================================

  /**
   * Đăng ký tài khoản mới
   */
  async register(username, email, password, fullName) {
    const response = await fetch(`${this.baseUrl}/api/auth/register`, {
      method: 'POST',
      headers: this._getHeaders(),
      body: JSON.stringify({
        username,
        email,
        password,
        full_name: fullName
      })
    });
    
    return await this._handleResponse(response);
  }

  /**
   * Đăng nhập
   */
  async login(username, password) {
    const response = await fetch(`${this.baseUrl}/api/auth/login`, {
      method: 'POST',
      headers: this._getHeaders(),
      body: JSON.stringify({ username, password })
    });
    
    const data = await this._handleResponse(response);
    
    // Lưu tokens
    this.accessToken = data.access_token;
    this.refreshToken = data.refresh_token;
    localStorage.setItem('accessToken', data.access_token);
    localStorage.setItem('refreshToken', data.refresh_token);
    localStorage.setItem('user', JSON.stringify(data.user));
    
    return data;
  }

  /**
   * Đăng xuất
   */
  logout() {
    this.accessToken = null;
    this.refreshToken = null;
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('user');
    window.location.href = 'login.html';
  }

  /**
   * Lấy thông tin user hiện tại
   */
  getCurrentUser() {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
  }

  /**
   * Kiểm tra đã đăng nhập chưa
   */
  isAuthenticated() {
    return !!this.accessToken;
  }

  /**
   * Kiểm tra có phải admin không
   */
  isAdmin() {
    const user = this.getCurrentUser();
    return user && user.is_admin === true;
  }

  // ==========================================
  // PREDICTION ENDPOINTS
  // ==========================================

  /**
   * Upload ảnh và nhận diện trái cây
   */
  async predictFruit(imageFile) {
    const formData = new FormData();
    formData.append('image', imageFile);
    
    return await this._request(`${this.baseUrl}/api/predict`, {
      method: 'POST',
      headers: this._getHeaders(true, true),
      body: formData
    });
  }

  /**
   * Lấy lịch sử dự đoán
   */
  async getPredictionHistory(page = 1, perPage = 10) {
    return await this._request(
      `${this.baseUrl}/api/predictions?page=${page}&per_page=${perPage}`,
      {
        method: 'GET',
        headers: this._getHeaders(true)
      }
    );
  }

  /**
   * Lấy chi tiết 1 dự đoán
   */
  async getPredictionDetail(predictionId) {
    return await this._request(
      `${this.baseUrl}/api/predictions/${predictionId}`,
      {
        method: 'GET',
        headers: this._getHeaders(true)
      }
    );
  }

  /**
   * Xóa dự đoán
   */
  async deletePrediction(predictionId) {
    return await this._request(
      `${this.baseUrl}/api/predictions/${predictionId}`,
      {
        method: 'DELETE',
        headers: this._getHeaders(true)
      }
    );
  }

  // ==========================================
  // FEEDBACK ENDPOINTS
  // ==========================================

  /**
   * Gửi phản hồi
   */
  async submitFeedback(predictionId, isCorrect, comment = null) {
    return await this._request(`${this.baseUrl}/api/feedback`, {
      method: 'POST',
      headers: this._getHeaders(true),
      body: JSON.stringify({
        prediction_id: predictionId,
        is_correct: isCorrect,
        comment: comment
      })
    });
  }

  // ==========================================
  // ADMIN ENDPOINTS
  // ==========================================

  /**
   * Lấy danh sách feedback (Admin)
   */
  async getAdminFeedbacks(page = 1, perPage = 20, isCorrect = null, isRead = null) {
    let url = `${this.baseUrl}/api/admin/feedback?page=${page}&per_page=${perPage}`;
    
    if (isCorrect !== null) {
      url += `&is_correct=${isCorrect}`;
    }
    if (isRead !== null) {
      url += `&is_read=${isRead}`;
    }
    
    return await this._request(url, {
      method: 'GET',
      headers: this._getHeaders(true)
    });
  }

  /**
   * Đánh dấu feedback đã đọc (Admin)
   */
  async markFeedbackAsRead(feedbackId) {
    return await this._request(
      `${this.baseUrl}/api/admin/feedback/${feedbackId}/read`,
      {
        method: 'PUT',
        headers: this._getHeaders(true)
      }
    );
  }

  /**
   * Thêm feedback vào training dataset (Admin)
   */
  async addFeedbackToTraining(feedbackId, correctLabel) {
    return await this._request(
      `${this.baseUrl}/api/admin/feedback/${feedbackId}/add_to_training`,
      {
        method: 'POST',
        headers: this._getHeaders(true),
        body: JSON.stringify({
          correct_label: correctLabel
        })
      }
    );
  }

  /**
   * Lấy thống kê (Admin)
   */
  async getAdminStats() {
    return await this._request(`${this.baseUrl}/api/admin/stats`, {
      method: 'GET',
      headers: this._getHeaders(true)
    });
  }
}

// Export singleton instance
const apiService = new ApiService();



