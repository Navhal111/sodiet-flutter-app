import 'package:get/get.dart';

import '../../constant/appConstant.dart';
import '../../model/plan_model.dart';
import '../../repo/authRepo.dart';

class HomeController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  HomeController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;

  // Observable variables to store dashboard summary data
  RxBool isLoadingDashboardSummary = false.obs;
  Rx<DashboardSummaryResponse?> dashboardSummaryResponse =
      Rx<DashboardSummaryResponse?>(null);

  // Observable variables to store nutrient weekly summary data
  RxBool isLoadingNutrientWeeklySummary = false.obs;
  Rx<NutrientWeeklySummaryResponse?> nutrientWeeklySummaryResponse =
      Rx<NutrientWeeklySummaryResponse?>(null);

  getDashboardSummary() async {
    isLoadingDashboardSummary.value = true;
    try {
      Response response = await authRepo.getDataSet(
          apiName: AppConstants.GET_DASHBOARD_SUMMARY);
      print("Dashboard Summary API Response Status: ${response.statusCode}");
      print("Dashboard Summary API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        dashboardSummaryResponse.value =
            DashboardSummaryResponse.fromJson(response.body);

        print('Dashboard Summary loaded successfully');
        return {
          'success': true,
          'message': 'Dashboard summary loaded successfully!'
        };
      } else {
        print('Error loading dashboard summary: ${response.statusCode}');
        dashboardSummaryResponse.value = null;
        return {
          'success': false,
          'message': 'Failed to load dashboard summary'
        };
      }
    } catch (e) {
      print('Exception in getDashboardSummary: $e');
      dashboardSummaryResponse.value = null;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    } finally {
      isLoadingDashboardSummary.value = false;
      update();
    }
  }

  getNutrientWeeklySummary() async {
    isLoadingNutrientWeeklySummary.value = true;
    try {
      Response response = await authRepo.getDataSet(
          apiName: AppConstants.GET_NUTRIENT_WEEKLY_SUMMARY);
      print(
          "Nutrient Weekly Summary API Response Status: ${response.statusCode}");
      print("Nutrient Weekly Summary API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        nutrientWeeklySummaryResponse.value =
            NutrientWeeklySummaryResponse.fromJson(response.body);

        print(
            'Nutrient Weekly Summary loaded successfully: ${nutrientWeeklySummaryResponse.value?.weeklyNutrientSummary.length} items');
        return {
          'success': true,
          'message': 'Nutrient weekly summary loaded successfully!'
        };
      } else {
        print('Error loading nutrient weekly summary: ${response.statusCode}');
        nutrientWeeklySummaryResponse.value = null;
        return {
          'success': false,
          'message': 'Failed to load nutrient weekly summary'
        };
      }
    } catch (e) {
      print('Exception in getNutrientWeeklySummary: $e');
      nutrientWeeklySummaryResponse.value = null;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    } finally {
      isLoadingNutrientWeeklySummary.value = false;
      update();
    }
  }

  // Dashboard Summary Helper Methods
  bool get hasDashboardSummary => dashboardSummaryResponse.value != null;

  KpiData? get dashboardKpi => dashboardSummaryResponse.value?.kpi;

  SummaryData? get dashboardSummaryData =>
      dashboardSummaryResponse.value?.summaryData;

  List<DailyData> get dailyDataList =>
      dashboardSummaryResponse.value?.summaryData.dailyData ?? [];

  LegacyFormat? get legacyFormat =>
      dashboardSummaryResponse.value?.summaryData.legacyFormat;

  // Nutrient Weekly Summary Helper Methods
  bool get hasNutrientWeeklySummary =>
      nutrientWeeklySummaryResponse.value != null;

  List<WeeklyNutrientData> get weeklyNutrientDataList =>
      nutrientWeeklySummaryResponse.value?.weeklyNutrientSummary ?? [];

  // Method to get nutrients for a specific week
  List<WeeklyNutrientData> getNutrientsForWeek(int weekNumber) {
    return weeklyNutrientDataList
        .where((data) => data.weekNumber == weekNumber)
        .toList();
  }

  // Method to get all available weeks
  List<int> get availableWeeks {
    return weeklyNutrientDataList
        .map((data) => data.weekNumber)
        .toSet()
        .toList()
      ..sort();
  }

  // Method to get a specific nutrient data across all weeks
  List<WeeklyNutrientData> getNutrientAcrossWeeks(String nutrientName) {
    return weeklyNutrientDataList
        .where((data) => data.nutrient == nutrientName)
        .toList();
  }

  // Method to refresh dashboard summary
  void refreshDashboardSummary() {
    getDashboardSummary();
  }

  // Method to refresh nutrient weekly summary
  void refreshNutrientWeeklySummary() {
    getNutrientWeeklySummary();
  }

  // Method to refresh all data
  void refreshAllData() {
    getDashboardSummary();
    getNutrientWeeklySummary();
  }

  // Method to clear dashboard data
  void clearDashboardData() {
    dashboardSummaryResponse.value = null;
    nutrientWeeklySummaryResponse.value = null;
    update();
  }
}
