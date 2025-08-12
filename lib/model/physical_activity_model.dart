class PhysicalActivityModel {
  final List<PhysicalActivity> activities;
  final int totalCount;

  PhysicalActivityModel({
    required this.activities,
    required this.totalCount,
  });

  factory PhysicalActivityModel.fromJson(Map<String, dynamic> json) {
    return PhysicalActivityModel(
      activities: (json['activities'] as List?)
              ?.map((activity) => PhysicalActivity.fromJson(activity))
              .toList() ??
          [],
      totalCount: json['total_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'total_count': totalCount,
    };
  }
}

class PhysicalActivity {
  final String paName;
  final double maleValue;
  final double femaleValue;

  PhysicalActivity({
    required this.paName,
    required this.maleValue,
    required this.femaleValue,
  });

  factory PhysicalActivity.fromJson(Map<String, dynamic> json) {
    return PhysicalActivity(
      paName: json['pa_name'] ?? '',
      maleValue: (json['male_value'] ?? 0).toDouble(),
      femaleValue: (json['female_value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pa_name': paName,
      'male_value': maleValue,
      'female_value': femaleValue,
    };
  }
}
