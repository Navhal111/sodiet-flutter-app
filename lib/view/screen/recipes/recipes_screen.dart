import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/constant/appConstant.dart';
import 'package:sodiet/controller/recipe/recipeController.dart';
import 'package:sodiet/model/recipe_model.dart';
import 'package:sodiet/route/app_routes.dart';
import 'package:sodiet/view/screen/recipes/recipe_detail_screen.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';
import 'package:sodiet/view/widgets/layouts/base_screen_layout.dart';
import 'package:sodiet/view/widgets/recipes/recipe_header_section_widget.dart';
import 'package:sodiet/view/widgets/recipes/recipes_header_widget.dart';
import 'package:sodiet/view/widgets/recipes/recipes_search_widget.dart';
import 'package:sodiet/view/widgets/recipes/filter_popup_widget.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late RecipeController recipeController;
  Timer? _debounceTimer;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    recipeController = Get.find<RecipeController>();
    recipeController.getRecipes();
    // Load food categories for filtering
    recipeController.getFoodCategories();
    // Load food subcategories for filtering
    recipeController.getFoodSubcategories();

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);

    // Add listener to search controller to update search query
    _searchController.addListener(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Pagination scroll listener
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Check if we're currently searching or browsing all recipes
      if (recipeController.isCurrentlySearching) {
        // Load more search results
        if (!recipeController.isLoadingSearchMore.value &&
            recipeController.hasMoreSearchData.value) {
          recipeController.loadMoreSearchResults();
        }
      } else {
        // Load more regular recipes
        if (!recipeController.isLoadingMore.value &&
            recipeController.hasMoreData.value) {
          recipeController.loadMoreRecipes();
        }
      }
    }
  }

  void _handleAddRecipe() {
    CustomToast.showInfo('Add recipe functionality will be implemented soon');
  }

  void _handleSearch(String value) {
    // Update search query without setState to avoid rebuilding
    _searchQuery = value;

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set up new timer for debounced search
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      if (_searchQuery.trim().isEmpty) {
        recipeController.clearSearchResults();
      } else {
        // Call search API with the query
        recipeController.searchRecipesAPI(_searchQuery.trim());
      }
    });
  }

  void _handleSearchSubmit() {
    // Cancel any pending debounced search
    _debounceTimer?.cancel();

    if (_searchQuery.trim().isEmpty) {
      recipeController.clearSearchResults();
    } else {
      // Call search API immediately
      recipeController.searchRecipesAPI(_searchQuery.trim());
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    _searchQuery = '';
    recipeController.clearSearchResults();
    FocusScope.of(context).unfocus();
  }

  void _handleFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterPopupWidget(
          onApplyFilter: (String? selectedCategory, String? selectedSubcategory,
              String selectedSortBy) {
            // Apply filters through the controller
            recipeController.applyFiltersAndSort(
                selectedCategory, selectedSubcategory, selectedSortBy);
          },
        );
      },
    );
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
                  onSubmitted: _handleSearchSubmit,
                  onClear: _clearSearch,
                  onFilterTap: _handleFilter,
                ),
                const SizedBox(height: 4),
                // Filter indicator chip
                _buildFilterIndicator(),
                // Categories and Dishes Section in white container
                // Container(
                //   margin: EdgeInsets.zero,
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(12),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.1),
                //         spreadRadius: 1,
                //         blurRadius: 5,
                //         offset: const Offset(0, 2),
                //       ),
                //     ],
                //   ),
                //   child: const RecipeHeaderSectionWidget(),
                // ),

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

  Widget _buildFilterIndicator() {
    return Obx(() {
      if (!recipeController.hasActiveFilters) {
        return const SizedBox.shrink();
      }

      String filterText = '';
      if (recipeController.selectedCategoryCode.value.isNotEmpty) {
        FoodCategory? category = recipeController
            .getFoodCategoryByCode(recipeController.selectedCategoryCode.value);
        filterText = 'Category: ${category?.category ?? 'Unknown'}';
      }

      if (recipeController.selectedSortBy.value != 'Name (A-Z)') {
        if (filterText.isNotEmpty) filterText += ' • ';
        filterText += 'Sort: ${recipeController.selectedSortBy.value}';
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: RegularText(
                        filterText,
                        fontSize: 12,
                        textColor: Theme.of(context).primaryColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        recipeController.clearFilters();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRecipeGrid() {
    return Obx(() {
      // Check if we're currently searching
      bool isCurrentlySearching = recipeController.isCurrentlySearching;

      // Show loading state
      if ((isCurrentlySearching &&
              recipeController.isSearching.value &&
              recipeController.searchResultsList.isEmpty) ||
          (!isCurrentlySearching &&
              recipeController.isLoadingRecipes.value &&
              recipeController.recipeList.isEmpty)) {
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
                  isCurrentlySearching
                      ? 'Searching recipes...'
                      : 'Loading recipes...',
                  fontSize: 16,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        );
      }

      // Get current display list
      List<Recipe> currentList = recipeController.getCurrentDisplayList();

      // Show empty state
      if (currentList.isEmpty &&
          !recipeController.isLoadingRecipes.value &&
          !recipeController.isSearching.value) {
        if (isCurrentlySearching) {
          // Empty search results
          return Container(
            height: 400,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  SemiBoldText(
                    'No recipes found',
                    fontSize: 18,
                    textColor: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  RegularText(
                    'Try searching with different keywords',
                    fontSize: 14,
                    textColor: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          );
        } else {
          // Empty recipe list
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
      }

      // Determine if we should show loading indicator for pagination
      bool hasMoreData = isCurrentlySearching
          ? recipeController.hasMoreSearchData.value
          : recipeController.hasMoreData.value;

      bool isLoadingMore = isCurrentlySearching
          ? recipeController.isLoadingSearchMore.value
          : recipeController.isLoadingMore.value;

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
            itemCount: currentList.length + (hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom when loading more
              if (index == currentList.length) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: isLoadingMore
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

              final recipe = currentList[index];
              return _buildRecipeCard(recipe);
            },
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
              'recipeCode':
                  recipe.recipeCode, // Pass the recipe code for API calls
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
                child: Stack(
                  children: [
                    // Main image with Hero animation
                    Hero(
                      tag: heroTag, // Hero tag for animation
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: double.infinity,
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
                    // Like and Dislike buttons positioned in top-right corner
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Like button
                          GestureDetector(
                            onTap: () async {
                              // Handle like action
                              bool success = await recipeController
                                  .likeRecipe(recipe.recipeCode);
                              if (success) {
                                CustomToast.showSuccess(
                                    'Liked ${recipe.recipeName}');
                              } else {
                                CustomToast.showError(
                                    'Failed to like recipe. Please try again.');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.shade500,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Dislike button
                          GestureDetector(
                            onTap: () async {
                              // Handle dislike action
                              bool success = await recipeController
                                  .dislikeRecipe(recipe.recipeCode);
                              if (success) {
                                CustomToast.showSuccess(
                                    'Disliked ${recipe.recipeName}');
                              } else {
                                CustomToast.showError(
                                    'Failed to dislike recipe. Please try again.');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.shade500,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.thumb_down,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
