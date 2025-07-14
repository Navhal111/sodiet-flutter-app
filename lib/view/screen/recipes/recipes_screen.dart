import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/header/app_header.dart';
import 'package:sodiet/view/widgets/home/home_drawer.dart';
import 'package:sodiet/view/widgets/recipes/recipes_header_widget.dart';
import 'package:sodiet/view/widgets/recipes/recipes_search_widget.dart';
import 'package:sodiet/view/widgets/recipes/dishes_section_widget.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'Time';

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

  void _handleSort() {
    // TODO: Show sort options
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SemiBoldText(
              'Sort by',
              fontSize: 16,
              textColor: const Color(0xFF091242),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: RegularText('Time', fontSize: 14),
              onTap: () {
                setState(() => _sortBy = 'Time');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: RegularText('Name', fontSize: 14),
              onTap: () {
                setState(() => _sortBy = 'Name');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: RegularText('Category', fontSize: 14),
              onTap: () {
                setState(() => _sortBy = 'Category');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipes Header Widget
                      RecipesHeaderWidget(
                        onAddRecipeTap: _handleAddRecipe,
                      ),

                      const SizedBox(height: 20),

                      // Search Widget
                      RecipesSearchWidget(
                        controller: _searchController,
                        onChanged: _handleSearch,
                        onFilterTap: _handleFilter,
                      ),

                      const SizedBox(height: 20),

                      // Dishes Section
                      DishesSectionWidget(
                        sortBy: _sortBy,
                        onSortTap: _handleSort,
                      ),

                      const SizedBox(height: 20),

                      // Recipes List (Empty state for now)
                      Container(
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
                            SemiBoldText(
                              'No recipes yet',
                              fontSize: 16,
                              textColor: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 8),
                            RegularText(
                              'Add your first recipe to get started',
                              fontSize: 14,
                              textColor: Colors.grey.shade500,
                            ),
                          ],
                        ),
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
