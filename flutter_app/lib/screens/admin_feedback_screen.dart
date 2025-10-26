import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../utils/timezone_helper.dart';
import '../models/admin_models.dart';

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  final ApiService _apiService = ApiService();
  List<FeedbackData> _feedbacks = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool? _filterIsCorrect;
  bool? _filterIsRead;

  @override
  void initState() {
    super.initState();
    _loadFeedbacks();
  }

  Future<void> _loadFeedbacks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.getFeedback(
        page: 1,
        perPage: 50,
        isCorrect: _filterIsCorrect,
        isRead: _filterIsRead,
      );
      
      setState(() {
        _feedbacks = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFeedbackRead(FeedbackData feedback) async {
    try {
      await _apiService.markFeedbackRead(feedback.id, !feedback.isRead);
      _loadFeedbacks(); // Reload để cập nhật UI
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            feedback.isRead 
              ? 'Đã đánh dấu chưa xem' 
              : 'Đã đánh dấu đã xem',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _apiService.markAllFeedbackRead();
      _loadFeedbacks();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã đánh dấu tất cả là đã xem'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Phản Hồi Người Dùng',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Đánh dấu tất cả đã xem',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Xác nhận'),
                  content: const Text('Đánh dấu tất cả phản hồi là đã xem?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _markAllAsRead();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: const Text('Xác nhận'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFeedbacks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitCircle(
                color: AppColors.primary,
                size: 50,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadFeedbacks,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _feedbacks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.feedback_outlined,
                            size: 64,
                            color: AppColors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Chưa có phản hồi nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadFeedbacks,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _feedbacks.length,
                        itemBuilder: (context, index) {
                          final feedback = _feedbacks[index];
                          return _buildFeedbackCard(feedback);
                        },
                      ),
                    ),
    );
  }

  Widget _buildFeedbackCard(FeedbackData feedback) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: feedback.isRead 
            ? Colors.transparent 
            : AppColors.primary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  feedback.isCorrect ? Icons.check_circle : Icons.cancel,
                  color: feedback.isCorrect ? AppColors.success : AppColors.error,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            feedback.isCorrect ? 'Dự đoán đúng' : 'Dự đoán sai',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: feedback.isCorrect
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (!feedback.isRead)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'MỚI',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID Phản hồi: ${feedback.id}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle button đã xem/chưa xem
                IconButton(
                  icon: Icon(
                    feedback.isRead 
                      ? Icons.mark_email_read 
                      : Icons.mark_email_unread,
                    color: feedback.isRead 
                      ? AppColors.grey 
                      : AppColors.primary,
                  ),
                  tooltip: feedback.isRead 
                    ? 'Đánh dấu chưa xem' 
                    : 'Đánh dấu đã xem',
                  onPressed: () => _toggleFeedbackRead(feedback),
                ),
              ],
            ),
            
            if (feedback.comment != null && feedback.comment!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.comment,
                      size: 16,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feedback.comment!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (feedback.prediction != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              // Hiển thị hình ảnh và thông tin dự đoán
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '${ApiConstants.baseUrl}/${feedback.prediction!.imagePath}',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.grey,
                            size: 32,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Thông tin dự đoán
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dự đoán:',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          FruitNames.getVietnameseName(feedback.prediction!.predictedLabel),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Độ tin cậy: ${(feedback.prediction!.confidence * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  TimezoneHelper.formatDateTime(
                    DateTime.parse(feedback.createdAt),
                    isUtc: true,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
            
            // Button thêm vào training dataset
            if (feedback.prediction != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              
              feedback.addedToTraining
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Đã thêm vào Training Dataset',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                              if (feedback.trainingLabel != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Label: ${FruitNames.getVietnameseName(feedback.trainingLabel!)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                              if (feedback.addedToTrainingAt != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Thời gian: ${feedback.addedToTrainingAt!.substring(0, 19).replaceAll('T', ' ')}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddToTrainingDialog(feedback),
                      icon: const Icon(Icons.add_photo_alternate, size: 20),
                      label: const Text('Thêm vào Training Dataset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddToTrainingDialog(FeedbackData feedback) {
    // Danh sách các loại trái cây
    final fruitLabels = [
      {'key': 'buoi_da_xanh', 'name': 'Bưởi Da Xanh'},
      {'key': 'cam_sanh_ha_giang', 'name': 'Cam Sành Hà Giang'},
      {'key': 'chom_chom_long_khanh', 'name': 'Chôm Chôm Long Khánh'},
      {'key': 'mang_cut_lai_thieu', 'name': 'Măng Cụt Lái Thiêu'},
      {'key': 'nhan_long_hung_yen', 'name': 'Nhãn Lồng Hưng Yên'},
      {'key': 'sau_rieng_ri6', 'name': 'Sầu Riêng Ri6'},
      {'key': 'thanh_long_binh_thuan', 'name': 'Thanh Long Bình Thuận'},
      {'key': 'vai_thieu_luc_ngan', 'name': 'Vải Thiều Lục Ngạn'},
      {'key': 'vu_sua_lo_ren', 'name': 'Vú Sữa Lò Rèn'},
      {'key': 'xoai_cat_hoa_loc', 'name': 'Xoài Cát Hòa Lộc'},
    ];

    // Label được dự đoán (gợi ý mặc định)
    String? selectedLabel = feedback.prediction?.predictedLabel;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Chọn Label Đúng'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn loại trái cây đúng cho hình ảnh này:',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Hiển thị dự đoán hiện tại
                if (feedback.prediction != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dự đoán: ${FruitNames.getVietnameseName(feedback.prediction!.predictedLabel)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Danh sách radio buttons
                ...fruitLabels.map((fruit) {
                  return RadioListTile<String>(
                    title: Text(fruit['name']!),
                    value: fruit['key']!,
                    groupValue: selectedLabel,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedLabel = value;
                      });
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Hủy',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: selectedLabel == null
                  ? null
                  : () async {
                      Navigator.pop(dialogContext);
                      await _addToTraining(feedback, selectedLabel!);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Thêm vào Training'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToTraining(FeedbackData feedback, String correctLabel) async {
    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Đang thêm vào training dataset...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final result = await _apiService.addFeedbackToTraining(
        feedback.id,
        correctLabel,
      );
      
      // Đóng loading dialog
      Navigator.pop(context);
      
      // Reload danh sách
      await _loadFeedbacks();
      
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '✓ Đã thêm vào training dataset!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Label: ${FruitNames.getVietnameseName(correctLabel)}',
                style: const TextStyle(fontSize: 12),
              ),
              if (result['total_images_in_category'] != null)
                Text(
                  'Tổng ảnh trong category: ${result['total_images_in_category']}',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      // Đóng loading dialog
      Navigator.pop(context);
      
      // Hiển thị lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showFilterDialog() {
    // Tạo biến local để lưu filter tạm thời
    bool? tempFilterIsCorrect = _filterIsCorrect;
    bool? tempFilterIsRead = _filterIsRead;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Lọc phản hồi'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trạng thái dự đoán:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                RadioListTile<bool?>(
                  title: const Text('Tất cả'),
                  value: null,
                  groupValue: tempFilterIsCorrect,
                  onChanged: (value) {
                    setDialogState(() {
                      tempFilterIsCorrect = value;
                    });
                  },
                ),
                RadioListTile<bool?>(
                  title: const Text('Dự đoán đúng'),
                  value: true,
                  groupValue: tempFilterIsCorrect,
                  onChanged: (value) {
                    setDialogState(() {
                      tempFilterIsCorrect = value;
                    });
                  },
                ),
                RadioListTile<bool?>(
                  title: const Text('Dự đoán sai'),
                  value: false,
                  groupValue: tempFilterIsCorrect,
                  onChanged: (value) {
                    setDialogState(() {
                      tempFilterIsCorrect = value;
                    });
                  },
                ),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Trạng thái xem:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                RadioListTile<bool?>(
                  title: const Text('Tất cả'),
                  value: null,
                  groupValue: tempFilterIsRead,
                  onChanged: (value) {
                    setDialogState(() {
                      tempFilterIsRead = value;
                    });
                  },
                ),
                RadioListTile<bool?>(
                  title: const Text('Chưa xem'),
                  value: false,
                  groupValue: tempFilterIsRead,
                  onChanged: (value) {
                    setDialogState(() {
                      tempFilterIsRead = value;
                    });
                  },
                ),
                RadioListTile<bool?>(
                  title: const Text('Đã xem'),
                  value: true,
                  groupValue: tempFilterIsRead,
                  onChanged: (value) {
                    setDialogState(() {
                      tempFilterIsRead = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterIsCorrect = null;
                  _filterIsRead = null;
                });
                Navigator.pop(dialogContext);
                _loadFeedbacks();
              },
              child: const Text(
                'Xóa bộ lọc',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterIsCorrect = tempFilterIsCorrect;
                  _filterIsRead = tempFilterIsRead;
                });
                Navigator.pop(dialogContext);
                _loadFeedbacks();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Áp dụng'),
            ),
          ],
        ),
      ),
    );
}
}