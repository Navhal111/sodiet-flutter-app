import 'package:get/get.dart';

import '../../constant/appConstant.dart';
import '../../model/pa_recall_model.dart';
import '../../model/physical_activity_model.dart';
import '../../repo/authRepo.dart';

class PhysicalActivityController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  PhysicalActivityController({
    required this.authRepo,
  });

  RxBool isLoading = false.obs;
  RxBool isLoadingList = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxBool isLoadingActivities = false.obs;

  // Observable variables to store PA recall data
  Rx<PaRecallModel?> paRecallData = Rx<PaRecallModel?>(null);
  RxList<PaRecallItem> paRecallList = <PaRecallItem>[].obs;
  RxInt totalCount = 0.obs;

  // Observable variables to store physical activities data
  Rx<PhysicalActivityModel?> physicalActivitiesData =
      Rx<PhysicalActivityModel?>(null);
  RxList<PhysicalActivity> activitiesList = <PhysicalActivity>[].obs;

  int currentPage = 1;
  int pageSize = 20; // Load 20 items per page

  getPaRecallList({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore.value || !hasMoreData.value) return;
      isLoadingMore.value = true;
      currentPage++;
    } else {
      isLoadingList.value = true;
      currentPage = 1;
      hasMoreData.value = true;
      paRecallList.clear(); // Clear list on fresh load
    }

    try {
      String apiUrl = AppConstants.GET_PA_RECALL;
      // if (loadMore || currentPage > 1) {
      apiUrl += '?page=$currentPage&page_size=$pageSize';
      // }

      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("PA Recall API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Parse the response using the model
        paRecallData.value = PaRecallModel.fromJson(response.body);

        if (loadMore) {
          // Append new items for pagination
          paRecallList.addAll(paRecallData.value?.recalls ?? []);
          print(
              "Loaded ${paRecallData.value?.recalls.length} more PA items. Total: ${paRecallList.length}");
        } else {
          // Replace all items for fresh load
          paRecallList.addAll(paRecallData.value?.recalls ?? []);
          print("Loaded ${paRecallList.length} PA items");
        }

        // Update total count
        totalCount.value = paRecallData.value?.totalCount ?? 0;

        // Check if there's more data
        if ((paRecallData.value?.recalls.length ?? 0) < pageSize) {
          hasMoreData.value = false;
          print("No more PA data to load");
        }
      } else {
        print("PA API Error: ${response.statusCode}");
        if (!loadMore) {
          paRecallData.value = null;
        }
      }
    } catch (e) {
      print('Exception in getPaRecallList: $e');
      if (!loadMore) {
        paRecallData.value = null;
      }
    }

    if (loadMore) {
      isLoadingMore.value = false;
    } else {
      isLoadingList.value = false;
    }
    update();
  }

  // Method to load more data when scrolling
  void loadMorePaRecalls() {
    getPaRecallList(loadMore: true);
  }

  // Method to get physical activities list
  getPhysicalActivitiesList() async {
    isLoadingActivities.value = true;
    try {
      String apiUrl = AppConstants.GET_PHYSICAL_ACTIVITIES;
      Response response = await authRepo.getDataSet(apiName: apiUrl);
      print("Physical Activities API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Parse the response using the model
        physicalActivitiesData.value =
            PhysicalActivityModel.fromJson(response.body);
        activitiesList.value = physicalActivitiesData.value?.activities ?? [];

        print("Loaded ${activitiesList.length} physical activities");
      } else {
        print("Physical Activities API Error: ${response.statusCode}");
        physicalActivitiesData.value = null;
        activitiesList.clear();
      }
    } catch (e) {
      print('Exception in getPhysicalActivitiesList: $e');
      physicalActivitiesData.value = null;
      activitiesList.clear();
    }

    isLoadingActivities.value = false;
    update();
  }

  addPaRecall(Map<String, dynamic> activityData) async {
    isLoading.value = true;
    try {
      Response response = await authRepo.postDataSet(
        sendData: activityData,
        apiName: AppConstants.GET_PA_RECALL,
      );
      print("Add PA Recall Response Status: ${response.statusCode}");
      print("Add PA Recall Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the list after successful addition
        await getPaRecallList();
        isLoading.value = false;
        return {
          'success': true,
          'message': 'Physical activity added successfully!'
        };
      } else {
        isLoading.value = false;
        return {
          'success': false,
          'message': 'Failed to add activity. Please try again.'
        };
      }
    } catch (e) {
      print('Exception in addPaRecall: $e');
      isLoading.value = false;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    }
  }

  deletePaRecall(String recallId) async {
    isLoading.value = true;
    try {
      String deleteUrl = "${AppConstants.GET_PA_RECALL}/$recallId";
      Response response = await authRepo.deleteDataSet(apiName: deleteUrl);
      print("Delete PA Recall Response Status: ${response.statusCode}");
      print("Delete PA Recall Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Refresh the PA recall list after successful deletion
        await getPaRecallList();
        isLoading.value = false;
        return {
          'success': true,
          'message': 'Physical activity deleted successfully!'
        };
      } else {
        isLoading.value = false;
        return {
          'success': false,
          'message': 'Failed to delete activity. Please try again.'
        };
      }
    } catch (e) {
      print("Exception in deletePaRecall: $e");
      isLoading.value = false;
      return {
        'success': false,
        'message': 'Network error. Please check your connection.'
      };
    }
  }
}
