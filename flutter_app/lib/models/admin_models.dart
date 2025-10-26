class DashboardData {
  final int totalPredictions;
  final int totalFeedback;
  final int correctFeedback;
  final int incorrectFeedback;
  final double accuracy;
  final double avgConfidence;
  final List<FruitDistribution> fruitDistribution;
  final List<PredictionTrend> predictionTrend;
  final TrainingLog? latestTraining;

  DashboardData({
    required this.totalPredictions,
    required this.totalFeedback,
    required this.correctFeedback,
    required this.incorrectFeedback,
    required this.accuracy,
    required this.avgConfidence,
    required this.fruitDistribution,
    required this.predictionTrend,
    this.latestTraining,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalPredictions: json['total_predictions'] ?? 0,
      totalFeedback: json['total_feedback'] ?? 0,
      correctFeedback: json['correct_feedback'] ?? 0,
      incorrectFeedback: json['incorrect_feedback'] ?? 0,
      accuracy: (json['accuracy'] ?? 0.0).toDouble(),
      avgConfidence: (json['avg_confidence'] ?? 0.0).toDouble(),
      fruitDistribution: (json['fruit_distribution'] as List?)
              ?.map((e) => FruitDistribution.fromJson(e))
              .toList() ??
          [],
      predictionTrend: (json['prediction_trend'] as List?)
              ?.map((e) => PredictionTrend.fromJson(e))
              .toList() ??
          [],
      latestTraining: json['latest_training'] != null
          ? TrainingLog.fromJson(json['latest_training'])
          : null,
    );
  }
}

class FruitDistribution {
  final String label;
  final int count;

  FruitDistribution({
    required this.label,
    required this.count,
  });

  factory FruitDistribution.fromJson(Map<String, dynamic> json) {
    return FruitDistribution(
      label: json['label'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class PredictionTrend {
  final String date;
  final int count;

  PredictionTrend({
    required this.date,
    required this.count,
  });

  factory PredictionTrend.fromJson(Map<String, dynamic> json) {
    return PredictionTrend(
      date: json['date'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class PredictionHistory {
  final int id;
  final int? userId;
  final String imagePath;
  final String predictedLabel;
  final double confidence;
  final String createdAt;

  PredictionHistory({
    required this.id,
    this.userId,
    required this.imagePath,
    required this.predictedLabel,
    required this.confidence,
    required this.createdAt,
  });

  factory PredictionHistory.fromJson(Map<String, dynamic> json) {
    return PredictionHistory(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      imagePath: json['image_path'] ?? '',
      predictedLabel: json['predicted_label'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      createdAt: json['created_at'] ?? '',
    );
  }
}

class FeedbackData {
  final int id;
  final int predictionId;
  final String? comment;
  final bool isCorrect;
  final bool isRead;
  final String createdAt;
  final PredictionHistory? prediction;
  final bool addedToTraining;
  final String? trainingLabel;
  final String? addedToTrainingAt;

  FeedbackData({
    required this.id,
    required this.predictionId,
    this.comment,
    required this.isCorrect,
    required this.isRead,
    required this.createdAt,
    this.prediction,
    this.addedToTraining = false,
    this.trainingLabel,
    this.addedToTrainingAt,
  });

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    return FeedbackData(
      id: json['id'] ?? 0,
      predictionId: json['prediction_id'] ?? 0,
      comment: json['comment'],
      isCorrect: json['is_correct'] ?? false,
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] ?? '',
      prediction: json['prediction'] != null
          ? PredictionHistory.fromJson(json['prediction'])
          : null,
      addedToTraining: json['added_to_training'] ?? false,
      trainingLabel: json['training_label'],
      addedToTrainingAt: json['added_to_training_at'],
    );
  }
}

class TrainingLog {
  final int id;
  final String modelVersion;
  final double accuracy;
  final double loss;
  final double? valAccuracy;
  final double? valLoss;
  final int? epochs;
  final String dateTrained;
  final String? notes;

  TrainingLog({
    required this.id,
    required this.modelVersion,
    required this.accuracy,
    required this.loss,
    this.valAccuracy,
    this.valLoss,
    this.epochs,
    required this.dateTrained,
    this.notes,
  });

  factory TrainingLog.fromJson(Map<String, dynamic> json) {
    return TrainingLog(
      id: json['id'] ?? 0,
      modelVersion: json['model_version'] ?? '',
      accuracy: (json['accuracy'] ?? 0.0).toDouble(),
      loss: (json['loss'] ?? 0.0).toDouble(),
      valAccuracy: json['val_accuracy'] != null
          ? (json['val_accuracy']).toDouble()
          : null,
      valLoss: json['val_loss'] != null ? (json['val_loss']).toDouble() : null,
      epochs: json['epochs'],
      dateTrained: json['date_trained'] ?? '',
      notes: json['notes'],
    );
  }
}

class LoginResponse {
  final String message;
  final String accessToken;
  final String? refreshToken;
  final UserData user;

  LoginResponse({
    required this.message,
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'],
      user: UserData.fromJson(json['user']),
    );
  }
}

class UserData {
  final int id;
  final String username;
  final String role;
  final String createdAt;

  UserData({
    required this.id,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      role: json['role'] ?? 'user',
      createdAt: json['created_at'] ?? '',
    );
  }
}
