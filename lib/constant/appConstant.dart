// ignore_for_file: constant_identifier_names

class AppConstants {
  static const String APP_NAME = 'SoDiet App';
  static const String somethingWentWrong = 'something Went Wrong';

  // API DOMAIN LINK
  // static const String DOMAIN = 'https://datatools.sjri.res.in';
  static const String DOMAIN = 'http://49.204.74.61';
  static const String BASE_URL = '${DOMAIN}/SD/api/v1/';
  static const String BASE_URL_IMAGE = '${DOMAIN}/static/VD/food_images_large/';

  // API ENDPOINTS
  static const String GET_DIET_RECALES = '${BASE_URL}log/diet-recall';
  static const String GET_PA_RECALL = '${BASE_URL}log/pa-recall';
  static const String GET_RECIPES = '${BASE_URL}recipes';
  static const String GET_RECIPES_SEARCH = '${BASE_URL}recipes/search';
  static const String GET_FOOD_CATEGORIES =
      '${BASE_URL}recipes/food-categories';

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
  static const String GET_PLAN_DETAILS = '${BASE_URL}bwp/plan-details';
  static const String GET_DASHBOARD_SUMMARY = '${BASE_URL}dashboard/summary';
  static const String GET_NUTRIENT_WEEKLY_SUMMARY =
      '${BASE_URL}dashboard/nutrient-weekly-summary';

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
