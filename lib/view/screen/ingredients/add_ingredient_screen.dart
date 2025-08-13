import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/recipe/recipeController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';
import 'package:sodiet/view/widgets/common/searchable_bottom_sheet.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';

class AddIngredientScreen extends StatefulWidget {
  const AddIngredientScreen({Key? key}) : super(key: key);

  @override
  State<AddIngredientScreen> createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends State<AddIngredientScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late RecipeController recipeController;

  @override
  bool get wantKeepAlive => true;

  // Method to preserve scroll position during state updates
  void _preserveScrollAndSetState(VoidCallback fn) {
    final scrollPosition =
        _scrollController.hasClients ? _scrollController.offset : 0.0;

    setState(fn);

    // Restore scroll position after rebuild
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Form controllers for ingredient details
  final TextEditingController _foodNameController =
      TextEditingController(); // Form controllers for nutritional information
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _dietaryFibreController = TextEditingController();
  final TextEditingController _calciumController = TextEditingController();
  final TextEditingController _zincController = TextEditingController();
  final TextEditingController _ironController = TextEditingController();
  final TextEditingController _magnesiumController = TextEditingController();
  final TextEditingController _folateController = TextEditingController();
  final TextEditingController _vitaminB12Controller = TextEditingController();
  final TextEditingController _vitaminB1Controller = TextEditingController();
  final TextEditingController _vitaminB2Controller = TextEditingController();
  final TextEditingController _vitaminB3Controller = TextEditingController();
  final TextEditingController _vitaminB6Controller = TextEditingController();
  final TextEditingController _vitaminCController = TextEditingController();
  final TextEditingController _vitaminAController = TextEditingController();

  // Dropdown values
  String? _selectedFoodGroup;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    recipeController = Get.find<RecipeController>();
    recipeController.getFoodGroups();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _foodNameController.dispose();
    _energyController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _dietaryFibreController.dispose();
    _calciumController.dispose();
    _zincController.dispose();
    _ironController.dispose();
    _magnesiumController.dispose();
    _folateController.dispose();
    _vitaminB12Controller.dispose();
    _vitaminB1Controller.dispose();
    _vitaminB2Controller.dispose();
    _vitaminB3Controller.dispose();
    _vitaminB6Controller.dispose();
    _vitaminCController.dispose();
    _vitaminAController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return GestureDetector(
      onTap: () {
        // Close keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: BaseScreenLayout(
        currentRoute: AppRoutes.addIngredientScreen,
        title: 'Add New Ingredient',
        child: Container(
          color: Colors.grey.shade50,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // Header Section
                _buildHeaderSection(),
                // Ingredient Detail Section
                _buildIngredientDetailSection(),

                const SizedBox(height: 10),

                // Nutritional Information Section
                _buildNutritionalInformationSection(),

                const SizedBox(height: 10),

                // Submit Button
                _buildSubmitButton(),

                // Add bottom padding for keyboard
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),

          const SizedBox(width: 16),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SemiBoldText(
                  'Add New Ingredient',
                  fontSize: 20,
                  textColor: const Color(0xFF091242),
                ),
                const SizedBox(height: 4),
                RegularText(
                  'Enter the details for the ingredient, including its nutritional values.',
                  fontSize: 14,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientDetailSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          // Section Title
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              SemiBoldText(
                'Provide Ingredient Information',
                fontSize: 16,
                textColor: const Color(0xFF091242),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Ingredient Detail subsection
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
                SemiBoldText(
                  'Ingredient Detail',
                  fontSize: 14,
                  textColor: const Color(0xFF091242),
                ),

                const SizedBox(height: 16),

                // Food Name Field
                _buildInputField(
                  controller: _foodNameController,
                  labelText: 'Food Name',
                  hintText: 'Enter food name',
                ),

                const SizedBox(height: 16),

                // Food Group Dropdown
                _buildDropdownField(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalInformationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          // Section Title
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              SemiBoldText(
                'Nutritional Information',
                fontSize: 16,
                textColor: const Color(0xFF091242),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Nutritional fields in grid layout
          _buildNutritionalGrid(),
        ],
      ),
    );
  }

  Widget _buildNutritionalGrid() {
    return Column(
      children: [
        // Row 1: Energy and Protein
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _energyController,
                labelText: 'Energy (Kcal)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                controller: _proteinController,
                labelText: 'Protein (g)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Row 2: Fat and Dietary Fibre
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _fatController,
                labelText: 'Fat (g)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                controller: _dietaryFibreController,
                labelText: 'Dietary Fibre (g)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Row 3: Calcium and Zinc
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _calciumController,
                labelText: 'Calcium (mg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                controller: _zincController,
                labelText: 'Zinc (mg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Row 4: Iron and Magnesium
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _ironController,
                labelText: 'Iron (mg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                controller: _magnesiumController,
                labelText: 'Magnesium (mg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Row 5: Folate and Vitamin B12
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _folateController,
                labelText: 'Folate (μg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                controller: _vitaminB12Controller,
                labelText: 'Vitamin B12 (μg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Row 6: Vitamin B1 and Vitamin B2
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _vitaminB1Controller,
                labelText: 'Vitamin B1 (Thiamine) (mg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                controller: _vitaminB2Controller,
                labelText: 'Vitamin B2 (Riboflavin) (mg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Row 7: Vitamin B3 and Vitamin B6
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _vitaminB3Controller,
                labelText: 'Vitamin B3 (Niacin) (mg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                controller: _vitaminB6Controller,
                labelText: 'Vitamin B6 (mg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Row 8: Vitamin C and Vitamin A
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _vitaminCController,
                labelText: 'Vitamin C (Total Ascorbic Acid) (mg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                controller: _vitaminAController,
                labelText: 'Vitamin A (μg)',
                hintText: '0',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RegularText(
            labelText,
            fontSize: 14,
            textColor: const Color(0xFF091242),
          ),
        ),

        // Input field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF091242),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RegularText(
            'Food Group',
            fontSize: 14,
            textColor: const Color(0xFF091242),
          ),
        ),

        // Food Group Selector
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SearchableBottomSheet(
                title: 'Select Food Group',
                items: recipeController.foodGroupsList
                    .map((group) => group.groupName)
                    .toList(),
                selectedValue: _selectedFoodGroup,
                onSelected: (value) {
                  _preserveScrollAndSetState(() {
                    _selectedFoodGroup = value;
                  });
                },
                searchHint: 'Search food groups...',
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    if (recipeController.isLoadingFoodGroups.value) {
                      return Row(
                        children: [
                          SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey.shade500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Loading food groups...',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    }

                    return Text(
                      _selectedFoodGroup ?? 'Select a Food Group',
                      style: TextStyle(
                        color: _selectedFoodGroup != null
                            ? const Color(0xFF091242)
                            : Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    );
                  }),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Obx(() {
        final isSubmitting = _isSubmitting;
        return ElevatedButton(
          onPressed: isSubmitting ? null : _submitIngredient,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8C00),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isSubmitting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    RegularText(
                      'Submitting...',
                      fontSize: 16,
                      textColor: Colors.white,
                    ),
                  ],
                )
              : RegularText(
                  'Add Ingredient',
                  fontSize: 14,
                  textColor: Colors.white,
                ),
        );
      }),
    );
  }

  void _submitIngredient() async {
    // Validate required fields
    if (_foodNameController.text.trim().isEmpty) {
      CustomToast.showError('Please enter food name');
      return;
    }

    if (_selectedFoodGroup == null || _selectedFoodGroup!.isEmpty) {
      CustomToast.showError('Please select a food group');
      return;
    }

    // Show loading state
    _preserveScrollAndSetState(() {
      _isSubmitting = true;
    });

    try {
      // Prepare ingredient data
      Map<String, dynamic> ingredientData = {
        'food_name': _foodNameController.text.trim(),
        'food_group': _selectedFoodGroup,
        'nutritional_info': {
          'energy_kcal': double.tryParse(_energyController.text.trim()) ?? 0.0,
          'protein_g': double.tryParse(_proteinController.text.trim()) ?? 0.0,
          'fat_g': double.tryParse(_fatController.text.trim()) ?? 0.0,
          'dietary_fibre_g':
              double.tryParse(_dietaryFibreController.text.trim()) ?? 0.0,
          'calcium_mg': double.tryParse(_calciumController.text.trim()) ?? 0.0,
          'zinc_mg': double.tryParse(_zincController.text.trim()) ?? 0.0,
          'iron_mg': double.tryParse(_ironController.text.trim()) ?? 0.0,
          'magnesium_mg':
              double.tryParse(_magnesiumController.text.trim()) ?? 0.0,
          'folate_ug': double.tryParse(_folateController.text.trim()) ?? 0.0,
          'vitamin_b12_ug':
              double.tryParse(_vitaminB12Controller.text.trim()) ?? 0.0,
          'vitamin_b1_mg':
              double.tryParse(_vitaminB1Controller.text.trim()) ?? 0.0,
          'vitamin_b2_mg':
              double.tryParse(_vitaminB2Controller.text.trim()) ?? 0.0,
          'vitamin_b3_mg':
              double.tryParse(_vitaminB3Controller.text.trim()) ?? 0.0,
          'vitamin_b6_mg':
              double.tryParse(_vitaminB6Controller.text.trim()) ?? 0.0,
          'vitamin_c_mg':
              double.tryParse(_vitaminCController.text.trim()) ?? 0.0,
          'vitamin_a_ug':
              double.tryParse(_vitaminAController.text.trim()) ?? 0.0,
        },
      };

      print('Ingredient data prepared: $ingredientData');

      // Submit using recipe controller
      final result = await recipeController.submitIngredient(
        foodName: _foodNameController.text.trim(),
        foodGroup: _selectedFoodGroup!,
        nutritionalInfo: {
          'energy_kcal': double.tryParse(_energyController.text.trim()) ?? 0.0,
          'protein_g': double.tryParse(_proteinController.text.trim()) ?? 0.0,
          'fat_g': double.tryParse(_fatController.text.trim()) ?? 0.0,
          'dietary_fibre_g':
              double.tryParse(_dietaryFibreController.text.trim()) ?? 0.0,
          'calcium_mg': double.tryParse(_calciumController.text.trim()) ?? 0.0,
          'zinc_mg': double.tryParse(_zincController.text.trim()) ?? 0.0,
          'iron_mg': double.tryParse(_ironController.text.trim()) ?? 0.0,
          'magnesium_mg':
              double.tryParse(_magnesiumController.text.trim()) ?? 0.0,
          'folate_ug': double.tryParse(_folateController.text.trim()) ?? 0.0,
          'vitamin_b12_ug':
              double.tryParse(_vitaminB12Controller.text.trim()) ?? 0.0,
          'vitamin_b1_mg':
              double.tryParse(_vitaminB1Controller.text.trim()) ?? 0.0,
          'vitamin_b2_mg':
              double.tryParse(_vitaminB2Controller.text.trim()) ?? 0.0,
          'vitamin_b3_mg':
              double.tryParse(_vitaminB3Controller.text.trim()) ?? 0.0,
          'vitamin_b6_mg':
              double.tryParse(_vitaminB6Controller.text.trim()) ?? 0.0,
          'vitamin_c_mg':
              double.tryParse(_vitaminCController.text.trim()) ?? 0.0,
          'vitamin_a_ug':
              double.tryParse(_vitaminAController.text.trim()) ?? 0.0,
        },
      );

      if (result['success'] == true) {
        CustomToast.showSuccess(
            result['message'] ?? 'Ingredient added successfully!');
        // Clear form on success
        _clearForm();
        // Navigate back
        Navigator.of(context).pop();
      } else {
        CustomToast.showError(result['message'] ?? 'Failed to add ingredient');
      }
    } catch (e) {
      print('Error submitting ingredient: $e');
      CustomToast.showError('Failed to add ingredient: $e');
    } finally {
      _preserveScrollAndSetState(() {
        _isSubmitting = false;
      });
    }
  }

  void _clearForm() {
    _foodNameController.clear();
    _preserveScrollAndSetState(() {
      _selectedFoodGroup = null;
    });

    // Clear all nutritional info controllers
    _energyController.clear();
    _proteinController.clear();
    _fatController.clear();
    _dietaryFibreController.clear();
    _calciumController.clear();
    _zincController.clear();
    _ironController.clear();
    _magnesiumController.clear();
    _folateController.clear();
    _vitaminB12Controller.clear();
    _vitaminB1Controller.clear();
    _vitaminB2Controller.clear();
    _vitaminB3Controller.clear();
    _vitaminB6Controller.clear();
    _vitaminCController.clear();
    _vitaminAController.clear();
  }
}
