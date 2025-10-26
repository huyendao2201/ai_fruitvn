import 'dart:io';
import 'package:flutter/material.dart';
import '../models/prediction_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class ResultScreen extends StatefulWidget {
  final PredictionResult predictionResult;
  final File imageFile;

  const ResultScreen({
    super.key,
    required this.predictionResult,
    required this.imageFile,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ApiService _apiService = ApiService();
  bool _feedbackSubmitted = false;

  Future<void> _submitFeedback(bool isCorrect) async {
    try {
      final feedback = FeedbackRequest(
        predictionId: widget.predictionResult.predictionId,
        isCorrect: isCorrect,
        comment: isCorrect ? 'Nhận diện chính xác' : 'Nhận diện không chính xác',
      );

      await _apiService.submitFeedback(feedback);

      setState(() {
        _feedbackSubmitted = true;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isCorrect ? 'Cảm ơn phản hồi của bạn!' : 'Cảm ơn phản hồi, chúng tôi sẽ cải thiện'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gửi phản hồi thất bại: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final confidence = widget.predictionResult.confidence * 100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Kết quả nhận diện',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image
            Hero(
              tag: 'fruit_image',
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Image.file(
                  widget.imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Result Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Fruit Name
                      const Text(
                        'Kết quả nhận diện',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.predictionResult.labelVn,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Confidence
                      const Text(
                        'Độ tin cậy',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: widget.predictionResult.confidence,
                          minHeight: 20,
                          backgroundColor: AppColors.lightGrey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            confidence >= 80
                                ? AppColors.success
                                : confidence >= 60
                                    ? AppColors.secondary
                                    : AppColors.error,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '${confidence.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: confidence >= 80
                              ? AppColors.success
                              : confidence >= 60
                                  ? AppColors.secondary
                                  : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Other Predictions
            if (widget.predictionResult.allPredictions != null &&
                widget.predictionResult.allPredictions!.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
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
                          'Các kết quả khác có thể',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...widget.predictionResult.allPredictions!
                            .skip(1)
                            .take(4)
                            .map((pred) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          pred.labelVn,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Text(
                                        '${(pred.confidence * 100).toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Feedback Section
            if (!_feedbackSubmitted)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      'Nhận diện có chính xác không?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _submitFeedback(true),
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Chính xác'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.success,
                              side: const BorderSide(color: AppColors.success),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _submitFeedback(false),
                            icon: const Icon(Icons.cancel),
                            label: const Text('Không chính xác'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success),
                    SizedBox(width: 8),
                    Text(
                      'Cảm ơn phản hồi của bạn!',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Thử lại',
                    style: AppTextStyles.button,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
}
}