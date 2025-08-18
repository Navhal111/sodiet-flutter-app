class MenuInteractionResponse {
  final List<MenuInteraction> menuInteractions;
  final int totalRecords;
  final String message;

  MenuInteractionResponse({
    required this.menuInteractions,
    required this.totalRecords,
    required this.message,
  });

  factory MenuInteractionResponse.fromJson(Map<String, dynamic> json) {
    return MenuInteractionResponse(
      menuInteractions: (json['menu_interactions'] as List)
          .map((interaction) => MenuInteraction.fromJson(interaction))
          .toList(),
      totalRecords: json['total_records'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_interactions':
          menuInteractions.map((interaction) => interaction.toJson()).toList(),
      'total_records': totalRecords,
      'message': message,
    };
  }
}

class MenuInteraction {
  final int pkey;
  final int weekNo;
  final String recipeCode;
  final String day;
  final String timings;
  final String status;

  MenuInteraction({
    required this.pkey,
    required this.weekNo,
    required this.recipeCode,
    required this.day,
    required this.timings,
    required this.status,
  });

  factory MenuInteraction.fromJson(Map<String, dynamic> json) {
    return MenuInteraction(
      pkey: json['Pkey'] ?? 0,
      weekNo: json['Week_No'] ?? 0,
      recipeCode: json['Recipe_Code'] ?? '',
      day: json['Day'] ?? '',
      timings: json['Timings'] ?? '',
      status: json['Status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Pkey': pkey,
      'Week_No': weekNo,
      'Recipe_Code': recipeCode,
      'Day': day,
      'Timings': timings,
      'Status': status,
    };
  }

  // Helper method to check if this is an ADD interaction
  bool get isAddInteraction => status.toUpperCase() == 'ADD';

  // Helper method to check if this is a REMOVE interaction
  bool get isRemoveInteraction => status.toUpperCase() == 'REMOVE';

  // Helper method to get timing display name
  String get timingDisplayName {
    switch (timings.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'snacks':
        return 'Snacks';
      default:
        return timings;
    }
  }

  // Helper method to get day display name
  String get dayDisplayName {
    switch (day.toLowerCase()) {
      case 'saturday':
        return 'Saturday';
      case 'sunday':
        return 'Sunday';
      case 'monday':
        return 'Monday';
      case 'tuesday':
        return 'Tuesday';
      case 'wednesday':
        return 'Wednesday';
      case 'thursday':
        return 'Thursday';
      case 'friday':
        return 'Friday';
      default:
        return day;
    }
  }

  // Helper method to check if interaction is for a specific day
  bool isForDay(String targetDay) {
    return day.toLowerCase() == targetDay.toLowerCase();
  }

  // Helper method to check if interaction is for a specific timing
  bool isForTiming(String targetTiming) {
    return timings.toLowerCase() == targetTiming.toLowerCase();
  }

  // Helper method to check if interaction is for a specific week
  bool isForWeek(int targetWeekNo) {
    return weekNo == targetWeekNo;
  }

  @override
  String toString() {
    return 'MenuInteraction{pkey: $pkey, weekNo: $weekNo, recipeCode: $recipeCode, day: $day, timings: $timings, status: $status}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuInteraction &&
        other.pkey == pkey &&
        other.weekNo == weekNo &&
        other.recipeCode == recipeCode &&
        other.day == day &&
        other.timings == timings &&
        other.status == status;
  }

  @override
  int get hashCode {
    return pkey.hashCode ^
        weekNo.hashCode ^
        recipeCode.hashCode ^
        day.hashCode ^
        timings.hashCode ^
        status.hashCode;
  }
}
