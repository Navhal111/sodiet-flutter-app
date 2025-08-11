import 'package:flutter/material.dart';
import 'package:sodiet/utils/recipe_constants.dart';
import 'package:sodiet/view/widgets/recipes/recipe_category_filter_widget.dart';
import 'package:sodiet/view/widgets/recipes/dishes_section_widget.dart';

class RecipeHeaderSectionWidget extends StatefulWidget {
  final ValueChanged<String>? onCategoryChanged;

  const RecipeHeaderSectionWidget({
    Key? key,
    this.onCategoryChanged,
  }) : super(key: key);

  @override
  State<RecipeHeaderSectionWidget> createState() =>
      _RecipeHeaderSectionWidgetState();
}

class _RecipeHeaderSectionWidgetState extends State<RecipeHeaderSectionWidget> {
  String _selectedCategory = 'Custom';
  String _sortBy = 'Time';

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    widget.onCategoryChanged?.call(category);
  }

  void _onSortTap() {
    // TODO: Show sort options
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dishes Section
        DishesSectionWidget(
          sortBy: _sortBy,
          onSortTap: _onSortTap,
        ),

        const SizedBox(height: 20),

        //   // Category Filter
        //   RecipeCategoryFilterWidget(
        //     categories: RecipeConstants.categories,
        //     selectedCategory: _selectedCategory,
        //     onCategorySelected: _onCategorySelected,
        //   ),
      ],
    );
  }
}
