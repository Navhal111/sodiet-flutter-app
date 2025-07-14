import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/utils/recipe_constants.dart';
import 'package:sodiet/view/widgets/recipes/recipe_card_widget.dart';
import 'package:sodiet/route/app_routes.dart';

class RecipeListingWidget extends StatefulWidget {
  const RecipeListingWidget({Key? key}) : super(key: key);

  @override
  State<RecipeListingWidget> createState() => _RecipeListingWidgetState();
}

class _RecipeListingWidgetState extends State<RecipeListingWidget> {
  String _selectedCategory = 'Custom';
  List<Map<String, dynamic>> _filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredRecipes();
  }

  void _updateFilteredRecipes() {
    setState(() {
      _filteredRecipes =
          RecipeConstants.getRecipesByCategory(_selectedCategory);
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _updateFilteredRecipes();
  }

  void _onRecipeTap(Map<String, dynamic> recipe) {
    Get.toNamed(AppRoutes.recipeDetailScreen, arguments: recipe);
  }

  @override
  Widget build(BuildContext context) {
    return _filteredRecipes.isEmpty
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
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
                  Icons.restaurant_menu_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No recipes in this category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try selecting a different category',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 1,
              mainAxisSpacing: 20,
              childAspectRatio: 0.7,
            ),
            itemCount: _filteredRecipes.length,
            itemBuilder: (context, index) {
              final recipe = _filteredRecipes[index];
              return RecipeCardWidget(
                recipe: recipe,
                onTap: () => _onRecipeTap(recipe),
              );
            },
          );
  }
}
