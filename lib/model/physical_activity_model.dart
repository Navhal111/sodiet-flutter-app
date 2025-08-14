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
  final double energyPerMin;

  PhysicalActivity({
    required this.paName,
    required this.energyPerMin,
  });

  factory PhysicalActivity.fromJson(Map<String, dynamic> json) {
    return PhysicalActivity(
      paName: json['pa_name'] ?? '',
      energyPerMin: (json['Energy_per_min'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pa_name': paName,
      'Energy_per_min': energyPerMin,
    };
  }
}
