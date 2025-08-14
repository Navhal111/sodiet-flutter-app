import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/preference/preference_onboarding_controller.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/preference/meal_type_tabs_widget.dart';
import 'package:sodiet/view/widgets/preference/combination_form_widget.dart';
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

                      // API Combinations - Each as its own CombinationFormWidget
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
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
