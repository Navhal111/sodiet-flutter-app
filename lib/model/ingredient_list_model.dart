class IngredientListResponse {
  final List<FoodIngredient> ingredients;
  final int totalCount;
  final int page;
  final int pageSize;
  final String? foodGroup;
  final String? searchTerm;

  IngredientListResponse({
    required this.ingredients,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    this.foodGroup,
    this.searchTerm,
  });

  factory IngredientListResponse.fromJson(Map<String, dynamic> json) {
    return IngredientListResponse(
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((item) => FoodIngredient.fromJson(item))
              .toList() ??
          [],
      totalCount: json['total_count'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 50,
      foodGroup: json['food_group'],
      searchTerm: json['search_term'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredients': ingredients.map((item) => item.toJson()).toList(),
      'total_count': totalCount,
      'page': page,
      'page_size': pageSize,
      'food_group': foodGroup,
      'search_term': searchTerm,
    };
  }
}

class FoodIngredient {
  final String foodGroup;
  final String foodCode;
  final String foodName;

  FoodIngredient({
    required this.foodGroup,
    required this.foodCode,
    required this.foodName,
  });

  factory FoodIngredient.fromJson(Map<String, dynamic> json) {
    return FoodIngredient(
      foodGroup: json['Food_Group'] ?? '',
      foodCode: json['Food_code'] ?? '',
      foodName: json['Food_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Food_Group': foodGroup,
      'Food_code': foodCode,
      'Food_name': foodName,
    };
  }
}
