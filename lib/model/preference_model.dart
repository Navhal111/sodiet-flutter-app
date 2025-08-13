class PreferenceFood {
  final int id;
  final String foodName;
  final double foodQty;
  final String time;
  final String description;
  final double recipeWeight;
  final String uid;
  final int pkey;

  PreferenceFood({
    required this.id,
    required this.foodName,
    required this.foodQty,
    required this.time,
    required this.description,
    required this.recipeWeight,
    required this.uid,
    required this.pkey,
  });

  factory PreferenceFood.fromJson(Map<String, dynamic> json) {
    return PreferenceFood(
      id: json['ID'] ?? 0,
      foodName: json['Food_Name'] ?? '',
      foodQty: (json['Food_Qty'] ?? 0).toDouble(),
      time: json['Time'] ?? '',
      description: json['Description'] ?? '',
      recipeWeight: (json['Recipe_weight'] ?? 0).toDouble(),
      uid: json['UID'] ?? '',
      pkey: json['Pkey'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Food_Name': foodName,
      'Food_Qty': foodQty,
      'Time': time,
      'Description': description,
      'Recipe_weight': recipeWeight,
      'UID': uid,
      'Pkey': pkey,
    };
  }
}

class PreferenceCombination {
  final int combinationId;
  final List<PreferenceFood> foods;
  final int totalItems;

  PreferenceCombination({
    required this.combinationId,
    required this.foods,
    required this.totalItems,
  });

  factory PreferenceCombination.fromJson(Map<String, dynamic> json) {
    var foodsList = json['foods'] as List? ?? [];
    List<PreferenceFood> foods =
        foodsList.map((food) => PreferenceFood.fromJson(food)).toList();

    return PreferenceCombination(
      combinationId: json['combination_id'] ?? 0,
      foods: foods,
      totalItems: json['total_items'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'combination_id': combinationId,
      'foods': foods.map((food) => food.toJson()).toList(),
      'total_items': totalItems,
    };
  }
}

class PreferenceResponse {
  final List<PreferenceCombination> combinations;
  final int totalPreferences;
  final int totalCombinations;
  final String message;

  PreferenceResponse({
    required this.combinations,
    required this.totalPreferences,
    required this.totalCombinations,
    required this.message,
  });

  factory PreferenceResponse.fromJson(Map<String, dynamic> json) {
    var combinationsList = json['combinations'] as List? ?? [];
    List<PreferenceCombination> combinations = combinationsList
        .map((combination) => PreferenceCombination.fromJson(combination))
        .toList();

    return PreferenceResponse(
      combinations: combinations,
      totalPreferences: json['total_preferences'] ?? 0,
      totalCombinations: json['total_combinations'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'combinations':
          combinations.map((combination) => combination.toJson()).toList(),
      'total_preferences': totalPreferences,
      'total_combinations': totalCombinations,
      'message': message,
    };
  }
}
