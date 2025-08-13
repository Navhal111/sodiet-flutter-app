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

  // API response data
  var apiCombinations = <PreferenceCombination>[].obs;
  var totalPreferences = 0.obs;
  var totalCombinations = 0.obs;
  var apiMessage = ''.obs;

  // Recipe data
  var recipeList = <Recipe>[].obs;

  // User combination data for each combination
  var userCombinationsByIndex = <int, RxList<Map<String, String>>>{}.obs;

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

        CustomToast.showSuccess('Preferences loaded successfully');
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

      Response response =
          await authRepo.getDataSet(apiName: AppConstants.GET_RECIPES);

      print(
          'Recipes response status code: ${response.statusCode}'); // Debug log
      print('Recipes response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final recipeResponse = RecipeResponse.fromJson(response.body);
        recipeList.value = recipeResponse.recipes;

        print('Loaded ${recipeList.length} recipes'); // Debug log
        CustomToast.showSuccess('Recipes loaded successfully');
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

  @override
  void onClose() {
    super.onClose();
  }
}
