/**
 * Main page logic - Upload & Predict
 */

// Check authentication
requireAuth();

// State
let selectedFile = null;
let currentPredictionId = null;

// DOM Elements
const uploadSection = document.getElementById('upload-section');
const resultSection = document.getElementById('result-section');
const uploadArea = document.getElementById('upload-area');
const fileInput = document.getElementById('file-input');
const selectFileBtn = document.getElementById('select-file-btn');
const previewImage = document.getElementById('preview-image');
const changeImageBtn = document.getElementById('change-image-btn');
const predictBtn = document.getElementById('predict-btn');
const predictionResult = document.getElementById('prediction-result');
const menuToggle = document.getElementById('menu-toggle');
const navMenu = document.getElementById('nav-menu');
const logoutBtn = document.getElementById('logout-btn');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
  initializeUser();
  setupEventListeners();
});

/**
 * Initialize user info
 */
function initializeUser() {
  const user = apiService.getCurrentUser();
  
  if (user) {
    document.getElementById('user-name').textContent = user.full_name || user.username;
    document.getElementById('user-avatar').textContent = 
      (user.full_name || user.username).charAt(0).toUpperCase();
    
    // Show admin link if admin
    if (apiService.isAdmin()) {
      document.getElementById('admin-link').style.display = 'block';
      document.getElementById('admin-link').href = 'pages/admin.html';
    }
  }
}

/**
 * Setup event listeners
 */
function setupEventListeners() {
  // Mobile menu toggle
  menuToggle.addEventListener('click', () => {
    navMenu.classList.toggle('active');
  });
  
  // Logout
  logoutBtn.addEventListener('click', () => {
    showConfirm('Bạn có chắc muốn đăng xuất?', () => {
      apiService.logout();
    });
  });
  
  // File selection
  selectFileBtn.addEventListener('click', () => {
    fileInput.click();
  });
  
  uploadArea.addEventListener('click', (e) => {
    if (e.target === uploadArea || e.target.closest('.upload-area')) {
      fileInput.click();
    }
  });
  
  fileInput.addEventListener('change', (e) => {
    if (e.target.files && e.target.files[0]) {
      handleFileSelect(e.target.files[0]);
    }
  });
  
  // Drag & Drop
  uploadArea.addEventListener('dragover', (e) => {
    e.preventDefault();
    uploadArea.classList.add('dragover');
  });
  
  uploadArea.addEventListener('dragleave', () => {
    uploadArea.classList.remove('dragover');
  });
  
  uploadArea.addEventListener('drop', (e) => {
    e.preventDefault();
    uploadArea.classList.remove('dragover');
    
    const file = e.dataTransfer.files[0];
    if (file) {
      handleFileSelect(file);
    }
  });
  
  // Change image
  changeImageBtn.addEventListener('click', () => {
    resetToUpload();
  });
  
  // Predict
  predictBtn.addEventListener('click', () => {
    handlePredict();
  });
  
  // Feedback buttons
  document.getElementById('correct-btn').addEventListener('click', () => {
    handleFeedback(true);
  });
  
  document.getElementById('incorrect-btn').addEventListener('click', () => {
    handleFeedback(false);
  });
  
  document.getElementById('submit-feedback-btn').addEventListener('click', () => {
    submitFeedback();
  });
  
  // New prediction
  document.getElementById('new-prediction-btn').addEventListener('click', () => {
    resetToUpload();
  });
}

/**
 * Handle file selection
 */
function handleFileSelect(file) {
  if (!file) return;
  
  try {
    // Validate
    validateImageFile(file);
    
    selectedFile = file;
    
    // Preview
    const reader = new FileReader();
    reader.onload = (e) => {
      previewImage.src = e.target.result;
    };
    reader.readAsDataURL(file);
    
    // Show result section
    uploadSection.style.display = 'none';
    resultSection.style.display = 'block';
    predictionResult.style.display = 'none';
    
  } catch (error) {
    showAlert(error.message, 'error');
  }
}

