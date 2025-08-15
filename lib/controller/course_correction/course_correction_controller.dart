import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/repo/authRepo.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';

class CourseCorrectionController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  CourseCorrectionController({
    required this.authRepo,
  });

  // Observable variables
  var isLoading = false.obs;
  var correctionData = <CourseCorrectionData>[].obs;
  var nrdDates = <String>[].obs;
  var selectedCorrections = <int>[].obs; // Track selected indices
  var totalDelta = 0.0.obs;
  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCorrectionPendingData();
  }

  // Get course correction pending data
  Future<void> getCorrectionPendingData() async {
    try {
      isLoading.value = true;

      final url = AppConstants.GET_CC_PENDING_DATA;

      Response response = await authRepo.getDataSet(
        apiName: url,
      );

      print('Course correction response status: ${response.statusCode}');
      print('Course correction response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = response.body['data'] as List;
        final nrd = response.body['nrd'] as List;

        // Parse correction data
        correctionData.value =
            data.map((item) => CourseCorrectionData.fromJson(item)).toList();

        // Parse NRD dates
        nrdDates.value = nrd.cast<String>();

        print('Loaded ${correctionData.length} correction items');
      } else {
        CustomToast.showError('Failed to load course correction data');
      }
    } catch (e) {
      print('Exception in getCorrectionPendingData: $e');
      CustomToast.showError('Error loading data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle selection of a correction item with cascading logic
  void toggleSelection(int index) {
    if (selectedCorrections.contains(index)) {
      // If deselecting, remove this index and all subsequent indices
      final indicesToRemove =
          selectedCorrections.where((i) => i >= index).toList();

      // Update total delta
      for (int i in indicesToRemove) {
        totalDelta.value -= correctionData[i].actualTotalDelta;
        selectedCorrections.remove(i);
      }
    } else {
      // If selecting, add this index and all previous indices that aren't already selected
      for (int i = 0; i <= index; i++) {
        if (!selectedCorrections.contains(i)) {
          selectedCorrections.add(i);
          totalDelta.value += correctionData[i].actualTotalDelta;
        }
      }
    }

    // Sort the selected corrections to maintain order
    selectedCorrections.sort();
  }

  // Check if an item is selected
  bool isSelected(int index) {
    return selectedCorrections.contains(index);
  }

  // Submit selected corrections
  Future<void> submitCorrections() async {
    if (selectedCorrections.isEmpty) {
      CustomToast.showWarning('Please select at least one correction');
      return;
    }

    try {
      isSubmitting.value = true;
      CustomToast.showLoading('Submitting corrections...');

      // TODO: Implement submit API call when endpoint is available
      // For now, just show success message
      await Future.delayed(const Duration(seconds: 2));

      CustomToast.showSuccess('Course corrections submitted successfully');

      // Clear selections and refresh data
      selectedCorrections.clear();
      totalDelta.value = 0.0;
      await getCorrectionPendingData();
    } catch (e) {
      print('Exception in submitCorrections: $e');
      CustomToast.showError('Error submitting corrections: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    selectedCorrections.clear();
    totalDelta.value = 0.0;
    await getCorrectionPendingData();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

// Model for course correction data
class CourseCorrectionData {
  final String date;
  final double intakeDelta;
  final double expDelta;
  final double actualTotalDelta;
  final double delta;

  CourseCorrectionData({
    required this.date,
    required this.intakeDelta,
    required this.expDelta,
    required this.actualTotalDelta,
    required this.delta,
  });

  factory CourseCorrectionData.fromJson(Map<String, dynamic> json) {
    return CourseCorrectionData(
      date: json['date']?.toString() ?? '',
      intakeDelta: (json['intake_delta'] ?? 0).toDouble(),
      expDelta: (json['exp_delta'] ?? 0).toDouble(),
      actualTotalDelta: (json['Actual_total_Delta'] ?? 0).toDouble(),
      delta: (json['delta'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'intake_delta': intakeDelta,
      'exp_delta': expDelta,
      'Actual_total_Delta': actualTotalDelta,
      'delta': delta,
    };
  }
}
