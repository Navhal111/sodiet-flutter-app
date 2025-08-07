import 'package:get/get.dart';

import '../../constant/appConstant.dart';
import '../../model/recipe_model.dart';
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

  int currentPage = 1;
  int pageSize = 20; // Load 20 items per page
  int searchCurrentPage = 1;

  RecipeResponse? recipeResponse;
  RxList<Recipe> recipeList = <Recipe>[].obs;
  RxList<Recipe> searchResultsList = <Recipe>[].obs;

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
    if (searchTerm.isEmpty) {
      clearSearchResults();
      return;
    }

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
        "Starting to search recipes... Search term: $searchTerm, Page: $searchCurrentPage");

    try {
      String apiUrl = AppConstants.GET_RECIPES_SEARCH;
      apiUrl +=
          '?search_term=$searchTerm&page=$searchCurrentPage&page_size=$pageSize';

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
  }

  // Method to get current display list (search results or all recipes)
  List<Recipe> getCurrentDisplayList() {
    return currentSearchTerm.value.isEmpty ? recipeList : searchResultsList;
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
}
