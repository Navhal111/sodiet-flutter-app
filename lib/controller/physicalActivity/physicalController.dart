import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/appConstant.dart';
import '../../helper/response_model.dart';
import '../../model/pa_recall_model.dart';
import '../../repo/authRepo.dart';

class PhysicalActivityController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  PhysicalActivityController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;
  RxBool isLoadingList = false.obs;

  // Observable variables to store PA recall data
  Rx<PaRecallModel?> paRecallData = Rx<PaRecallModel?>(null);
  RxList<PaRecallItem> paRecallList = <PaRecallItem>[].obs;
  RxInt totalCount = 0.obs;
  RxInt currentPage = 1.obs;
  RxInt pageSize = 10.obs;

  getPaRecallList() async {
    isLoadingList.value = true;
    try {
      Response response =
          await authRepo.getDataSet(apiName: AppConstants.GET_PA_RECALL);
      ResponseModel responseModel;
      Map<String, dynamic> responcejson = response.body;

      if (response.statusCode == 200) {
        // Parse the response using the model
        paRecallData.value = PaRecallModel.fromJson(responcejson);

        // Store data in observable variables
        paRecallList.value = paRecallData.value?.recalls ?? [];
        totalCount.value = paRecallData.value?.totalCount ?? 0;
        currentPage.value = paRecallData.value?.page ?? 1;
        pageSize.value = paRecallData.value?.pageSize ?? 10;

        // Handle success
        print(
            'PA Recall data loaded successfully: ${paRecallList.length} items');
      } else {
        // Handle error
        print('Error loading PA recall data: ${response.statusCode}');
        paRecallList.clear();
        totalCount.value = 0;
      }
    } catch (e) {
      print('Exception in getPaRecallList: $e');
      paRecallList.clear();
      totalCount.value = 0;
    } finally {
      isLoadingList.value = false;
    }
  }

  addPaRecall(Map<String, dynamic> activityData) async {
    isLoading.value = true;
    try {
      Response response = await authRepo.postDataSet(
        sendData: activityData,
        apiName: AppConstants.GET_PA_RECALL,
      );

      Map<String, dynamic> responcejson = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Activity added successfully');
        // Refresh the list after successful addition
        await getPaRecallList();

        Get.snackbar(
          'Success',
          'Physical activity added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
        );
      } else {
        print('Error adding activity: ${response.statusCode}');
        print('Response: $responcejson');

        Get.snackbar(
          'Error',
          'Failed to add activity. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF44336),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Exception in addPaRecall: $e');

      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
