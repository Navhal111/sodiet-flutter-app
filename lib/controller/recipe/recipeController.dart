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

  int currentPage = 1;
  int pageSize = 20; // Load 20 items per page

  RecipeResponse? recipeResponse;
  RxList<Recipe> recipeList = <Recipe>[].obs;

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
          print("Loaded ${recipeResponse!.recipes.length} more recipes. Total: ${recipeList.length}");
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
    
    print("Finished fetching recipes. Loading state: ${isLoadingRecipes.value}");
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

  // Method to search recipes by name
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
            recipe.subcategories.toLowerCase().contains(category.toLowerCase()) ||
            recipe.codeCooccurence.toLowerCase().contains(category.toLowerCase()))
        .toList();
  }
}
