import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/recipe/recipeController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';
import 'package:sodiet/view/widgets/common/searchable_bottom_sheet.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen>
    with AutomaticKeepAliveClientMixin {
  late RecipeController recipeController;
  int _currentPage = 0;

  // Main scroll controller for the entire screen
  final ScrollController _mainScrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  // Method to update state without triggering rebuilds for dropdowns
  void _updateState(VoidCallback fn) {
    fn(); // Just execute the function, no setState for dropdowns
  }

  // Form controllers
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();

  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _portionController = TextEditingController();

  final TextEditingController _portionWeightController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Dropdown values
  String? _selectedCategory;
  String? _selectedSubcategory;
  String? _selectedDescription = 'select';

  // Description dropdown options for Additional Details
  final List<String> _descriptionOptions = [
    'select',
    'cup',
    'number',
    'tablespoon',
    'glass',
    'teaspoon',
    'scoop',
    'slice',
    'bowl',
  ];

  // Ingredients form
  String? _selectedIngredient;
  String? _selectedUnit;
  final TextEditingController _ingredientQuantityController =
      TextEditingController();

  List<Map<String, dynamic>> _addedIngredients = [];

  // Recipe Attributes
  List<String> _selectedRegionalCuisine = [];
  List<String> _selectedMealTime = [];
  List<String> _selectedDietaryPreference = [];
  List<String> _selectedOtherAttributes = [];

  // Image
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    recipeController = Get.find<RecipeController>();
    // Load food categories and ingredients when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      recipeController.getFoodCategories();
      recipeController.getIngredientList(); // Load ingredients for dropdown
    });
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _cookingTimeController.dispose();
    _tagsController.dispose();
    _portionController.dispose();
    _portionWeightController.dispose();
    _quantityController.dispose();
    _ingredientQuantityController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    print("Building AddRecipeScreen, current page: $_currentPage");
    return GestureDetector(
      onTap: () {
        // Close keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: BaseScreenLayout(
        currentRoute: AppRoutes.addRecipeScreen,
        child: Container(
          color: Colors.grey.shade50,
          child: SingleChildScrollView(
            controller: _mainScrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              key: const ValueKey('main_content_column'),
              children: [
                // Image Upload Section at the top
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildImageUploadSection(),
                ),

                // Tab Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTabButtons(),
                ),

                const SizedBox(height: 24),

                // Main content - now directly rendered instead of IndexedStack
                _currentPage == 0
                    ? _buildRecipeFormContent()
                    : _buildIngredientsContent(),
              ],
            ),
          ),
        ),
      ),
    ); // Close GestureDetector
  } // Close build method

  Widget _buildRecipeFormContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Title
          SemiBoldText(
            'Provide Recipe information',
            fontSize: 16,
            textColor: Color(0xFF091242),
          ),

          const SizedBox(height: 20),

          // Basic Information Section
          _buildBasicInformationSection(),

          // Add bottom padding for keyboard
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: _selectedImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40, color: Colors.grey[600]),
                      SizedBox(height: 8),
                      Text('Image Selected',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
            )
          : GestureDetector(
              onTap: _pickImage,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add Recipe Photo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Upload a photo of your recipe',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTabButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("Recipe Form tab clicked, current page: $_currentPage");
                setState(() {
                  _currentPage = 0;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _currentPage == 0
                      ? Theme.of(context).primaryColor.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: _currentPage == 0
                      ? Border.all(
                          color: Theme.of(context).primaryColorDark,
                          width: 1,
                        )
                      : null,
                ),
                child: Center(
                  child: SemiBoldText(
                    'Recipe Form',
                    fontSize: 14,
                    textColor: _currentPage == 0
                        ? Theme.of(context).primaryColorDark
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("Ingredients tab clicked, current page: $_currentPage");
                setState(() {
                  _currentPage = 1;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _currentPage == 1
                      ? Theme.of(context).primaryColor.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: _currentPage == 1
                      ? Border.all(
                          color: Theme.of(context).primaryColorDark,
                          width: 1,
                        )
                      : null,
                ),
                child: Center(
                  child: SemiBoldText(
                    'Ingredients',
                    fontSize: 14,
                    textColor: _currentPage == 1
                        ? Theme.of(context).primaryColorDark
                        : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformationSection() {
    return Column(
      children: [
        // Basic Information Section
        Container(
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
              SemiBoldText(
                'Basic Information',
                fontSize: 18,
                textColor: Color(0xFF091242),
              ),

              const SizedBox(height: 24),

              // Recipe Name Field
              _buildInputField(
                controller: _recipeNameController,
                hintText: 'Recipe Name',
              ),

              const SizedBox(height: 16),

              // Cooking Time Field
              _buildInputField(
                controller: _cookingTimeController,
                hintText: 'Cooking Time (Mins)',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Description Field
              _buildInputField(
                controller: _tagsController,
                hintText: 'Tags',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Additional Details Section
        Container(
          key: const ValueKey('additional_details_section'),
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
              SemiBoldText(
                'Additional Details',
                fontSize: 18,
                textColor: Color(0xFF091242),
              ),

              const SizedBox(height: 24),

              // Code Co-occurrence Dropdown
              Obx(() {
                final categories = recipeController.foodCategoriesList;
                return _buildDropdownField(
                  value: _selectedCategory,
                  hint: 'Code Co-occurrence',
                  items: categories.map((e) => e.category).toList(),
                  onChanged: (value) async {
                    if (value != _selectedCategory) {
                      _selectedCategory = value;
                      _selectedSubcategory = null; // Reset subcategory
                      if (value != null) {
                        // Find the code for the selected category
                        final categoryCode = categories
                            .firstWhere((cat) => cat.category == value)
                            .code;
                        await recipeController.getFoodSubcategories(
                            mainCategoryCode: categoryCode);
                      }
                    }
                  },
                  searchHint: 'Search categories...',
                );
              }),

              const SizedBox(height: 16),

              // Subcategories Dropdown
              Obx(() {
                final subcategories = recipeController.foodSubcategoriesList;
                return _buildDropdownField(
                  value: _selectedSubcategory,
                  hint: 'Subcategories',
                  items: _selectedCategory != null
                      ? subcategories.map((e) => e.subCategory).toList()
                      : [],
                  onChanged: (value) {
                    if (value != _selectedSubcategory) {
                      _selectedSubcategory = value;
                    }
                  },
                  searchHint: 'Search subcategories...',
                );
              }),

              const SizedBox(height: 16),

              // Portion Field
              _buildInputField(
                controller: _portionController,
                hintText: 'Portion',
              ),

              const SizedBox(height: 16),

              // Description Field
              _buildDropdownField(
                value: _selectedDescription,
                hint: 'Description',
                items: _descriptionOptions,
                onChanged: (value) {
                  _selectedDescription = value;
                },
                searchHint: 'Select description...',
              ),

              const SizedBox(height: 16),

              // Portion Weight Field
              _buildInputField(
                controller: _portionWeightController,
                hintText: 'Portion Weight (g)',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Recipe Attributes Section
        _buildRecipeAttributesSection(),

        const SizedBox(height: 24),

        // Submit Button
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            final isSubmitting = recipeController.isSubmittingRecipe.value;
            return ElevatedButton(
              onPressed: isSubmitting ? null : _submitRecipe,
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
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
                      'Submit',
                      fontSize: 14,
                      textColor: Colors.white,
                    ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
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
    );
  }

  Widget _buildIngredientsContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          SemiBoldText(
            'Add Recipe Ingredients',
            fontSize: 16,
            textColor: Color(0xFF091242),
          ),

          const SizedBox(height: 20),

          // Ingredients Form Section
          _buildIngredientsFormSection(),

          const SizedBox(height: 24),

          // Ingredients List Section
          _buildIngredientsListSection(),

          // Add bottom padding for keyboard
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      // Image picker functionality to be implemented
      // For now, just simulate image selection
      setState(() {
        _selectedImage = "placeholder_image_path";
      });
      CustomToast.showSuccess("Image picker functionality to be implemented");
    } catch (e) {
      CustomToast.showError('Failed to pick image: $e');
    }
  }

  void _submitRecipe() async {
    print('Starting recipe submission...');

    // Validate basic information
    if (_recipeNameController.text.trim().isEmpty) {
      CustomToast.showError('Please enter recipe name');
      return;
    }

    if (_cookingTimeController.text.trim().isEmpty) {
      CustomToast.showError('Please enter cooking time');
      return;
    }

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      CustomToast.showError('Please select a category');
      return;
    }

    if (_selectedSubcategory == null || _selectedSubcategory!.isEmpty) {
      CustomToast.showError('Please select a subcategory');
      return;
    }

    if (_addedIngredients.isEmpty) {
      CustomToast.showError('Please add at least one ingredient');
      return;
    }

    // Check if category and subcategory lists are loaded
    if (recipeController.foodCategoriesList.isEmpty) {
      CustomToast.showError(
          'Categories not loaded. Please wait and try again.');
      return;
    }

    if (recipeController.foodSubcategoriesList.isEmpty) {
      CustomToast.showError(
          'Subcategories not loaded. Please wait and try again.');
      return;
    }

    print(
        'Categories available: ${recipeController.foodCategoriesList.length}');
    print(
        'Subcategories available: ${recipeController.foodSubcategoriesList.length}');
    print('Selected category: $_selectedCategory');
    print('Selected subcategory: $_selectedSubcategory');

    try {
      // Get category and subcategory codes with error handling
      final categoryList = recipeController.foodCategoriesList
          .where((cat) => cat.category == _selectedCategory)
          .toList();

      if (categoryList.isEmpty) {
        CustomToast.showError(
            'Selected category not found. Please reselect category.');
        return;
      }

      final selectedCat = categoryList.first;

      final subcategoryList = recipeController.foodSubcategoriesList
          .where((subcat) => subcat.subCategory == _selectedSubcategory)
          .toList();

      if (subcategoryList.isEmpty) {
        CustomToast.showError(
            'Selected subcategory not found. Please reselect subcategory.');
        return;
      }

      final selectedSubcat = subcategoryList.first;

      // Convert ingredients to API format
      List<Map<String, dynamic>> tableData =
          _addedIngredients.map((ingredient) {
        return {
          'ingredient': ingredient['name'],
          'quantity': double.tryParse(ingredient['quantity'].toString()) ?? 0.0,
          'unit': ingredient['unit'],
        };
      }).toList();

      // Parse numeric values with defaults
      double portion = double.tryParse(_portionController.text.trim()) ?? 1.0;
      double portionWeight =
          double.tryParse(_portionWeightController.text.trim()) ?? 100.0;
      double servings = double.tryParse(_quantityController.text.trim().isEmpty
              ? '1'
              : _quantityController.text.trim()) ??
          1.0;

      // Prepare submission data
      final result = await recipeController.submitRecipe(
        recipeName: _recipeNameController.text.trim(),
        cookingTime: _cookingTimeController.text.trim(),
        description: _tagsController.text.trim().isNotEmpty
            ? _tagsController.text.trim()
            : 'Recipe description',
        additionalDescription: _selectedDescription,
        categoryCode: selectedCat.code,
        subcategoryCode: selectedSubcat.code,
        portion: portion,
        portionWeight: portionWeight,
        servings: servings,
        regional: _selectedRegionalCuisine,
        mealtime: _selectedMealTime,
        dietary: _selectedDietaryPreference,
        attributes: _selectedOtherAttributes,
        tableData: tableData,
      );

      if (result['success'] == true) {
        CustomToast.showSuccess(
            result['message'] ?? 'Recipe submitted successfully');
        Navigator.of(context).pop();
      } else {
        CustomToast.showError(result['message'] ?? 'Failed to submit recipe');
      }
    } catch (e) {
      print('Error submitting recipe: $e');
      CustomToast.showError('An error occurred while submitting recipe');
    }
  }

  Widget _buildDropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
    String? searchHint,
  }) {
    return GestureDetector(
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
            searchHint: searchHint ?? 'Search $hint...',
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
    );
  }

  Widget _buildRecipeAttributesSection() {
    return Container(
      key: const ValueKey('recipe_attributes_section'),
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
          SemiBoldText(
            'Recipe Attributes',
            fontSize: 18,
            textColor: Color(0xFF091242),
          ),
          const SizedBox(height: 24),

          // Regional Cuisine
          _buildCheckboxSection(
            title: 'Regional cuisine',
            options: ['North', 'South', 'Continental'],
            selectedItems: _selectedRegionalCuisine,
          ),

          const SizedBox(height: 20),

          // Meal Time
          _buildCheckboxSection(
            title: 'Meal Time',
            options: ['Breakfast', 'Lunch', 'Dinner', 'Snack', 'Dessert'],
            selectedItems: _selectedMealTime,
          ),

          const SizedBox(height: 20),

          // Dietary Preference
          _buildCheckboxSection(
            title: 'Dietary Preference',
            options: ['Vegetarian', 'Non - Vegetarian', 'Ovo Vegetarian'],
            selectedItems: _selectedDietaryPreference,
          ),

          const SizedBox(height: 20),

          // Other Attributes
          _buildCheckboxSection(
            title: 'Other Attributes',
            options: ['Beverages', 'Savoury', 'Sweet', 'Spicy'],
            selectedItems: _selectedOtherAttributes,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxSection({
    required String title,
    required List<String> options,
    required List<String> selectedItems,
  }) {
    return Column(
      key: ValueKey('${title}_${selectedItems.join('_')}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SemiBoldText(
          title,
          fontSize: 14,
          textColor: Color(0xFF091242),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedItems.contains(option);
            return GestureDetector(
              onTap: () {
                // Use the simple state update method
                if (isSelected) {
                  selectedItems.remove(option);
                } else {
                  selectedItems.add(option);
                }
                // Force a rebuild only for this specific section
                setState(() {});
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4CAF50)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIngredientsFormSection() {
    return Container(
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
          SemiBoldText(
            'Provide Recipe ingredients',
            fontSize: 18,
            textColor: Color(0xFF091242),
          ),
          const SizedBox(height: 24),

          // Ingredient Name Dropdown
          Obx(() {
            final isLoading = recipeController.isLoadingIngredientList.value;
            final ingredientNames = recipeController.ingredientNamesList;

            return Column(
              children: [
                if (isLoading)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        RegularText(
                          'Loading ingredients...',
                          fontSize: 14,
                          textColor: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  )
                else
                  _buildDropdownField(
                    value: _selectedIngredient,
                    hint: 'Ingredient Name',
                    items: ingredientNames,
                    onChanged: (value) {
                      setState(() {
                        _selectedIngredient = value;
                      });
                    },
                    searchHint: 'Search ingredients...',
                  ),
              ],
            );
          }),

          const SizedBox(height: 16),

          // Quantity and Unit Row
          Row(
            children: [
              // Quantity Field
              Expanded(
                flex: 2,
                child: _buildInputField(
                  controller: _ingredientQuantityController,
                  hintText: 'Quantity',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 16),
              // Unit Dropdown
              Expanded(
                flex: 2,
                child: _buildDropdownField(
                  value: _selectedUnit,
                  hint: 'Unit',
                  items: [
                    'cup',
                    'tbsp',
                    'tsp',
                    'g',
                    'kg',
                    'ml',
                    'l',
                    'piece',
                    'pinch'
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedUnit = value;
                    });
                  },
                  searchHint: 'Search units...',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Add to recipe Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addIngredientToRecipe,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C00),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: RegularText(
                'Add to recipe',
                fontSize: 16,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsListSection() {
    if (_addedIngredients.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 12),
            RegularText(
              'No ingredients added yet',
              fontSize: 14,
              textColor: Colors.grey.shade500,
            ),
          ],
        ),
      );
    }

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SemiBoldText(
                'Added Ingredients',
                fontSize: 18,
                textColor: Color(0xFF091242),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RegularText(
                  '${_addedIngredients.length} items',
                  fontSize: 12,
                  textColor: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SemiBoldText(
                    'Ingredient',
                    fontSize: 14,
                    textColor: Color(0xFF091242),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SemiBoldText(
                    'Quantity',
                    fontSize: 14,
                    textColor: Color(0xFF091242),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SemiBoldText(
                    'Unit',
                    fontSize: 14,
                    textColor: Color(0xFF091242),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 40), // Space for delete button
              ],
            ),
          ),

          // Ingredients List
          ...List.generate(_addedIngredients.length, (index) {
            final ingredient = _addedIngredients[index];
            final isEvenRow = index % 2 == 0;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isEvenRow ? Colors.white : Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: RegularText(
                      ingredient['name'],
                      fontSize: 14,
                      textColor: Color(0xFF091242),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RegularText(
                      ingredient['quantity'],
                      fontSize: 14,
                      textColor: Colors.grey.shade600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: RegularText(
                      ingredient['unit'],
                      fontSize: 14,
                      textColor: Colors.grey.shade600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      onPressed: () => _removeIngredient(index),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade400,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _addIngredientToRecipe() {
    if (_selectedIngredient == null || _selectedIngredient!.isEmpty) {
      CustomToast.showError('Please select an ingredient');
      return;
    }

    if (_ingredientQuantityController.text.trim().isEmpty) {
      CustomToast.showError('Please enter quantity');
      return;
    }

    if (_selectedUnit == null || _selectedUnit!.isEmpty) {
      CustomToast.showError('Please select a unit');
      return;
    }

    // Check if ingredient already exists
    bool ingredientExists = _addedIngredients.any(
      (ingredient) => ingredient['name'] == _selectedIngredient,
    );

    if (ingredientExists) {
      CustomToast.showError('Ingredient already added');
      return;
    }

    setState(() {
      _addedIngredients.add({
        'name': _selectedIngredient,
        'quantity': _ingredientQuantityController.text.trim(),
        'unit': _selectedUnit,
      });

      // Clear form
      _selectedIngredient = null;
      _ingredientQuantityController.clear();
      _selectedUnit = null;
    });

    CustomToast.showSuccess('Ingredient added successfully');
  }

  void _removeIngredient(int index) {
    setState(() {
      _addedIngredients.removeAt(index);
    });
    CustomToast.showSuccess('Ingredient removed');
  }
}
