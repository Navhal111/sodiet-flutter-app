import 'package:get/get.dart';
import 'package:sodiet/route/app_routes.dart';

import '../../constant/appConstant.dart';
import '../../model/plan_model.dart';
import '../../model/weight_data.dart';
import '../../repo/authRepo.dart';

class PlanController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  PlanController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;
  RxBool isLoadingActivePlan = false.obs;
  RxBool isLoadingPlanDetails = false.obs;
  RxBool isGeneratingPlan = false.obs;

  // Observable variables to store active plan data
  RxString planId = ''.obs;
  RxBool isActive = false.obs;

  // Observable variables for form fields to prevent UI rebuilding
  RxString selectedSex = ''.obs;
  RxString selectedPlan = ''.obs;

  // Method to clear form fields
  void clearFormFields() {
    selectedSex.value = '';
    selectedPlan.value = '';
  }

  // Observable variables to store plan details data
  Rx<PlanDetailsResponse?> planDetailsResponse = Rx<PlanDetailsResponse?>(null);
  RxList<PlanData> planDataList = <PlanData>[].obs;

  // Observable variables to store dashboard summary data
  RxBool isLoadingDashboardSummary = false.obs;
  Rx<DashboardSummaryResponse?> dashboardSummaryResponse =
      Rx<DashboardSummaryResponse?>(null);

  // Observable variables to store activity overview data
  RxBool isLoadingActivityOverview = false.obs;
  Rx<ActivityOverviewResponse?> activityOverviewResponse =
      Rx<ActivityOverviewResponse?>(null);

  // Raw response storage
  Map<String, dynamic>? activePlanResponse;

  getActivePlan() async {
    isLoadingActivePlan.value = true;
    try {
      Response response =
          await authRepo.getDataSet(apiName: AppConstants.GET_PLAN_ACTIVE);
      print("Active Plan API Response Status: ${response.statusCode}");
      print("Active Plan API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        activePlanResponse = response.body;

        // Store data in observable variables
        planId.value = activePlanResponse?['plan_id']?.toString() ?? '';
        isActive.value = activePlanResponse?['is_active'] ?? false;

        print(
            'Active Plan loaded successfully: Plan ID: ${planId.value}, Is Active: ${isActive.value}');
        return {'success': true, 'message': 'Active plan loaded successfully!'};
      } else {
        print('Error loading active plan: ${response.statusCode}');
        activePlanResponse = null;
        planId.value = '';
        isActive.value = false;
        return {'success': false, 'message': 'Failed to load active plan'};
      }
    } catch (e) {
      print('Exception in getActivePlan: $e');
      activePlanResponse = null;
      planId.value = '';
      isActive.value = false;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    } finally {
      isLoadingActivePlan.value = false;
      update();
    }
  }

  getPlanDetails(String planId) async {
    isLoadingPlanDetails.value = true;
    try {
      String apiUrl = "${AppConstants.GET_PLAN_DETAILS}/$planId";
      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("Plan Details API Response Status: ${response.statusCode}");
      print("Plan Details API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        planDetailsResponse.value = PlanDetailsResponse.fromJson(response.body);

        // Store plan data list in observable variable
        planDataList.clear();
        planDataList.addAll(planDetailsResponse.value?.planData ?? []);

        print(
            'Plan Details loaded successfully: ${planDataList.length} plan data items');
        return {
          'success': true,
          'message': 'Plan details loaded successfully!'
        };
      } else {
        print('Error loading plan details: ${response.statusCode}');
        planDetailsResponse.value = null;
        planDataList.clear();
        return {'success': false, 'message': 'Failed to load plan details'};
      }
    } catch (e) {
      print('Exception in getPlanDetails: $e');
      planDetailsResponse.value = null;
      planDataList.clear();
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    } finally {
      isLoadingPlanDetails.value = false;
      update();
    }
  }

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

  deletePlan(String planId) async {
    isLoading.value = true;
    try {
      Response response = await authRepo.deleteDataSet(
          apiName: "${AppConstants.DELETE_PLAN_ACTIVE}/$planId");
      print("Delete Plan API Response Status: ${response.statusCode}");
      print("Delete Plan API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print('Plan deleted successfully: ${response.body['message']}');
        Get.offNamed(AppRoutes.generatePlanScreen);

        return {
          'success': true,
          'message': response.body['message'] ?? 'Plan deleted successfully!',
          'planId': response.body['plan_id']?.toString() ?? planId,
          'status': response.body['status'] ?? 'DEACTIVATED'
        };
      } else {
        print('Error deleting plan: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to delete plan',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      print('Exception in deletePlan: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Method to get active plan details (combines both API calls)
  getActivePlanDetails() async {
    final activePlanResult = await getActivePlan();
    if (activePlanResult['success'] && planId.value.isNotEmpty) {
      await getDashboardSummary();
      await getActivityOverview();
      return await getPlanDetails(planId.value);
    } else {
      Get.offNamed(AppRoutes.generatePlanScreen);
    }
    return activePlanResult;
  }

  // Method to refresh active plan data
  void refreshActivePlan() {
    getActivePlan();
  }

  // Method to refresh plan details
  void refreshPlanDetails() {
    if (planId.value.isNotEmpty) {
      getPlanDetails(planId.value);
    }
  }

  // Method to check if plan is active
  bool get hasActivePlan => planId.value.isNotEmpty && isActive.value;

  // Method to get plan ID as string
  String get activePlanId => planId.value;

  // Method to get current plan data (first item if available)
  PlanData? get currentPlanData =>
      planDataList.isNotEmpty ? planDataList.first : null;

  // Method to get user's full name
  String get userFullName => currentPlanData?.fullName ?? '';

  // Method to get user's BMI
  double get userBMI => currentPlanData?.bmi ?? 0.0;

  // Method to get weight to lose
  double get weightToLose => currentPlanData?.weightToLose ?? 0.0;

  // Method to check if plan details are loaded
  bool get hasPlanDetails => planDataList.isNotEmpty;

  // Dashboard Summary Helper Methods
  bool get hasDashboardSummary => dashboardSummaryResponse.value != null;

  KpiData? get dashboardKpi => dashboardSummaryResponse.value?.kpi;

  SummaryData? get dashboardSummaryData =>
      dashboardSummaryResponse.value?.summaryData;

  List<DailyData> get dailyDataList =>
      dashboardSummaryResponse.value?.summaryData.dailyData ?? [];

  LegacyFormat? get legacyFormat =>
      dashboardSummaryResponse.value?.summaryData.legacyFormat;

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

  // Method to refresh dashboard summary
  void refreshDashboardSummary() {
    getDashboardSummary();
  }

  // Method to clear plan data
  void clearPlanData() {
    activePlanResponse = null;
    planId.value = '';
    isActive.value = false;
    planDetailsResponse.value = null;
    planDataList.clear();
    dashboardSummaryResponse.value = null;
    activityOverviewResponse.value = null;
    update();
  }

  // Method to generate a new plan
  generatePlan({
    required int age,
    required String sex,
    required double height,
    required double weight,
    required double targetWeight,
    required int duration,
    required String startDate,
  }) async {
    isGeneratingPlan.value = true;
    try {
      // Prepare the payload according to the API specification
      Map<String, dynamic> payload = {
        "username": "Testlogin",
        "bwp_form_data": {
          "age": age,
          "sex": sex,
          "height": height,
          "weight": weight,
          "target_weight": targetWeight,
          "duration": duration,
          "start_date": startDate,
          "sleep": 0,
          "school": 0,
          "WSA": 0,
          "PALText": "string",
          "DeltaPALText": ""
        }
      };

      print("Generate Plan API Payload: $payload");

      Response response = await authRepo.postDataSet(
        apiName: AppConstants.GENERATE_PLAN,
        sendData: payload,
      );

      print("Generate Plan API Response Status: ${response.statusCode}");
      print("Generate Plan API Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Plan generated successfully: ${response.body}');

        // Refresh active plan data after successful generation
        await getActivePlan();

        return {
          'success': true,
          'message': response.body['message'] ?? 'Plan generated successfully!',
          'data': response.body
        };
      } else {
        print('Error generating plan: ${response.statusCode}');
        return {
          'success': false,
          'message': response.body['message'] ?? 'Failed to generate plan',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      print('Exception in generatePlan: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    } finally {
      isGeneratingPlan.value = false;
      update();
    }
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

    if (weightValues.isEmpty) {
      return {
        'minIntake': minIntake,
        'maxIntake': maxIntake,
        'minWeight': 70.0,
        'maxWeight': 80.0,
      };
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
