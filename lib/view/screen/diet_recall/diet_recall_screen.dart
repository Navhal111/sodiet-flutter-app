import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/model/diet_recall_model.dart';
import 'package:sodiet/model/recipe_model.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/utils/images.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';
import 'package:sodiet/view/widgets/common/searchable_recipe_bottom_sheet.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';
import 'package:sodiet/view/widgets/diet_recall/diet_entry_card_widget.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/chart/intake_overview_chart.dart';
import 'package:sodiet/view/widgets/common/shimmer_loading.dart';

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
  final FocusNode _quantityFocusNode = FocusNode();

  // Edit dialog controllers and notifiers
  late TextEditingController _editDateController;
  late TextEditingController _editQuantityController;
  late ValueNotifier<String> _editTimingNotifier;
  late ValueNotifier<String> _editUnitNotifier;
  late ValueNotifier<String?> _editRecipeKeyNotifier;
  late ValueNotifier<String?> _editRecipeValueNotifier;

  var dietController = Get.find<DietController>();

  // Use ValueNotifiers to prevent full rebuilds
  final ValueNotifier<String> selectedTimingNotifier =
      ValueNotifier('Breakfast');
  final ValueNotifier<String> selectedUnitNotifier = ValueNotifier('Grams');
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

  // Dynamic unit options based on selected recipe
  List<Map<String, dynamic>> get unitOptions {
    List<Map<String, dynamic>> units = [
      {'label': 'Grams', 'icon': 'assets/units/piece.png'}, // Static option
    ];

    // Add dynamic unit from selected recipe's Recipe_Description
    if (selectedRecipeKey != null) {
      final selectedRecipe = dietController.recipeList
          .firstWhereOrNull((recipe) => recipe.recipeCode == selectedRecipeKey);
      if (selectedRecipe != null &&
          selectedRecipe.recipeDescription.isNotEmpty) {
        String dynamicUnit = selectedRecipe.recipeDescription;
        // Capitalize first letter
        dynamicUnit = dynamicUnit[0].toUpperCase() +
            dynamicUnit.substring(1).toLowerCase();

        units.insert(0, {
          'label': dynamicUnit,
          'icon': 'assets/units/cup.png', // You can change this icon as needed
        });
      }
    }

    return units;
  }

  @override
  void initState() {
    super.initState();
    // Set today's date by default
    _dateController.text = DateTime.now().toString().split(' ')[0];
    dietController.getDietRecallList();
    dietController.getRecipes(); // Fetch recipes from API
    dietController.getIntakeOverview(); // Fetch intake overview data

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
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

  // Pagination scroll listener for main scroll controller
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !dietController.isLoadingMore.value &&
        dietController.hasMoreData.value) {
      dietController.loadMoreDietRecalls();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return BaseScreenLayout(
      currentRoute: AppRoutes.dietRecallScreen,
      title: 'Diet Recall',
      child: Obx(() => Column(
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
                    // Handle pagination when reaching near bottom
                    if (scrollNotification is ScrollUpdateNotification) {
                      _onScroll();
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
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

                        // Intake Overview Chart
                        Container(
                          key: const ValueKey(
                              'intake_chart_section'), // Stable key
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Obx(() {
                            if (dietController.isLoadingIntakeOverview.value) {
                              return ShimmerChart(
                                width: double.infinity,
                                height: 300,
                                title: 'Intake Overview',
                              );
                            }

                            return IntakeOverviewChart(
                              intakeData: dietController.intakeOverviewChart,
                              title: 'Intake Overview',
                              titleColor: const Color(0xFF091242),
                              titleFontSize: 22,
                            );
                          }),
                        ),

                        const SizedBox(height: 20),

                        // List Section - completely separate
                        Container(
                          key: const ValueKey('list_section'), // Stable key
                          child: _buildDietEntriesList(),
                        ),

                        const SizedBox(
                            height: 100), // Extra padding for keyboard
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
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
            key: const ValueKey('quantity_field'),
            child: CustomTextField(
              controller: _quantityController,
              labelText: '',
              hintText: 'Enter quantity',
              textInputType: TextInputType.number,
              focusNode: _quantityFocusNode,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                _quantityFocusNode.unfocus();
              },
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
    final isLoadingRecipes = dietController.isLoadingRecipes.value;

    if (isLoadingRecipes) {
      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColorDark,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading recipes...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ValueListenableBuilder<String?>(
      valueListenable: selectedRecipeValueNotifier,
      builder: (context, selectedRecipeValue, child) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SearchableRecipeBottomSheet(
                title: 'Select Recipe',
                selectedValue: selectedRecipeValue,
                onSelected: (String? selectedValue, String? selectedCode) {
                  selectedRecipeValueNotifier.value = selectedValue;
                  selectedRecipeKeyNotifier.value = selectedCode;

                  // Reset unit selection and set default based on new recipe
                  if (selectedValue != null) {
                    // We don't have recipe description from API search, so default to Grams
                    selectedUnitNotifier.value = 'Grams';
                  }
                },
                searchHint: 'Search for recipes or browse all',
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedRecipeValue ?? 'Select a recipe',
                    style: TextStyle(
                      color: selectedRecipeValue != null
                          ? const Color(0xFF091242)
                          : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUnitsSelection() {
    return ValueListenableBuilder<String>(
      valueListenable: selectedUnitNotifier,
      builder: (context, selectedUnit, child) {
        // Also listen to recipe changes to rebuild units
        return ValueListenableBuilder<String?>(
          valueListenable: selectedRecipeKeyNotifier,
          builder: (context, selectedRecipeKey, child) {
            final currentUnitOptions = unitOptions; // Get dynamic options

            // Ensure selected unit is valid for current options
            if (!currentUnitOptions
                .any((unit) => unit['label'] == selectedUnit)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (currentUnitOptions.isNotEmpty) {
                  selectedUnitNotifier.value =
                      currentUnitOptions.first['label'];
                }
              });
            }

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: currentUnitOptions.map((unit) {
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
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).primaryColorDark,
                              width: 2)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Image.asset(
                            unit['icon'],
                            width: 16,
                            height: 16,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.category,
                                size: 16,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: RegularText(
                            unit['label'],
                            fontSize: 10,
                            textColor: Colors.black87,
                            overflow: TextOverflow.ellipsis,
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
      },
    );
  }

  Widget _buildAddButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      width: double.infinity,
      height: 40,
      child: Obx(() => ElevatedButton(
            onPressed: dietController.isLoading.value
                ? null
                : () async {
                    // Dismiss keyboard first
                    FocusScope.of(context).unfocus();

                    if (_dateController.text.isNotEmpty &&
                        selectedRecipeKey != null &&
                        selectedRecipeValue != null &&
                        _quantityController.text.isNotEmpty) {
                      // Show loading toast
                      CustomToast.showLoading('Adding diet entry...');

                      // Add entry to list - send proper recipe code as food_name
                      final result = await dietController.addDietRecall({
                        'entry_date': _dateController.text,
                        'time_of_day': selectedTiming.toLowerCase(),
                        'food_name':
                            selectedRecipeKey, // This is the recipe code (A000002, etc.)
                        'food_qty': _quantityController.text,
                        'unit': selectedUnit.toLowerCase(),
                      });

                      // Show result toast
                      if (result['success']) {
                        CustomToast.showSuccess(result['message']);

                        // Clear form on success
                        selectedRecipeKeyNotifier.value = null;
                        selectedRecipeValueNotifier.value = null;
                        _quantityController.clear();

                        // Ensure keyboard stays dismissed
                        _quantityFocusNode.unfocus();
                      } else {
                        CustomToast.showError(result['message']);
                      }
                    } else {
                      CustomToast.showWarning(
                          'Please fill all required fields');
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: dietController.isLoading.value
                  ? Colors.grey
                  : const Color(0xFFFF9800),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: dietController.isLoading.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Adding...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          )),
    );
  }

  // Custom delete confirmation dialog
  void _showDeleteConfirmation(String recallId, String recipeName) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: const Color(0xFFF44336),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Delete Entry',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this diet entry?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: Theme.of(context).primaryColorDark,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recipeName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Obx(() => ElevatedButton(
                onPressed: dietController.isLoading.value
                    ? null
                    : () async {
                        Get.back(); // Close dialog first

                        // Show loading toast
                        CustomToast.showLoading('Deleting diet entry...');

                        // Call delete API
                        final result =
                            await dietController.deleteDietRecall(recallId);

                        // Show result toast
                        if (result['success']) {
                          CustomToast.showSuccess(result['message']);
                        } else {
                          CustomToast.showError(result['message']);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dietController.isLoading.value
                      ? Colors.grey
                      : const Color(0xFFF44336),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: dietController.isLoading.value
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              )),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildDietEntriesList() {
    final dietRecalls = dietController.dietRecallList;
    final recipes = dietController.recipeList;

    return Container(
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
        children: [
          // Header section
          if (dietRecalls.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  SemiBoldText(
                    'Recall All Records (${dietController.dietRecallListResponse!.totalCount})',
                    fontSize: 16,
                    textColor: Colors.grey.shade800,
                  ),
                ],
              ),
            ),

          // Non-scrollable ListView that expands to fit content
          dietRecalls.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true, // Let ListView fit its content
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable ListView scrolling
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: dietRecalls.length +
                      (dietController.hasMoreData.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the bottom when loading more
                    if (index == dietRecalls.length) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: dietController.isLoadingMore.value
                              ? Column(
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    RegularText(
                                      'Loading more...',
                                      fontSize: 12,
                                      textColor: Colors.grey.shade600,
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      );
                    }

                    final entry = dietRecalls[index];
                    return _buildDietEntryItem(entry, recipes, index);
                  },
                )
              : _buildEmptyState(),
        ],
      ),
    );
  }

  // Custom edit dialog
  void _showEditDialog(DietRecall entry) {
    // Initialize controllers with current data
    _editDateController = TextEditingController(text: entry.entryDate);
    _editQuantityController =
        TextEditingController(text: entry.foodQty.toString());
    _editTimingNotifier =
        ValueNotifier(entry.timeOfDay.capitalize ?? 'Breakfast');

    // Properly initialize unit with capitalized value
    String currentUnit = entry.unit;
    if (currentUnit.isNotEmpty) {
      currentUnit =
          currentUnit[0].toUpperCase() + currentUnit.substring(1).toLowerCase();
    }
    _editUnitNotifier =
        ValueNotifier(currentUnit.isNotEmpty ? currentUnit : 'Grams');

    _editRecipeKeyNotifier = ValueNotifier(entry.foodName);

    // Find the recipe name for display
    final selectedRecipe = dietController.recipeList
        .firstWhereOrNull((recipe) => recipe.recipeCode == entry.foodName);
    _editRecipeValueNotifier = ValueNotifier(selectedRecipe?.recipeName);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
            maxWidth: MediaQuery.of(Get.context!).size.width * 0.9,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Theme.of(Get.context!).primaryColorDark,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Edit Diet Entry',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.back();
                      _disposeEditControllers();
                    },
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Field
                      SemiBoldText(
                        'Date',
                        fontSize: 14,
                        textColor: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: Get.context!,
                            initialDate:
                                DateTime.tryParse(_editDateController.text) ??
                                    DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _editDateController.text =
                                picked.toString().split(' ')[0];
                          }
                        },
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _editDateController,
                            labelText: '',
                            hintText: 'Select date',
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Timing Section
                      SemiBoldText(
                        'Timing',
                        fontSize: 14,
                        textColor: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      _buildEditTimingSelection(),

                      const SizedBox(height: 16),

                      // Recipe Field
                      SemiBoldText(
                        'Recipe',
                        fontSize: 14,
                        textColor: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      _buildEditRecipeDropdown(),

                      const SizedBox(height: 16),

                      // Quantity Field
                      SemiBoldText(
                        'Quantity',
                        fontSize: 14,
                        textColor: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _editQuantityController,
                        labelText: '',
                        hintText: 'Enter quantity',
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),

                      const SizedBox(height: 16),

                      // Units Section
                      SemiBoldText(
                        'Units',
                        fontSize: 14,
                        textColor: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      _buildEditUnitsSelection(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                        _disposeEditControllers();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                          onPressed: dietController.isLoading.value
                              ? null
                              : () async {
                                  await _handleEditSubmit(entry.recallId);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dietController.isLoading.value
                                ? Colors.grey
                                : Theme.of(Get.context!).primaryColorDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: dietController.isLoading.value
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildEditTimingSelection() {
    return ValueListenableBuilder<String>(
      valueListenable: _editTimingNotifier,
      builder: (context, selectedTiming, child) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: timingOptions.map((timing) {
            final isSelected = selectedTiming == timing['label'];
            return GestureDetector(
              onTap: () {
                _editTimingNotifier.value = timing['label'];
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 120) / 4,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColorDark
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
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
                            size: 16,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    RegularText(
                      timing['label'],
                      fontSize: 10,
                      textColor: isSelected ? Colors.white : Colors.black87,
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

  Widget _buildEditRecipeDropdown() {
    final isLoadingRecipes = dietController.isLoadingRecipes.value;

    if (isLoadingRecipes) {
      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(Get.context!).primaryColorDark,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading recipes...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ValueListenableBuilder<String?>(
      valueListenable: _editRecipeValueNotifier,
      builder: (context, selectedRecipeValue, child) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SearchableRecipeBottomSheet(
                title: 'Select Recipe',
                selectedValue: selectedRecipeValue,
                onSelected: (String? selectedValue, String? selectedCode) {
                  _editRecipeValueNotifier.value = selectedValue;
                  _editRecipeKeyNotifier.value = selectedCode;

                  // Reset unit selection and set default based on new recipe
                  if (selectedValue != null) {
                    // We don't have recipe description from API search, so default to Grams
                    _editUnitNotifier.value = 'Grams';
                  }
                },
                searchHint: 'Search for recipes or browse all',
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedRecipeValue ?? 'Select a recipe',
                    style: TextStyle(
                      color: selectedRecipeValue != null
                          ? const Color(0xFF091242)
                          : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Dynamic unit options based on selected recipe for edit dialog
  List<Map<String, dynamic>> getEditUnitOptions() {
    List<Map<String, dynamic>> units = [
      {'label': 'Grams', 'icon': 'assets/units/piece.png'}, // Static option
    ];

    // Add dynamic unit from selected recipe's Recipe_Description
    if (_editRecipeKeyNotifier.value != null) {
      final selectedRecipe = dietController.recipeList.firstWhereOrNull(
          (recipe) => recipe.recipeCode == _editRecipeKeyNotifier.value);
      if (selectedRecipe != null &&
          selectedRecipe.recipeDescription.isNotEmpty) {
        String dynamicUnit = selectedRecipe.recipeDescription;
        // Capitalize first letter
        dynamicUnit = dynamicUnit[0].toUpperCase() +
            dynamicUnit.substring(1).toLowerCase();

        units.insert(0, {
          'label': dynamicUnit,
          'icon': 'assets/units/cup.png', // You can change this icon as needed
        });
      }
    }

    return units;
  }

  Widget _buildEditUnitsSelection() {
    return ValueListenableBuilder<String>(
      valueListenable: _editUnitNotifier,
      builder: (context, selectedUnit, child) {
        // Also listen to recipe changes to rebuild units in edit dialog
        return ValueListenableBuilder<String?>(
          valueListenable: _editRecipeKeyNotifier,
          builder: (context, selectedRecipeKey, child) {
            final currentUnitOptions =
                getEditUnitOptions(); // Get dynamic options

            // Ensure selected unit is valid for current options
            if (!currentUnitOptions
                .any((unit) => unit['label'] == selectedUnit)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (currentUnitOptions.isNotEmpty) {
                  _editUnitNotifier.value = currentUnitOptions.first['label'];
                }
              });
            }

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: currentUnitOptions.map((unit) {
                final isSelected = selectedUnit == unit['label'];

                return GestureDetector(
                  onTap: () {
                    _editUnitNotifier.value = unit['label'];
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 120) / 3,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).primaryColorDark,
                              width: 2)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          child: Image.asset(
                            unit['icon'],
                            width: 16,
                            height: 16,
                            color: Theme.of(context).primaryColorDark,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.restaurant,
                                color: Theme.of(context).primaryColorDark,
                                size: 16,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: RegularText(
                            unit['label'],
                            fontSize: 10,
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
      },
    );
  }

  Future<void> _handleEditSubmit(String recallId) async {
    if (_editDateController.text.isNotEmpty &&
        _editRecipeKeyNotifier.value != null &&
        _editRecipeValueNotifier.value != null &&
        _editQuantityController.text.isNotEmpty) {
      Get.back(); // Close dialog first
      CustomToast.showLoading('Updating diet entry...');

      // Update entry
      final result = await dietController.updateDietRecall(recallId, {
        'entry_date': _editDateController.text,
        'time_of_day': _editTimingNotifier.value.toLowerCase(),
        'food_name': _editRecipeKeyNotifier.value,
        'food_qty': _editQuantityController.text,
        'unit': _editUnitNotifier.value.toLowerCase(),
      });

      // Show result toast
      if (result['success']) {
        CustomToast.showSuccess(result['message']);
      } else {
        CustomToast.showError(result['message']);
      }

      _disposeEditControllers();
    } else {
      CustomToast.showWarning('Please fill all required fields');
    }
  }

  void _disposeEditControllers() {
    _editDateController.dispose();
    _editQuantityController.dispose();
    _editTimingNotifier.dispose();
    _editUnitNotifier.dispose();
    _editRecipeKeyNotifier.dispose();
    _editRecipeValueNotifier.dispose();
  }

  // Optimized method for building individual items with index
  Widget _buildDietEntryItem(
      DietRecall entry, List<Recipe> recipes, int index) {
    final foodName = entry.recipeName;
    final quantity = entry.foodQty;
    final unit = entry.unit;
    final recallId = entry.recallId;

    // Cache recipe lookup to avoid repeated searches
    final displayName = _getCachedRecipeName(foodName, recipes);

    return Container(
      key: ValueKey('diet_entry_$index'), // Stable key for better performance
      child: DietEntryCardWidget(
        title: displayName,
        imagePath: MyImages.food1,
        onTap: () {
          // Handle card tap
          CustomToast.showInfo('You tapped on $displayName');
        },
        subtitle: "$quantity $unit",
        onEdit: () {
          // Show edit dialog
          _showEditDialog(entry);
        },
        onDelete: () {
          // Show delete confirmation dialog
          _showDeleteConfirmation(recallId, displayName);
        },
      ),
    );
  }

  // Cache for recipe names to avoid repeated lookups
  final Map<String, String> _recipeNameCache = {};

  String _getCachedRecipeName(String foodName, List<Recipe> recipes) {
    if (_recipeNameCache.containsKey(foodName)) {
      return _recipeNameCache[foodName]!;
    }

    final selectedRecipe =
        recipes.firstWhereOrNull((recipe) => recipe.recipeCode == foodName);
    final displayName = selectedRecipe?.recipeName ?? foodName;

    _recipeNameCache[foodName] = displayName;
    return displayName;
  }

  Widget _buildEmptyState() {
    return Container(
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
    );
  }
}