/**
 * Handle prediction
 */
async function handlePredict() {
  if (!selectedFile) {
    showAlert('Vui lòng chọn hình ảnh', 'warning');
    return;
  }
  
  try {
    showLoading('Đang nhận diện...');
    
    const result = await apiService.predictFruit(selectedFile);
    
    hideLoading();
    
    // Save prediction ID
    currentPredictionId = result.prediction_id;
    
    // Display result
    displayPredictionResult(result);
    
  } catch (error) {
    hideLoading();
    console.error('Prediction error:', error);
    showAlert(error.message || 'Nhận diện thất bại. Vui lòng thử lại!', 'error');
  }
}

/**
 * Display prediction result
 */
function displayPredictionResult(result) {
  // Show result section
  predictionResult.style.display = 'block';
  
  // Hide predict button
  predictBtn.style.display = 'none';
  
  // Display fruit info
  const fruitName = getVietnameseName(result.predicted_label);
  const fruitEmoji = getFruitEmoji(result.predicted_label);
  const confidence = Math.round(result.confidence * 100);
  
  document.getElementById('result-emoji').textContent = fruitEmoji;
  document.getElementById('result-name').textContent = fruitName;
  
  // Animate confidence bar
  setTimeout(() => {
    const confidenceFill = document.getElementById('confidence-fill');
    confidenceFill.style.width = confidence + '%';
    document.getElementById('confidence-text').textContent = confidence + '%';
  }, 100);
  
  // Reset feedback section
  document.getElementById('comment-section').style.display = 'none';
  document.getElementById('comment-input').value = '';
  document.getElementById('correct-btn').disabled = false;
  document.getElementById('incorrect-btn').disabled = false;
}

/**
 * Handle feedback button click
 */
function handleFeedback(isCorrect) {
  // Show comment section
  document.getElementById('comment-section').style.display = 'block';
  
  // Store feedback choice
  document.getElementById('submit-feedback-btn').dataset.isCorrect = isCorrect;
  
  // Update button states
  if (isCorrect) {
    document.getElementById('correct-btn').classList.add('btn-primary');
    document.getElementById('incorrect-btn').classList.remove('btn-danger');
    document.getElementById('incorrect-btn').classList.add('btn-outline');
  } else {
    document.getElementById('incorrect-btn').classList.add('btn-danger');
    document.getElementById('correct-btn').classList.remove('btn-primary');
    document.getElementById('correct-btn').classList.add('btn-outline');
  }
}

/**
 * Submit feedback
 */
async function submitFeedback() {
  const isCorrect = document.getElementById('submit-feedback-btn').dataset.isCorrect === 'true';
  const comment = document.getElementById('comment-input').value.trim();
  
  try {
    showLoading('Đang gửi phản hồi...');
    
    await apiService.submitFeedback(
      currentPredictionId,
      isCorrect,
      comment || null
    );
    
    hideLoading();
    showAlert('Cảm ơn bạn đã gửi phản hồi! 🙏', 'success');
    
    // Disable feedback buttons
    document.getElementById('correct-btn').disabled = true;
    document.getElementById('incorrect-btn').disabled = true;
    document.getElementById('submit-feedback-btn').disabled = true;
    
  } catch (error) {
    hideLoading();
    showAlert(error.message || 'Gửi phản hồi thất bại', 'error');
  }
}

/**
 * Reset to upload state
 */
function resetToUpload() {
  selectedFile = null;
  currentPredictionId = null;
  fileInput.value = '';
  
  uploadSection.style.display = 'block';
  resultSection.style.display = 'none';
  predictionResult.style.display = 'none';
  predictBtn.style.display = 'inline-flex';
  
  // Reset confidence bar
  document.getElementById('confidence-fill').style.width = '0%';
  document.getElementById('confidence-text').textContent = '0%';
}



