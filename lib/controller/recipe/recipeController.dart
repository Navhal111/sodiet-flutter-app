import 'package:get/get.dart';

import '../../constant/appConstant.dart';
import '../../model/recipe_model.dart';
import '../../model/food_group.dart';
import '../../repo/authRepo.dart';

class RecipeController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  RecipeController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;
  RxBool isLoadingRecipes = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;

  // Search related variables
  RxBool isSearching = false.obs;
  RxBool isLoadingSearchMore = false.obs;
  RxBool hasMoreSearchData = true.obs;
  RxString currentSearchTerm = ''.obs;

  // Ingredients related variables
  RxBool isLoadingIngredients = false.obs;

  // Nutrition related variables
  RxBool isLoadingNutrition = false.obs;

  // Food categories related variables
  RxBool isLoadingFoodCategories = false.obs;

  // Food subcategories related variables
  RxBool isLoadingFoodSubcategories = false.obs;

  int currentPage = 1;
  int pageSize = 20; // Load 20 items per page
  int searchCurrentPage = 1;

  RecipeResponse? recipeResponse;
  RxList<Recipe> recipeList = <Recipe>[].obs;
  RxList<Recipe> searchResultsList = <Recipe>[].obs;

  // Ingredients data
  Rx<IngredientsResponse?> ingredientsResponse = Rx<IngredientsResponse?>(null);

  // Nutrition data
  Rx<NutritionResponse?> nutritionResponse = Rx<NutritionResponse?>(null);

  // Food categories data
  Rx<FoodCategoriesResponse?> foodCategoriesResponse =
      Rx<FoodCategoriesResponse?>(null);

  // Food subcategories data
  Rx<FoodSubcategoriesResponse?> foodSubcategoriesResponse =
      Rx<FoodSubcategoriesResponse?>(null);

  // Food groups data
  RxBool isLoadingFoodGroups = false.obs;
  Rx<FoodGroupResponse?> foodGroupsResponse = Rx<FoodGroupResponse?>(null);

  // Filter and Sort variables
  RxString selectedCategoryCode = ''.obs;
  RxString selectedSubcategoryCode = ''.obs;
  RxString selectedSortBy = 'Name (A-Z)'.obs;
  RxList<Recipe> filteredRecipeList = <Recipe>[].obs;

  // Recipe submission related variables
  RxBool isSubmittingRecipe = false.obs;

  getRecipes({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore.value || !hasMoreData.value) return;
      isLoadingMore.value = true;
      currentPage++;
    } else {
      isLoadingRecipes.value = true;
      currentPage = 1;
      hasMoreData.value = true;
      recipeList.clear(); // Clear list on fresh load
    }

    print("Starting to fetch recipes... Page: $currentPage");

    try {
      String apiUrl = AppConstants.GET_RECIPES;
      if (loadMore || currentPage > 1) {
        apiUrl += '?page=$currentPage&page_size=$pageSize';
      } else {
        apiUrl += '?page_size=$pageSize';
      }

      // Add category filter if selected
      if (selectedCategoryCode.value.isNotEmpty) {
        if (apiUrl.contains('?')) {
          apiUrl += '&recipe_category=${selectedCategoryCode.value}';
        } else {
          apiUrl += '?recipe_category=${selectedCategoryCode.value}';
        }
        print(
            "Adding category filter to main recipes: ${selectedCategoryCode.value}");
      }

      // Add subcategory filter if selected
      if (selectedSubcategoryCode.value.isNotEmpty) {
        if (apiUrl.contains('?')) {
          apiUrl += '&subcategories=${selectedSubcategoryCode.value}';
        } else {
          apiUrl += '?subcategories=${selectedSubcategoryCode.value}';
        }
        print(
            "Adding subcategory filter to main recipes: ${selectedSubcategoryCode.value}");
      }

      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("Recipe API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        recipeResponse = RecipeResponse.fromJson(response.body);

        if (loadMore) {
          // Append new items for pagination
          recipeList.addAll(recipeResponse!.recipes);
          print(
              "Loaded ${recipeResponse!.recipes.length} more recipes. Total: ${recipeList.length}");
        } else {
          // Replace all items for fresh load
          recipeList.addAll(recipeResponse!.recipes);
          print("Loaded ${recipeList.length} recipes");
        }

        // Check if there's more data
        if (recipeResponse!.recipes.length < pageSize) {
          hasMoreData.value = false;
          print("No more recipe data to load");
        }
      } else {
        print("Recipe API Error: ${response.statusCode}");
        if (!loadMore) {
          recipeResponse = null;
        }
      }
    } catch (e) {
      print("Exception in getRecipes: $e");
      if (!loadMore) {
        recipeResponse = null;
      }
    }

    if (loadMore) {
      isLoadingMore.value = false;
    } else {
      isLoadingRecipes.value = false;
    }

    print(
        "Finished fetching recipes. Loading state: ${isLoadingRecipes.value}");
    _updateFilteredList(); // Update filtered list after loading recipes
    update();
  }

  // Method to load more data when scrolling
  void loadMoreRecipes() {
    getRecipes(loadMore: true);
  }

  // Method to refresh recipes
  void refreshRecipes() {
    getRecipes();
  }

  // Method to search recipes via API
  searchRecipesAPI(String searchTerm, {bool loadMore = false}) async {
    // Allow empty search term for filtering only
    // if (searchTerm.isEmpty) {
    //   clearSearchResults();
    //   return;
    // }

    if (loadMore) {
      if (isLoadingSearchMore.value || !hasMoreSearchData.value) return;
      isLoadingSearchMore.value = true;
      searchCurrentPage++;
    } else {
      isSearching.value = true;
      searchCurrentPage = 1;
      hasMoreSearchData.value = true;
      searchResultsList.clear();
      currentSearchTerm.value = searchTerm;
    }

    print(
        "Starting to search recipes... Search term: '$searchTerm', Page: $searchCurrentPage");

    try {
      String apiUrl = AppConstants.GET_RECIPES_SEARCH;

      // Build query parameters
      List<String> queryParams = [];
      queryParams.add('page=$searchCurrentPage');
      queryParams.add('page_size=$pageSize');

      // Add search term only if it's not empty
      if (searchTerm.isNotEmpty) {
        queryParams.add('search_term=$searchTerm');
      }

      apiUrl += '?' + queryParams.join('&');

      // Add category filter if selected
      if (selectedCategoryCode.value.isNotEmpty) {
        apiUrl += '&recipe_category=${selectedCategoryCode.value}';
        print("Adding category filter: ${selectedCategoryCode.value}");
      }

      // Add subcategory filter if selected
      if (selectedSubcategoryCode.value.isNotEmpty) {
        apiUrl += '&subcategories=${selectedSubcategoryCode.value}';
        print("Adding subcategory filter: ${selectedSubcategoryCode.value}");
      }

      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("Search Recipe API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        RecipeResponse searchResponse = RecipeResponse.fromJson(response.body);

        if (loadMore) {
          // Append new items for pagination
          searchResultsList.addAll(searchResponse.recipes);
          print(
              "Loaded ${searchResponse.recipes.length} more search results. Total: ${searchResultsList.length}");
        } else {
          // Replace all items for fresh search
          searchResultsList.addAll(searchResponse.recipes);
          print("Loaded ${searchResultsList.length} search results");
        }

        // Check if there's more data
        if (searchResponse.recipes.length < pageSize) {
          hasMoreSearchData.value = false;
          print("No more search data to load");
        }
      } else {
        print("Search Recipe API Error: ${response.statusCode}");
        if (!loadMore) {
          searchResultsList.clear();
        }
      }
    } catch (e) {
      print("Exception in searchRecipesAPI: $e");
      if (!loadMore) {
        searchResultsList.clear();
      }
    }

    if (loadMore) {
      isLoadingSearchMore.value = false;
    } else {
      isSearching.value = false;
    }

    print("Finished searching recipes. Search state: ${isSearching.value}");
    _updateFilteredList(); // Update filtered list after search
    update();
  }

  // Method to load more search results
  void loadMoreSearchResults() {
    if (currentSearchTerm.value.isNotEmpty) {
      searchRecipesAPI(currentSearchTerm.value, loadMore: true);
    }
  }

  // Method to clear search results
  void clearSearchResults() {
    searchResultsList.clear();
    currentSearchTerm.value = '';
    searchCurrentPage = 1;
    hasMoreSearchData.value = true;
    isSearching.value = false;
    isLoadingSearchMore.value = false;
    _updateFilteredList(); // Update filtered list after clearing search
  }

  // Method to get current display list (search results or all recipes)
  List<Recipe> getCurrentDisplayList() {
    print("🎯 getCurrentDisplayList called:");
    print("   - Search term: '${currentSearchTerm.value}'");
    print("   - Category filter: '${selectedCategoryCode.value}'");
    print("   - Subcategory filter: '${selectedSubcategoryCode.value}'");
    print("   - Sort: '${selectedSortBy.value}'");

    // Check if any filters are active (category or subcategory)
    bool hasFilters = selectedCategoryCode.value.isNotEmpty ||
        selectedSubcategoryCode.value.isNotEmpty;

    // If there's an active search term OR filters are active, use search results
    // (because both scenarios use searchRecipesAPI)
    if (currentSearchTerm.value.isNotEmpty || hasFilters) {
      print("   -> 🔍 Returning searchResultsList (search/filter mode)");
      return searchResultsList;
    }

    // If only sorting is applied (no search, no category/subcategory filters), use filtered list
    if (selectedSortBy.value != 'Name (A-Z)') {
      print("   -> 🔄 Returning filteredRecipeList (sort only)");
      return filteredRecipeList;
    }

    // Default case: normal browsing with no search, no filters, default sorting
    print("   -> 📋 Returning recipeList (normal browsing)");
    return recipeList;
  }

  // Method to check if currently searching
  bool get isCurrentlySearching => currentSearchTerm.value.isNotEmpty;

  // Method to search recipes by name (local search - kept for backward compatibility)
  List<Recipe> searchRecipes(String query) {
    if (query.isEmpty) {
      return recipeList;
    }
    return recipeList
        .where((recipe) =>
            recipe.recipeName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Method to get recipe by code
  Recipe? getRecipeByCode(String recipeCode) {
    try {
      return recipeList.firstWhere((recipe) => recipe.recipeCode == recipeCode);
    } catch (e) {
      return null;
    }
  }

  // Method to get recipes by category/subcategory
  List<Recipe> getRecipesByCategory(String category) {
    return recipeList
        .where((recipe) =>
            recipe.subcategories
                .toLowerCase()
                .contains(category.toLowerCase()) ||
            recipe.codeCooccurence
                .toLowerCase()
                .contains(category.toLowerCase()))
        .toList();
  }

  // Method to like a recipe
  Future<bool> likeRecipe(String recipeCode) async {
    print("Starting to like recipe: $recipeCode");

    try {
      String apiUrl = AppConstants.getRecipeLikeUrl(recipeCode);
      Map<String, dynamic> requestBody = {
        'recipeCode': recipeCode,
      };

      Response response = await authRepo.postDataSet(
        apiName: apiUrl,
        sendData: requestBody,
      );

      print("Like Recipe API Response Status: ${response.statusCode}");
      print("Like Recipe API Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Recipe liked successfully");
        return true;
      } else {
        print("Failed to like recipe. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Exception in likeRecipe: $e");
      return false;
    }
  }

  // Method to dislike a recipe
  Future<bool> dislikeRecipe(String recipeCode) async {
    print("Starting to dislike recipe: $recipeCode");

    try {
      String apiUrl = AppConstants.getRecipeDislikeUrl(recipeCode);
      Map<String, dynamic> requestBody = {
        'recipeCode': recipeCode,
      };

      Response response = await authRepo.postDataSet(
        apiName: apiUrl,
        sendData: requestBody,
      );

      print("Dislike Recipe API Response Status: ${response.statusCode}");
      print("Dislike Recipe API Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Recipe disliked successfully");
        return true;
      } else {
        print("Failed to dislike recipe. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Exception in dislikeRecipe: $e");
      return false;
    }
  }

  // Method to get recipe ingredients
  Future<bool> getRecipeIngredients(String recipeCode) async {
    print("Starting to fetch ingredients for recipe: $recipeCode");

    isLoadingIngredients.value = true;

    try {
      String apiUrl = AppConstants.getRecipeIngredientsUrl(recipeCode);

      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("Ingredients API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        ingredientsResponse.value = IngredientsResponse.fromJson(response.body);
        print(
            "Loaded ${ingredientsResponse.value?.ingredients.length ?? 0} ingredients");
        return true;
      } else {
        print("Ingredients API Error: ${response.statusCode}");
        ingredientsResponse.value = null;
        return false;
      }
    } catch (e) {
      print("Exception in getRecipeIngredients: $e");
      ingredientsResponse.value = null;
      return false;
    } finally {
      isLoadingIngredients.value = false;
    }
  }

  // Method to clear ingredients data
  void clearIngredients() {
    ingredientsResponse.value = null;
  }

  // Method to get recipe nutrition
  Future<bool> getRecipeNutrition(String recipeCode) async {
    print("Starting to fetch nutrition for recipe: $recipeCode");
    isLoadingNutrition.value = true;

    try {
      String apiUrl = AppConstants.getRecipeNutritionUrl(recipeCode);

      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("Nutrition API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        nutritionResponse.value = NutritionResponse.fromJson(response.body);
        print(
            "Loaded nutrition data for recipe: ${nutritionResponse.value?.recipeName}");
        return true;
      } else {
        print("Nutrition API Error: ${response.statusCode}");
        nutritionResponse.value = null;
        return false;
      }
    } catch (e) {
      print("Exception in getRecipeNutrition: $e");
      nutritionResponse.value = null;
      return false;
    } finally {
      isLoadingNutrition.value = false;
    }
  }

  // Method to clear nutrition data
  void clearNutrition() {
    nutritionResponse.value = null;
  }

  // Method to get food categories
  Future<bool> getFoodCategories() async {
    print("Starting to fetch food categories");
    isLoadingFoodCategories.value = true;

    try {
      String apiUrl = AppConstants.GET_FOOD_CATEGORIES;

      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("Food Categories API Response Status: ${response.statusCode}");
      print("Food Categories API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        foodCategoriesResponse.value =
            FoodCategoriesResponse.fromJson(response.body);
        print(
            "Loaded ${foodCategoriesResponse.value?.foodCategories.length ?? 0} food categories");
        return true;
      } else {
        print("Food Categories API Error: ${response.statusCode}");
        foodCategoriesResponse.value = null;
        return false;
      }
    } catch (e) {
      print("Exception in getFoodCategories: $e");
      foodCategoriesResponse.value = null;
      return false;
    } finally {
      isLoadingFoodCategories.value = false;
    }
  }

  // Method to get food categories list
  List<FoodCategory> get foodCategoriesList =>
      foodCategoriesResponse.value?.foodCategories ?? [];

  // Method to get food category by code
  FoodCategory? getFoodCategoryByCode(String code) {
    try {
      return foodCategoriesList.firstWhere((category) => category.code == code);
    } catch (e) {
      return null;
    }
  }

  // Method to search food categories by name
  List<FoodCategory> searchFoodCategories(String query) {
    if (query.isEmpty) {
      return foodCategoriesList;
    }
    return foodCategoriesList
        .where((category) =>
            category.category.toLowerCase().contains(query.toLowerCase()) ||
            category.code.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Method to check if food categories are loaded
  bool get hasFoodCategories => foodCategoriesResponse.value != null;

  // Method to clear food categories data
  void clearFoodCategories() {
    foodCategoriesResponse.value = null;
  }

  // ==================== FOOD GROUPS METHODS ====================

  Future<bool> getFoodGroups() async {
    try {
      isLoadingFoodGroups.value = true;

      final response = await authRepo.getDataSet(
        apiName: AppConstants.GET_FOOD_GROUPS,
      );

      if (response.statusCode == 200) {
        print("Food groups API response: ${response.body}");

        final responseData = FoodGroupResponse.fromJson(response.body);
        foodGroupsResponse.value = responseData;

        print(
            "Food groups loaded successfully: ${responseData.foodGroups.length} groups");
        return true;
      } else {
        print("Failed to load food groups: ${response.statusCode}");
        foodGroupsResponse.value = null;
        return false;
      }
    } catch (e) {
      print("Exception in getFoodGroups: $e");
      foodGroupsResponse.value = null;
      return false;
    } finally {
      isLoadingFoodGroups.value = false;
    }
  }

  // Method to get food groups list
  List<FoodGroup> get foodGroupsList =>
      foodGroupsResponse.value?.foodGroups ?? [];

  // Method to get food group by name
  FoodGroup? getFoodGroupByName(String name) {
    try {
      return foodGroupsList.firstWhere((group) => group.groupName == name);
    } catch (e) {
      return null;
    }
  }

  // Method to search food groups by name
  List<FoodGroup> searchFoodGroups(String query) {
    if (query.isEmpty) {
      return foodGroupsList;
    }
    return foodGroupsList
        .where((group) =>
            group.groupName.toLowerCase().contains(query.toLowerCase()) ||
            group.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Method to check if food groups are loaded
  bool get hasFoodGroups => foodGroupsResponse.value != null;

  // Method to clear food groups data
  void clearFoodGroups() {
    foodGroupsResponse.value = null;
  }

  // Method to refresh food categories
  void refreshFoodCategories() {
    getFoodCategories();
  }

  // Method to get food subcategories
  Future<bool> getFoodSubcategories({String? mainCategoryCode}) async {
    print("Starting to fetch food subcategories");
    isLoadingFoodSubcategories.value = true;

    try {
      String apiUrl = AppConstants.GET_FOOD_SUBCATEGORIES;

      // Add main category filter if provided
      if (mainCategoryCode != null && mainCategoryCode.isNotEmpty) {
        apiUrl += '?main_category_code=$mainCategoryCode';
        print("Filtering subcategories by main category: $mainCategoryCode");
      }

      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("Food Subcategories API Response Status: ${response.statusCode}");
      print("Food Subcategories API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        foodSubcategoriesResponse.value =
            FoodSubcategoriesResponse.fromJson(response.body);
        print(
            "Loaded ${foodSubcategoriesResponse.value?.foodSubcategories.length ?? 0} food subcategories");
        return true;
      } else {
        print("Food Subcategories API Error: ${response.statusCode}");
        foodSubcategoriesResponse.value = null;
        return false;
      }
    } catch (e) {
      print("Exception in getFoodSubcategories: $e");
      foodSubcategoriesResponse.value = null;
      return false;
    } finally {
      isLoadingFoodSubcategories.value = false;
    }
  }

  // Method to get food subcategories list
  List<FoodSubcategory> get foodSubcategoriesList =>
      foodSubcategoriesResponse.value?.foodSubcategories ?? [];

  // Method to get food subcategory by code
  FoodSubcategory? getFoodSubcategoryByCode(String code) {
    try {
      return foodSubcategoriesList
          .firstWhere((subcategory) => subcategory.code == code);
    } catch (e) {
      return null;
    }
  }

  // Method to search food subcategories by name
  List<FoodSubcategory> searchFoodSubcategories(String query) {
    if (query.isEmpty) {
      return foodSubcategoriesList;
    }
    return foodSubcategoriesList
        .where((subcategory) =>
            subcategory.subCategory
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            subcategory.code.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Method to get subcategories by main category code
  List<FoodSubcategory> getSubcategoriesByMainCategory(
      String mainCategoryCode) {
    return foodSubcategoriesList
        .where(
            (subcategory) => subcategory.mainCategoryCode == mainCategoryCode)
        .toList();
  }

  // Method to check if food subcategories are loaded
  bool get hasFoodSubcategories => foodSubcategoriesResponse.value != null;

  // Method to clear food subcategories data
  void clearFoodSubcategories() {
    foodSubcategoriesResponse.value = null;
  }

  // Method to refresh food subcategories
  void refreshFoodSubcategories({String? mainCategoryCode}) {
    getFoodSubcategories(mainCategoryCode: mainCategoryCode);
  }

  // Method to apply filters and sorting
  void applyFiltersAndSort(
      String? categoryCode, String? subcategoryCode, String sortBy) {
    String previousCategoryCode = selectedCategoryCode.value;
    String previousSubcategoryCode = selectedSubcategoryCode.value;
    selectedCategoryCode.value = categoryCode ?? '';
    selectedSubcategoryCode.value = subcategoryCode ?? '';
    selectedSortBy.value = sortBy;

    print("Applying filters and sort:");
    print("- Category: ${selectedCategoryCode.value}");
    print("- Subcategory: ${selectedSubcategoryCode.value}");
    print("- Sort: ${selectedSortBy.value}");
    print("- Current search term: '${currentSearchTerm.value}'");

    // If category or subcategory filter changed, refresh the data from API
    if (previousCategoryCode != selectedCategoryCode.value ||
        previousSubcategoryCode != selectedSubcategoryCode.value) {
      // Check if any filters are active

      bool hasFilters = selectedCategoryCode.value.isNotEmpty ||
          selectedSubcategoryCode.value.isNotEmpty;

      if (hasFilters) {
        // Use searchRecipesAPI for filtering (with or without search term)
        String searchTerm =
            currentSearchTerm.value.isNotEmpty ? currentSearchTerm.value : "";
        print(
            "🔍 Using searchRecipesAPI with filters. Search term: '$searchTerm'");
        searchRecipesAPI(searchTerm);
      } else {
        // No filters active, use getRecipes for normal browsing
        if (currentSearchTerm.value.isNotEmpty) {
          // User was searching but removed filters, continue with search
          print(
              "🔍 Using searchRecipesAPI for search without filters: ${currentSearchTerm.value}");
          searchRecipesAPI(currentSearchTerm.value);
        } else {
          // No search, no filters - use normal list
          print(
              "📋 Using getRecipes for normal browsing (no filters, no search)");
          getRecipes();
        }
      }
    } else {
      // Just update filtered list for sorting changes
      print("🔄 Only sorting changed, updating filtered list locally");
      _updateFilteredList();
    }
  }

  // Method to clear filters
  void clearFilters() {
    bool hadCategoryFilter = selectedCategoryCode.value.isNotEmpty;
    bool hadSubcategoryFilter = selectedSubcategoryCode.value.isNotEmpty;
    selectedCategoryCode.value = '';
    selectedSubcategoryCode.value = '';
    selectedSortBy.value = 'Name (A-Z)';

    print("Clearing filters:");
    print("- Had category filter: $hadCategoryFilter");
    print("- Had subcategory filter: $hadSubcategoryFilter");
    print("- Current search term: '${currentSearchTerm.value}'");

    // If any filter was active, refresh the data from API
    if (hadCategoryFilter || hadSubcategoryFilter) {
      // Always use searchRecipesAPI when clearing filters if we had filters before
      // This ensures we get fresh data from the search endpoint
      String searchTerm =
          currentSearchTerm.value.isNotEmpty ? currentSearchTerm.value : "";
      print(
          "🔍 Using searchRecipesAPI after clearing filters. Search term: '$searchTerm'");
      searchRecipesAPI(searchTerm);
    } else {
      // No filters were active, just update filtered list for sorting changes
      if (currentSearchTerm.value.isNotEmpty) {
        // User is still searching, keep using search results
        print("� Continuing with search results (no filters were active)");
        _updateFilteredList();
      } else {
        // No search, no filters - use normal list
        print("� Using normal list (no filters were active, no search)");
        _updateFilteredList();
      }
    }
  }

  // Private method to update filtered list
  void _updateFilteredList() {
    print("🔄 _updateFilteredList called");

    // Check if any filters are active
    bool hasFilters = selectedCategoryCode.value.isNotEmpty ||
        selectedSubcategoryCode.value.isNotEmpty;

    // Determine base list based on search term or filters
    List<Recipe> baseList;
    if (currentSearchTerm.value.isNotEmpty || hasFilters) {
      // Use search results when searching or filtering (both use searchRecipesAPI)
      baseList = searchResultsList;
      print("   - Using searchResultsList as base (search/filter mode)");
    } else {
      // Use main recipe list for normal browsing
      baseList = recipeList;
      print("   - Using recipeList as base (normal browsing)");
    }

    List<Recipe> filtered = List.from(baseList);

    // Note: Category filtering is now handled via API, so we only apply sorting here

    // Apply sorting
    switch (selectedSortBy.value) {
      case 'Name (A-Z)':
        filtered.sort((a, b) => a.recipeName.compareTo(b.recipeName));
        break;
      case 'Name (Z-A)':
        filtered.sort((a, b) => b.recipeName.compareTo(a.recipeName));
        break;
      case 'Energy (Low to High)':
        filtered.sort((a, b) => a.energyKcal.compareTo(b.energyKcal));
        break;
      case 'Energy (High to Low)':
        filtered.sort((a, b) => b.energyKcal.compareTo(a.energyKcal));
        break;
      case 'Cooking Time (Short to Long)':
        // Since we don't have cooking time in the model, we'll sort by portion as an example
        filtered.sort((a, b) => a.portion.compareTo(b.portion));
        break;
      case 'Cooking Time (Long to Short)':
        // Since we don't have cooking time in the model, we'll sort by portion as an example
        filtered.sort((a, b) => b.portion.compareTo(a.portion));
        break;
      case 'Category (A-Z)':
        filtered.sort((a, b) => a.subcategories.compareTo(b.subcategories));
        break;
      default:
        filtered.sort((a, b) => a.recipeName.compareTo(b.recipeName));
    }

    filteredRecipeList.value = filtered;
    update();
  }

  // Method to check if filters are active
  bool get hasActiveFilters =>
      selectedCategoryCode.value.isNotEmpty ||
      selectedSubcategoryCode.value.isNotEmpty ||
      selectedSortBy.value != 'Name (A-Z)';

  // Method to submit a new recipe
  Future<Map<String, dynamic>> submitRecipe({
    required String recipeName,
    required String cookingTime,
    required String description,
    String? additionalDescription,
    required String categoryCode,
    required String subcategoryCode,
    required double portion,
    required double portionWeight,
    required double servings,
    required List<String> regional,
    required List<String> mealtime,
    required List<String> dietary,
    required List<String> attributes,
    required List<Map<String, dynamic>> tableData,
  }) async {
    print("Starting to submit recipe: $recipeName");
    isSubmittingRecipe.value = true;

    try {
      String apiUrl = AppConstants.SUBMIT_RECIPE;

      Map<String, dynamic> requestBody = {
        'code_cooccurence': categoryCode,
        'subcategories': subcategoryCode,
        'portion': portion,
        'description': additionalDescription?.toLowerCase() ?? 'select',
        'portion_weight': portionWeight,
        'servings': servings,
        'cookingTime': cookingTime,
        'recipeName': recipeName,
        'regional': regional,
        'mealtime': mealtime,
        'dietary': dietary,
        'attributes': attributes,
        'tableData': tableData,
      };

      print("Recipe submission payload: $requestBody");

      Response response = await authRepo.postDataSet(
        apiName: apiUrl,
        sendData: requestBody,
      );

      print("Submit Recipe API Response Status: ${response.statusCode}");
      print("Submit Recipe API Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Recipe submitted successfully");

        // Refresh recipes list to include the new recipe
        refreshRecipes();

        return {
          'success': true,
          'message':
              response.body['message'] ?? 'Recipe submitted successfully',
          'data': response.body
        };
      } else {
        print("Failed to submit recipe. Status: ${response.statusCode}");
        return {
          'success': false,
          'message': response.body['message'] ?? 'Failed to submit recipe',
          'error': response.body
        };
      }
    } catch (e) {
      print("Exception in submitRecipe: $e");
      return {
        'success': false,
        'message': 'An error occurred while submitting recipe',
        'error': e.toString()
      };
    } finally {
      isSubmittingRecipe.value = false;
    }
  }

  // ==================== INGREDIENT SUBMISSION METHODS ====================

  RxBool isSubmittingIngredient = false.obs;

  Future<Map<String, dynamic>> submitIngredient({
    required String foodName,
    required String foodGroup,
    String? otherFoodGroup,
    required Map<String, double> nutritionalInfo,
  }) async {
    try {
      isSubmittingIngredient.value = true;

      // Prepare the payload according to the API specification
      Map<String, dynamic> payload = {
        "food_name": foodName,
        "food_group": foodGroup,
        "other_food_group": otherFoodGroup ?? "",
        "Energy.ENERC_KJ": nutritionalInfo['energy_kcal'] ?? 0,
        "Protein.PROTCNT g ": nutritionalInfo['protein_g'] ?? 0,
        "TotalFat.FATCE g ": nutritionalInfo['fat_g'] ?? 0,
        "TotalDietaryFibre.FIBTG g ": nutritionalInfo['dietary_fibre_g'] ?? 0,
        "CalciumCa.CA mg ": nutritionalInfo['calcium_mg'] ?? 0,
        "ZincZn.ZN mg ": nutritionalInfo['zinc_mg'] ?? 0,
        "IronFe.FE mg ": nutritionalInfo['iron_mg'] ?? 0,
        "MagnesiumMg.MG mg ": nutritionalInfo['magnesium_mg'] ?? 0,
        "TotalFolatesB9.FOLSUM Î¼g ": nutritionalInfo['folate_ug'] ?? 0,
        "VB12": nutritionalInfo['vitamin_b12_ug'] ?? 0,
        "ThiamineB1.THIA mg ": nutritionalInfo['vitamin_b1_mg'] ?? 0,
        "RiboflavinB2.RIBF mg ": nutritionalInfo['vitamin_b2_mg'] ?? 0,
        "NiacinB3.NIA mg ": nutritionalInfo['vitamin_b3_mg'] ?? 0,
        "TotalB6A.VITB6A mg ": nutritionalInfo['vitamin_b6_mg'] ?? 0,
        "TotalAscorbicAcid.VITC mg ": nutritionalInfo['vitamin_c_mg'] ?? 0,
        "VA_RAE_mcg": nutritionalInfo['vitamin_a_ug'] ?? 0,
      };

      print("Submitting ingredient with payload: $payload");

      final response = await authRepo.postDataSet(
        apiName: AppConstants.SUBMIT_INGREDIENT,
        sendData: payload,
      );

      print("Ingredient submission response: ${response.statusCode}");
      print("Ingredient submission body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Ingredient submitted successfully!',
          'data': response.body
        };
      } else {
        return {
          'success': false,
          'message': response.body['message'] ?? 'Failed to submit ingredient',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      print("Exception in submitIngredient: $e");
      return {
        'success': false,
        'message': 'An error occurred while submitting ingredient',
        'error': e.toString()
      };
    } finally {
      isSubmittingIngredient.value = false;
    }
  }
}
