import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/model/fat_log.dart';
import 'package:sodiet/repo/authRepo.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';

class FatLogController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  FatLogController({
    required this.authRepo,
  });

  // Observable variables
  var fatLogs = <FatLog>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isSubmitting = false.obs;
  var currentPage = 1.obs;
  var totalCount = 0.obs;
  var pageSize = 10.obs;
  var hasMoreData = true.obs;

  // Controllers for form
  final TextEditingController dateController = TextEditingController();
  final TextEditingController fatController = TextEditingController();

  // Edit mode variables
  var isEditing = false.obs;
  var editingLogId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getFatLogs();
    // Set today's date as default
    dateController.text = formatDate(DateTime.now());
  }

  @override
  void onClose() {
    dateController.dispose();
    fatController.dispose();
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

  Future<void> getFatLogs({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
        fatLogs.clear();
      }

      if (!hasMoreData.value && !isRefresh) return;

      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final url =
          '${AppConstants.GET_FAT_LOGS}?page=${currentPage.value}&page_size=${pageSize.value}';

      Response response = await authRepo.getDataSet(apiName: url);

      if (response.statusCode == 200) {
        final fatLogResponse = FatLogResponse.fromJson(response.body);

        totalCount.value = fatLogResponse.totalCount;

        if (isRefresh || currentPage.value == 1) {
          fatLogs.value = fatLogResponse.logs;
        } else {
          fatLogs.addAll(fatLogResponse.logs);
        }

        // Check if there's more data
        hasMoreData.value = fatLogs.length < totalCount.value;

        if (fatLogResponse.logs.isNotEmpty) {
          currentPage.value++;
        }
      } else {
        CustomToast.showError('Failed to load fat logs');
      }
    } catch (e) {
      CustomToast.showError('Error loading fat logs: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> addFatLog() async {
    if (dateController.text.trim().isEmpty ||
        fatController.text.trim().isEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      CustomToast.showError('Please fill in all fields');
      return;
    }

    final fat = double.tryParse(fatController.text.trim());
    if (fat == null || fat < 0) {
      FocusManager.instance.primaryFocus?.unfocus();
      CustomToast.showError('Please enter a valid body fat percentage');
      return;
    }

    try {
      isSubmitting.value = true;

      final data = {
        'log_date': dateController.text.trim(),
        'body_fat_pct': fat,
      };

      Response response = await authRepo.postDataSet(
        apiName: AppConstants.ADD_FAT_LOG,
        sendData: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess('Fat log added successfully');
        // Close keyboard before clearing and navigating
        FocusManager.instance.primaryFocus?.unfocus();
        fatController.clear();
        Get.back();
        // Refresh the list
        await getFatLogs(isRefresh: true);
      } else {
        CustomToast.showError('Failed to add fat log');
      }
    } catch (e) {
      CustomToast.showError('Error adding fat log: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateFatLog() async {
    if (dateController.text.trim().isEmpty ||
        fatController.text.trim().isEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      CustomToast.showError('Please fill in all fields');
      return;
    }

    final fat = double.tryParse(fatController.text.trim());
    if (fat == null || fat < 0) {
      FocusManager.instance.primaryFocus?.unfocus();
      CustomToast.showError('Please enter a valid body fat percentage');
      return;
    }

    try {
      isSubmitting.value = true;

      final data = {
        'log_date': dateController.text.trim(),
        'body_fat_pct': fat,
      };

      final url = '${AppConstants.UPDATE_FAT_LOG}/${editingLogId.value}';
      Response response = await authRepo.putDataSet(
        apiName: url,
        sendData: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess('Fat log updated successfully');
        // Close keyboard before clearing and updating
        FocusManager.instance.primaryFocus?.unfocus();
        cancelEdit();
        // Refresh the list
        await getFatLogs(isRefresh: true);
      } else {
        CustomToast.showError('Failed to update fat log');
      }
    } catch (e) {
      CustomToast.showError('Error updating fat log: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteFatLog(int logId) async {
    try {
      final url = '${AppConstants.DELETE_FAT_LOG}/$logId';
      Response response = await authRepo.deleteDataSet(apiName: url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        CustomToast.showSuccess('Fat log deleted successfully');
        // Remove from local list
        fatLogs.removeWhere((log) => log.logId == logId);
        totalCount.value--;
      } else {
        CustomToast.showError('Failed to delete fat log');
      }
    } catch (e) {
      CustomToast.showError('Error deleting fat log: $e');
    }
  }

  void editFatLog(FatLog log) {
    isEditing.value = true;
    editingLogId.value = log.logId;
    dateController.text = log.logDate;
    fatController.text = log.bodyFatPct.toString();
  }

  void cancelEdit() {
    isEditing.value = false;
    editingLogId.value = 0;
    fatController.clear();
    dateController.text = formatDate(DateTime.now());
  }

  Future<void> submitFatLog() async {
    if (isEditing.value) {
      await updateFatLog();
    } else {
      await addFatLog();
    }
  }

  void loadMoreData() {
    if (!isLoadingMore.value && hasMoreData.value) {
      getFatLogs();
    }
  }
}
