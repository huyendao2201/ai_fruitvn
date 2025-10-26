import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../models/admin_models.dart';

class AdminTrainingScreen extends StatefulWidget {
  const AdminTrainingScreen({super.key});

  @override
  State<AdminTrainingScreen> createState() => _AdminTrainingScreenState();
}

class _AdminTrainingScreenState extends State<AdminTrainingScreen> {
  final ApiService _apiService = ApiService();
  List<TrainingLog> _trainingLogs = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTrainingLogs();
  }

  Future<void> _loadTrainingLogs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = StorageService.getAccessToken();
      if (token != null) {
        _apiService.setAccessToken(token);
      }

      final data = await _apiService.getTrainingLogs();
      
      setState(() {
        _trainingLogs = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Nhật Ký Huấn Luyện',
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
            icon: const Icon(Icons.refresh),
            onPressed: _loadTrainingLogs,
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
                        onPressed: _loadTrainingLogs,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _trainingLogs.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.model_training,
                            size: 64,
                            color: AppColors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Chưa có nhật ký huấn luyện',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadTrainingLogs,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _trainingLogs.length,
                        itemBuilder: (context, index) {
                          final log = _trainingLogs[index];
                          return _buildTrainingCard(log, index == 0);
                        },
                      ),
                    ),
    );
  }

  Widget _buildTrainingCard(TrainingLog log, bool isLatest) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isLatest ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isLatest
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.model_training,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Phiên bản ${log.modelVersion}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isLatest) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Mới nhất',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        log.dateTrained.substring(0, 19).replaceAll('T', ' '),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Metrics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildMetricItem(
                  'Độ chính xác',
                  '${(log.accuracy * 100).toStringAsFixed(2)}%',
                  Icons.check_circle,
                  AppColors.success,
                ),
                _buildMetricItem(
                  'Loss',
                  log.loss.toStringAsFixed(4),
                  Icons.show_chart,
                  AppColors.secondary,
                ),
                if (log.valAccuracy != null)
                  _buildMetricItem(
                    'Val Accuracy',
                    '${(log.valAccuracy! * 100).toStringAsFixed(2)}%',
                    Icons.verified,
                    const Color(0xFF9C27B0),
                  ),
                if (log.valLoss != null)
                  _buildMetricItem(
                    'Val Loss',
                    log.valLoss!.toStringAsFixed(4),
                    Icons.trending_down,
                    AppColors.error,
                  ),
                if (log.epochs != null)
                  _buildMetricItem(
                    'Epochs',
                    log.epochs.toString(),
                    Icons.refresh,
                    AppColors.primary,
                  ),
              ],
            ),

            if (log.notes != null && log.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
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
                      Icons.note,
                      size: 16,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        log.notes!,
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
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
}
}