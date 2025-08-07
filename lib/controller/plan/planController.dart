import 'package:get/get.dart';

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

  // Observable variables to store active plan data
  RxString planId = ''.obs;
  RxBool isActive = false.obs;

  // Observable variables to store plan details data
  Rx<PlanDetailsResponse?> planDetailsResponse = Rx<PlanDetailsResponse?>(null);
  RxList<PlanData> planDataList = <PlanData>[].obs;

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

  // Method to get active plan details (combines both API calls)
  getActivePlanDetails() async {
    final activePlanResult = await getActivePlan();
    if (activePlanResult['success'] && planId.value.isNotEmpty) {
      return await getPlanDetails(planId.value);
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

  // Method to clear plan data
  void clearPlanData() {
    activePlanResponse = null;
    planId.value = '';
    isActive.value = false;
    planDetailsResponse.value = null;
    planDataList.clear();
    update();
  }
}
