import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/controller/recipe/recipeController.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/screen/recipes/recipe_detail_screen.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/recipes/recipe_header_section_widget.dart';
import 'package:sodiet/view/widgets/recipes/recipes_header_widget.dart';
import 'package:sodiet/view/widgets/recipes/recipes_search_widget.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late RecipeController recipeController;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    recipeController = Get.find<RecipeController>();
    recipeController.getRecipes();

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Pagination scroll listener
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !recipeController.isLoadingMore.value &&
        recipeController.hasMoreData.value) {
      recipeController.loadMoreRecipes();
    }
  }

  void _handleAddRecipe() {
    CustomToast.showInfo('Add recipe functionality will be implemented soon');
  }

  void _handleSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _handleFilter() {
    CustomToast.showInfo('Filter functionality will be implemented soon');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentRoute: AppRoutes.recipesScreen,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            _onScroll();
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipes Header Widget
                RecipesHeaderWidget(
                  onAddRecipeTap: _handleAddRecipe,
                ),

                const SizedBox(height: 4),
                // Search Widget
                RecipesSearchWidget(
                  controller: _searchController,
                  onChanged: _handleSearch,
                  onFilterTap: _handleFilter,
                ),
                const SizedBox(height: 4),
                // Categories and Dishes Section in white container
                Container(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(16),
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
                  child: const RecipeHeaderSectionWidget(),
                ),

                const SizedBox(height: 8),
                // Recipe Grid with API data
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRecipeGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeGrid() {
    return Obx(() {
      if (recipeController.isLoadingRecipes.value &&
          recipeController.recipeList.isEmpty) {
        return Container(
          height: 400,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColorDark,
                  ),
                ),
                const SizedBox(height: 16),
                RegularText(
                  'Loading recipes...',
                  fontSize: 16,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        );
      }

      if (recipeController.recipeList.isEmpty &&
          !recipeController.isLoadingRecipes.value) {
        return Container(
          height: 400,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                SemiBoldText(
                  'No Recipes Found',
                  fontSize: 18,
                  textColor: Colors.grey.shade600,
                ),
                const SizedBox(height: 8),
                RegularText(
                  'Try refreshing or check your connection',
                  fontSize: 14,
                  textColor: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        );
      }

      // Filter recipes based on search query
      final filteredRecipes = _searchQuery.isEmpty
          ? recipeController.recipeList
          : recipeController.searchRecipes(_searchQuery);

      return Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: filteredRecipes.length +
                (recipeController.hasMoreData.value ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom when loading more
              if (index == filteredRecipes.length) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: recipeController.isLoadingMore.value
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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

              final recipe = filteredRecipes[index];
              return _buildRecipeCard(recipe);
            },
          ),
          if (filteredRecipes.isEmpty && _searchQuery.isNotEmpty)
            Container(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    RegularText(
                      'No recipes found for "$_searchQuery"',
                      fontSize: 16,
                      textColor: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildRecipeCard(recipe) {
    final imageUrl = '${AppConstants.BASE_URL_IMAGE}${recipe.recipeCode}.jpg';
    final heroTag = 'recipe_${recipe.recipeCode}'; // Unique hero tag

    return GestureDetector(
      onTap: () {
        // Navigate to recipe detail with Recipe object - Pass imageUrl and heroTag
        Get.to(() => RecipeDetailScreen(recipe: {
              'title': recipe.recipeName,
              'imageUrl': imageUrl, // Pass the network image URL
              'heroTag': heroTag, // Pass the hero tag
              'description':
                  'This recipe contains nutritious ingredients that provide essential nutrients for a balanced diet.',
              'calories': recipe.energyKcal.toStringAsFixed(1),
              'time': '30 min',
              'serving': recipe.portion.toString(),
            }));
      },
      child: Container(
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
            // Recipe Image from API with Hero animation
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Colors.grey.shade200,
                ),
                child: Hero(
                  tag: heroTag, // Hero tag for animation
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade200,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade400,
                                size: 40,
                              ),
                              const SizedBox(height: 4),
                              RegularText(
                                'No image',
                                fontSize: 10,
                                textColor: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Recipe Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Name
                    Expanded(
                      child: SemiBoldText(
                        recipe.recipeName,
                        fontSize: 14,
                        textColor: const Color(0xFF091242),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Recipe Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 16,
                                color: Colors.orange.shade600,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: RegularText(
                                  '${recipe.energyKcal.toStringAsFixed(0)} kcal',
                                  fontSize: 11,
                                  textColor: Colors.grey.shade600,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 16,
                                color: Colors.green.shade600,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: RegularText(
                                  '${recipe.portion} ${recipe.recipeDescription}',
                                  fontSize: 11,
                                  textColor: Colors.grey.shade600,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
