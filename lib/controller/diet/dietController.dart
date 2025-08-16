import 'package:get/get.dart';

import '../../constant/appConstant.dart';
import '../../model/diet_recall_model.dart';
import '../../model/recipe_model.dart';
import '../../model/plan_model.dart';
import '../../repo/authRepo.dart';

class DietController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  DietController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;
  RxBool isLoadingList = false.obs;
  RxBool isLoadingRecipes = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;

  // Observable variables to store intake overview data
  RxBool isLoadingIntakeOverview = false.obs;
  Rx<IntakeOverviewResponse?> intakeOverviewResponse =
      Rx<IntakeOverviewResponse?>(null);

  int currentPage = 1;
  int pageSize = 20; // Load 20 items per page

  DietRecallListResponse? dietRecallListResponse;
  RxList<DietRecall> dietRecallList = <DietRecall>[].obs;

  RecipeResponse? recipeResponse;
  RxList<Recipe> recipeList = <Recipe>[].obs;

  getDietRecallList({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore.value || !hasMoreData.value) return;
      isLoadingMore.value = true;
      currentPage++;
    } else {
      isLoadingList.value = true;
      currentPage = 1;
      hasMoreData.value = true;
      dietRecallList.clear(); // Clear list on fresh load
    }

    try {
      String apiUrl = AppConstants.GET_DIET_RECALES;
      apiUrl += '?page=$currentPage&page_size=$pageSize';

      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("Diet Recall API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        dietRecallListResponse = DietRecallListResponse.fromJson(response.body);

        if (loadMore) {
          // Append new items for pagination
          dietRecallList.addAll(dietRecallListResponse!.recalls);
          print(
              "Loaded ${dietRecallListResponse!.recalls.length} more items. Total: ${dietRecallList.length}");
        } else {
          // Replace all items for fresh load
          dietRecallList.addAll(dietRecallListResponse!.recalls);
          print("Loaded ${dietRecallList.length} items");
        }

        // Check if there's more data
        if (dietRecallListResponse!.recalls.length < pageSize) {
          hasMoreData.value = false;
          print("No more data to load");
        }
      } else {
        print("API Error: ${response.statusCode}");
        if (!loadMore) {
          dietRecallListResponse = null;
        }
      }
    } catch (e) {
      print("Exception in getDietRecallList: $e");
      if (!loadMore) {
        dietRecallListResponse = null;
      }
    }

    if (loadMore) {
      isLoadingMore.value = false;
    } else {
      isLoadingList.value = false;
    }
    update();
  }

  // Method to load more data when scrolling
  void loadMoreDietRecalls() {
    getDietRecallList(loadMore: true);
  }

  getRecipes() async {
    print("Starting to fetch recipes...");
    isLoadingRecipes.value = true;
    print("Loading state set to: ${isLoadingRecipes.value}");
    update(); // Force update
    try {
      Response response = await authRepo.getDataSet(
          apiName: "${AppConstants.GET_RECIPES_SEARCH}/?page=1&page_size=100");
      print("Recipe API Response Status: ${response.statusCode}");
      // print("Recipe API Response Body: ${response.body}"); // Comment out to reduce console spam

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
    print("Update called at: ${DateTime.now()}");
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

  updateDietRecall(String recallId, Map<String, dynamic> dietData) async {
    isLoading.value = true;
    try {
      String updateUrl = "${AppConstants.GET_DIET_RECALES}/$recallId";
      Response response = await authRepo.putDataSet(
        sendData: dietData,
        apiName: updateUrl,
      );
      print("Update Diet Recall Response Status: ${response.statusCode}");
      print("Update Diet Recall Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the diet recall list after successful update
        await getDietRecallList();
        isLoading.value = false;
        return {'success': true, 'message': 'Diet entry updated successfully!'};
      } else {
        isLoading.value = false;
        return {
          'success': false,
          'message': 'Failed to update diet entry. Please try again.'
        };
      }
    } catch (e) {
      print("Exception in updateDietRecall: $e");
      isLoading.value = false;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    }
  }

  getIntakeOverview() async {
    isLoadingIntakeOverview.value = true;
    try {
      Response response =
          await authRepo.getDataSet(apiName: AppConstants.GET_INTAKE_OVERVIEW);
      print("Intake Overview API Response Status: ${response.statusCode}");
      print("Intake Overview API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        intakeOverviewResponse.value =
            IntakeOverviewResponse.fromJson(response.body);

        print('Intake Overview loaded successfully');
        return {
          'success': true,
          'message': 'Intake overview loaded successfully!'
        };
      } else {
        print('Error loading intake overview: ${response.statusCode}');
        intakeOverviewResponse.value = null;
        return {'success': false, 'message': 'Failed to load intake overview'};
      }
    } catch (e) {
      print('Exception in getIntakeOverview: $e');
      intakeOverviewResponse.value = null;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    } finally {
      isLoadingIntakeOverview.value = false;
      update();
    }
  }

  // Intake Overview Helper Methods
  bool get hasIntakeOverview => intakeOverviewResponse.value != null;

  IntakeOverviewChart? get intakeOverviewChart =>
      intakeOverviewResponse.value?.intakeOverviewChart;

  List<String> get intakeDates =>
      intakeOverviewResponse.value?.intakeOverviewChart.dates ?? [];

  List<IntakeSeriesData> get intakeSeries =>
      intakeOverviewResponse.value?.intakeOverviewChart.series ?? [];

  // Method to refresh intake overview
  void refreshIntakeOverview() {
    getIntakeOverview();
  }
}
