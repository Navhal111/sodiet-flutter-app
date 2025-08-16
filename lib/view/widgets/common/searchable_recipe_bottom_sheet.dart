import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/appConstant.dart';
import '../../../model/recipe_model.dart';
import '../../../repo/authRepo.dart';
import '../../widgets/app_text.dart';

class SearchableRecipeBottomSheet extends StatefulWidget {
  final String title;
  final String? selectedValue;
  final Function(String?, String?)
      onSelected; // Returns (recipeName, recipeCode)
  final String searchHint;

  const SearchableRecipeBottomSheet({
    Key? key,
    required this.title,
    this.selectedValue,
    required this.onSelected,
    this.searchHint = 'Search recipes...',
  }) : super(key: key);

  @override
  State<SearchableRecipeBottomSheet> createState() =>
      _SearchableRecipeBottomSheetState();
}

class _SearchableRecipeBottomSheetState
    extends State<SearchableRecipeBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final AuthRepo _authRepo = Get.find<AuthRepo>();

  List<Recipe> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Load default recipes when first opened (without search term)
    _loadDefaultRecipes();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchTerm = _searchController.text.trim();

    // Cancel any existing timer
    _debounceTimer?.cancel();

    if (searchTerm.isEmpty) {
      // If search is cleared, reload default recipes
      _loadDefaultRecipes();
      return;
    }

    // Only search if term has at least 2 characters
    if (searchTerm.length >= 2) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _searchRecipes(searchTerm);
      });
    }
  }

  Timer? _debounceTimer;

  Future<void> _loadDefaultRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call API without search_term to get default list
      final url = "${AppConstants.GET_RECIPES_SEARCH}/?page=1&page_size=50";
      final response = await _authRepo.getDataSet(apiName: url);

      if (response.statusCode == 200) {
        final recipeResponse = RecipeResponse.fromJson(response.body);
        setState(() {
          _searchResults = recipeResponse.recipes;
          _hasSearched = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _searchResults.clear();
          _hasSearched = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading default recipes: $e");
      setState(() {
        _searchResults.clear();
        _hasSearched = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _searchRecipes(String searchTerm) async {
    if (searchTerm.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final url =
          "${AppConstants.GET_RECIPES_SEARCH}/?search_term=$searchTerm&page=1&page_size=50";
      final response = await _authRepo.getDataSet(apiName: url);

      if (response.statusCode == 200) {
        final recipeResponse = RecipeResponse.fromJson(response.body);
        setState(() {
          _searchResults = recipeResponse.recipes;
          _hasSearched = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _searchResults.clear();
          _hasSearched = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error searching recipes: $e");
      setState(() {
        _searchResults.clear();
        _hasSearched = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SemiBoldText(
                  widget.title,
                  fontSize: 18,
                  textColor: const Color(0xFF091242),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: StatefulBuilder(builder: (context, setFieldState) {
                return TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setFieldState(() {}); // Rebuild to show/hide clear icon
                  },
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setFieldState(
                                  () {}); // Rebuild to hide clear icon
                              // This will trigger _onSearchChanged and reload default recipes
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.grey.shade500,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                );
              }),
            ),
          ),

          // Results Area
          Expanded(
            child: _buildResultsArea(),
          ),

          // Clear Selection Button (if something is selected)
          if (widget.selectedValue != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    widget.onSelected(null, null);
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Clear Selection',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsArea() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            RegularText(
              'Loading recipes...',
              fontSize: 14,
              textColor: Colors.grey.shade500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            RegularText(
              _searchController.text.trim().isEmpty
                  ? 'No recipes available'
                  : 'No recipes found',
              fontSize: 14,
              textColor: Colors.grey.shade500,
            ),
            if (_searchController.text.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              RegularText(
                'Try different search terms',
                fontSize: 12,
                textColor: Colors.grey.shade400,
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final recipe = _searchResults[index];
        final isSelected = widget.selectedValue == recipe.recipeName;

        return ListTile(
          title: Text(
            recipe.recipeName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : const Color(0xFF091242),
            ),
          ),
          subtitle: recipe.recipeDescription.isNotEmpty
              ? Text(
                  recipe.recipeDescription,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                )
              : null,
          onTap: () {
            widget.onSelected(recipe.recipeName, recipe.recipeCode);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  static void show({
    required BuildContext context,
    required String title,
    String? selectedValue,
    required Function(String?, String?) onSelected,
    String searchHint = 'Search recipes...',
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchableRecipeBottomSheet(
        title: title,
        selectedValue: selectedValue,
        onSelected: onSelected,
        searchHint: searchHint,
      ),
    );
  }
}
