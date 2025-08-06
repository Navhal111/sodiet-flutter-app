class DietRecall {
  final String entryDate;
  final String foodName;
  final double foodQty;
  final String unit;
  final String timeOfDay;
  final String recallId;
  final String createdAt;
  final String recipeName;

  DietRecall({
    required this.entryDate,
    required this.foodName,
    required this.foodQty,
    required this.unit,
    required this.timeOfDay,
    required this.recallId,
    required this.createdAt,
    required this.recipeName,
  });

  factory DietRecall.fromJson(Map<String, dynamic> json) {
    return DietRecall(
      entryDate: json['entry_date'] ?? '',
      foodName: json['food_name'] ?? '',
      foodQty: (json['food_qty'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      timeOfDay: json['time_of_day'] ?? '',
      recallId: json['recall_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      recipeName: json['Recipe_name'] ?? '',
    );
  }
}

class DietRecallListResponse {
  final List<DietRecall> recalls;
  final int totalCount;
  final int page;
  final int pageSize;

  DietRecallListResponse({
    required this.recalls,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  factory DietRecallListResponse.fromJson(Map<String, dynamic> json) {
    return DietRecallListResponse(
      recalls: (json['recalls'] as List<dynamic>?)
              ?.map((e) => DietRecall.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['total_count'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 10,
    );
  }
}
