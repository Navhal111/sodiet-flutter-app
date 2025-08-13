// ignore_for_file: constant_identifier_names

class AppConstants {
  static const String APP_NAME = 'SoDiet App';
  static const String somethingWentWrong = 'something Went Wrong';

  // API DOMAIN LINK
  static const String DOMAIN = 'https://datatools.sjri.res.in';
  // static const String DOMAIN = 'http://49.204.74.61';
  static const String BASE_URL = '${DOMAIN}/SD/api/v1/';
  static const String BASE_URL_IMAGE = '${DOMAIN}/static/VD/food_images_large/';

  // API ENDPOINTS
  static const String GET_DIET_RECALES = '${BASE_URL}log/diet-recall';
  static const String GET_PA_RECALL = '${BASE_URL}log/pa-recall';
  static const String GET_PHYSICAL_ACTIVITIES =
      '${BASE_URL}log/physical-activities';
  static const String GET_RECIPES = '${BASE_URL}recipes';
  static const String GET_RECIPES_SEARCH = '${BASE_URL}recipes/search';
  static const String GET_FOOD_CATEGORIES =
      '${BASE_URL}recipes/food-categories';
  static const String GET_FOOD_SUBCATEGORIES =
      '${BASE_URL}recipes/food-subcategories';
  static const String SUBMIT_RECIPE = '${BASE_URL}recipes/';
  static const String GET_FOOD_GROUPS =
      '${BASE_URL}recipes/ingredients/food-groups';
  static const String SUBMIT_INGREDIENT = '${BASE_URL}recipes/ingredients';

  // Recipe Like/Dislike endpoints
  static String getRecipeLikeUrl(String recipeCode) =>
      '${GET_RECIPES}/$recipeCode/like';
  static String getRecipeDislikeUrl(String recipeCode) =>
      '${GET_RECIPES}/$recipeCode/dislike';

  // Recipe ingredients endpoint
  static String getRecipeIngredientsUrl(String recipeCode) =>
      '${GET_RECIPES}/$recipeCode/ingredients';

  // Recipe nutrition endpoint
  static String getRecipeNutritionUrl(String recipeCode) =>
      '${GET_RECIPES}/$recipeCode/nutrition';

  static const String GET_PLAN_ACTIVE = '${BASE_URL}bwp/active-plan-id';
  static const String DELETE_PLAN_ACTIVE = '${BASE_URL}bwp/plan';
  static const String GET_PLAN_DETAILS = '${BASE_URL}bwp/plan-details';
  static const String GENERATE_PLAN = '${BASE_URL}bwp/generate-plan';
  static const String GET_DASHBOARD_SUMMARY = '${BASE_URL}dashboard/summary';
  static const String GET_NUTRIENT_WEEKLY_SUMMARY =
      '${BASE_URL}dashboard/nutrient-weekly-summary';

  // Weight Log endpoints
  static const String GET_WEIGHT_LOGS = '${BASE_URL}log/weight-log';
  static const String ADD_WEIGHT_LOG = '${BASE_URL}log/weight-log';
  static const String UPDATE_WEIGHT_LOG = '${BASE_URL}log/weight-log';
  static const String DELETE_WEIGHT_LOG = '${BASE_URL}log/weight-log';

  // Fat Log endpoints
  static const String GET_FAT_LOGS = '${BASE_URL}log/bodyfat-log';
  static const String ADD_FAT_LOG = '${BASE_URL}log/bodyfat-log';
  static const String UPDATE_FAT_LOG = '${BASE_URL}log/bodyfat-log';
  static const String DELETE_FAT_LOG = '${BASE_URL}log/bodyfat-log';

  // Contant Save data keys
  static const String INTRO = 'intro';
  static const String TOKEN = 'token';
  static const String THEME = 'theme';
  static const String LANGUAGE_CODE = 'in';

  // Version names for the app
  static const String ANDROID_VERSION = "1.0.0";
  static const String IOS_VERSION = "1.0.0";
  static const String VERSION = "1.0.0";

// Share Prefernce API data
  static const String userData = 'userData';
  static const String SaveAccessKey = 'access_key';
}
