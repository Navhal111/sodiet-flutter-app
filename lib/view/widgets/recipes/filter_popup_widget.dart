import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/recipe/recipeController.dart';
import 'package:sodiet/model/recipe_model.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class FilterPopupWidget extends StatefulWidget {
  final Function(String? selectedCategory, String? selectedSubcategory,
      String selectedSortBy) onApplyFilter;

  const FilterPopupWidget({
    Key? key,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  State<FilterPopupWidget> createState() => _FilterPopupWidgetState();
}

class _FilterPopupWidgetState extends State<FilterPopupWidget> {
  late RecipeController recipeController;
  String? selectedCategory;
  String? selectedSubcategory;
  String selectedSortBy = 'Name (A-Z)';

  final List<String> sortOptions = [
    'Name (A-Z)',
    'Name (Z-A)',
    'Energy (Low to High)',
    'Energy (High to Low)',
    'Cooking Time (Short to Long)',
    'Cooking Time (Long to Short)',
    'Category (A-Z)',
  ];

  @override
  void initState() {
    super.initState();
    recipeController = Get.find<RecipeController>();
    // Load food categories if not already loaded
    if (!recipeController.hasFoodCategories) {
      recipeController.getFoodCategories();
    }
    // Load food subcategories
    if (!recipeController.hasFoodSubcategories) {
      recipeController.getFoodSubcategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BoldText(
                  'Filter & Sort',
                  fontSize: 20,
                  textColor: const Color(0xFF091242),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Category Filter Section
            SemiBoldText(
              'Filter by Category',
              fontSize: 16,
              textColor: const Color(0xFF091242),
            ),
            const SizedBox(height: 12),
            _buildCategoryDropdown(),

            const SizedBox(height: 20),

            // Subcategory Filter Section
            SemiBoldText(
              'Filter by Subcategory',
              fontSize: 16,
              textColor: const Color(0xFF091242),
            ),
            const SizedBox(height: 12),
            _buildSubcategoryDropdown(),

            const SizedBox(height: 24),

            // Sort By Section
            SemiBoldText(
              'Sort By',
              fontSize: 16,
              textColor: const Color(0xFF091242),
            ),
            const SizedBox(height: 12),
            _buildSortDropdown(),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: RegularText(
                      'Clear All',
                      fontSize: 14,
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: RegularText(
                      'Apply',
                      fontSize: 14,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(() {
      if (recipeController.isLoadingFoodCategories.value) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }

      List<FoodCategory> categories = recipeController.foodCategoriesList;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: selectedCategory,
            hint: RegularText(
              'Select Category',
              fontSize: 14,
              textColor: Colors.grey.shade600,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
            ),
            isExpanded: true,
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: RegularText(
                  'All Categories',
                  fontSize: 14,
                  textColor: Colors.black,
                ),
              ),
              ...categories.map((category) {
                return DropdownMenuItem<String?>(
                  value: category.code,
                  child: RegularText(
                    category.category,
                    fontSize: 14,
                    textColor: Colors.black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
            ],
            onChanged: (String? value) {
              setState(() {
                selectedCategory = value;
                selectedSubcategory =
                    null; // Clear subcategory when category changes
              });
              // Load subcategories for the selected category
              if (value != null) {
                recipeController.getFoodSubcategories(mainCategoryCode: value);
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buildSubcategoryDropdown() {
    return Obx(() {
      if (recipeController.isLoadingFoodSubcategories.value) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }

      List<FoodSubcategory> subcategories = selectedCategory != null
          ? recipeController.getSubcategoriesByMainCategory(selectedCategory!)
          : recipeController.foodSubcategoriesList;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: selectedSubcategory,
            hint: RegularText(
              'Select Subcategory',
              fontSize: 14,
              textColor: Colors.grey.shade600,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
            ),
            isExpanded: true,
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: RegularText(
                  'All Subcategories',
                  fontSize: 14,
                  textColor: Colors.black,
                ),
              ),
              ...subcategories.map((subcategory) {
                return DropdownMenuItem<String?>(
                  value: subcategory.code,
                  child: RegularText(
                    subcategory.subCategory,
                    fontSize: 14,
                    textColor: Colors.black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
            ],
            onChanged: (String? value) {
              setState(() {
                selectedSubcategory = value;
              });
            },
          ),
        ),
      );
    });
  }

  Widget _buildSortDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSortBy,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey.shade600,
          ),
          isExpanded: true,
          items: sortOptions.map((String sortOption) {
            return DropdownMenuItem<String>(
              value: sortOption,
              child: RegularText(
                sortOption,
                fontSize: 14,
                textColor: Colors.black,
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                selectedSortBy = value;
              });
            }
          },
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      selectedCategory = null;
      selectedSubcategory = null;
      selectedSortBy = 'Name (A-Z)';
    });
  }

  void _applyFilters() {
    widget.onApplyFilter(selectedCategory, selectedSubcategory, selectedSortBy);
    Navigator.of(context).pop();
  }
}
