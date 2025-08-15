import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/home/welcome_title_widget.dart';
import 'package:sodiet/route/app_routes.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

  // Sample meal data for the calendar
  final Map<String, List<Map<String, dynamic>>> mealData = {
    '2025-03-02': [
      {
        'Recipe_Name': 'Coffee',
        'Recipe_Code': 'A001',
        'Portion': 1,
        'Description': 'Cup',
        'Recipe_Weight': 200,
        'mealType': 'Breakfast'
      }
    ],
    '2025-03-09': [
      {
        'Recipe_Name': 'Protein Bowl',
        'Recipe_Code': 'A002',
        'Portion': 1,
        'Description': 'Bowl',
        'Recipe_Weight': 300,
        'mealType': 'Breakfast'
      },
      {
        'Recipe_Name': 'Masala Karela',
        'Recipe_Code': 'A003',
        'Portion': 1,
        'Description': 'Bowl',
        'Recipe_Weight': 250,
        'mealType': 'Lunch'
      },
      {
        'Recipe_Name': 'Biryani',
        'Recipe_Code': 'A004',
        'Portion': 1,
        'Description': 'Bowl',
        'Recipe_Weight': 350,
        'mealType': 'Lunch'
      }
    ]
  };

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
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.calendarScreen,
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
                              setState(() {
                                currentMonth = DateTime(
                                  currentMonth.year,
                                  currentMonth.month - 1,
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Color(0xFF6B7280),
                              size: 24,
                            ),
                          ),
                          SemiBoldText(
                            '${months[currentMonth.month - 1]}',
                            fontSize: 20,
                            textColor: const Color(0xFF1F2937),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentMonth = DateTime(
                                  currentMonth.year,
                                  currentMonth.month + 1,
                                );
                              });
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
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
  }

  Widget _buildCalendarGrid() {
    List<Widget> calendarDays = [];

    // Get first day of the month
    DateTime firstDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month, 1);
    int firstWeekday =
        firstDayOfMonth.weekday % 7; // Convert to 0-6 where 0 is Sunday

    // Get last day of the month
    DateTime lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);
    int daysInMonth = lastDayOfMonth.day;

    // Add empty cells for days before the first day
    for (int i = 0; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }

    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(currentMonth.year, currentMonth.month, day);
      String dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      bool hasData = mealData.containsKey(dateKey);
      bool isSelected = selectedDate.day == day &&
          selectedDate.month == currentMonth.month &&
          selectedDate.year == currentMonth.year;
      bool isToday = DateTime.now().day == day &&
          DateTime.now().month == currentMonth.month &&
          DateTime.now().year == currentMonth.year;

      calendarDays.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
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
    String selectedDateKey =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    List<Map<String, dynamic>> dayMeals = mealData[selectedDateKey] ?? [];

    // Group meals by type
    Map<String, List<Map<String, dynamic>>> groupedMeals = {};
    for (var meal in dayMeals) {
      String mealType = meal['mealType'] ?? 'Other';
      if (!groupedMeals.containsKey(mealType)) {
        groupedMeals[mealType] = [];
      }
      groupedMeals[mealType]!.add(meal);
    }

    List<Widget> mealSections = [];

    // Add breakfast section
    if (groupedMeals.containsKey('Breakfast')) {
      mealSections
          .add(_buildMealTypeSection('Breakfast', groupedMeals['Breakfast']!));
    }

    // Add lunch section
    if (groupedMeals.containsKey('Lunch')) {
      mealSections.add(_buildMealTypeSection('Lunch', groupedMeals['Lunch']!));
    }

    // Add dinner section
    if (groupedMeals.containsKey('Dinner')) {
      mealSections
          .add(_buildMealTypeSection('Dinner', groupedMeals['Dinner']!));
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
              'No meals planned for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
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
            child: SemiBoldText(
              mealType,
              fontSize: 18,
              textColor: const Color(0xFF091242),
            ),
          ),
          ...meals
              .map((meal) => _buildMealItem(
                    '${AppConstants.BASE_URL_IMAGE}${meal['Recipe_Code']}.jpg',
                    meal['Recipe_Name']?.toString() ?? 'Unknown Recipe',
                    '${meal['Portion']?.toString() ?? '0'} ${meal['Description']?.toString() ?? ''}',
                    '${meal['Recipe_Weight']?.toString() ?? '0'}gms',
                  ))
              .toList(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMealItem(
      String imagePath, String foodName, String quantity, String weight) {
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
                    foodName,
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
              weight,
              fontSize: 14,
              textColor: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
