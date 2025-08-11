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

// Dashboard Summary Models
class DashboardSummaryResponse {
  final KpiData kpi;
  final SummaryData summaryData;

  DashboardSummaryResponse({
    required this.kpi,
    required this.summaryData,
  });

  factory DashboardSummaryResponse.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryResponse(
      kpi: KpiData.fromJson(json['kpi'] ?? {}),
      summaryData: SummaryData.fromJson(json['summary_data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kpi': kpi.toJson(),
      'summary_data': summaryData.toJson(),
    };
  }
}

class KpiData {
  final double startWeightKg;
  final double targetWeightKg;
  final int currentPlanDay;
  final int totalPlanDurationDays;
  final double mostRecentWeightKg;
  final double targetProgressPercentage;
  final String planStartDate;

  KpiData({
    required this.startWeightKg,
    required this.targetWeightKg,
    required this.currentPlanDay,
    required this.totalPlanDurationDays,
    required this.mostRecentWeightKg,
    required this.targetProgressPercentage,
    required this.planStartDate,
  });

  factory KpiData.fromJson(Map<String, dynamic> json) {
    return KpiData(
      startWeightKg: (json['start_weight_kg'] ?? 0).toDouble(),
      targetWeightKg: (json['target_weight_kg'] ?? 0).toDouble(),
      currentPlanDay: json['current_plan_day'] ?? 0,
      totalPlanDurationDays: json['total_plan_duration_days'] ?? 0,
      mostRecentWeightKg: (json['most_recent_weight_kg'] ?? 0).toDouble(),
      targetProgressPercentage:
          (json['target_progress_percentage'] ?? 0).toDouble(),
      planStartDate: json['plan_start_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_weight_kg': startWeightKg,
      'target_weight_kg': targetWeightKg,
      'current_plan_day': currentPlanDay,
      'total_plan_duration_days': totalPlanDurationDays,
      'most_recent_weight_kg': mostRecentWeightKg,
      'target_progress_percentage': targetProgressPercentage,
      'plan_start_date': planStartDate,
    };
  }
}

class SummaryData {
  final List<DailyData> dailyData;
  final LegacyFormat legacyFormat;

  SummaryData({
    required this.dailyData,
    required this.legacyFormat,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      dailyData: (json['daily_data'] as List<dynamic>?)
              ?.map((item) => DailyData.fromJson(item))
              .toList() ??
          [],
      legacyFormat: LegacyFormat.fromJson(json['legacy_format'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_data': dailyData.map((item) => item.toJson()).toList(),
      'legacy_format': legacyFormat.toJson(),
    };
  }
}

class DailyData {
  final String date;
  final String day;
  final double projectedWeight;
  final double? loggedWeight;
  final double targetIntake;
  final double targetExpenditure;
  final double actualIntake;
  final double actualExpenditure;
  final double ccIntake;
  final double ccExpenditure;

  DailyData({
    required this.date,
    required this.day,
    required this.projectedWeight,
    this.loggedWeight,
    required this.targetIntake,
    required this.targetExpenditure,
    required this.actualIntake,
    required this.actualExpenditure,
    required this.ccIntake,
    required this.ccExpenditure,
  });

  factory DailyData.fromJson(Map<String, dynamic> json) {
    return DailyData(
      date: json['date'] ?? '',
      day: json['day']?.toString() ?? '',
      projectedWeight: (json['projected_weight'] ?? 0).toDouble(),
      loggedWeight: json['logged_weight'] != null
          ? (json['logged_weight']).toDouble()
          : null,
      targetIntake: (json['target_intake'] ?? 0).toDouble(),
      targetExpenditure: (json['target_expenditure'] ?? 0).toDouble(),
      actualIntake: (json['actual_intake'] ?? 0).toDouble(),
      actualExpenditure: (json['actual_expenditure'] ?? 0).toDouble(),
      ccIntake: (json['cc_intake'] ?? 0).toDouble(),
      ccExpenditure: (json['cc_expenditure'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day,
      'projected_weight': projectedWeight,
      'logged_weight': loggedWeight,
      'target_intake': targetIntake,
      'target_expenditure': targetExpenditure,
      'actual_intake': actualIntake,
      'actual_expenditure': actualExpenditure,
      'cc_intake': ccIntake,
      'cc_expenditure': ccExpenditure,
    };
  }
}

class LegacyFormat {
  final List<String> labels;
  final DataSets dataSets;

  LegacyFormat({
    required this.labels,
    required this.dataSets,
  });

  factory LegacyFormat.fromJson(Map<String, dynamic> json) {
    return LegacyFormat(
      labels: (json['labels'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      dataSets: DataSets.fromJson(json['datasets'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labels': labels,
      'datasets': dataSets.toJson(),
    };
  }
}

class DataSets {
  final List<String> date;
  final List<double> projectedWeight;
  final List<double?> loggedWeight;
  final List<double> targetIntake;
  final List<double> targetExpenditure;
  final List<double> actualIntake;
  final List<double> actualExpenditure;
  final List<double> ccIntake;
  final List<double> ccExpenditure;

  DataSets({
    required this.date,
    required this.projectedWeight,
    required this.loggedWeight,
    required this.targetIntake,
    required this.targetExpenditure,
    required this.actualIntake,
    required this.actualExpenditure,
    required this.ccIntake,
    required this.ccExpenditure,
  });

  factory DataSets.fromJson(Map<String, dynamic> json) {
    return DataSets(
      date: (json['Date'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      projectedWeight: (json['Projected Weight (kg)'] as List<dynamic>?)
              ?.map<double>((item) => (item ?? 0).toDouble())
              .toList() ??
          [],
      loggedWeight: (json['Logged Weight (kg)'] as List<dynamic>?)
              ?.map<double?>((item) => item != null ? (item).toDouble() : null)
              .toList() ??
          [],
      targetIntake: (json['Target Intake (kcal)'] as List<dynamic>?)
              ?.map<double>((item) => (item ?? 0).toDouble())
              .toList() ??
          [],
      targetExpenditure: (json['Target Expenditure (kcal)'] as List<dynamic>?)
              ?.map<double>((item) => (item ?? 0).toDouble())
              .toList() ??
          [],
      actualIntake: (json['Actual Intake (kcal)'] as List<dynamic>?)
              ?.map<double>((item) => (item ?? 0).toDouble())
              .toList() ??
          [],
      actualExpenditure: (json['Actual Expenditure (kcal)'] as List<dynamic>?)
              ?.map<double>((item) => (item ?? 0).toDouble())
              .toList() ??
          [],
      ccIntake: (json['CC Intake (kcal)'] as List<dynamic>?)
              ?.map<double>((item) => (item ?? 0).toDouble())
              .toList() ??
          [],
      ccExpenditure: (json['CC Expenditure (kcal)'] as List<dynamic>?)
              ?.map<double>((item) => (item ?? 0).toDouble())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Date': date,
      'Projected Weight (kg)': projectedWeight,
      'Logged Weight (kg)': loggedWeight,
      'Target Intake (kcal)': targetIntake,
      'Target Expenditure (kcal)': targetExpenditure,
      'Actual Intake (kcal)': actualIntake,
      'Actual Expenditure (kcal)': actualExpenditure,
      'CC Intake (kcal)': ccIntake,
      'CC Expenditure (kcal)': ccExpenditure,
    };
  }
}
