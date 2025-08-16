import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/repo/authRepo.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';

class CalendarController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  CalendarController({
    required this.authRepo,
  });

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  var weeklyMenuList = <Map<String, dynamic>>[].obs;
  var selectedDate = DateTime.now().obs;
  var currentMonth = DateTime.now().obs;

  // Grouped data by date and timing
  var groupedMealData = <String, Map<String, List<Map<String, dynamic>>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    print('CalendarController onInit called');
    getCalendarData();
  }

  Future<void> getCalendarData() async {
    try {
      print('CalendarController: Starting getCalendarData');
      isLoading.value = true;
      hasError.value = false;

      final url = AppConstants.WEEKLY_MENU;
      final payload = {"week_no": 999};

      print(
          'CalendarController: Making API call to $url with payload: $payload');

      Response response = await authRepo.postDataSet(
        apiName: url,
        sendData: payload,
      );

      print('Calendar weekly menu response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Calendar weekly menu API response successful');

        if (response.body['weekly_menu'] != null) {
          final data = response.body['weekly_menu'] as List;
          print('Calendar weekly menu data length: ${data.length}');

          weeklyMenuList.value = List<Map<String, dynamic>>.from(data);
          _groupMealDataByDateAndTiming();
          print('Calendar data stored, count: ${weeklyMenuList.length}');
        } else {
          print('No weekly_menu key found in calendar response');
          weeklyMenuList.value = [];
        }
      } else {
        hasError.value = true;
        final errorMsg =
            response.body['message'] ?? 'Failed to load calendar data';
        errorMessage.value = errorMsg;
        CustomToast.showError(errorMsg);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error: ${e.toString()}';
      print('Calendar API Error: $e');
      CustomToast.showError('Error fetching calendar data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _groupMealDataByDateAndTiming() {
    groupedMealData.clear();

    print(
        'CalendarController: Starting to group ${weeklyMenuList.length} items');

    // Debug: Print the first item to see field names
    if (weeklyMenuList.isNotEmpty) {
      print(
          'CalendarController: First item keys: ${weeklyMenuList.first.keys.toList()}');
      print('CalendarController: First item sample: ${weeklyMenuList.first}');
    }

    for (var mealItem in weeklyMenuList) {
      // Extract date and timings from the meal item (using exact field names from API)
      String? dateStr = mealItem['Date']?.toString();
      String? timing =
          mealItem['Timings']?.toString(); // Note: 'Timings' with 's'

      print(
          'CalendarController: Processing item - Date: $dateStr, Timings: $timing');

      if (dateStr != null && timing != null) {
        // Initialize date if not exists
        if (!groupedMealData.containsKey(dateStr)) {
          groupedMealData[dateStr] = <String, List<Map<String, dynamic>>>{};
        }

        // Initialize timing if not exists
        if (!groupedMealData[dateStr]!.containsKey(timing)) {
          groupedMealData[dateStr]![timing] = <Map<String, dynamic>>[];
        }

        // Add meal item to the group
        groupedMealData[dateStr]![timing]!.add(mealItem);
        print('CalendarController: Added meal to $dateStr/$timing');
      } else {
        print(
            'CalendarController: Skipping item due to null Date ($dateStr) or Timings ($timing)');
      }
    }

    print('Grouped meal data: ${groupedMealData.length} dates');
    groupedMealData.forEach((date, timings) {
      print(
          'Date $date has ${timings.length} timings: ${timings.keys.toList()}');
    });
  }

  // Get meals for a specific date
  Map<String, List<Map<String, dynamic>>> getMealsForDate(DateTime date) {
    String dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return groupedMealData[dateKey] ?? {};
  }

  // Check if a date has meal data
  bool hasDataForDate(DateTime date) {
    String dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return groupedMealData.containsKey(dateKey);
  }

  // Get all available dates
  List<String> get availableDates {
    return groupedMealData.keys.toList();
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // Set current month
  void setCurrentMonth(DateTime month) {
    currentMonth.value = month;
  }

  // Refresh data
  Future<void> refreshData() async {
    await getCalendarData();
  }

  // Get timing display name
  String getTimingDisplayName(String timing) {
    switch (timing.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'snack':
      case 'snacks':
        return 'Snacks';
      default:
        return timing.capitalizeFirst ?? timing;
    }
  }

  // Get timing icon
  String getTimingIcon(String timing) {
    switch (timing.toLowerCase()) {
      case 'breakfast':
        return 'assets/icons/breakfast.png';
      case 'lunch':
        return 'assets/icons/lunch.png';
      case 'dinner':
        return 'assets/icons/dinner.png';
      case 'snack':
      case 'snacks':
        return 'assets/icons/snaks.png';
      default:
        return 'assets/icons/breakfast.png';
    }
  }
}
