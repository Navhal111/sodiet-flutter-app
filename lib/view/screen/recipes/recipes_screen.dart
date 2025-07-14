import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/header/app_header.dart';
import 'package:sodiet/view/widgets/home/home_drawer.dart';
import 'package:sodiet/view/widgets/recipes/recipes_header_widget.dart';
import 'package:sodiet/view/widgets/recipes/recipes_search_widget.dart';
import 'package:sodiet/view/widgets/recipes/recipe_header_section_widget.dart';
import 'package:sodiet/view/widgets/recipes/recipe_listing_widget.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _handleNotificationTap() {
    // TODO: Implement notification screen navigation
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: RegularText('Notifications feature will be implemented soon'),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }

  void _handleProfileTap() {
    // TODO: Implement profile screen navigation
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: RegularText('Profile feature will be implemented soon'),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }

  void _handleAddRecipe() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: RegularText('Add recipe functionality will be implemented soon'),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }

  void _handleSearch(String value) {
    // TODO: Implement search functionality
    print('Searching for: $value');
  }

  void _handleFilter() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: RegularText('Filter functionality will be implemented soon'),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).cardColor,
      drawer: const HomeDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // App Header
            AppHeader(
              onMenuTap: _openDrawer,
              onNotificationTap: _handleNotificationTap,
              onProfileTap: _handleProfileTap,
            ),

            // Recipes content
            Expanded(
              child: SingleChildScrollView(
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
                      // Recipe Grid (transparent background)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const RecipeListingWidget(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
