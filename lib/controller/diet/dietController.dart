import 'package:get/get.dart';

import '../../constant/appConstant.dart';
import '../../model/diet_recall_model.dart';
import '../../model/recipe_model.dart';
import '../../repo/authRepo.dart';

class DietController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  DietController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;
  RxBool isLoadingList = false.obs;
  RxBool isLoadingRecipes = false.obs;

  DietRecallListResponse? dietRecallListResponse;
  RxList<DietRecall> dietRecallList = <DietRecall>[].obs;

  RecipeResponse? recipeResponse;
  RxList<Recipe> recipeList = <Recipe>[].obs;

  getDietRecallList() async {
    isLoadingList.value = true;
    Response response =
        await authRepo.getDataSet(apiName: AppConstants.GET_DIET_RECALES);
    if (response.statusCode == 200) {
      dietRecallListResponse = DietRecallListResponse.fromJson(response.body);
      dietRecallList.clear(); // Clear existing items
      dietRecallList.addAll(dietRecallListResponse!.recalls);
    } else {
      dietRecallListResponse = null;
    }
    isLoadingList.value = false;
    update();
  }

  getRecipes() async {
    print("Starting to fetch recipes...");
    isLoadingRecipes.value = true;
    update(); // Force update

    try {
      Response response =
          await authRepo.getDataSet(apiName: AppConstants.GET_RECIPES);
      print("Recipe API Response Status: ${response.statusCode}");
      print("Recipe API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        recipeResponse = RecipeResponse.fromJson(response.body);
        recipeList.clear(); // Clear existing items
        recipeList.addAll(recipeResponse!.recipes);
        print("Loaded ${recipeList.length} recipes");
      } else {
        print("API Error: ${response.statusCode}");
        recipeResponse = null;
        recipeList.clear(); // Clear list on error
      }
    } catch (e) {
      print("Exception in getRecipes: $e");
      recipeResponse = null;
      recipeList.clear();
    }

    isLoadingRecipes.value = false;
    print(
        "Finished fetching recipes. Loading state: ${isLoadingRecipes.value}");
    update(); // Force update
  }

  addDietRecall(Map<String, dynamic> dietData) async {
    isLoading.value = true;
    try {
      Response response = await authRepo.postDataSet(
        sendData: dietData,
        apiName: AppConstants.GET_DIET_RECALES,
      );
      print("Add Diet Recall Response Status: ${response.statusCode}");
      print("Add Diet Recall Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the diet recall list after successful addition
        await getDietRecallList();
        isLoading.value = false;
        return {'success': true, 'message': 'Diet entry added successfully!'};
      } else {
        isLoading.value = false;
        return {
          'success': false,
          'message': 'Failed to add diet entry. Please try again.'
        };
      }
    } catch (e) {
      print("Exception in addDietRecall: $e");
      isLoading.value = false;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    }
  }

  deleteDietRecall(String recallId) async {
    isLoading.value = true;
    try {
      String deleteUrl = "${AppConstants.GET_DIET_RECALES}/$recallId";
      Response response = await authRepo.deleteDataSet(apiName: deleteUrl);
      print("Delete Diet Recall Response Status: ${response.statusCode}");
      print("Delete Diet Recall Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Refresh the diet recall list after successful deletion
        await getDietRecallList();
        isLoading.value = false;
        return {'success': true, 'message': 'Diet entry deleted successfully!'};
      } else {
        isLoading.value = false;
        return {
          'success': false,
          'message': 'Failed to delete diet entry. Please try again.'
        };
      }
    } catch (e) {
      print("Exception in deleteDietRecall: $e");
      isLoading.value = false;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    }
  }
}
