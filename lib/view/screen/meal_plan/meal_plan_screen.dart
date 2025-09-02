import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/controller/optimization/optimization_controller.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/searchable_recipe_bottom_sheet.dart';
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
  String mode = 'view'; // Default mode, will be updated from arguments

  // Recipe selection state variables
  String? selectedRecipeName;
  String? selectedRecipeCode;

  // Day and timing selection state variables
  String? selectedDay;
  String? selectedTiming;

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

    // Get mode from navigation arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments['mode'] != null) {
      mode = arguments['mode'];
    }

    print(
        'MealPlanScreen initState - Using OptimizationController, mode: $mode');

    // Load menu interactions draft
    controller.getMenuInteractionsDraft();
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

                          // Search recipe field or Recipe dropdown based on mode
                          if (mode == 'edit')
                            Obx(() => _buildRecipeDropdown())
                          else
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
                                    color: Colors.grey.shade600,
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
      // Show submit button only when there are menu interactions in draft
      bottomNavigationBar: Obx(
        () => (controller.menuInteractionsList.isNotEmpty && mode == 'edit')
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Draft info
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.drafts,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${controller.menuInteractionsList.length} draft changes pending',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitDraftChanges();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Submit Draft Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDaySection(String day) {
    final menuItems = controller.getMenuForDay(day);

    // Filter menu items based on search query (only in view mode)
    final filteredMenuItems = menuItems.where((menuItem) {
      // In edit mode, don't filter by search query since we use recipe bottom sheet
      if (mode == 'edit') return true;

      if (searchQuery.isEmpty) return true;
      final recipeName =
          menuItem['Recipe_Name']?.toString().toLowerCase() ?? '';
      return recipeName.contains(searchQuery);
    }).toList();

    // Group menu items by timing
    final Map<String, List<Map<String, dynamic>>> groupedByTiming = {};
    for (var menuItem in filteredMenuItems) {
      final rawTiming = menuItem['Timings']?.toString() ?? 'Other';
      // Normalize timing to match our expected format
      final timing = _normalizeTimingName(rawTiming);
      if (!groupedByTiming.containsKey(timing)) {
        groupedByTiming[timing] = [];
      }
      groupedByTiming[timing]!.add(menuItem);
    }

    // Define timing order for consistent display
    final timingOrder = ['Breakfast', 'Lunch', 'Snacks', 'Dinner', 'Other'];
    final sortedTimings = groupedByTiming.keys.toList();
    sortedTimings.sort((a, b) {
      final indexA = timingOrder.indexOf(a);
      final indexB = timingOrder.indexOf(b);
      if (indexA == -1 && indexB == -1) return a.compareTo(b);
      if (indexA == -1) return 1;
      if (indexB == -1) return -1;
      return indexA.compareTo(indexB);
    });

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

        // Dynamic meal items grouped by timing
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
                    mode == 'edit'
                        ? 'No meals planned for $day. Select a recipe above to add meals.'
                        : searchQuery.isEmpty
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
          ...sortedTimings.map((timing) {
            final timingMeals = groupedByTiming[timing]!;
            return _buildTimingSection(timing, timingMeals, day);
          }).toList(),
      ],
    );
  }

  Widget _buildTimingSection(
      String timing, List<Map<String, dynamic>> timingMeals, String day) {
    // Get timing-specific colors and icons
    Color timingColor = _getTimingColor(timing);
    IconData timingIcon = _getTimingIcon(timing);

    // Capitalize the timing properly
    String displayTiming = _capitalizeFirst(timing);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timing header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: timingColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: timingColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  timingIcon,
                  color: timingColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                SemiBoldText(
                  displayTiming,
                  fontSize: 14,
                  textColor: timingColor,
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: timingColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${timingMeals.length}',
                    style: TextStyle(
                      color: timingColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Meals for this timing
          ...timingMeals
              .map((menuItem) => _buildMealItem(
                    '${AppConstants.BASE_URL_IMAGE}${menuItem['Recipe_Code']}.jpg',
                    menuItem['Recipe_Name']?.toString() ?? 'Unknown Recipe',
                    '${menuItem['Portion']?.toString() ?? '0'} ${menuItem['Description']?.toString() ?? ''}',
                    '${(menuItem['Recipe_Weight']?.toDouble() ?? 0.0).toInt()}gms',
                    mode,
                    menuItem,
                    day,
                  ))
              .toList(),
        ],
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _normalizeTimingName(String rawTiming) {
    // Convert to lowercase for comparison and then to proper case
    final normalized = rawTiming.toLowerCase().trim();

    switch (normalized) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'snacks':
      case 'snack':
        return 'Snacks';
      case 'dinner':
        return 'Dinner';
      default:
        return 'Other';
    }
  }

  Color _getTimingColor(String timing) {
    switch (timing.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFFFF9800); // Orange
      case 'lunch':
        return const Color(0xFF4CAF50); // Green
      case 'dinner':
        return const Color(0xFF2196F3); // Blue
      case 'snacks':
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF607D8B); // Blue Grey
    }
  }

  IconData _getTimingIcon(String timing) {
    switch (timing.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny;
      case 'lunch':
        return Icons.wb_sunny_outlined;
      case 'dinner':
        return Icons.nightlight;
      case 'snacks':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildMealItem(String imagePath, String foodName, String quantity,
      String weight, String mode, Map<String, dynamic> menuItem, String day) {
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
                // Only show close icon in edit mode
                if (mode == 'edit')
                  GestureDetector(
                    onTap: () {
                      _showRemoveConfirmationDialog(menuItem, day);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.red.shade400,
                      size: 20,
                    ),
                  ),
                if (mode == 'edit') const SizedBox(height: 8),
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

  // Submit draft changes
  void _submitDraftChanges() {
    // Show confirmation dialog
    Get.dialog(
      AlertDialog(
        title: Text(
          'Submit Draft Changes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF091242),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have ${controller.menuInteractionsList.length} pending changes:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            // Show summary of changes
            Container(
              constraints: BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.menuInteractionsList.map((interaction) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: interaction.isAddInteraction
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: interaction.isAddInteraction
                              ? Colors.green.shade200
                              : Colors.red.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            interaction.isAddInteraction
                                ? Icons.add_circle_outline
                                : Icons.remove_circle_outline,
                            color: interaction.isAddInteraction
                                ? Colors.green.shade600
                                : Colors.red.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${interaction.status} ${interaction.recipeCode} - ${interaction.dayDisplayName} ${interaction.timingDisplayName}',
                              style: TextStyle(
                                fontSize: 12,
                                color: interaction.isAddInteraction
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Do you want to submit these changes?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performRemoveDrafts();
            },
            child: Text(
              'Remove Drafts',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performSubmitDraftChanges();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Perform actual submit operation
  void _performSubmitDraftChanges() async {
    bool isDialogOpen = false;

    try {
      // Show loading dialog
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Submitting changes...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
      isDialogOpen = true;

      // Call the actual API to submit draft changes
      final result = await controller.submitMenuInteractionsDraft();

      // Close loading dialog
      if (isDialogOpen && Get.isDialogOpen == true) {
        Get.back();
        isDialogOpen = false;
      }

      if (result['success'] == true) {
        // Show success message
        Get.snackbar(
          'Success',
          result['message'] ?? 'Draft changes submitted successfully!',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
          ),
        );

        // Refresh data after successful submission
        await controller.getMenuInteractionsDraft();
      } else {
        // Show error message from API
        Get.snackbar(
          'Error',
          result['message'] ??
              'Failed to submit draft changes. Please try again.',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.error,
            color: Colors.red.shade600,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (isDialogOpen && Get.isDialogOpen == true) {
        Get.back();
        isDialogOpen = false;
      }

      print('Exception in _performSubmitDraftChanges: $e');

      // Show error message
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red.shade600,
        ),
      );
    } finally {
      // Final safety check to ensure dialog is closed
      if (isDialogOpen && Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          print('Error closing dialog in finally block: $e');
        }
      }
    }
  }

  // Perform remove drafts operation
  void _performRemoveDrafts() async {
    bool isDialogOpen = false;

    try {
      // Show loading dialog
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Removing drafts...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
      isDialogOpen = true;

      // Call the API to remove drafts
      final result = await controller.removeDraftInteractions();

      // Close loading dialog
      if (isDialogOpen && Get.isDialogOpen == true) {
        Get.back();
        isDialogOpen = false;
      }

      if (result['success'] == true) {
        // Show success message
        Get.snackbar(
          'Success',
          result['message'] ?? 'Draft changes removed successfully!',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
          ),
        );

        // Refresh data after successful removal
        await controller.getMenuInteractionsDraft();
      } else {
        // Show error message from API
        Get.snackbar(
          'Error',
          result['message'] ??
              'Failed to remove draft changes. Please try again.',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.error,
            color: Colors.red.shade600,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (isDialogOpen && Get.isDialogOpen == true) {
        Get.back();
        isDialogOpen = false;
      }

      print('Exception in _performRemoveDrafts: $e');

      // Show error message
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red.shade600,
        ),
      );
    } finally {
      // Final safety check to ensure dialog is closed
      if (isDialogOpen && Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          print('Error closing dialog in finally block: $e');
        }
      }
    }
  }

  // Show remove confirmation dialog
  void _showRemoveConfirmationDialog(
      Map<String, dynamic> menuItem, String day) {
    final recipeName = menuItem['Recipe_Name']?.toString() ?? 'Unknown Recipe';
    final timing = menuItem['Timings']?.toString() ?? '';

    Get.dialog(
      AlertDialog(
        title: Text(
          'Remove Recipe',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF091242),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to remove this recipe from your meal plan?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            // Recipe details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        color: Colors.red.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recipeName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.red.shade600,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$day - $timing',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performRemoveMenuItem(menuItem, day);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Remove',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Perform remove menu item operation
  void _performRemoveMenuItem(Map<String, dynamic> menuItem, String day) async {
    bool isDialogOpen = false;

    try {
      final recipeCode = menuItem['Recipe_Code']?.toString() ?? '';
      final timing = menuItem['Timings']?.toString() ?? '';

      if (recipeCode.isEmpty) {
        Get.snackbar(
          'Error',
          'Cannot remove recipe: Recipe code not found',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.error,
            color: Colors.red.shade600,
          ),
        );
        return;
      }

      // Show loading dialog
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Removing recipe...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
      isDialogOpen = true;

      // Call the API to remove menu interaction
      final result = await controller.removeMenuInteraction(
        weekNo: controller.currentWeekNo.value,
        recipeCode: recipeCode,
        day: day,
        timings: timing,
      );

      // Close loading dialog
      if (isDialogOpen && Get.isDialogOpen == true) {
        Get.back();
        isDialogOpen = false;
      }

      if (result['success'] == true) {
        // Show success message
        Get.snackbar(
          'Success',
          result['message'] ?? 'Recipe removed from meal plan successfully!',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
          ),
        );

        // Refresh data after successful removal
        await controller.getMenuInteractionsDraft();
      } else {
        // Show error message from API
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to remove recipe. Please try again.',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.error,
            color: Colors.red.shade600,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (isDialogOpen && Get.isDialogOpen == true) {
        Get.back();
        isDialogOpen = false;
      }

      print('Exception in _performRemoveMenuItem: $e');

      // Show error message
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red.shade600,
        ),
      );
    } finally {
      // Final safety check to ensure dialog is closed
      if (isDialogOpen && Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          print('Error closing dialog in finally block: $e');
        }
      }
    }
  }

  // Show day and timing selection bottom sheet
  void _showDayTimingSelectionSheet(String recipeName, String recipeCode) {
    print(
        '_showDayTimingSelectionSheet called with recipeName: $recipeName, recipeCode: $recipeCode');

    // Reset selections
    selectedDay = null;
    selectedTiming = null;
    bool isAddingInteraction = false;

    final availableDays = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    final timingOptions = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

    print('About to call showModalBottomSheet for timing selection');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false, // Prevent dismissing while API is loading
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SemiBoldText(
                              'Add Recipe into',
                              fontSize: 18,
                              textColor: Colors.black87,
                            ),
                            const SizedBox(height: 4),
                            RegularText(
                              recipeName,
                              fontSize: 14,
                              textColor: Colors.grey.shade600,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (!isAddingInteraction) // Hide close button when loading
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Day Selection
                        SemiBoldText(
                          'Select Day',
                          fontSize: 16,
                          textColor: Colors.black87,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: availableDays.map((day) {
                            final isSelected = selectedDay == day;
                            return GestureDetector(
                              onTap: isAddingInteraction
                                  ? null
                                  : () {
                                      setModalState(() {
                                        selectedDay = day;
                                      });
                                    },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: RegularText(
                                  day,
                                  fontSize: 12,
                                  textColor: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // Timing Selection
                        SemiBoldText(
                          'Timing',
                          fontSize: 16,
                          textColor: Colors.black87,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: timingOptions.map((timing) {
                            final isSelected = selectedTiming == timing;
                            return GestureDetector(
                              onTap: isAddingInteraction
                                  ? null
                                  : () {
                                      setModalState(() {
                                        selectedTiming = timing;
                                      });
                                    },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: RegularText(
                                  timing,
                                  fontSize: 12,
                                  textColor: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 32),

                        // Add Interaction Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: (selectedDay != null &&
                                    selectedTiming != null &&
                                    !isAddingInteraction)
                                ? () async {
                                    setModalState(() {
                                      isAddingInteraction = true;
                                    });

                                    // Call the API
                                    final result =
                                        await controller.addMenuInteraction(
                                      weekNo: controller.currentWeekNo.value,
                                      recipeCode: recipeCode,
                                      day: selectedDay!,
                                      timings: selectedTiming!,
                                    );

                                    setModalState(() {
                                      isAddingInteraction = false;
                                    });

                                    if (result['success']) {
                                      Navigator.pop(context);
                                      // Clear selected recipe
                                      if (mounted) {
                                        setState(() {
                                          selectedRecipeName = null;
                                          selectedRecipeCode = null;
                                        });
                                      }
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (selectedDay != null &&
                                      selectedTiming != null &&
                                      !isAddingInteraction)
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isAddingInteraction
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SemiBoldText(
                                        'Adding...',
                                        fontSize: 16,
                                        textColor: Colors.white,
                                      ),
                                    ],
                                  )
                                : SemiBoldText(
                                    'Add Interaction',
                                    fontSize: 16,
                                    textColor: Colors.white,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Build recipe dropdown for edit mode
  Widget _buildRecipeDropdown() {
    final hasRecipes = controller.recipeList.isNotEmpty;

    return GestureDetector(
      onTap: hasRecipes
          ? () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SearchableRecipeBottomSheet(
                  title: 'Select Recipe',
                  selectedValue: selectedRecipeName,
                  recipeList: controller
                      .recipeList, // Use OptimizationController recipe list
                  onSelected: (String? selectedValue, String? selectedCode,
                      String? recipeDescription) async {
                    print(
                        'Selected recipe 123: $selectedValue, code: $selectedCode');

                    if (mounted) {
                      setState(() {
                        selectedRecipeName = selectedValue;
                        selectedRecipeCode = selectedCode;
                      });
                    }
                    print(
                        'Selected recipe: $selectedValue, code: $selectedCode');

                    // Show day and timing selection bottom sheet
                    if (selectedCode != null) {
                      print(
                          'About to show day timing sheet with recipe: $selectedValue, code: $selectedCode');

                      // Wait for the current modal to fully close first
                      await Future.delayed(const Duration(milliseconds: 500));

                      if (mounted && context.mounted) {
                        print('Context is still mounted, showing timing sheet');
                        _showDayTimingSelectionSheet(
                            selectedValue!, selectedCode);
                      } else {
                        _showDayTimingSelectionSheet(
                            selectedValue!, selectedCode);
                        print('Context not mounted, cannot show timing sheet');
                      }
                    } else {
                      print('selectedCode is null, cannot show timing sheet');
                    }
                  },
                  searchHint: 'Search for recipes',
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: hasRecipes ? const Color(0xFFF5F5F5) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              hasRecipes ? Icons.restaurant_menu : Icons.hourglass_empty,
              color: Colors.grey.shade500,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                !hasRecipes
                    ? 'Loading recipes...'
                    : selectedRecipeName?.isNotEmpty == true
                        ? selectedRecipeName!
                        : 'Select recipe to add',
                style: TextStyle(
                  color: !hasRecipes
                      ? Colors.grey.shade500
                      : selectedRecipeName?.isNotEmpty == true
                          ? Colors.black87
                          : Colors.grey.shade600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasRecipes)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedRecipeName?.isNotEmpty == true)
                    GestureDetector(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            selectedRecipeName = null;
                            selectedRecipeCode = null;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.clear,
                          color: Colors.grey.shade500,
                          size: 18,
                        ),
                      ),
                    ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
