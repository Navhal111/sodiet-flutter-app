import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/preference/preference_onboarding_controller.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/preference/meal_type_tabs_widget.dart';
import 'package:sodiet/view/widgets/preference/combination_form_widget.dart';
import 'package:sodiet/view/widgets/common/shimmer_loading.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/custom_text_field.dart';
import 'package:sodiet/view/widgets/custom_button.dart';
import 'package:sodiet/view/widgets/common/searchable_bottom_sheet.dart';
import 'package:sodiet/route/app_routes.dart';

class PreferenceOnboardingScreen extends StatefulWidget {
  const PreferenceOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<PreferenceOnboardingScreen> createState() =>
      _PreferenceOnboardingScreenState();
}

class _PreferenceOnboardingScreenState
    extends State<PreferenceOnboardingScreen> {
  late PreferenceOnboardingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PreferenceOnboardingController>();
  }

  void _showAddCombinationDialog() {
    // Clear temporary data when opening dialog
    controller.clearTempFoods();

    // Create a local text controller for quantity input
    final quantityController = TextEditingController();

    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          // Clean disposal when dialog is closed by back button
          try {
            quantityController.dispose();
          } catch (e) {
            print('Error disposing on back: $e');
          }
          return true;
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapping outside input fields
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: double.maxFinite,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
                minHeight: 400,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fixed Header
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
                          child: SemiBoldText(
                            'Add Combination - ${controller.selectedMealType.value}',
                            fontSize: 20,
                            textColor: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.clearTempFoods();
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add Food Form
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RegularText(
                                  'Add Food Item',
                                  fontSize: 16,
                                  textColor: Colors.black87,
                                ),
                                const SizedBox(height: 12),

                                // Recipe Selection
                                GestureDetector(
                                  onTap: () {
                                    final recipeNames = controller.recipeList
                                        .map((recipe) => recipe.recipeName)
                                        .toList();

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          SearchableBottomSheet(
                                        title: 'Select Recipe',
                                        items: recipeNames,
                                        selectedValue: controller
                                                .selectedFoodName.value.isEmpty
                                            ? null
                                            : controller.selectedFoodName.value,
                                        onSelected: (value) {
                                          controller.selectedFoodName.value =
                                              value ?? '';
                                        },
                                        searchHint: 'Search recipes...',
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Obx(() => RegularText(
                                                controller.selectedFoodName
                                                        .value.isEmpty
                                                    ? 'Select Recipe'
                                                    : controller
                                                        .selectedFoodName.value,
                                                fontSize: 14,
                                                textColor: controller
                                                        .selectedFoodName
                                                        .value
                                                        .isEmpty
                                                    ? Colors.grey.shade600
                                                    : Colors.black87,
                                              )),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey.shade600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Quantity Input
                                CustomTextField(
                                  controller: quantityController,
                                  hintText: 'Enter quantity (grams)',
                                  labelText: 'Quantity',
                                  textInputType:
                                      TextInputType.numberWithOptions(
                                          decimal: true),
                                  onChanged: (value) {
                                    controller.selectedFoodQuantity.value =
                                        value;
                                  },
                                ),

                                const SizedBox(height: 12),

                                // Add Food Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: CustomButton(
                                    text: 'Add Food',
                                    onPressed: () {
                                      // Dismiss keyboard first
                                      FocusScope.of(context).unfocus();
                                      // Then add food to list
                                      controller.addFoodToTempList();
                                      // Clear the form fields after adding
                                      quantityController.clear();
                                      controller.selectedFoodName.value = '';
                                    },
                                    backgroundColor: const Color(0xFF2196F3),
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Added Foods List
                          Container(
                            constraints: const BoxConstraints(
                              maxHeight:
                                  200, // Limit height for better keyboard handling
                              minHeight: 120,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RegularText(
                                    'Added Foods',
                                    fontSize: 16,
                                    textColor: Colors.black87,
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: Obx(() {
                                      if (controller.tempFoodsList.isEmpty) {
                                        return Center(
                                          child: RegularText(
                                            'No foods added yet',
                                            fontSize: 14,
                                            textColor: Colors.grey.shade600,
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        itemCount:
                                            controller.tempFoodsList.length,
                                        itemBuilder: (context, index) {
                                          final food =
                                              controller.tempFoodsList[index];
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey.shade200),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RegularText(
                                                        food['Food_Name']
                                                            .toString(),
                                                        fontSize: 14,
                                                        textColor:
                                                            Colors.black87,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      RegularText(
                                                        '${food['Food_Qty']}g',
                                                        fontSize: 12,
                                                        textColor: Colors
                                                            .grey.shade600,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    controller
                                                        .removeFoodFromTempList(
                                                            index);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Fixed Action Buttons at Bottom
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: CustomButton(
                              text: 'Cancel',
                              onPressed: () {
                                controller.clearTempFoods();
                                Get.back();
                              },
                              backgroundColor: Colors.grey.shade400,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: Obx(() => CustomButton(
                                  text: controller.isCreatingCombination.value
                                      ? 'Saving...'
                                      : 'Save Combination',
                                  onPressed: controller
                                          .isCreatingCombination.value
                                      ? null
                                      : () async {
                                          print('Save button pressed'); // Debug
                                          final success = await controller
                                              .saveCombination();
                                          print(
                                              'Save result: $success'); // Debug

                                          // Close dialog after successful save
                                          if (success) {
                                            print(
                                                'Success - closing dialog'); // Debug
                                            // Small delay to show success toast before closing
                                            await Future.delayed(const Duration(
                                                milliseconds: 800));
                                            // Close dialog first
                                            Get.back();
                                            // Dispose after dialog close animation
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 300), () {
                                              try {
                                                quantityController.dispose();
                                              } catch (e) {
                                                print('Error disposing: $e');
                                              }
                                            });
                                          }
                                        },
                                  backgroundColor: const Color(0xFF4CAF50),
                                  textColor: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferenceOnboardingController>(
      builder: (controller) {
        return BaseScreenLayout(
          currentRoute: AppRoutes.preferenceOnboardingScreen,
          title: 'Preferences',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleSectionWidget(
                  imagePath: 'assets/images/plan.png',
                  title: 'Preference Onboarding',
                  description:
                      'Add your preferred food combinations for different meals of the day',
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Meal Type Tabs
                      Obx(() => MealTypeTabsWidget(
                            selectedMealType: controller.selectedMealType.value,
                            onMealTypeSelected: controller.onMealTypeChanged,
                          )),
                      const SizedBox(height: 16),

                      // Add Combination Button
                      Obx(() => SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton.icon(
                              onPressed: controller.isCreatingCombination.value
                                  ? null
                                  : _showAddCombinationDialog,
                              icon: controller.isCreatingCombination.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.add),
                              label: Text(
                                controller.isCreatingCombination.value
                                    ? 'Creating...'
                                    : 'Add Combination',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(height: 16),

                      // API Combinations - Each as its own CombinationFormWidget
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Column(
                            children: List.generate(3, (index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ShimmerCombinationForm(
                                  width: double.infinity,
                                  height: 160,
                                  title: 'Loading Combination ${index + 1}...',
                                ),
                              );
                            }),
                          );
                        }

                        // Filter API combinations for current meal type
                        final relevantCombinations = controller.apiCombinations
                            .where((combination) => combination.foods.any(
                                (food) =>
                                    food.time.toLowerCase() ==
                                    controller.selectedMealType.value
                                        .toLowerCase()))
                            .toList();

                        // If no API data found, show message
                        if (relevantCombinations.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No data found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No combinations available for ${controller.selectedMealType.value}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        // Show API combinations - Each combination as one CombinationFormWidget
                        return Column(
                          children:
                              relevantCombinations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final combination = entry.value;

                            // Filter foods for current meal type
                            final relevantFoods = combination.foods
                                .where((food) =>
                                    food.time.toLowerCase() ==
                                    controller.selectedMealType.value
                                        .toLowerCase())
                                .toList();

                            if (relevantFoods.isEmpty)
                              return const SizedBox.shrink();

                            // Create combinations map for all foods in this combination
                            final apiCombinationsList = relevantFoods
                                .map((food) => {
                                      'mealType':
                                          controller.selectedMealType.value,
                                      'food': food.foodName,
                                      'quantity':
                                          '${food.foodQty}g - ${food.description}',
                                      'pkey': food.pkey
                                          .toString(), // Add Pkey for deletion
                                    })
                                .toList();

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: CombinationFormWidget(
                                selectedFood: '',
                                quantity: '',
                                onFoodChanged: (_) {},
                                onQuantityChanged: (_) {},
                                onAddCombination: () {},
                                combinations: apiCombinationsList,
                                onDeleteCombination: (_) {},
                                availableFoods: controller.recipeList
                                    .map((recipe) => recipe.recipeName)
                                    .toList(),
                                isApiCombination: false,
                                combinationTitle: 'Combination ${index + 1}',
                                combinationId: combination.combinationId,
                                controller: controller,
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
