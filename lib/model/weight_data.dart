class WeightData {
  final int day;
  final double projectedWeightKg; // Projected Weight (kg) - Pink line
  final double?
      loggedWeightKg; // Logged Weight (kg) - Dark blue line (nullable)
  final double targetIntakeKcal; // Target Intake (kcal) - Light blue line
  final double targetExpenditureKcal; // Target Expenditure (kcal) - Teal line
  final double actualIntakeKcal; // Actual Intake (kcal) - Purple line
  final double actualExpenditureKcal; // Actual Expenditure (kcal) - Orange line
  final double ccIntakeKcal; // CC Intake (kcal) - Dark blue line
  final double ccExpenditureKcal; // CC Expenditure (kcal) - Green line

  WeightData({
    required this.day,
    required this.projectedWeightKg,
    this.loggedWeightKg,
    required this.targetIntakeKcal,
    required this.targetExpenditureKcal,
    required this.actualIntakeKcal,
    required this.actualExpenditureKcal,
    required this.ccIntakeKcal,
    required this.ccExpenditureKcal,
  });

  // Legacy support - these getters maintain backward compatibility
  double get loggedWeight => actualIntakeKcal;
  double get plannedWeight => projectedWeightKg;
}
