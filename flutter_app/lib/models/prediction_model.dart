class PredictionResult {
  final int predictionId;
  final String label;
  final String labelVn;
  final double confidence;
  final String imageUrl;
  final List<PredictionItem>? allPredictions;

  PredictionResult({
    required this.predictionId,
    required this.label,
    required this.labelVn,
    required this.confidence,
    required this.imageUrl,
    this.allPredictions,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictionId: json['prediction_id'] ?? 0,
      label: json['label'] ?? '',
      labelVn: json['label_vn'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      allPredictions: json['all_predictions'] != null
          ? (json['all_predictions'] as List)
              .map((e) => PredictionItem.fromJson(e))
              .toList()
          : null,
    );
  }
}

class PredictionItem {
  final String label;
  final String labelVn;
  final double confidence;

  PredictionItem({
    required this.label,
    required this.labelVn,
    required this.confidence,
  });

  factory PredictionItem.fromJson(Map<String, dynamic> json) {
    return PredictionItem(
      label: json['label'] ?? '',
      labelVn: json['label_vn'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }
}

class FeedbackRequest {
  final int predictionId;
  final bool isCorrect;
  final String? comment;

  FeedbackRequest({
    required this.predictionId,
    required this.isCorrect,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'prediction_id': predictionId,
      'is_correct': isCorrect,
      'comment': comment,
    };
  }
}
