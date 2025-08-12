class FatLog {
  final int logId;
  final String logDate;
  final double bodyFatPct;
  final String createdAt;

  FatLog({
    required this.logId,
    required this.logDate,
    required this.bodyFatPct,
    required this.createdAt,
  });

  factory FatLog.fromJson(Map<String, dynamic> json) {
    return FatLog(
      logId: json['log_id'] ?? 0,
      logDate: json['log_date'] ?? '',
      bodyFatPct: (json['body_fat_pct'] ?? 0).toDouble(),
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'log_id': logId,
      'log_date': logDate,
      'body_fat_pct': bodyFatPct,
      'created_at': createdAt,
    };
  }
}

class FatLogResponse {
  final List<FatLog> logs;
  final int totalCount;
  final int page;
  final int pageSize;

  FatLogResponse({
    required this.logs,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  factory FatLogResponse.fromJson(Map<String, dynamic> json) {
    var logsList = json['logs'] as List? ?? [];
    List<FatLog> logs = logsList.map((log) => FatLog.fromJson(log)).toList();

    return FatLogResponse(
      logs: logs,
      totalCount: json['total_count'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 10,
    );
  }
}
