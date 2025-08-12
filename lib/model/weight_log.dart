class WeightLog {
  final int logId;
  final String logDate;
  final double weightKg;
  final String createdAt;

  WeightLog({
    required this.logId,
    required this.logDate,
    required this.weightKg,
    required this.createdAt,
  });

  factory WeightLog.fromJson(Map<String, dynamic> json) {
    return WeightLog(
      logId: json['log_id'] ?? 0,
      logDate: json['log_date'] ?? '',
      weightKg: (json['weight_kg'] ?? 0).toDouble(),
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'log_id': logId,
      'log_date': logDate,
      'weight_kg': weightKg,
      'created_at': createdAt,
    };
  }
}

class WeightLogResponse {
  final List<WeightLog> logs;
  final int totalCount;
  final int page;
  final int pageSize;

  WeightLogResponse({
    required this.logs,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  factory WeightLogResponse.fromJson(Map<String, dynamic> json) {
    return WeightLogResponse(
      logs: (json['logs'] as List<dynamic>? ?? [])
          .map((item) => WeightLog.fromJson(item))
          .toList(),
      totalCount: json['total_count'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 10,
    );
  }
}
