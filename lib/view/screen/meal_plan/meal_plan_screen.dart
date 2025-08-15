import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/controller/optimization/optimization_controller.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/header/app_header.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/common/shimmer_loading.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  String selectedOption = 'All';
  bool viewTwoDays = false;
  final TextEditingController _searchController = TextEditingController();
  late OptimizationController controller;
  String searchQuery = '';

  final List<String> options = [
    'All',
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  @override
  void initState() {
    super.initState();
    // Use the existing OptimizationController
    controller = Get.find<OptimizationController>();
    print('MealPlanScreen initState - Using OptimizationController');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              showBackButton: true,
              title: 'Meal Plan',
              onBackTap: () => Get.back(),
              onNotificationTap: () {},
              onProfileTap: () {},
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    TitleSectionWidget(
                      imagePath: 'assets/images/plan.png',
                      title: 'Weekly Meal Plan',
                      description:
                          'Plan your meals for the week to maintain a balanced diet and achieve your fitness goals.',
                    ),

                    // Day Selection Section
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Option Selection (All, Saturday, Sunday, etc.)
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options[index];
                                final isSelected = option == selectedOption;

                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = option;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2)
                                            : Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: SemiBoldText(
                                          option,
                                          fontSize: 14,
                                          textColor: isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Search recipe field
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value.toLowerCase();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search recipe',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade500,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Meal Plan Content - Simple list approach
                    Obx(() {
                      print(
                          'MealPlanScreen Obx - isMenuLoading: ${controller.isMenuLoading.value}');
                      print(
                          'MealPlanScreen Obx - weeklyMenuList length: ${controller.weeklyMenuList.length}');

                      if (controller.isMenuLoading.value) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
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
                            children: List.generate(
                              7,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerLoading(
                                      width: 100,
                                      height: 20,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    const SizedBox(height: 12),
                                    ShimmerLoading(
                                      width: double.infinity,
                                      height: 80,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    const SizedBox(height: 8),
                                    ShimmerLoading(
                                      width: double.infinity,
                                      height: 80,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (controller.weeklyMenuList.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
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
                                'No meal plan available',
                                fontSize: 16,
                                textColor: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              RegularText(
                                'No meals planned for week ${controller.currentWeekNo.value}',
                                fontSize: 14,
                                textColor: Colors.grey.shade500,
                              ),
                            ],
                          ),
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
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
                            // Show current week info
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  SemiBoldText(
                                    'Week ${controller.currentWeekNo.value} Meal Plan',
                                    fontSize: 14,
                                    textColor: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            // Dynamic days - filtered based on selected option
                            ...(_getFilteredDays()).map((day) {
                              final isLast = day == _getFilteredDays().last;
                              return Column(
                                children: [
                                  _buildDaySection(day),
                                  if (!isLast) const SizedBox(height: 18),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySection(String day) {
    final menuItems = controller.getMenuForDay(day);

    // Filter menu items based on search query
    final filteredMenuItems = menuItems.where((menuItem) {
      if (searchQuery.isEmpty) return true;
      final recipeName =
          menuItem['Recipe_Name']?.toString().toLowerCase() ?? '';
      return recipeName.contains(searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day title
        SemiBoldText(
          day,
          fontSize: 18,
          textColor: const Color(0xFF091242),
        ),
        const SizedBox(height: 12),

        // Dynamic meal items for the day
        if (filteredMenuItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RegularText(
                    searchQuery.isEmpty
                        ? 'No meals planned for $day'
                        : 'No recipes found matching "$searchQuery" for $day',
                    fontSize: 14,
                    textColor: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          )
        else
          ...filteredMenuItems
              .map((menuItem) => _buildMealItem(
                    '${AppConstants.BASE_URL_IMAGE}${menuItem['Recipe_Code']}.jpg', // image path - we'll use default
                    menuItem['Recipe_Name']?.toString() ?? 'Unknown Recipe',
                    '${menuItem['Portion']?.toString() ?? '0'} ${menuItem['Description']?.toString() ?? ''}',
                    '${menuItem['Recipe_Weight']?.toString() ?? '0'}gms',
                  ))
              .toList(),
      ],
    );
  }

  Widget _buildMealItem(
      String imagePath, String foodName, String quantity, String weight) {
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color:
            const Color(0xFFF8F8F8), // Light gray background like in screenshot
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
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
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
                    const SizedBox(height: 15),
                    RegularText(
                      quantity,
                      fontSize: 14,
                      textColor: Colors.grey.shade600,
                    ),
                  ],
                )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle remove item
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                RegularText(
                  weight,
                  fontSize: 14,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
            // Weight and remove button
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(
    String mealType,
    String time,
    List<String> items,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: backgroundColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SemiBoldText(
                mealType,
                fontSize: 16,
                textColor: const Color(0xFF091242),
              ),
              RegularText(
                time,
                fontSize: 12,
                textColor: Colors.grey.shade600,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RegularText(
                        item,
                        fontSize: 14,
                        textColor: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // Get filtered days based on selected option
  List<String> _getFilteredDays() {
    if (selectedOption == 'All') {
      return controller.availableDays;
    } else {
      // Return only the selected day if it exists in available days
      return controller.availableDays
          .where((day) => day == selectedOption)
          .toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
