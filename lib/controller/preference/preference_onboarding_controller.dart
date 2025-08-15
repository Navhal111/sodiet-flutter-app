import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/model/preference_model.dart';
import 'package:sodiet/model/recipe_model.dart';
import 'package:sodiet/repo/authRepo.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';

class PreferenceOnboardingController extends GetxController
    implements GetxService {
  final AuthRepo authRepo;

  PreferenceOnboardingController({
    required this.authRepo,
  });

  // Observable variables
  var selectedMealType = 'Breakfast'.obs;
  var isLoading = false.obs;
  var isLoadingRecipes = false.obs;
  var isCreatingCombination = false.obs;

  // API response data
  var apiCombinations = <PreferenceCombination>[].obs;
  var totalPreferences = 0.obs;
  var totalCombinations = 0.obs;
  var apiMessage = ''.obs;

  // Recipe data
  var recipeList = <Recipe>[].obs;

  // User combination data for each combination
  var userCombinationsByIndex = <int, RxList<Map<String, String>>>{}.obs;

  // Popup form variables
  RxList<Map<String, dynamic>> tempFoodsList = <Map<String, dynamic>>[].obs;
  RxString selectedFoodName = ''.obs;
  RxString selectedFoodQuantity = ''.obs;

  // Available meal types
  final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  @override
  void onInit() {
    super.onInit();
    // Load initial preferences for Breakfast
    getPreferences();
    // Load recipes for dropdowns
    getRecipes();
  }

  void onMealTypeChanged(String mealType) {
    selectedMealType.value = mealType;
    // Clear user combinations when switching meal types
    userCombinationsByIndex.clear();
    // Fetch preferences for the new meal type
    getPreferences();
  }

  Future<void> getPreferences() async {
    try {
      isLoading.value = true;

      // Convert meal type to lowercase for API
      final timeParam = selectedMealType.value.toLowerCase();
      final url = '${AppConstants.GET_PREFERENCES}?time=$timeParam';

      print('Fetching preferences from: $url'); // Debug log

      Response response = await authRepo.getDataSet(apiName: url);

      print('Response status code: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final preferenceResponse = PreferenceResponse.fromJson(response.body);

        apiCombinations.value = preferenceResponse.combinations;
        totalPreferences.value = preferenceResponse.totalPreferences;
        totalCombinations.value = preferenceResponse.totalCombinations;
        apiMessage.value = preferenceResponse.message;

        print('Loaded ${apiCombinations.length} combinations'); // Debug log
        print('API Message: ${apiMessage.value}'); // Debug log
      } else {
        print('API Error: Status ${response.statusCode}'); // Debug log
        CustomToast.showError('Failed to load preferences');
      }
    } catch (e) {
      print('Exception in getPreferences: $e'); // Debug log
      CustomToast.showError('Error loading preferences: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getRecipes() async {
    try {
      isLoadingRecipes.value = true;

      print('Fetching recipes...'); // Debug log

      Response response = await authRepo.getDataSet(
          apiName: "${AppConstants.GET_RECIPES}/?page=1&page_size=100");

      print(
          'Recipes response status code: ${response.statusCode}'); // Debug log
      print('Recipes response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final recipeResponse = RecipeResponse.fromJson(response.body);
        recipeList.value = recipeResponse.recipes;
      } else {
        print('API Error: Status ${response.statusCode}'); // Debug log
        CustomToast.showError('Failed to load recipes');
      }
    } catch (e) {
      print('Exception in getRecipes: $e'); // Debug log
      CustomToast.showError('Error loading recipes: $e');
    } finally {
      isLoadingRecipes.value = false;
    }
  }

  // Get user combinations for a specific combination index
  List<Map<String, String>> getUserCombinations(int combinationIndex) {
    if (!userCombinationsByIndex.containsKey(combinationIndex)) {
      userCombinationsByIndex[combinationIndex] = <Map<String, String>>[].obs;
    }
    return userCombinationsByIndex[combinationIndex]!;
  }

  // Add a food to a specific combination
  void addFoodToCombination(
      int combinationIndex, String food, String quantity) {
    if (food.isNotEmpty && quantity.isNotEmpty) {
      if (!userCombinationsByIndex.containsKey(combinationIndex)) {
        userCombinationsByIndex[combinationIndex] = <Map<String, String>>[].obs;
      }

      userCombinationsByIndex[combinationIndex]!.add({
        'mealType': selectedMealType.value,
        'food': food,
        'quantity': quantity,
      });

      CustomToast.showSuccess('Food added to combination successfully');
    } else {
      CustomToast.showWarning('Please fill all fields');
    }
  }

  // Delete a food from a specific combination
  void deleteFoodFromCombination(int combinationIndex, int foodIndex) {
    if (userCombinationsByIndex.containsKey(combinationIndex) &&
        foodIndex >= 0 &&
        foodIndex < userCombinationsByIndex[combinationIndex]!.length) {
      userCombinationsByIndex[combinationIndex]!.removeAt(foodIndex);
      CustomToast.showSuccess('Food removed from combination');
    }
  }

  // Add food to combination via API
  Future<bool> addFoodToCombinationAPI({
    required int combinationId,
    required String foodName,
    required double foodQty,
    required String time,
    required String description,
  }) async {
    try {
      CustomToast.showLoading('Adding food to combination...');

      final url = AppConstants.getAddFoodToCombinationUrl(combinationId);

      final payload = {
        "add_foods": [
          {
            "Food_Name": foodName,
            "Food_Qty": foodQty,
            "Time": time,
            "Description": description,
            "Recipe_weight": 0, // Static as requested
          }
        ],
      };

      print('Adding food to combination API URL: $url'); // Debug log
      print('Payload: $payload'); // Debug log

      Response response = await authRepo.putDataSet(
        sendData: payload,
        apiName: url,
      );

      print('Add food response status: ${response.statusCode}'); // Debug log
      print('Add food response body: ${response.body}'); // Debug log

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess('Food added to combination successfully');
        // Refresh preferences to get updated data
        await getPreferences();
        return true;
      } else {
        CustomToast.showError('Failed to add food to combination');
        return false;
      }
    } catch (e) {
      print('Exception in addFoodToCombinationAPI: $e'); // Debug log
      CustomToast.showError('Error adding food to combination: $e');
      return false;
    }
  }

  // Delete food from preferences via API
  Future<bool> deleteFoodFromPreferencesAPI(int pkey) async {
    try {
      CustomToast.showLoading('Deleting food from preferences...');

      final url = AppConstants.getDeleteFoodFromPreferencesUrl(pkey);

      print('Deleting food from preferences API URL: $url'); // Debug log

      Response response = await authRepo.deleteDataSet(apiName: url);

      print('Delete food response status: ${response.statusCode}'); // Debug log
      print('Delete food response body: ${response.body}'); // Debug log

      if (response.statusCode == 200 || response.statusCode == 204) {
        CustomToast.showSuccess('Food deleted from preferences successfully');
        // Refresh preferences to get updated data
        await getPreferences();
        return true;
      } else {
        CustomToast.showError('Failed to delete food from preferences');
        return false;
      }
    } catch (e) {
      print('Exception in deleteFoodFromPreferencesAPI: $e'); // Debug log
      CustomToast.showError('Error deleting food from preferences: $e');
      return false;
    }
  }

  // Create new combination via API
  Future<bool> createCombination() async {
    try {
      isCreatingCombination.value = true;
      CustomToast.showLoading('Creating new combination...');

      final url = AppConstants.CREATE_COMBINATION;

      final payload = {
        "foods": [],
        "time": selectedMealType.value.toLowerCase(),
      };

      print('Creating combination API URL: $url'); // Debug log
      print('Payload: $payload'); // Debug log

      Response response = await authRepo.postDataSet(
        sendData: payload,
        apiName: url,
      );

      print(
          'Create combination response status: ${response.statusCode}'); // Debug log
      print('Create combination response body: ${response.body}'); // Debug log

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess('New combination created successfully');
        // Refresh preferences to get updated data
        await getPreferences();
        return true;
      } else {
        CustomToast.showError('Failed to create new combination');
        return false;
      }
    } catch (e) {
      print('Exception in createCombination: $e'); // Debug log
      CustomToast.showError('Error creating combination: $e');
      return false;
    } finally {
      isCreatingCombination.value = false;
    }
  }

  // Clear temporary foods list
  void clearTempFoods() {
    tempFoodsList.clear();
    selectedFoodName.value = '';
    selectedFoodQuantity.value = '';
  }

  // Add food to temporary list
  void addFoodToTempList() {
    if (selectedFoodName.value.isNotEmpty &&
        selectedFoodQuantity.value.isNotEmpty) {
      // Find the selected recipe to get Recipe_weight
      final selectedRecipe = recipeList.firstWhereOrNull(
        (recipe) => recipe.recipeName == selectedFoodName.value,
      );

      tempFoodsList.add({
        "Food_Name": selectedFoodName.value,
        "Food_Qty": double.tryParse(selectedFoodQuantity.value) ?? 0.0,
        "Time": selectedMealType.value.toLowerCase(),
        "Description": selectedRecipe?.recipeDescription.isNotEmpty == true
            ? selectedRecipe!.recipeDescription
            : selectedFoodName.value,
        "Recipe_weight": selectedRecipe?.recipeWeightG ?? 0.0,
      });

      // Clear form fields
      selectedFoodName.value = '';
      selectedFoodQuantity.value = '';

      CustomToast.showSuccess('Food added to combination');
    } else {
      CustomToast.showWarning('Please fill all fields');
    }
  }

  // Remove food from temporary list
  void removeFoodFromTempList(int index) {
    if (index >= 0 && index < tempFoodsList.length) {
      tempFoodsList.removeAt(index);
      CustomToast.showSuccess('Food removed from combination');
    }
  }

  // Save combination with foods
  Future<bool> saveCombination() async {
    try {
      if (tempFoodsList.isEmpty) {
        CustomToast.showWarning('Please add at least one food item');
        return false;
      }

      isCreatingCombination.value = true;
      CustomToast.showLoading('Saving combination...');

      final url = AppConstants.CREATE_COMBINATION;

      final payload = {
        "foods": tempFoodsList.toList(),
        "time": selectedMealType.value.toLowerCase(),
      };

      print('Saving combination API URL: $url'); // Debug log
      print('Payload: $payload'); // Debug log

      Response response = await authRepo.postDataSet(
        sendData: payload,
        apiName: url,
      );

      print(
          'Save combination response status: ${response.statusCode}'); // Debug log
      print('Save combination response body: ${response.body}'); // Debug log

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess('Combination saved successfully');
        // Clear temporary data
        clearTempFoods();
        // Refresh preferences to get updated data
        await getPreferences();
        // Small delay to ensure UI updates complete
        await Future.delayed(const Duration(milliseconds: 500));
        print('Returning true from saveCombination'); // Debug
        isCreatingCombination.value = false;
        return true;
      } else {
        CustomToast.showError('Failed to save combination');
        isCreatingCombination.value = false;
        return false;
      }
    } catch (e) {
      print('Exception in saveCombination: $e'); // Debug log
      CustomToast.showError('Error saving combination: $e');
      isCreatingCombination.value = false;
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
