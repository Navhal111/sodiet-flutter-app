import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/repo/authRepo.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';

class OptimizationController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  OptimizationController({
    required this.authRepo,
  });

  // Observable variables
  var isLoading = false.obs;
  var weekPlanData = <WeekPlanData>[].obs;
  var totalRecords = 0.obs;

  // Weekly menu data variables
  var isMenuLoading = false.obs;
  var weeklyMenuList = <Map<String, dynamic>>[].obs;
  var currentWeekNo = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getWeekPlanMaster();
  }

  // Get week plan master data
  Future<void> getWeekPlanMaster() async {
    try {
      isLoading.value = true;

      final url = AppConstants.WEEK_PLAN_MASTER;

      Response response = await authRepo.getDataSet(
        apiName: url,
      );

      print('Week plan master response status: ${response.statusCode}');
      print('Week plan master response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = response.body['week_plan_data'] as List;
        totalRecords.value = response.body['total_records'] ?? 0;

        // Parse week plan data
        weekPlanData.value =
            data.map((item) => WeekPlanData.fromJson(item)).toList();

        print('Parsed ${weekPlanData.length} week plan records');
      } else {
        final errorMessage =
            response.body['message'] ?? 'Failed to fetch week plan data';
        CustomToast.showError(errorMessage);
      }
    } catch (e) {
      print('Exception in getWeekPlanMaster: $e');
      CustomToast.showError('Error fetching week plan data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await getWeekPlanMaster();
  }

  // Get weekly menu data for specific week
  Future<void> getWeeklyMenu(int weekNo) async {
    try {
      isMenuLoading.value = true;
      currentWeekNo.value = weekNo;

      final url = AppConstants.WEEKLY_MENU;

      final payload = {
        "week_no": weekNo,
      };

      Response response = await authRepo.postDataSet(
        apiName: url,
        sendData: payload,
      );

      print('Weekly menu response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Weekly menu API response successful');

        if (response.body['weekly_menu'] != null) {
          final data = response.body['weekly_menu'] as List;
          print('Weekly menu data length: ${data.length}');

          // Simply store the list directly
          weeklyMenuList.value = List<Map<String, dynamic>>.from(data);
          print('Data stored in list, count: ${weeklyMenuList.length}');
        } else {
          print('No weekly_menu key found in response');
          weeklyMenuList.value = [];
        }
      } else {
        final errorMessage =
            response.body['message'] ?? 'Failed to fetch weekly menu';
        CustomToast.showError(errorMessage);
      }
    } catch (e) {
      print('Exception in getWeeklyMenu: $e');
      CustomToast.showError('Error fetching weekly menu: $e');
    } finally {
      isMenuLoading.value = false;
    }
  }

  // Get unique days from the menu list
  List<String> get availableDays {
    final days =
        weeklyMenuList.map((item) => item['Day'].toString()).toSet().toList();
    const dayOrder = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    return dayOrder.where((day) => days.contains(day)).toList();
  }

  // Get menu items for a specific day
  List<Map<String, dynamic>> getMenuForDay(String day) {
    return weeklyMenuList
        .where((item) => item['Day'].toString() == day)
        .toList();
  }

  // Get background color based on status
  List<dynamic> getStatusColors(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return [
          const Color(0xFFF5F5F5), // Background color
          const Color(0xFF4C4C4C), // Text color
          [
            const Color(0xFFFFB74D),
            const Color(0xFFFFCC02),
            const Color(0xFFFFF176),
          ], // Action colors
        ];
      case 'running':
      case 'optimal':
      case 'completed':
        return [
          const Color(0xFFE8F5E8), // Background color
          const Color(0xFF2E7D32), // Text color
          [
            const Color(0xFF4CAF50),
            const Color(0xFF81C784),
            const Color(0xFFA5D6A7),
          ], // Action colors
        ];
      case 'error':
      case 'failed':
        return [
          const Color(0xFFFFEBEE), // Background color
          const Color(0xFFE53935), // Text color
          [
            const Color(0xFFE57373),
            const Color(0xFFEF5350),
            const Color(0xFFE53935),
          ], // Action colors
        ];
      case 'na':
      case 'not available':
      case '':
      default:
        return [
          const Color(0xFFF5F5F5), // Default background
          const Color(0xFF4C4C4C), // Default text color
          [
            const Color(0xFFBDBDBD),
            const Color(0xFF9E9E9E),
            const Color(0xFF757575),
          ], // Default action colors
        ];
    }
  }
}

class WeekPlanData {
  final int week;
  final String startDate;
  final String endDate;
  final String optStatus;
  final String optDate;
  final int planId;
  final int pkey;
  final String optEnergyStatus;

  WeekPlanData({
    required this.week,
    required this.startDate,
    required this.endDate,
    required this.optStatus,
    required this.optDate,
    required this.planId,
    required this.pkey,
    required this.optEnergyStatus,
  });

  factory WeekPlanData.fromJson(Map<String, dynamic> json) {
    return WeekPlanData(
      week: json['Week'] ?? 0,
      startDate: json['Start_Date'] ?? '',
      endDate: json['End_Date'] ?? '',
      optStatus: json['OPTStatus'] ?? '',
      optDate: json['OPTDate'] ?? '',
      planId: json['PLAN_ID'] ?? 0,
      pkey: json['Pkey'] ?? 0,
      optEnergyStatus: json['OPTEnergyStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Week': week,
      'Start_Date': startDate,
      'End_Date': endDate,
      'OPTStatus': optStatus,
      'OPTDate': optDate,
      'PLAN_ID': planId,
      'Pkey': pkey,
      'OPTEnergyStatus': optEnergyStatus,
    };
  }

  // Get formatted date range
  String get dateRange {
    if (startDate.isEmpty || endDate.isEmpty) return '';

    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      final startFormatted = '${_getMonthName(start.month)}${start.day}';
      final endFormatted = '${_getMonthName(end.month)}${end.day}';

      return '$startFormatted - $endFormatted';
    } catch (e) {
      return '$startDate - $endDate';
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  // Get formatted last run date
  String get lastRunDate {
    if (optDate.isEmpty) return 'Never';

    try {
      final date = DateTime.parse(optDate);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) return 'Today';
      if (difference == 1) return 'Yesterday';
      if (difference < 7) return '$difference days ago';

      return '${_getMonthName(date.month)}${date.day}';
    } catch (e) {
      return optDate;
    }
  }
}
