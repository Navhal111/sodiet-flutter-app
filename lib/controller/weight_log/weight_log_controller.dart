import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/model/weight_log.dart';
import 'package:sodiet/repo/authRepo.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';

class WeightLogController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  WeightLogController({
    required this.authRepo,
  });

  // Observable variables
  var weightLogs = <WeightLog>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isSubmitting = false.obs;
  var currentPage = 1.obs;
  var totalCount = 0.obs;
  var pageSize = 10.obs;
  var hasMoreData = true.obs;

  // Controllers for form
  final TextEditingController dateController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  // Edit mode variables
  var isEditing = false.obs;
  var editingLogId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getWeightLogs();
    // Set today's date as default
    dateController.text = formatDate(DateTime.now());
  }

  @override
  void onClose() {
    dateController.dispose();
    weightController.dispose();
    super.onClose();
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String formatDisplayDate(String apiDate) {
    try {
      final date = DateTime.parse(apiDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return apiDate;
    }
  }

  Future<void> getWeightLogs({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
        weightLogs.clear();
      }

      if (!hasMoreData.value && !isRefresh) return;

      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final url =
          '${AppConstants.GET_WEIGHT_LOGS}?page=${currentPage.value}&page_size=${pageSize.value}';

      Response response = await authRepo.getDataSet(apiName: url);

      if (response.statusCode == 200) {
        final weightLogResponse = WeightLogResponse.fromJson(response.body);

        totalCount.value = weightLogResponse.totalCount;

        if (isRefresh || currentPage.value == 1) {
          weightLogs.value = weightLogResponse.logs;
        } else {
          weightLogs.addAll(weightLogResponse.logs);
        }

        // Check if there's more data
        hasMoreData.value = weightLogs.length < totalCount.value;

        if (weightLogResponse.logs.isNotEmpty) {
          currentPage.value++;
        }
      } else {
        CustomToast.showError('Failed to load weight logs');
      }
    } catch (e) {
      CustomToast.showError('Error loading weight logs: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> addWeightLog() async {
    if (dateController.text.trim().isEmpty ||
        weightController.text.trim().isEmpty) {
      CustomToast.showError('Please fill in all fields');
      return;
    }

    final weight = double.tryParse(weightController.text.trim());
    if (weight == null || weight <= 0) {
      CustomToast.showError('Please enter a valid weight');
      return;
    }

    try {
      isSubmitting.value = true;

      final data = {
        'log_date': dateController.text.trim(),
        'weight_kg': weight,
      };

      Response response = await authRepo.postDataSet(
        apiName: AppConstants.ADD_WEIGHT_LOG,
        sendData: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess('Weight log added successfully');

        // Clear weight field but keep the date for easy re-entry
        weightController.clear();

        // Refresh the list
        await getWeightLogs(isRefresh: true);

        // Return true to indicate successful submission
        return;
      } else {
        CustomToast.showError('Failed to add weight log');
      }
    } catch (e) {
      CustomToast.showError('Error adding weight log: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateWeightLog() async {
    if (dateController.text.trim().isEmpty ||
        weightController.text.trim().isEmpty) {
      CustomToast.showError('Please fill in all fields');
      return;
    }

    final weight = double.tryParse(weightController.text.trim());
    if (weight == null || weight <= 0) {
      CustomToast.showError('Please enter a valid weight');
      return;
    }

    try {
      isSubmitting.value = true;

      final data = {
        'log_date': dateController.text.trim(),
        'weight_kg': weight,
      };

      final url = '${AppConstants.UPDATE_WEIGHT_LOG}/${editingLogId.value}';
      Response response = await authRepo.putDataSet(
        apiName: url,
        sendData: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess('Weight log updated successfully');
        cancelEdit();
        // Refresh the list
        await getWeightLogs(isRefresh: true);
      } else {
        CustomToast.showError('Failed to update weight log');
      }
    } catch (e) {
      CustomToast.showError('Error updating weight log: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteWeightLog(int logId) async {
    try {
      final url = '${AppConstants.DELETE_WEIGHT_LOG}/$logId';
      Response response = await authRepo.deleteDataSet(apiName: url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        CustomToast.showSuccess('Weight log deleted successfully');
        // Remove from local list
        weightLogs.removeWhere((log) => log.logId == logId);
        totalCount.value--;
      } else {
        CustomToast.showError('Failed to delete weight log');
      }
    } catch (e) {
      CustomToast.showError('Error deleting weight log: $e');
    }
  }

  void editWeightLog(WeightLog log) {
    isEditing.value = true;
    editingLogId.value = log.logId;
    dateController.text = log.logDate;
    weightController.text = log.weightKg.toString();
  }

  void cancelEdit() {
    isEditing.value = false;
    editingLogId.value = 0;
    weightController.clear();
    dateController.text = formatDate(DateTime.now());
  }

  Future<void> submitWeightLog() async {
    if (isEditing.value) {
      await updateWeightLog();
    } else {
      await addWeightLog();
    }
  }

  void loadMoreData() {
    if (!isLoadingMore.value && hasMoreData.value) {
      getWeightLogs();
    }
  }
}
