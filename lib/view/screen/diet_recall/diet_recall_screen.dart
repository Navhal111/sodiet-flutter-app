import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/staticData.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';
import 'package:sodiet/view/widgets/diet_recall/diet_entry_card_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';

import '../../../controller/diet/dietController.dart';

class DietRecallScreen extends StatefulWidget {
  const DietRecallScreen({Key? key}) : super(key: key);

  @override
  State<DietRecallScreen> createState() => _DietRecallScreenState();
}

class _DietRecallScreenState extends State<DietRecallScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _quantityFocusNode =
      FocusNode(); // Add focus node for quantity field

  var dietController = Get.find<DietController>();

  // Use ValueNotifiers to prevent full rebuilds
  final ValueNotifier<String> selectedTimingNotifier =
      ValueNotifier('Breakfast');
  final ValueNotifier<String> selectedUnitNotifier = ValueNotifier('Cup');
  final ValueNotifier<String?> selectedRecipeKeyNotifier = ValueNotifier(null);
  final ValueNotifier<String?> selectedRecipeValueNotifier =
      ValueNotifier(null);

  // Getters for backward compatibility
  String get selectedTiming => selectedTimingNotifier.value;
  String get selectedUnit => selectedUnitNotifier.value;
  String? get selectedRecipeKey => selectedRecipeKeyNotifier.value;
  String? get selectedRecipeValue => selectedRecipeValueNotifier.value;

  @override
  bool get wantKeepAlive => true;

  final List<Map<String, dynamic>> timingOptions = [
    {'label': 'Breakfast', 'icon': 'assets/icons/breakfast.png'},
    {'label': 'Lunch', 'icon': 'assets/icons/lunch.png'},
    {'label': 'Dinner', 'icon': 'assets/icons/dinner.png'},
    {'label': 'Snacks', 'icon': 'assets/icons/snaks.png'},
  ];
  final List<Map<String, dynamic>> unitOptions = [
    {'label': 'Cup', 'icon': 'assets/units/cup.png'},
    {'label': 'Bowl', 'icon': 'assets/units/bowl.png'},
    {'label': 'Tsp', 'icon': 'assets/units/Moon.png'}, // Using Moon.png for Tsp
    {'label': 'Tbsp', 'icon': 'assets/units/tbsp.png'},
    {'label': 'Glass', 'icon': 'assets/units/glass.png'},
    {'label': 'Pieces', 'icon': 'assets/units/piece.png'},
  ];

  @override
  void initState() {
    super.initState();
    // Set today's date by default
    _dateController.text = DateTime.now().toString().split(' ')[0];
    dietController.getDietRecallList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _dateController.dispose();
    _quantityController.dispose();
    _quantityFocusNode.dispose(); // Dispose focus node
    selectedTimingNotifier.dispose();
    selectedUnitNotifier.dispose();
    selectedRecipeKeyNotifier.dispose();
    selectedRecipeValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return BaseScreenLayout(
      currentRoute: AppRoutes.dietRecallScreen,
      title: 'Diet Recall',
      child: Column(
        children: [
          // Fixed Header - Non-scrollable
          Container(
            color: Theme.of(context).cardColor,
            child: TitleSectionWidget(
              imagePath: 'assets/images/combinations.png',
              title: 'Diet Recall',
              description:
                  'Recall your daily diet and track your food intake to maintain a healthy and balanced diet.',
              imageWidth: 60,
              imageHeight: 60,
            ),
          ),

          const SizedBox(height: 16),

          // Scrollable Content with stable structure
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                // Prevent auto-scroll on setState
                return false;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,
                child: Column(
                  key: const ValueKey('main_content'), // Stable key
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Section with stable structure
                    Container(
                      key: const ValueKey('form_section'), // Stable key
                      child: _buildFormSection(),
                    ),

                    const SizedBox(height: 20),

                    // List Section - completely separate
                    Container(
                      key: const ValueKey('list_section'), // Stable key
                      child: _buildDietEntriesList(),
                    ),

                    const SizedBox(height: 100), // Extra padding for keyboard
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SemiBoldText(
            'Add New Entry',
            fontSize: 18,
            textColor: Colors.black87,
          ),
          const SizedBox(height: 8),

          // Date Field
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _dateController.text = picked.toString().split(' ')[0];
              }
            },
            child: AbsorbPointer(
              child: CustomTextField(
                controller: _dateController,
                labelText: 'Date',
                hintText: 'Select date',
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Timing Section
          SemiBoldText(
            'Timing',
            fontSize: 16,
            textColor: Colors.black87,
          ),
          const SizedBox(height: 12),
          _buildTimingSelection(),

          const SizedBox(height: 8),

          // Recipe Field (Dropdown)
          SemiBoldText(
            'Recipe',
            fontSize: 16,
            textColor: Colors.black87,
          ),
          const SizedBox(height: 8),
          _buildRecipeDropdown(),

          const SizedBox(height: 8),
          // Quantity Field
          SemiBoldText(
            'Quantity',
            fontSize: 16,
            textColor: Colors.black87,
          ),
          const SizedBox(height: 8),
          Container(
            key: const ValueKey(
                'quantity_field'), // Stable key to prevent rebuilds
            child: CustomTextField(
              controller: _quantityController,
              labelText: '',
              hintText: 'Quantity',
              textInputType: TextInputType.number,
              focusNode:
                  _quantityFocusNode, // Add focus node to maintain keyboard focus
            ),
          ),

          const SizedBox(height: 8),

          // Units Section
          SemiBoldText(
            'Units',
            fontSize: 16,
            textColor: Colors.black87,
          ),
          const SizedBox(height: 12),
          _buildUnitsSelection(),

          const SizedBox(height: 20),

          // Add Button
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildTimingSelection() {
    return ValueListenableBuilder<String>(
      valueListenable: selectedTimingNotifier,
      builder: (context, selectedTiming, child) {
        return Row(
          children: timingOptions.map((timing) {
            final isSelected = selectedTiming == timing['label'];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  selectedTimingNotifier.value = timing['label'];
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColorDark
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Image.asset(
                          timing['icon'],
                          width: 20,
                          height: 20,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).primaryColorDark,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.restaurant,
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).primaryColorDark,
                              size: 20,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Text
                      RegularText(
                        timing['label'],
                        fontSize: 11,
                        textColor: isSelected ? Colors.white : Colors.black87,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRecipeDropdown() {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedRecipeKeyNotifier,
      builder: (context, selectedRecipeKey, child) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.8),
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedRecipeKey,
            decoration: const InputDecoration(
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            items: StaticData.RECIPES.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: RegularText(
                  entry.value,
                  fontSize: 14,
                  textColor: Colors.black87,
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              selectedRecipeKeyNotifier.value = newValue;
              selectedRecipeValueNotifier.value =
                  newValue != null ? StaticData.RECIPES[newValue] : null;
            },
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey.shade600,
              size: 20,
            ),
            dropdownColor: Colors.white,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            menuMaxHeight: 200,
          ),
        );
      },
    );
  }

  Widget _buildUnitsSelection() {
    return ValueListenableBuilder<String>(
      valueListenable: selectedUnitNotifier,
      builder: (context, selectedUnit, child) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: unitOptions.map((unit) {
            final isSelected = selectedUnit == unit['label'];

            return GestureDetector(
              onTap: () {
                selectedUnitNotifier.value = unit['label'];
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 110) / 3,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColorDark.withOpacity(0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).primaryColorDark, width: 2)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Unit Icon
                    Container(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        unit['icon'],
                        width: 20,
                        height: 20,
                        color: Theme.of(context).primaryColorDark,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.restaurant,
                            color: Theme.of(context).primaryColorDark,
                            size: 20,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Unit Label
                    Expanded(
                      child: RegularText(
                        unit['label'],
                        fontSize: 12,
                        textColor: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          if (_dateController.text.isNotEmpty &&
              selectedRecipeKey != null &&
              selectedRecipeValue != null &&
              _quantityController.text.isNotEmpty) {
            // Add entry to list
            dietController.addDietRecall({
              'entry_date': _dateController.text,
              'time_of_day': selectedTiming.toLowerCase(),
              'food_name': selectedRecipeKey,
              'foodName': selectedRecipeValue,
              'food_qty': _quantityController.text,
              'unit': selectedUnit.toLowerCase(),
            });

            // Clear form
            selectedRecipeKeyNotifier.value = null;
            selectedRecipeValueNotifier.value = null;
            _quantityController.clear();
          } else {
            Get.snackbar(
              'Error',
              'Please fill all required fields',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFF44336),
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 8,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Add',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDietEntriesList() {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: dietController.dietRecallList.isNotEmpty
                ? [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          SemiBoldText(
                            'Recall All Records (${dietController.dietRecallList.length})',
                            fontSize: 16,
                            textColor: Colors.grey.shade800,
                          ),
                        ],
                      ),
                    ),
                    // Example cards - you can customize these as needed
                    ...dietController.dietRecallList.map((entry) {
                      final foodName = entry.foodName;
                      final quantity = entry.foodQty;
                      final unit = entry.unit;
                      return DietEntryCardWidget(
                        title: StaticData.getRecipeByKey(foodName) ?? foodName,
                        imagePath: MyImages.food1,
                        onTap: () {
                          // Handle card tap - you can implement your list functionality here
                          Get.snackbar(
                            'Entry Tapped',
                            'You tapped on $foodName',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF2196F3),
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 8,
                          );
                        },
                        subtitle: "$quantity $unit",
                      );
                    }).toList(),
                  ]
                : [
                    // Empty state
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          RegularText(
                            'No diet entries yet',
                            fontSize: 16,
                            textColor: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 4),
                          RegularText(
                            'Add your first meal to get started',
                            fontSize: 14,
                            textColor: Colors.grey.shade500,
                          ),
                        ],
                      ),
                    ),
                  ],
          ),
        ));
  }
}
