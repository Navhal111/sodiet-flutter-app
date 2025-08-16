import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/controller/calendar/calendar_controller.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarController controller;

  List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.find<CalendarController>();
    // Ensure data is loaded when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if data is already loaded, if not, load it
      if (controller.weeklyMenuList.isEmpty && !controller.isLoading.value) {
        print('Calendar: Loading data on screen init');
        controller.getCalendarData();
      } else {
        print('Calendar: Data already loaded or loading in progress');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.calendarScreen,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
            
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                SemiBoldText(
                  'Failed to load calendar data',
                  fontSize: 18,
                  textColor: Colors.red.shade600,
                ),
                const SizedBox(height: 8),
                RegularText(
                  controller.errorMessage.value,
                  fontSize: 14,
                  textColor: Colors.grey.shade600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    controller.refreshData();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshData();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleSectionWidget(
                    imagePath: 'assets/images/plan.png',
                    title: 'Calendar',
                    description:
                        'View and manage your optimization plans to track your progress and stay on top of your diet and fitness goals.',
                  ),
                  const SizedBox(height: 24),

                  // Calendar Widget
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Calendar Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  DateTime newMonth = DateTime(
                                    controller.currentMonth.value.year,
                                    controller.currentMonth.value.month - 1,
                                  );
                                  controller.setCurrentMonth(newMonth);
                                },
                                icon: const Icon(
                                  Icons.chevron_left,
                                  color: Color(0xFF6B7280),
                                  size: 24,
                                ),
                              ),
                              SemiBoldText(
                                '${months[controller.currentMonth.value.month - 1]}',
                                fontSize: 20,
                                textColor: const Color(0xFF1F2937),
                              ),
                              IconButton(
                                onPressed: () {
                                  DateTime newMonth = DateTime(
                                    controller.currentMonth.value.year,
                                    controller.currentMonth.value.month + 1,
                                  );
                                  controller.setCurrentMonth(newMonth);
                                },
                                icon: const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF6B7280),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Week days header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: weekDays.map((day) {
                              return Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: RegularText(
                                      day,
                                      fontSize: 13,
                                      textColor: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // Calendar Grid
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: _buildCalendarGrid(),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Selected Date Meals
                  _buildSelectedDateMeals(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarGrid() {
    List<Widget> calendarDays = [];

    // Get first day of the month
    DateTime firstDayOfMonth = DateTime(controller.currentMonth.value.year,
        controller.currentMonth.value.month, 1);
    int firstWeekday =
        firstDayOfMonth.weekday % 7; // Convert to 0-6 where 0 is Sunday

    // Get last day of the month
    DateTime lastDayOfMonth = DateTime(controller.currentMonth.value.year,
        controller.currentMonth.value.month + 1, 0);
    int daysInMonth = lastDayOfMonth.day;

    // Add empty cells for days before the first day
    for (int i = 0; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }

    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(controller.currentMonth.value.year,
          controller.currentMonth.value.month, day);
      bool hasData = controller.hasDataForDate(date);
      bool isSelected = controller.selectedDate.value.day == day &&
          controller.selectedDate.value.month ==
              controller.currentMonth.value.month &&
          controller.selectedDate.value.year ==
              controller.currentMonth.value.year;
      bool isToday = DateTime.now().day == day &&
          DateTime.now().month == controller.currentMonth.value.month &&
          DateTime.now().year == controller.currentMonth.value.year;

      calendarDays.add(
        GestureDetector(
          onTap: () {
            controller.setSelectedDate(date);
          },
          child: Container(
            height: 48,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(
                      0xFFEF4444) // Red for selected (like in your image)
                  : isToday
                      ? const Color(0xFFFEF2F2)
                      : hasData
                          ? const Color(0xFFDCFCE7) // Light green for data
                          : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: const Color(0xFFEF4444), width: 2)
                  : hasData && !isToday
                      ? Border.all(color: const Color(0xFF10B981), width: 2)
                      : isToday && !isSelected
                          ? Border.all(color: const Color(0xFFEF4444), width: 1)
                          : Border.all(
                              color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Center(
              child: RegularText(
                day.toString(),
                fontSize: 16,
                textColor: isSelected
                    ? Colors.white
                    : isToday
                        ? const Color(0xFFEF4444)
                        : hasData
                            ? const Color(0xFF059669)
                            : const Color(0xFF374151),
              ),
            ),
          ),
        ),
      );
    }

    // Create rows of 7 days each
    List<Widget> rows = [];
    for (int i = 0; i < calendarDays.length; i += 7) {
      rows.add(
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: calendarDays
                .sublist(i,
                    i + 7 > calendarDays.length ? calendarDays.length : i + 7)
                .map((day) => Expanded(child: day))
                .toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildSelectedDateMeals() {
    Map<String, List<Map<String, dynamic>>> dayMeals =
        controller.getMealsForDate(controller.selectedDate.value);

    List<Widget> mealSections = [];

    if (dayMeals.isNotEmpty) {
      // Sort timings in a logical order
      List<String> timingOrder = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
      List<String> sortedTimings = dayMeals.keys.toList();
      sortedTimings.sort((a, b) {
        int indexA = timingOrder.indexOf(controller.getTimingDisplayName(a));
        int indexB = timingOrder.indexOf(controller.getTimingDisplayName(b));
        if (indexA == -1) indexA = timingOrder.length;
        if (indexB == -1) indexB = timingOrder.length;
        return indexA.compareTo(indexB);
      });

      for (String timing in sortedTimings) {
        List<Map<String, dynamic>> meals = dayMeals[timing] ?? [];
        if (meals.isNotEmpty) {
          mealSections.add(_buildMealTypeSection(
              controller.getTimingDisplayName(timing), meals));
        }
      }
    }

    if (mealSections.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            SemiBoldText(
              'No meals planned',
              fontSize: 16,
              textColor: Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            RegularText(
              'No meals planned for ${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
              fontSize: 14,
              textColor: Colors.grey.shade500,
            ),
          ],
        ),
      );
    }

    return Column(children: mealSections);
  }

  Widget _buildMealTypeSection(
      String mealType, List<Map<String, dynamic>> meals) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(
                  controller.getTimingIcon(mealType),
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.restaurant,
                      size: 24,
                      color: Colors.grey.shade600,
                    );
                  },
                ),
                const SizedBox(width: 8),
                SemiBoldText(
                  mealType,
                  fontSize: 18,
                  textColor: const Color(0xFF091242),
                ),
              ],
            ),
          ),
          ...meals.map((meal) => _buildMealItem(meal)).toList(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMealItem(Map<String, dynamic> meal) {
    String recipeName = meal['Recipe_Name']?.toString() ?? 'Unknown Recipe';
    String recipeCode = meal['Recipe_Code']?.toString() ?? '';
    String portion = meal['Portion']?.toString() ?? '0';
    String description = meal['Description']?.toString() ?? '';
    String weight = meal['Recipe_Weight']?.toString() ?? '0';

    String imagePath = '${AppConstants.BASE_URL_IMAGE}$recipeCode.jpg';
    String quantity = '$portion $description';
    String weightText = '${weight}gms';

    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Food image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: imagePath.startsWith('http')
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade400,
                            size: 25,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade200,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade400,
                            size: 25,
                          ),
                        );
                      },
                    ),
            ),
          ),

          const SizedBox(width: 12),

          // Food details
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SemiBoldText(
                    recipeName,
                    fontSize: 16,
                    textColor: const Color(0xFF091242),
                  ),
                  const SizedBox(height: 8),
                  RegularText(
                    quantity,
                    fontSize: 14,
                    textColor: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),

          // Weight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RegularText(
              weightText,
              fontSize: 14,
              textColor: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
