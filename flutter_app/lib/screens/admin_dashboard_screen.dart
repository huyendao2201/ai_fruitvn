import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../models/admin_models.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final ApiService _apiService = ApiService();
  DashboardData? _dashboardData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load access token
      final token = StorageService.getAccessToken();
      if (token == null) {
        // Không có token, quay về màn hình đăng nhập
        if (!mounted) return;
        await StorageService.clearAll();
        Navigator.pushReplacementNamed(context, '/admin_login');
        return;
      }
      
      _apiService.setAccessToken(token);
      final data = await _apiService.getDashboard();
      
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } on UnauthorizedException {
      // Token không hợp lệ hoặc hết hạn - Tự động logout
      await StorageService.clearAll();
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 3),
        ),
      );
      
      Navigator.pushReplacementNamed(context, '/admin_login');
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _apiService.logoutAdmin();
      await StorageService.clearAll();
      
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi đăng xuất: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = StorageService.getUsername() ?? 'Admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Bảng Điều Khiển Admin',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboard,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildDrawer(username),
      body: _isLoading
          ? const Center(
              child: SpinKitCircle(
                color: AppColors.primary,
                size: 50,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
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
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadDashboard,
                          child: const Text('Thử lại'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await StorageService.clearAll();
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã xóa dữ liệu. Vui lòng đăng nhập lại.'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            Navigator.pushReplacementNamed(context, '/admin_login');
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Xóa dữ liệu & Đăng nhập lại'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDashboard,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeCard(username),
                        const SizedBox(height: 20),
                        _buildStatsGrid(),
                        const SizedBox(height: 20),
                        _buildPredictionTrendChart(),
                        const SizedBox(height: 20),
                        _buildFruitDistributionChart(),
                        const SizedBox(height: 20),
                        _buildLatestTraining(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildDrawer(String username) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 35,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  username,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Quản trị viên',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Bảng Điều Khiển'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Lịch Sử Dự Đoán'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin_history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Phản Hồi Người Dùng'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin_feedback');
            },
          ),
          ListTile(
            leading: const Icon(Icons.model_training),
            title: const Text('Nhật Ký Huấn Luyện'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin_training');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'Đăng Xuất',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(String username) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.waving_hand,
              size: 40,
              color: AppColors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào, $username!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Chào mừng đến với bảng điều khiển quản trị',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    if (_dashboardData == null) return const SizedBox();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          'Tổng Dự Đoán',
          _dashboardData!.totalPredictions.toString(),
          Icons.image_search,
          AppColors.primary,
        ),
        _buildStatCard(
          'Phản Hồi',
          _dashboardData!.totalFeedback.toString(),
          Icons.feedback,
          AppColors.secondary,
        ),
        _buildStatCard(
          'Độ Chính Xác',
          '${_dashboardData!.accuracy.toStringAsFixed(1)}%',
          Icons.check_circle,
          AppColors.success,
        ),
        _buildStatCard(
          'Độ Tin Cậy TB',
          '${_dashboardData!.avgConfidence.toStringAsFixed(1)}%',
          Icons.show_chart,
          const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionTrendChart() {
    if (_dashboardData == null || _dashboardData!.predictionTrend.isEmpty) {
      return const SizedBox();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Xu Hướng Dự Đoán',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < _dashboardData!.predictionTrend.length) {
                            final date = _dashboardData!.predictionTrend[index].date;
                            return Text(
                              date.substring(5),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _dashboardData!.predictionTrend
                          .asMap()
                          .entries
                          .map((e) => FlSpot(
                                e.key.toDouble(),
                                e.value.count.toDouble(),
                              ))
                          .toList(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFruitDistributionChart() {
    if (_dashboardData == null || _dashboardData!.fruitDistribution.isEmpty) {
      return const SizedBox();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Phân Bố Loại Trái Cây',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ..._dashboardData!.fruitDistribution.take(5).map((fruit) {
              final total = _dashboardData!.fruitDistribution
                  .fold<int>(0, (sum, item) => sum + item.count);
              final percentage = (fruit.count / total * 100);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            FruitNames.getVietnameseName(fruit.label),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          '${fruit.count} (${percentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.lightGrey,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestTraining() {
    if (_dashboardData?.latestTraining == null) {
      return const SizedBox();
    }

    final training = _dashboardData!.latestTraining!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.model_training, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Lần Huấn Luyện Gần Nhất',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Phiên bản', training.modelVersion),
            _buildInfoRow(
              'Độ chính xác',
              '${(training.accuracy * 100).toStringAsFixed(2)}%',
            ),
            if (training.valAccuracy != null)
              _buildInfoRow(
                'Độ chính xác val',
                '${(training.valAccuracy! * 100).toStringAsFixed(2)}%',
              ),
            _buildInfoRow('Epochs', training.epochs?.toString() ?? 'N/A'),
            _buildInfoRow('Ngày huấn luyện', training.dateTrained.substring(0, 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
}
}