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

class IngredientsResponse {
  final String recipeId;
  final String recipeName;
  final List<Ingredient> ingredients;

  IngredientsResponse({
    required this.recipeId,
    required this.recipeName,
    required this.ingredients,
  });

  factory IngredientsResponse.fromJson(Map<String, dynamic> json) {
    return IngredientsResponse(
      recipeId: json['recipe_id'] ?? '',
      recipeName: json['recipe_name'] ?? '',
      ingredients: (json['ingredients'] as List)
          .map((ingredient) => Ingredient.fromJson(ingredient))
          .toList(),
    );
  }
}

class Ingredient {
  final String recipeCode;
  final String recipeName;
  final String ingredients;
  final double ingRawAmountsG;
  final double qty;
  final String unit;
  final double servings; // Changed from int to double
  final double recWeight; // Changed from int to double
  final double portion;
  final String recipeDescription;

  Ingredient({
    required this.recipeCode,
    required this.recipeName,
    required this.ingredients,
    required this.ingRawAmountsG,
    required this.qty,
    required this.unit,
    required this.servings,
    required this.recWeight,
    required this.portion,
    required this.recipeDescription,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      recipeCode: json['Recipe_Code'] ?? '',
      recipeName: json['Recipe_Name'] ?? '',
      ingredients: json['Ingredients'] ?? '',
      ingRawAmountsG: (json['Ing_raw_amounts_g'] ?? 0).toDouble(),
      qty: (json['Qty'] ?? 0).toDouble(),
      unit: json['Unit'] ?? '',
      servings:
          (json['Servings'] ?? 1).toDouble(), // Changed to double conversion
      recWeight:
          (json['Rec_weight'] ?? 0).toDouble(), // Changed to double conversion
      portion: (json['Portion'] ?? 0).toDouble(),
      recipeDescription: json['Recipe_Description'] ?? '',
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

class NutritionResponse {
  final String recipeId;
  final String recipeName;
  final NutritionData nutrition;

  NutritionResponse({
    required this.recipeId,
    required this.recipeName,
    required this.nutrition,
  });
  factory NutritionResponse.fromJson(Map<String, dynamic> json) {
    return NutritionResponse(
      recipeId: json['recipe_id'] ?? '',
      recipeName: json['recipe_name'] ?? '',
      nutrition: NutritionData.fromJson(json['nutrition'] ?? {}),
    );
  }
}

class NutritionData {
  final double servings;
  final String ctime;
  final double energyKcal;
  final double proteinG;
  final double totalFatG;
  final double totalDietaryFibreG;
  final double calciumMg;
  final double zincMg;
  final double ironMg;
  final double magnesiumMg;
  final double totalFolatesMcg;
  final double vb12Ug;
  final double thiamineMg;
  final double riboflavinMg;
  final double niacinMg;
  final double totalB6AMg;
  final double totalAscorbicAcidMg;
  final double vaRaeMcg;
  final double portionWeightG;
  final double portion;
  final String recipeDescription;

  NutritionData({
    required this.servings,
    required this.ctime,
    required this.energyKcal,
    required this.proteinG,
    required this.totalFatG,
    required this.totalDietaryFibreG,
    required this.calciumMg,
    required this.zincMg,
    required this.ironMg,
    required this.magnesiumMg,
    required this.totalFolatesMcg,
    required this.vb12Ug,
    required this.thiamineMg,
    required this.riboflavinMg,
    required this.niacinMg,
    required this.totalB6AMg,
    required this.totalAscorbicAcidMg,
    required this.vaRaeMcg,
    required this.portionWeightG,
    required this.portion,
    required this.recipeDescription,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      servings: (json['Servings'] ?? 0).toDouble(),
      ctime: json['Ctime'] ?? '',
      energyKcal: (json['Energy_kcal'] ?? 0).toDouble(),
      proteinG: (json['Protein.PROTCNT_g'] ?? 0).toDouble(),
      totalFatG: (json['TotalFat.FATCE_g'] ?? 0).toDouble(),
      totalDietaryFibreG: (json['TotalDietaryFibre.FIBTG_g'] ?? 0).toDouble(),
      calciumMg: (json['CalciumCa.CA_mg'] ?? 0).toDouble(),
      zincMg: (json['ZincZn.ZN_mg'] ?? 0).toDouble(),
      ironMg: (json['IronFe.FE_mg'] ?? 0).toDouble(),
      magnesiumMg: (json['MagnesiumMg.MG_mg'] ?? 0).toDouble(),
      totalFolatesMcg: (json['TotalFolatesB9.FOLSUM_mcg'] ?? 0).toDouble(),
      vb12Ug: (json['VB12_ug'] ?? 0).toDouble(),
      thiamineMg: (json['ThiamineB1.THIA_mg'] ?? 0).toDouble(),
      riboflavinMg: (json['RiboflavinB2.RIBF_mg'] ?? 0).toDouble(),
      niacinMg: (json['NiacinB3.NIA_mg'] ?? 0).toDouble(),
      totalB6AMg: (json['TotalB6A.VITB6A_mg'] ?? 0).toDouble(),
      totalAscorbicAcidMg: (json['TotalAscorbicAcid.VITC_mg'] ?? 0).toDouble(),
      vaRaeMcg: (json['VA_RAE_mcg'] ?? 0).toDouble(),
      portionWeightG: (json['Portion_weight_(g)'] ?? 0).toDouble(),
      portion: (json['Portion'] ?? 0).toDouble(),
      recipeDescription: json['Recipe_Description'] ?? '',
    );
  }
}
