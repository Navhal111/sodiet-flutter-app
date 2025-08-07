class PlanDetailsResponse {
  final String planId;
  final List<PlanData> planData;
  final bool isActive;

  PlanDetailsResponse({
    required this.planId,
    required this.planData,
    required this.isActive,
  });

  factory PlanDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PlanDetailsResponse(
      planId: json['plan_id']?.toString() ?? '',
      planData: (json['plan_data'] as List<dynamic>?)
              ?.map((item) => PlanData.fromJson(item))
              .toList() ??
          [],
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'plan_data': planData.map((item) => item.toJson()).toList(),
      'is_active': isActive,
    };
  }
}

class PlanData {
  final String username;
  final String firstName;
  final String secondName;
  final int age;
  final String sex;
  final String joinedDate;
  final int numDays;
  final double initWeight;
  final double height;
  final double initPal;
  final double targetWeight;
  final int planId;
  final String planStatus;

  PlanData({
    required this.username,
    required this.firstName,
    required this.secondName,
    required this.age,
    required this.sex,
    required this.joinedDate,
    required this.numDays,
    required this.initWeight,
    required this.height,
    required this.initPal,
    required this.targetWeight,
    required this.planId,
    required this.planStatus,
  });

  factory PlanData.fromJson(Map<String, dynamic> json) {
    return PlanData(
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      secondName: json['second_name'] ?? '',
      age: json['age'] ?? 0,
      sex: json['sex'] ?? '',
      joinedDate: json['joined_date'] ?? '',
      numDays: json['num_days'] ?? 0,
      initWeight: (json['init_weight'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      initPal: (json['init_pal'] ?? 0).toDouble(),
      targetWeight: (json['target_weight'] ?? 0).toDouble(),
      planId: json['PLAN_ID'] ?? 0,
      planStatus: json['PLAN_STATUS'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'second_name': secondName,
      'age': age,
      'sex': sex,
      'joined_date': joinedDate,
      'num_days': numDays,
      'init_weight': initWeight,
      'height': height,
      'init_pal': initPal,
      'target_weight': targetWeight,
      'PLAN_ID': planId,
      'PLAN_STATUS': planStatus,
    };
  }

  // Helper getters for commonly used calculations
  double get bmi => initWeight / ((height / 100) * (height / 100));
  double get weightToLose => initWeight - targetWeight;
  String get fullName => '$firstName $secondName'.trim();
}
