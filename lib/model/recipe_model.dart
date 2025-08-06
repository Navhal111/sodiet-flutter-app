class RecipeResponse {
  final List<Recipe> recipes;
  final int totalCount;
  final int page;
  final int pageSize;

  RecipeResponse({
    required this.recipes,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    return RecipeResponse(
      recipes: (json['recipes'] as List)
          .map((recipe) => Recipe.fromJson(recipe))
          .toList(),
      totalCount: json['total_count'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 10,
    );
  }
}

class Recipe {
  final String recipeCode;
  final String recipeName;
  final double portion;
  final String recipeDescription;
  final double recipeWeightG; // Changed from int to double
  final String codeCooccurence;
  final String subcategories;
  final double energyKcal;

  Recipe({
    required this.recipeCode,
    required this.recipeName,
    required this.portion,
    required this.recipeDescription,
    required this.recipeWeightG,
    required this.codeCooccurence,
    required this.subcategories,
    required this.energyKcal,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeCode: json['recipeCode'] ?? '',
      recipeName: json['recipeName'] ?? '',
      portion: (json['Portion'] ?? 0).toDouble(),
      recipeDescription: json['Recipe_Description'] ?? '',
      recipeWeightG: (json['recipeWeightG'] ?? 0)
          .toDouble(), // Changed to double conversion
      codeCooccurence: json['Code_cooccurence'] ?? '',
      subcategories: json['Subcategories'] ?? '',
      energyKcal: (json['Energy_kcal'] ?? 0).toDouble(),
    );
  }
}
