import 'package:get/get.dart';
import 'package:sodiet/route/app_routes.dart';

import '../../constant/appConstant.dart';
import '../../model/plan_model.dart';
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

  // Observable variables to store plan details data
  Rx<PlanDetailsResponse?> planDetailsResponse = Rx<PlanDetailsResponse?>(null);
  RxList<PlanData> planDataList = <PlanData>[].obs;

  // Observable variables to store dashboard summary data
  RxBool isLoadingDashboardSummary = false.obs;
  Rx<DashboardSummaryResponse?> dashboardSummaryResponse =
      Rx<DashboardSummaryResponse?>(null);

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
}
