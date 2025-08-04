class PaRecallModel {
  List<PaRecallItem> recalls;
  int totalCount;
  int page;
  int pageSize;

  PaRecallModel({
    required this.recalls,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  factory PaRecallModel.fromJson(Map<String, dynamic> json) {
    return PaRecallModel(
      recalls: (json['recalls'] as List<dynamic>?)
              ?.map((item) => PaRecallItem.fromJson(item))
              .toList() ??
          [],
      totalCount: json['total_count'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recalls': recalls.map((item) => item.toJson()).toList(),
      'total_count': totalCount,
      'page': page,
      'page_size': pageSize,
    };
  }
}

class PaRecallItem {
  String entryDate;
  String activityName;
  int durationMinutes;
  String timeOfDay;
  String recallId;
  String createdAt;

  PaRecallItem({
    required this.entryDate,
    required this.activityName,
    required this.durationMinutes,
    required this.timeOfDay,
    required this.recallId,
    required this.createdAt,
  });

  factory PaRecallItem.fromJson(Map<String, dynamic> json) {
    return PaRecallItem(
      entryDate: json['entry_date'] ?? '',
      activityName: json['activity_name'] ?? '',
      durationMinutes: (json['duration_minutes'] is double)
          ? (json['duration_minutes'] as double).toInt()
          : json['duration_minutes'] ?? 0,
      timeOfDay: json['time_of_day'] ?? '',
      recallId: json['recall_id'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entry_date': entryDate,
      'activity_name': activityName,
      'duration_minutes': durationMinutes,
      'time_of_day': timeOfDay,
      'recall_id': recallId,
      'created_at': createdAt,
    };
  }
}
