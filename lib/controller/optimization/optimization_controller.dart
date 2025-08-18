import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/model/recipe_model.dart';
import 'package:sodiet/model/menu_interaction_model.dart';
import 'package:sodiet/repo/authRepo.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';

class OptimizationController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  OptimizationController({
    required this.authRepo,
  });

  // Observable variables
  var isLoading = false.obs;
  var weekPlanData = <WeekPlanData>[].obs;
  var totalRecords = 0.obs;

  // Weekly menu data variables
  var isMenuLoading = false.obs;
  var weeklyMenuList = <Map<String, dynamic>>[].obs;
  var currentWeekNo = 1.obs;

  // Recipe data variables
  var isLoadingRecipes = false.obs;
  var recipeList = <Recipe>[].obs;

  // Menu interactions data variables
  var isLoadingMenuInteractions = false.obs;
  var menuInteractionsList = <MenuInteraction>[].obs;
  var totalMenuInteractionsRecords = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getWeekPlanMaster();
    getRecipes(); // Load recipes on initialization
  }

  // Get week plan master data
  Future<void> getWeekPlanMaster() async {
    try {
      isLoading.value = true;

      final url = AppConstants.WEEK_PLAN_MASTER;

      Response response = await authRepo.getDataSet(
        apiName: url,
      );

      print('Week plan master response status: ${response.statusCode}');
      print('Week plan master response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = response.body['week_plan_data'] as List;
        totalRecords.value = response.body['total_records'] ?? 0;

        // Parse week plan data
        weekPlanData.value =
            data.map((item) => WeekPlanData.fromJson(item)).toList();

        print('Parsed ${weekPlanData.length} week plan records');
      } else {
        final errorMessage =
            response.body['message'] ?? 'Failed to fetch week plan data';
        CustomToast.showError(errorMessage);
      }
    } catch (e) {
      print('Exception in getWeekPlanMaster: $e');
      CustomToast.showError('Error fetching week plan data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await getWeekPlanMaster();
  }

  // Get weekly menu data for specific week
  Future<void> getWeeklyMenu(int weekNo) async {
    try {
      isMenuLoading.value = true;
      currentWeekNo.value = weekNo;

      final url = AppConstants.WEEKLY_MENU;

      final payload = {
        "week_no": weekNo,
      };

      Response response = await authRepo.postDataSet(
        apiName: url,
        sendData: payload,
      );

      print('Weekly menu response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Weekly menu API response successful');

        if (response.body['weekly_menu'] != null) {
          final data = response.body['weekly_menu'] as List;
          print('Weekly menu data length: ${data.length}');

          // Simply store the list directly
          weeklyMenuList.value = List<Map<String, dynamic>>.from(data);
          print('Data stored in list, count: ${weeklyMenuList.length}');
        } else {
          print('No weekly_menu key found in response');
          weeklyMenuList.value = [];
        }
      } else {
        final errorMessage =
            response.body['message'] ?? 'Failed to fetch weekly menu';
        CustomToast.showError(errorMessage);
      }
    } catch (e) {
      print('Exception in getWeeklyMenu: $e');
      CustomToast.showError('Error fetching weekly menu: $e');
    } finally {
      isMenuLoading.value = false;
    }
  }

  // Get recipes for meal plan interaction
  Future<void> getRecipes() async {
    print("Starting to fetch recipes...");
    isLoadingRecipes.value = true;
    print("Loading state set to: ${isLoadingRecipes.value}");
    try {
      Response response = await authRepo.getDataSet(
          apiName: "${AppConstants.GET_RECIPES_SEARCH}/?page=1&page_size=100");
      print("Recipe API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.body['recipes'] != null) {
          final data = response.body['recipes'] as List;
          print('Recipe data length: ${data.length}');

          // Convert to Recipe objects
          recipeList.value = data.map((item) => Recipe.fromJson(item)).toList();
          print('Recipes stored in list, count: ${recipeList.length}');
        } else {
          print('No recipes key found in response');
          recipeList.value = [];
        }
      } else {
        print("API Error: ${response.statusCode}");
        final errorMessage =
            response.body['message'] ?? 'Failed to fetch recipes';
        CustomToast.showError(errorMessage);
        recipeList.clear();
      }
    } catch (e) {
      print("Exception in getRecipes: $e");
      CustomToast.showError('Error fetching recipes: $e');
      recipeList.clear();
    }

    isLoadingRecipes.value = false;
    print(
        "Finished fetching recipes. Loading state: ${isLoadingRecipes.value}");
  }

  // Get menu interactions draft
  Future<void> getMenuInteractionsDraft() async {
    print("Starting to fetch menu interactions draft...");
    isLoadingMenuInteractions.value = true;
    print("Loading state set to: ${isLoadingMenuInteractions.value}");

    try {
      final url = AppConstants.MENU_INTERACTIONS_DRAFT;

      Response response = await authRepo.getDataSet(
        apiName: url,
      );

      print('Menu interactions draft response status: ${response.statusCode}');
      print('Menu interactions draft response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body['menu_interactions'] != null) {
          final data = response.body['menu_interactions'] as List;
          totalMenuInteractionsRecords.value =
              response.body['total_records'] ?? 0;

          print('Menu interactions data length: ${data.length}');

          // Convert to MenuInteraction objects
          menuInteractionsList.value =
              data.map((item) => MenuInteraction.fromJson(item)).toList();
          print(
              'Menu interactions stored in list, count: ${menuInteractionsList.length}');
        } else {
          print('No menu_interactions key found in response');
          menuInteractionsList.value = [];
          totalMenuInteractionsRecords.value = 0;
        }
      } else {
        final errorMessage = response.body['message'] ??
            'Failed to fetch menu interactions draft';
        CustomToast.showError(errorMessage);
        menuInteractionsList.clear();
        totalMenuInteractionsRecords.value = 0;
      }
    } catch (e) {
      print('Exception in getMenuInteractionsDraft: $e');
      CustomToast.showError('Error fetching menu interactions draft: $e');
      menuInteractionsList.clear();
      totalMenuInteractionsRecords.value = 0;
    } finally {
      isLoadingMenuInteractions.value = false;
      print(
          "Finished fetching menu interactions draft. Loading state: ${isLoadingMenuInteractions.value}");
    }
  }

  // Get unique days from the menu list
  List<String> get availableDays {
    final days =
        weeklyMenuList.map((item) => item['Day'].toString()).toSet().toList();
    const dayOrder = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    return dayOrder.where((day) => days.contains(day)).toList();
  }

  // Get menu items for a specific day
  List<Map<String, dynamic>> getMenuForDay(String day) {
    return weeklyMenuList
        .where((item) => item['Day'].toString() == day)
        .toList();
  }

  // Helper methods for menu interactions

  // Get menu interactions for a specific week
  List<MenuInteraction> getMenuInteractionsForWeek(int weekNo) {
    return menuInteractionsList
        .where((interaction) => interaction.isForWeek(weekNo))
        .toList();
  }

  // Get menu interactions for a specific day
  List<MenuInteraction> getMenuInteractionsForDay(String day) {
    return menuInteractionsList
        .where((interaction) => interaction.isForDay(day))
        .toList();
  }

  // Get menu interactions for a specific day and timing
  List<MenuInteraction> getMenuInteractionsForDayAndTiming(
      String day, String timing) {
    return menuInteractionsList
        .where((interaction) =>
            interaction.isForDay(day) && interaction.isForTiming(timing))
        .toList();
  }

  // Get ADD interactions for a specific day
  List<MenuInteraction> getAddInteractionsForDay(String day) {
    return menuInteractionsList
        .where((interaction) =>
            interaction.isForDay(day) && interaction.isAddInteraction)
        .toList();
  }

  // Get REMOVE interactions for a specific day
  List<MenuInteraction> getRemoveInteractionsForDay(String day) {
    return menuInteractionsList
        .where((interaction) =>
            interaction.isForDay(day) && interaction.isRemoveInteraction)
        .toList();
  }

  // Check if a recipe is added for a specific day and timing
  bool isRecipeAddedForDayAndTiming(
      String recipeCode, String day, String timing) {
    return menuInteractionsList.any((interaction) =>
        interaction.recipeCode == recipeCode &&
        interaction.isForDay(day) &&
        interaction.isForTiming(timing) &&
        interaction.isAddInteraction);
  }

  // Get all recipe codes that are added for a specific day
  List<String> getAddedRecipeCodesForDay(String day) {
    return menuInteractionsList
        .where((interaction) =>
            interaction.isForDay(day) && interaction.isAddInteraction)
        .map((interaction) => interaction.recipeCode)
        .toSet() // Remove duplicates
        .toList();
  }

  // Add menu interaction
  Future<Map<String, dynamic>> addMenuInteraction({
    required int weekNo,
    required String recipeCode,
    required String day,
    required String timings,
  }) async {
    try {
      final url = AppConstants.MENU_INTERACTIONS_DRAFT;

      final payload = {
        "Week_No": weekNo,
        "Recipe_Code": recipeCode,
        "Day": day,
        "Timings": timings,
        "Status": "ADD"
      };

      print('Add menu interaction payload: $payload');

      Response response = await authRepo.postDataSet(
        apiName: url,
        sendData: payload,
      );

      print('Add menu interaction response status: ${response.statusCode}');
      print('Add menu interaction response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess('Recipe added to meal plan successfully');

        // Refresh the weekly menu to get updated data
        await getWeeklyMenu(weekNo);

        // Refresh the menu interactions to get updated data
        await getMenuInteractionsDraft();

        return {
          'success': true,
          'message': 'Recipe added to meal plan successfully'
        };
      } else {
        final errorMessage =
            response.body['message'] ?? 'Failed to add recipe to meal plan';
        CustomToast.showError(errorMessage);
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Exception in addMenuInteraction: $e');
      CustomToast.showError('Error adding recipe to meal plan: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    }
  }

  // Remove menu interaction
  Future<Map<String, dynamic>> removeMenuInteraction({
    required int weekNo,
    required String recipeCode,
    required String day,
    required String timings,
  }) async {
    try {
      final url = AppConstants.MENU_INTERACTIONS_DRAFT;

      final payload = {
        "Week_No": weekNo,
        "Recipe_Code": recipeCode,
        "Day": day,
        "Timings": timings,
        "Status": "REMOVE"
      };

      print('Remove menu interaction payload: $payload');

      Response response = await authRepo.postDataSet(
        apiName: url,
        sendData: payload,
      );

      print('Remove menu interaction response status: ${response.statusCode}');
      print('Remove menu interaction response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Don't show toast here, let the UI handle it
        print('Recipe removed from meal plan successfully');

        // Refresh the weekly menu to get updated data
        await getWeeklyMenu(weekNo);

        // Refresh the menu interactions to get updated data
        await getMenuInteractionsDraft();

        return {
          'success': true,
          'message': 'Recipe removed from meal plan successfully'
        };
      } else {
        final errorMessage = response.body['message'] ??
            'Failed to remove recipe from meal plan';
        print('Error removing recipe from meal plan: $errorMessage');
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Exception in removeMenuInteraction: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    }
  }

  // Submit menu interactions draft
  Future<Map<String, dynamic>> submitMenuInteractionsDraft() async {
    try {
      final url = AppConstants.SUBMIT_MENU_INTERACTIONS;

      // Prepare payload with all current menu interactions
      final payload = {
        "menu_interactions": menuInteractionsList
            .map((interaction) => interaction.toJson())
            .toList(),
      };

      print('Submit menu interactions payload: $payload');

      Response response = await authRepo.postDataSet(
        apiName: url,
        sendData: payload,
      );

      print('Submit menu interactions response status: ${response.statusCode}');
      print('Submit menu interactions response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Don't show toast here, let the UI handle it
        print('Menu changes submitted successfully');

        // Clear the draft after successful submission
        menuInteractionsList.clear();
        totalMenuInteractionsRecords.value = 0;

        // Refresh the weekly menu to get updated data
        if (currentWeekNo.value > 0) {
          await getWeeklyMenu(currentWeekNo.value);
        }

        return {'success': true, 'message': response.body['message']};
      } else {
        final errorMessage =
            response.body['message'] ?? 'Failed to submit menu changes';
        print('Error submitting menu changes: $errorMessage');

        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Exception in submitMenuInteractionsDraft: $e');

      // Return error instead of throwing to ensure UI can handle it properly
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    }
  }

  // Remove draft interactions (DELETE method with no body)
  Future<Map<String, dynamic>> removeDraftInteractions() async {
    try {
      final url = AppConstants.MENU_INTERACTIONS_DRAFT;

      print('Remove draft interactions: DELETE $url');

      Response response = await authRepo.deleteDataSet(
        apiName: url,
      );

      print(
          'Remove draft interactions response status: ${response.statusCode}');
      print('Remove draft interactions response body: ${response.body}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        print('Draft interactions removed successfully');

        // Clear the draft after successful removal
        menuInteractionsList.clear();
        totalMenuInteractionsRecords.value = 0;

        // Refresh the weekly menu to get updated data
        if (currentWeekNo.value > 0) {
          await getWeeklyMenu(currentWeekNo.value);
        }

        return {
          'success': true,
          'message': 'Draft changes removed successfully'
        };
      } else {
        final errorMessage =
            response.body['message'] ?? 'Failed to remove draft changes';
        print('Error removing draft changes: $errorMessage');

        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Exception in removeDraftInteractions: $e');

      // Return error instead of throwing to ensure UI can handle it properly
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    }
  }

  // Get background color based on status
  List<dynamic> getStatusColors(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return [
          const Color(0xFFF5F5F5), // Background color
          const Color(0xFF4C4C4C), // Text color
          [
            const Color(0xFFFFB74D),
            const Color(0xFFFFCC02),
            const Color(0xFFFFF176),
          ], // Action colors
        ];
      case 'running':
      case 'optimal':
      case 'completed':
        return [
          const Color(0xFFE8F5E8), // Background color
          const Color(0xFF2E7D32), // Text color
          [
            const Color(0xFF4CAF50),
            const Color(0xFF81C784),
            const Color(0xFFA5D6A7),
          ], // Action colors
        ];
      case 'error':
      case 'failed':
        return [
          const Color(0xFFFFEBEE), // Background color
          const Color(0xFFE53935), // Text color
          [
            const Color(0xFFE57373),
            const Color(0xFFEF5350),
            const Color(0xFFE53935),
          ], // Action colors
        ];
      case 'na':
      case 'not available':
      case '':
      default:
        return [
          const Color(0xFFF5F5F5), // Default background
          const Color(0xFF4C4C4C), // Default text color
          [
            const Color(0xFFBDBDBD),
            const Color(0xFF9E9E9E),
            const Color(0xFF757575),
          ], // Default action colors
        ];
    }
  }
}

class WeekPlanData {
  final int week;
  final String startDate;
  final String endDate;
  final String optStatus;
  final String optDate;
  final int planId;
  final int pkey;
  final String optEnergyStatus;

  WeekPlanData({
    required this.week,
    required this.startDate,
    required this.endDate,
    required this.optStatus,
    required this.optDate,
    required this.planId,
    required this.pkey,
    required this.optEnergyStatus,
  });

  factory WeekPlanData.fromJson(Map<String, dynamic> json) {
    return WeekPlanData(
      week: json['Week'] ?? 0,
      startDate: json['Start_Date'] ?? '',
      endDate: json['End_Date'] ?? '',
      optStatus: json['OPTStatus'] ?? '',
      optDate: json['OPTDate'] ?? '',
      planId: json['PLAN_ID'] ?? 0,
      pkey: json['Pkey'] ?? 0,
      optEnergyStatus: json['OPTEnergyStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Week': week,
      'Start_Date': startDate,
      'End_Date': endDate,
      'OPTStatus': optStatus,
      'OPTDate': optDate,
      'PLAN_ID': planId,
      'Pkey': pkey,
      'OPTEnergyStatus': optEnergyStatus,
    };
  }

  // Get formatted date range
  String get dateRange {
    if (startDate.isEmpty || endDate.isEmpty) return '';

    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      final startFormatted = '${_getMonthName(start.month)}${start.day}';
      final endFormatted = '${_getMonthName(end.month)}${end.day}';

      return '$startFormatted - $endFormatted';
    } catch (e) {
      return '$startDate - $endDate';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  // Get formatted last run date
  String get lastRunDate {
    if (optDate.isEmpty) return 'Never';

    try {
      final date = DateTime.parse(optDate);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) return 'Today';
      if (difference == 1) return 'Yesterday';
      if (difference < 7) return '$difference days ago';

      return '${_getMonthName(date.month)}${date.day}';
    } catch (e) {
      return optDate;
    }
  }
}
