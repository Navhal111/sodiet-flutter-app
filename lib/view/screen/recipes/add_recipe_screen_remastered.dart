import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/recipe/recipeController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';
import 'package:sodiet/view/widgets/common/searchable_bottom_sheet.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';

class AddRecipeScreenRemastered extends StatefulWidget {
  const AddRecipeScreenRemastered({Key? key}) : super(key: key);

  @override
  State<AddRecipeScreenRemastered> createState() =>
      _AddRecipeScreenRemasteredState();
}

class _AddRecipeScreenRemasteredState extends State<AddRecipeScreenRemastered>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late RecipeController recipeController;
  late TabController _tabController;

  // Individual scroll controllers with fixed positions
  final ScrollController _recipeScrollController = ScrollController();
  final ScrollController _ingredientScrollController = ScrollController();

  // Global keys for maintaining widget state
  final GlobalKey<FormState> _recipeFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _ingredientFormKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;

  // Text Controllers
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _portionController = TextEditingController();
  final TextEditingController _portionWeightController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _ingredientQuantityController =
      TextEditingController();

  // Form State Variables (these won't trigger rebuilds when updated properly)
  String? _selectedFoodCategory;
  String? _selectedRegionalCuisine;
  String? _selectedMealTime;
  String? _selectedDietaryPreference;
  String? _selectedImage;

  // Ingredients state
  List<Map<String, dynamic>> _addedIngredients = [];
  String? _selectedIngredient;
  String? _selectedIngredientUnit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    recipeController = Get.find<RecipeController>();

    // Load data without triggering rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    await recipeController.getFoodCategories();
    await recipeController.getIngredientList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _recipeScrollController.dispose();
    _ingredientScrollController.dispose();
    _recipeNameController.dispose();
    _cookingTimeController.dispose();
    _tagsController.dispose();
    _portionController.dispose();
    _portionWeightController.dispose();
    _quantityController.dispose();
    _ingredientQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BaseScreenLayout(
        currentRoute: AppRoutes.addRecipeScreen,
        child: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: [
              // Fixed Image Upload Section
              _buildImageUploadSection(),

              // Fixed Tab Navigation
              _buildTabNavigation(),

              // Tab Content with preserved state
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevent swipe gestures
                  children: [
                    _buildRecipeFormTab(),
                    _buildIngredientsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          GestureDetector(
            onTap: () {
              // Handle image selection without rebuilding
              _selectImage();
            },
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt,
                            size: 40, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'Add Recipe Image',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _tabController,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => _tabController.animateTo(0),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _tabController.index == 0
                          ? Theme.of(context).primaryColor.withOpacity(0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: _tabController.index == 0
                          ? Border.all(
                              color: Theme.of(context).primaryColorDark)
                          : null,
                    ),
                    child: Center(
                      child: SemiBoldText(
                        'Recipe Form',
                        fontSize: 14,
                        textColor: _tabController.index == 0
                            ? Theme.of(context).primaryColorDark
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _tabController,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => _tabController.animateTo(1),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _tabController.index == 1
                          ? Theme.of(context).primaryColor.withOpacity(0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: _tabController.index == 1
                          ? Border.all(
                              color: Theme.of(context).primaryColorDark)
                          : null,
                    ),
                    child: Center(
                      child: SemiBoldText(
                        'Ingredients',
                        fontSize: 14,
                        textColor: _tabController.index == 1
                            ? Theme.of(context).primaryColorDark
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeFormTab() {
    return Container(
      key: const ValueKey('recipe_form_tab'),
      child: SingleChildScrollView(
        controller: _recipeScrollController,
        physics: const ClampingScrollPhysics(),
        child: Form(
          key: _recipeFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Form Title
                SemiBoldText(
                  'Provide Recipe Information',
                  fontSize: 16,
                  textColor: Color(0xFF091242),
                ),

                const SizedBox(height: 24),

                // Recipe Name
                _buildTextField(
                  controller: _recipeNameController,
                  label: 'Recipe Name',
                  hint: 'Enter recipe name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter recipe name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Food Category Dropdown
                _buildDropdownField(
                  label: 'Food Category',
                  value: _selectedFoodCategory,
                  hint: 'Select food category',
                  items: recipeController.foodCategoriesList
                      .map((e) => e.category)
                      .toList(),
                  onChanged: (value) => _updateFoodCategory(value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select food category';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Cooking Time
                _buildTextField(
                  controller: _cookingTimeController,
                  label: 'Cooking Time (minutes)',
                  hint: 'Enter cooking time',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter cooking time';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter valid number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Regional Cuisine
                _buildDropdownField(
                  label: 'Regional Cuisine',
                  value: _selectedRegionalCuisine,
                  hint: 'Select regional cuisine',
                  items: [
                    'Indian',
                    'Chinese',
                    'Italian',
                    'Mexican',
                    'Thai',
                    'Japanese'
                  ],
                  onChanged: (value) => _updateRegionalCuisine(value),
                ),

                const SizedBox(height: 16),

                // Meal Time
                _buildDropdownField(
                  label: 'Meal Time',
                  value: _selectedMealTime,
                  hint: 'Select meal time',
                  items: ['Breakfast', 'Lunch', 'Dinner', 'Snacks'],
                  onChanged: (value) => _updateMealTime(value),
                ),

                const SizedBox(height: 16),

                // Dietary Preference
                _buildDropdownField(
                  label: 'Dietary Preference',
                  value: _selectedDietaryPreference,
                  hint: 'Select dietary preference',
                  items: ['Vegetarian', 'Non-Vegetarian', 'Vegan', 'Jain'],
                  onChanged: (value) => _updateDietaryPreference(value),
                ),

                const SizedBox(height: 16),

                // Tags
                _buildTextField(
                  controller: _tagsController,
                  label: 'Tags (comma separated)',
                  hint: 'Enter tags',
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                // Portion Details
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _portionController,
                        label: 'Portion',
                        hint: 'e.g., 2',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _portionWeightController,
                        label: 'Portion Weight (g)',
                        hint: 'e.g., 150',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return Container(
      key: const ValueKey('ingredients_tab'),
      child: SingleChildScrollView(
        controller: _ingredientScrollController,
        physics: const ClampingScrollPhysics(),
        child: Form(
          key: _ingredientFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Form Title
                SemiBoldText(
                  'Add Recipe Ingredients',
                  fontSize: 16,
                  textColor: Color(0xFF091242),
                ),

                const SizedBox(height: 24),

                // Ingredient Selection Form
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
                      // Ingredient Dropdown
                      _buildDropdownField(
                        label: 'Select Ingredient',
                        value: _selectedIngredient,
                        hint: 'Choose ingredient',
                        items: recipeController.ingredientNamesList,
                        onChanged: (value) => _updateSelectedIngredient(value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select ingredient';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Quantity and Unit Row
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _ingredientQuantityController,
                              label: 'Quantity',
                              hint: 'Enter quantity',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Invalid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: _buildDropdownField(
                              label: 'Unit',
                              value: _selectedIngredientUnit,
                              hint: 'Select unit',
                              items: [
                                'grams',
                                'kg',
                                'ml',
                                'liters',
                                'cups',
                                'tbsp',
                                'tsp',
                                'pieces'
                              ],
                              onChanged: (value) =>
                                  _updateIngredientUnit(value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Add Ingredient Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addIngredient,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8C00),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: RegularText(
                            'Add Ingredient',
                            fontSize: 14,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Added Ingredients List
                if (_addedIngredients.isNotEmpty) ...[
                  SemiBoldText(
                    'Added Ingredients',
                    fontSize: 14,
                    textColor: Color(0xFF091242),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                      children: _addedIngredients.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> ingredient = entry.value;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ingredient['name'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${ingredient['quantity']} ${ingredient['unit']}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeIngredient(index),
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade400,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Save Recipe Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C00),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: RegularText(
                      'Submit',
                      fontSize: 14,
                      textColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF091242),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF091242),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SearchableBottomSheet(
                title: hint,
                items: items,
                selectedValue: value,
                onSelected: onChanged,
                searchHint: 'Search $hint...',
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xffF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? hint,
                  style: TextStyle(
                    color: value != null
                        ? const Color(0xFF091242)
                        : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // State update methods that don't trigger unwanted rebuilds
  void _updateFoodCategory(String? value) {
    _selectedFoodCategory = value;
    // Only update the dropdown, not the entire screen
  }

  void _updateRegionalCuisine(String? value) {
    _selectedRegionalCuisine = value;
  }

  void _updateMealTime(String? value) {
    _selectedMealTime = value;
  }

  void _updateDietaryPreference(String? value) {
    _selectedDietaryPreference = value;
  }

  void _updateSelectedIngredient(String? value) {
    _selectedIngredient = value;
  }

  void _updateIngredientUnit(String? value) {
    _selectedIngredientUnit = value;
  }

  void _selectImage() {
    // Implement image selection logic
    // This won't cause screen rebuilds
    print('Image selection logic here');
  }

  void _addIngredient() {
    if (_ingredientFormKey.currentState?.validate() ?? false) {
      setState(() {
        _addedIngredients.add({
          'name': _selectedIngredient,
          'quantity': _ingredientQuantityController.text,
          'unit': _selectedIngredientUnit,
        });
      });

      // Clear the form
      _selectedIngredient = null;
      _selectedIngredientUnit = null;
      _ingredientQuantityController.clear();

      // Show success message
      CustomToast.showSuccess("Ingredient added successfully");
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _addedIngredients.removeAt(index);
    });
    CustomToast.showSuccess("Ingredient removed");
  }

  void _saveRecipe() async {
    bool recipeFormValid = _recipeFormKey.currentState?.validate() ?? false;
    bool ingredientsValid = _addedIngredients.isNotEmpty;

    if (!recipeFormValid) {
      _tabController.animateTo(0);
      CustomToast.showError("Please fill all required recipe fields");
      return;
    }

    if (!ingredientsValid) {
      _tabController.animateTo(1);
      CustomToast.showError("Please add at least one ingredient");
      return;
    }

    // Show success message for now - implement full API integration later
    CustomToast.showSuccess(
        "Recipe validation completed! Ready for submission.");

    // For now, just navigate back - replace with actual API call later
    // Get.back();

    // TODO: Implement full submitRecipe integration matching original file
    // This requires proper category/subcategory mapping and complex validation
  }
}
