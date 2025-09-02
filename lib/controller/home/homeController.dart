import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/auth/authController.dart';
import 'package:sodiet/route/app_routes.dart';

import '../../constant/appConstant.dart';
import '../../model/plan_model.dart';
import '../../model/weight_data.dart';
import '../../repo/authRepo.dart';
import '../../view/widgets/common/custom_toast.dart';

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

  // Observable variables to store intake overview data
  RxBool isLoadingIntakeOverview = false.obs;
  Rx<IntakeOverviewResponse?> intakeOverviewResponse =
      Rx<IntakeOverviewResponse?>(null);

  // Observable variables to store activity overview data
  RxBool isLoadingActivityOverview = false.obs;
  Rx<ActivityOverviewResponse?> activityOverviewResponse =
      Rx<ActivityOverviewResponse?>(null);

  // Observable variables to store nutrient time series data
  RxBool isLoadingNutrientTimeSeries = false.obs;
  Rx<NutrientTimeSeriesResponse?> nutrientTimeSeriesResponse =
      Rx<NutrientTimeSeriesResponse?>(null);

  // Weight log variables for quick add functionality
  var isSubmittingWeightLog = false.obs;
  final TextEditingController weightLogDateController = TextEditingController();
  final TextEditingController weightLogWeightController =
      TextEditingController();

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
      }
      if (response.statusCode == 401) {
        final authController = Get.find<AuthController>();
        // Use the new context-free logout method
        authController.logoutUser();
      } else {
        print('Error loading dashboard summary: ${response.statusCode}');
        // Get.offNamed(AppRoutes.generatePlanScreen);
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

  getActivityOverview() async {
    isLoadingActivityOverview.value = true;
    try {
      Response response = await authRepo.getDataSet(
          apiName: AppConstants.GET_ACTIVITY_OVERVIEW);
      print("Activity Overview API Response Status: ${response.statusCode}");
      print("Activity Overview API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        activityOverviewResponse.value =
            ActivityOverviewResponse.fromJson(response.body);

        print('Activity Overview loaded successfully');
        return {
          'success': true,
          'message': 'Activity overview loaded successfully!'
        };
      } else {
        print('Error loading activity overview: ${response.statusCode}');
        activityOverviewResponse.value = null;
        return {
          'success': false,
          'message': 'Failed to load activity overview'
        };
      }
    } catch (e) {
      print('Exception in getActivityOverview: $e');
      activityOverviewResponse.value = null;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    } finally {
      isLoadingActivityOverview.value = false;
      update();
    }
  }

  getNutrientTimeSeries() async {
    isLoadingNutrientTimeSeries.value = true;
    try {
      Response response = await authRepo.getDataSet(
          apiName: AppConstants.GET_NUTRIENT_TIME_SERIES);
      print("Nutrient Time Series API Response Status: ${response.statusCode}");
      print("Nutrient Time Series API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        nutrientTimeSeriesResponse.value =
            NutrientTimeSeriesResponse.fromJson(response.body);

        print('Nutrient Time Series loaded successfully');
        return {
          'success': true,
          'message': 'Nutrient time series loaded successfully!'
        };
      } else {
        print('Error loading nutrient time series: ${response.statusCode}');
        nutrientTimeSeriesResponse.value = null;
        return {
          'success': false,
          'message': 'Failed to load nutrient time series'
        };
      }
    } catch (e) {
      print('Exception in getNutrientTimeSeries: $e');
      nutrientTimeSeriesResponse.value = null;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    } finally {
      isLoadingNutrientTimeSeries.value = false;
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

  // Activity Overview Helper Methods
  bool get hasActivityOverview => activityOverviewResponse.value != null;

  ActivityOverviewChart? get activityOverviewChart =>
      activityOverviewResponse.value?.activityOverviewChart;

  List<String> get activityDates =>
      activityOverviewResponse.value?.activityOverviewChart.dates ?? [];

  List<ActivitySeriesData> get activitySeries =>
      activityOverviewResponse.value?.activityOverviewChart.series ?? [];

  // Method to refresh activity overview
  void refreshActivityOverview() {
    getActivityOverview();
  }

  // Nutrient Time Series Helper Methods
  bool get hasNutrientTimeSeries => nutrientTimeSeriesResponse.value != null;

  NutrientTimeSeriesResponse? get nutrientTimeSeriesData =>
      nutrientTimeSeriesResponse.value;

  List<String> get availableNutrients =>
      nutrientTimeSeriesResponse.value?.nutrientTimeSeries.keys.toList() ?? [];

  // Method to refresh nutrient time series
  void refreshNutrientTimeSeries() {
    getNutrientTimeSeries();
  }

  // Weight Log Methods
  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void initializeWeightLogForm() {
    weightLogDateController.text = formatDate(DateTime.now());
    weightLogWeightController.clear();
  }

  Future<void> addWeightLogFromHome() async {
    if (weightLogDateController.text.trim().isEmpty ||
        weightLogWeightController.text.trim().isEmpty) {
      CustomToast.showError('Please fill in all fields');
      return;
    }

    final weight = double.tryParse(weightLogWeightController.text.trim());
    if (weight == null || weight <= 0) {
      CustomToast.showError('Please enter a valid weight');
      return;
    }

    try {
      isSubmittingWeightLog.value = true;

      final data = {
        'log_date': weightLogDateController.text.trim(),
        'weight_kg': weight,
      };

      Response response = await authRepo.postDataSet(
        apiName: AppConstants.ADD_WEIGHT_LOG,
        sendData: data,
      );
      Get.back();
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess('Weight log added successfully');
        weightLogWeightController.clear();
        Get.back(); // Close the dialog first

        // Then refresh dashboard data in background
        Future.delayed(const Duration(milliseconds: 100), () {
          getDashboardSummary();
          // getNutrientWeeklySummary();
          // getIntakeOverview();
          // getActivityOverview();
          // getNutrientTimeSeries();
        });
      } else {
        CustomToast.showError('Failed to add weight log');
      }
    } catch (e) {
      CustomToast.showError('Error adding weight log: $e');
    } finally {
      isSubmittingWeightLog.value = false;
    }
  }

  @override
  void onClose() {
    weightLogDateController.dispose();
    weightLogWeightController.dispose();
    super.onClose();
  }

  // Method to refresh all data
  void refreshAllData() {
    getDashboardSummary();
    getNutrientWeeklySummary();
    getIntakeOverview();
    getActivityOverview();
    getNutrientTimeSeries();
  }

  // Method to clear dashboard data
  void clearDashboardData() {
    dashboardSummaryResponse.value = null;
    nutrientWeeklySummaryResponse.value = null;
    nutrientTimeSeriesResponse.value = null;
    update();
  }

  // Method to convert legacy format data to WeightData list for chart
  List<WeightData> getChartWeightData() {
    if (!hasDashboardSummary || legacyFormat == null) {
      return [];
    }

    final legacy = legacyFormat!;
    final datasets = legacy.dataSets;

    List<WeightData> weightDataList = [];

    // Process each day's data
    for (int i = 0; i < legacy.labels.length; i++) {
      final day = int.tryParse(legacy.labels[i]) ?? (i + 1);

      // Get projected weight (kg)
      double projectedWeightKg = 75.0; // default fallback
      if (i < datasets.projectedWeight.length) {
        projectedWeightKg = datasets.projectedWeight[i];
      }

      // Get logged weight (kg) - use null if not available or invalid
      double? loggedWeightKg;
      if (i < datasets.loggedWeight.length &&
          datasets.loggedWeight[i] != null) {
        final logged = datasets.loggedWeight[i]!;
        // Only use reasonable weight values (30-200 kg range)
        if (logged >= 30 && logged <= 200) {
          loggedWeightKg = logged;
        }
      }

      // Get all the kcal data
      double targetIntakeKcal =
          i < datasets.targetIntake.length ? datasets.targetIntake[i] : 0.0;
      double targetExpenditureKcal = i < datasets.targetExpenditure.length
          ? datasets.targetExpenditure[i]
          : 0.0;
      double actualIntakeKcal =
          i < datasets.actualIntake.length ? datasets.actualIntake[i] : 0.0;
      double actualExpenditureKcal = i < datasets.actualExpenditure.length
          ? datasets.actualExpenditure[i]
          : 0.0;
      double ccIntakeKcal =
          i < datasets.ccIntake.length ? datasets.ccIntake[i] : 0.0;
      double ccExpenditureKcal =
          i < datasets.ccExpenditure.length ? datasets.ccExpenditure[i] : 0.0;

      weightDataList.add(WeightData(
        day: day,
        projectedWeightKg: projectedWeightKg,
        loggedWeightKg: loggedWeightKg,
        targetIntakeKcal: targetIntakeKcal,
        targetExpenditureKcal: targetExpenditureKcal,
        actualIntakeKcal: actualIntakeKcal,
        actualExpenditureKcal: actualExpenditureKcal,
        ccIntakeKcal: ccIntakeKcal,
        ccExpenditureKcal: ccExpenditureKcal,
      ));
    }

    return weightDataList;
  }

  // Method to get chart data ranges
  Map<String, double> getChartDataRanges() {
    final chartData = getChartWeightData();

    if (chartData.isEmpty) {
      return {
        'minIntake': 0.0,
        'maxIntake': 5000.0,
        'minWeight': 70.0,
        'maxWeight': 80.0,
      };
    }

    // Collect all kcal values for range calculation
    List<double> allKcalValues = [];

    for (var data in chartData) {
      allKcalValues.addAll([
        data.targetIntakeKcal,
        data.targetExpenditureKcal,
        data.actualIntakeKcal,
        data.actualExpenditureKcal,
        data.ccIntakeKcal,
        data.ccExpenditureKcal,
      ]);
    }

    // Filter out zero/negative values for better range calculation
    allKcalValues = allKcalValues.where((value) => value > 0).toList();

    double minIntake = allKcalValues.isNotEmpty
        ? allKcalValues.reduce((a, b) => a < b ? a : b)
        : 0.0;
    double maxIntake = allKcalValues.isNotEmpty
        ? allKcalValues.reduce((a, b) => a > b ? a : b)
        : 5000.0;

    // Add some padding to the intake range (10%)
    final intakeRange = maxIntake - minIntake;
    minIntake = (minIntake - intakeRange * 0.1).clamp(0.0, double.infinity);
    maxIntake = maxIntake + intakeRange * 0.1;

    // Get weight range (projected and logged weights)
    List<double> weightValues =
        chartData.map((data) => data.projectedWeightKg).toList();

    // Add logged weight values if they exist
    for (var data in chartData) {
      if (data.loggedWeightKg != null) {
        weightValues.add(data.loggedWeightKg!);
      }
    }

    double minWeight = weightValues.reduce((a, b) => a < b ? a : b);
    double maxWeight = weightValues.reduce((a, b) => a > b ? a : b);

    // Ensure minimum range of 10kg for meaningful display
    final weightRange = (maxWeight - minWeight).clamp(10.0, double.infinity);
    final center = (minWeight + maxWeight) / 2;

    // Create a nice rounded range
    minWeight = (center - weightRange / 2);
    maxWeight = (center + weightRange / 2);

    // Round to nearest 5kg for cleaner display
    minWeight = (minWeight / 5).floor() * 5.0;
    maxWeight = (maxWeight / 5).ceil() * 5.0;

    return {
      'minIntake': minIntake,
      'maxIntake': maxIntake,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
    };
  }
}
