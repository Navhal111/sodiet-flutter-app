import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/repo/authRepo.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';

class MealPlanController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  MealPlanController({
    required this.authRepo,
  });

  // Observable variables
  var isLoading = false.obs;
  var weeklyMenuList = <Map<String, dynamic>>[].obs;
  var currentWeekNo = 1.obs;

  @override
  void onInit() {
    super.onInit();
    print('MealPlanController onInit called');
    print('Get.arguments: ${Get.arguments}');

    // Get arguments from navigation
    if (Get.arguments != null && Get.arguments['week_no'] != null) {
      currentWeekNo.value = Get.arguments['week_no'];
      print('Week number from arguments: ${currentWeekNo.value}');
      getWeeklyMenu(currentWeekNo.value);
    } else {
      print('No arguments found, using default week 1');
      getWeeklyMenu(1); // Load default week 1 if no arguments
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Check if week number changed and reload if needed
    _checkAndLoadWeekData();
  }

  void _checkAndLoadWeekData() {
    if (Get.arguments != null && Get.arguments['week_no'] != null) {
      final newWeekNo = Get.arguments['week_no'];
      if (newWeekNo != currentWeekNo.value) {
        print(
            'Week changed from ${currentWeekNo.value} to $newWeekNo, reloading...');
        currentWeekNo.value = newWeekNo;
        getWeeklyMenu(newWeekNo);
      }
    }
  }

  // Call this method when the screen becomes active again
  void checkForUpdatedArguments() {
    _checkAndLoadWeekData();
  }

  // Get weekly menu data
  Future<void> getWeeklyMenu(int weekNo) async {
    try {
      isLoading.value = true;
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
        print('API response successful');

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
      isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await getWeeklyMenu(currentWeekNo.value);
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
}

class WeeklyMenuItem {
  final int id;
  final String recipeCode;
  final String recipeName;
  final String day;
  final String quantity;
  final String weight;
  final String mealType;
  final String imagePath;

  WeeklyMenuItem({
    required this.id,
    required this.recipeCode,
    required this.recipeName,
    required this.day,
    required this.quantity,
    required this.weight,
    required this.mealType,
    required this.imagePath,
  });

  factory WeeklyMenuItem.fromJson(Map<String, dynamic> json) {
    return WeeklyMenuItem(
      id: json['id'] ?? 0,
      recipeCode: json['recipe_code'] ?? '',
      recipeName: json['recipe_name'] ?? '',
      day: json['day'] ?? '',
      quantity: json['quantity'] ?? '',
      weight: json['weight'] ?? '',
      mealType: json['meal_type'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_code': recipeCode,
      'recipe_name': recipeName,
      'day': day,
      'quantity': quantity,
      'weight': weight,
      'meal_type': mealType,
      'image_path': imagePath,
    };
  }

  // Get formatted quantity with proper display
  String get displayQuantity {
    if (quantity.isEmpty) return '';

    // Handle different quantity formats
    if (quantity.contains('tbsp') || quantity.contains('Tbsp')) {
      return quantity;
    }
    if (quantity.contains('cup') || quantity.contains('Cup')) {
      return quantity;
    }
    if (quantity.contains('number') || quantity.contains('Number')) {
      return quantity
          .replaceAll('number', 'Number')
          .replaceAll('Number', 'Number');
    }

    return quantity;
  }

  // Get formatted weight
  String get displayWeight {
    if (weight.isEmpty) return '';

    // Add 'gms' if not present
    if (!weight.toLowerCase().contains('gms') &&
        !weight.toLowerCase().contains('g') &&
        !weight.toLowerCase().contains('kg')) {
      return '${weight}gms';
    }

    return weight;
  }

  // Get image URL or fallback to static images
  String get imageUrl {
    if (imagePath.isNotEmpty) {
      // If image path is provided from API, use it
      return AppConstants.BASE_URL_IMAGE + imagePath;
    }

    // Fallback to static images based on recipe name or meal type
    final images = [
      'assets/images/food/food1.png',
      'assets/images/food/food2.png',
      'assets/images/food/food3.png',
      'assets/images/food/food4.png',
    ];

    // Use recipe code hash to get consistent image for same recipe
    final index = recipeCode.hashCode.abs() % images.length;
    return images[index];
  }
}
