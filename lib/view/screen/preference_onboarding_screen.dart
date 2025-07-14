import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/header/app_header.dart';
import 'package:sodiet/view/widgets/common/title_section_widget.dart';
import 'package:sodiet/view/widgets/preference/meal_type_tabs_widget.dart';
import 'package:sodiet/view/widgets/preference/combination_form_widget.dart';
import 'package:sodiet/view/widgets/preference/combinations_list_widget.dart';

class PreferenceOnboardingScreen extends StatefulWidget {
  const PreferenceOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<PreferenceOnboardingScreen> createState() =>
      _PreferenceOnboardingScreenState();
}

class _PreferenceOnboardingScreenState
    extends State<PreferenceOnboardingScreen> {
  String selectedMealType = 'Breakfast';
  String selectedFood = 'Biryani';
  String quantity = '';
  List<Map<String, String>> combinations = [];

  void _onMealTypeChanged(String mealType) {
    setState(() {
      selectedMealType = mealType;
    });
  }

  void _onFoodChanged(String? food) {
    setState(() {
      selectedFood = food ?? 'Biryani';
    });
  }

  void _onQuantityChanged(String qty) {
    setState(() {
      quantity = qty;
    });
  }

  void _onAddCombination() {
    if (selectedFood.isNotEmpty && quantity.isNotEmpty) {
      setState(() {
        combinations.add({
          'mealType': selectedMealType,
          'food': selectedFood,
          'quantity': quantity,
        });
        quantity = ''; // Reset quantity after adding
      });
    }
  }

  void _onDeleteCombination(int index) {
    setState(() {
      combinations.removeAt(index);
    });
  }

  List<Map<String, String>> get _filteredCombinations {
    return combinations
        .where((combination) => combination['mealType'] == selectedMealType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Preferences',
              showBackButton: true,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleSectionWidget(
                      imagePath: 'assets/images/plan.png',
                      title: 'Preference Onboarding',
                      description:
                          'Add your preferred food combinations for different meals of the day',
                    ),
                    const SizedBox(height: 4),
                    // Meal Type Tabs
                    MealTypeTabsWidget(
                      selectedMealType: selectedMealType,
                      onMealTypeSelected: _onMealTypeChanged,
                    ),
                    const SizedBox(height: 8),
                    // Food Combination Form
                    CombinationFormWidget(
                      selectedFood: selectedFood,
                      quantity: quantity,
                      onFoodChanged: _onFoodChanged,
                      onQuantityChanged: _onQuantityChanged,
                      onAddCombination: _onAddCombination,
                    ),

                    // Combinations List
                    CombinationsListWidget(
                      combinations: _filteredCombinations,
                      onDeleteCombination: _onDeleteCombination,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _savePreferences() {
    // Here you would typically save the preferences to your data store
    // For now, we'll just show a success message and go back
    Get.snackbar(
      'Success',
      'Your preferences have been saved!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );

    // You might want to navigate to a different screen or go back
    Get.back();
  }
}
