class WeightData {
  final int day;
  final double loggedWeight; // KCal (0.0 to 1.0 range)
  final double plannedWeight; // Weight in kg (96.0 to 100.0 range)

  // -1 means no logged data for that day
  WeightData({
    required this.day,
    required this.loggedWeight,
    required this.plannedWeight,
  });
}
