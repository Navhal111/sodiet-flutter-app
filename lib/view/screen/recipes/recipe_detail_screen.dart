import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sodiet/controller/recipe/recipeController.dart';
import 'package:sodiet/model/recipe_model.dart';
import 'package:sodiet/view/widgets/app_text.dart';
import 'package:sodiet/view/widgets/common/custom_toast.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _isNutrientsSelected = true;
  bool _isExpanded = false;
  String _selectedDescription = 'select'; // Default description value

  // Description dropdown options
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

  late RecipeController recipeController = Get.find<RecipeController>();

  @override
  void initState() {
    super.initState();
    recipeController = Get.find<RecipeController>();

    // Automatically call nutrition API when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNutritionData();
    });
  }

  // Method to load nutrition data automatically
  void _loadNutritionData() async {
    String? recipeCode = widget.recipe['recipeCode'];
    if (recipeCode != null && recipeCode.isNotEmpty) {
      await recipeController.getRecipeNutrition(recipeCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Header with back button and title
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: Color(0xFF091242),
                              ),
                              const SizedBox(width: 4),
                              SemiBoldText(
                                'Back',
                                fontSize: 16,
                                textColor: const Color(0xFF091242),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      SemiBoldText(
                        'Recipe Detail',
                        fontSize: 18,
                        textColor: const Color(0xFF091242),
                      ),
                      const Spacer(),
                      const SizedBox(width: 60), // Balance the back button
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: !_isNutrientsSelected
                            ? 100
                            : 0, // Space for bottom widget when ingredients tab is active
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recipe Image - Updated to handle network images with Hero animation
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: Colors.grey.shade200,
                            ),
                            child: Hero(
                              tag: widget.recipe['heroTag'] ??
                                  'default_hero', // Use the passed hero tag
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: widget.recipe['imageUrl'] != null
                                    ? Image.network(
                                        widget.recipe['imageUrl'],
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            color: Colors.grey.shade200,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.shade200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey.shade400,
                                                  size: 60,
                                                ),
                                                const SizedBox(height: 8),
                                                RegularText(
                                                  'Image not available',
                                                  fontSize: 12,
                                                  textColor:
                                                      Colors.grey.shade600,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey.shade200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey.shade400,
                                              size: 60,
                                            ),
                                            const SizedBox(height: 8),
                                            RegularText(
                                              'No image available',
                                              fontSize: 12,
                                              textColor: Colors.grey.shade600,
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Recipe Title and Description
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SemiBoldText(
                                  widget.recipe['title'],
                                  fontSize: 20,
                                  textColor: const Color(0xFF091242),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: _isExpanded
                                            ? widget.recipe['description']
                                            : widget.recipe['description']
                                                    .substring(0, 50) +
                                                '...',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isExpanded = !_isExpanded;
                                            });
                                          },
                                          child: Text(
                                            _isExpanded
                                                ? ' See Less...'
                                                : 'See More...',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Tab Selection
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isNutrientsSelected = true;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: _isNutrientsSelected
                                              ? Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.3)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: _isNutrientsSelected
                                              ? Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  width: 1,
                                                )
                                              : null,
                                        ),
                                        child: Center(
                                          child: SemiBoldText(
                                            'Nutrients information',
                                            fontSize: 14,
                                            textColor: _isNutrientsSelected
                                                ? Theme.of(context)
                                                    .primaryColorDark
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isNutrientsSelected = false;
                                        });

                                        // Extract recipe code from the title to make API call
                                        // Assuming the recipe code is passed in the recipe data
                                        String? recipeCode =
                                            widget.recipe['recipeCode'];
                                        if (recipeCode != null &&
                                            recipeCode.isNotEmpty) {
                                          await recipeController
                                              .getRecipeIngredients(recipeCode);
                                        } else {
                                          CustomToast.showError(
                                              'Recipe code not available');
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: !_isNutrientsSelected
                                              ? Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.3)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: !_isNutrientsSelected
                                              ? Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 1,
                                                )
                                              : null,
                                        ),
                                        child: Center(
                                          child: SemiBoldText(
                                            'Ingredients',
                                            fontSize: 14,
                                            textColor: !_isNutrientsSelected
                                                ? Theme.of(context)
                                                    .primaryColorDark
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Tab content sections
                          const SizedBox(height: 16),

                          // Ingredients Section
                          if (!_isNutrientsSelected) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Obx(() {
                                if (recipeController
                                    .isLoadingIngredients.value) {
                                  return Container(
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          RegularText(
                                            'Loading ingredients...',
                                            fontSize: 14,
                                            textColor: Colors.grey.shade600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                if (recipeController
                                        .ingredientsResponse.value ==
                                    null) {
                                  return Container(
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.restaurant_menu,
                                            size: 48,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 16),
                                          SemiBoldText(
                                            'No ingredients data',
                                            fontSize: 16,
                                            textColor: Colors.grey.shade600,
                                          ),
                                          const SizedBox(height: 8),
                                          RegularText(
                                            'Ingredients information not available',
                                            fontSize: 14,
                                            textColor: Colors.grey.shade500,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final ingredients = recipeController
                                    .ingredientsResponse.value!.ingredients;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SemiBoldText(
                                      'Ingredients (${ingredients.length})',
                                      fontSize: 18,
                                      textColor: const Color(0xFF091242),
                                    ),
                                    const SizedBox(height: 16),

                                    // Ingredients Table
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
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
                                          // Table Header
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: SemiBoldText(
                                                    'Ingredient',
                                                    fontSize: 14,
                                                    textColor:
                                                        const Color(0xffA2A2A2),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: SemiBoldText(
                                                    'Description',
                                                    fontSize: 14,
                                                    textColor:
                                                        const Color(0xffA2A2A2),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: SemiBoldText(
                                                    'Unit',
                                                    fontSize: 14,
                                                    textColor:
                                                        const Color(0xffA2A2A2),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: SemiBoldText(
                                                    'Weight (gram)',
                                                    fontSize: 14,
                                                    textColor:
                                                        const Color(0xffA2A2A2),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Table Rows
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: ingredients.length,
                                            itemBuilder: (context, index) {
                                              final ingredient =
                                                  ingredients[index];
                                              return _buildIngredientItem(
                                                  ingredient, index);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],

                          // Nutrients Section (shown when nutrients tab is selected)
                          if (_isNutrientsSelected) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Obx(() {
                                if (recipeController.isLoadingNutrition.value) {
                                  return Container(
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          RegularText(
                                            'Loading nutrition information...',
                                            fontSize: 14,
                                            textColor: Colors.grey.shade600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                if (recipeController.nutritionResponse.value ==
                                    null) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SemiBoldText(
                                        'Nutrition Information',
                                        fontSize: 18,
                                        textColor: const Color(0xFF091242),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                size: 48,
                                                color: Colors.grey.shade400,
                                              ),
                                              const SizedBox(height: 16),
                                              RegularText(
                                                'Nutrition information not available',
                                                fontSize: 14,
                                                textColor: Colors.grey.shade600,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                final nutrition = recipeController
                                    .nutritionResponse.value!.nutrition;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nutrition Grid
                                    GridView.count(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.85,
                                      children: [
                                        _buildNutritionCard(
                                          'Energy Kcal',
                                          nutrition.energyKcal
                                              .toStringAsFixed(0),
                                          Icons.local_fire_department,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Protein (g)',
                                          nutrition.proteinG.toStringAsFixed(2),
                                          Icons.fitness_center,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Fat (g)',
                                          nutrition.totalFatG
                                              .toStringAsFixed(2),
                                          Icons.water_drop,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Iron (mg)',
                                          nutrition.ironMg.toStringAsFixed(2),
                                          Icons.settings,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Calcium (mg)',
                                          nutrition.calciumMg
                                              .toStringAsFixed(2),
                                          Icons.medication,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Dietary Fiber (g)',
                                          nutrition.totalDietaryFibreG
                                              .toStringAsFixed(2),
                                          Icons.grass,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Magnesium (mg)',
                                          nutrition.magnesiumMg
                                              .toStringAsFixed(2),
                                          Icons.science,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Folate (ug)',
                                          nutrition.totalFolatesMcg
                                              .toStringAsFixed(2),
                                          Icons.biotech,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Vit B12 (ug)',
                                          nutrition.vb12Ug.toStringAsFixed(2),
                                          Icons.medication,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Vit B1 (ug)',
                                          nutrition.thiamineMg
                                              .toStringAsFixed(2),
                                          Icons.medication,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Vit B2 (ug)',
                                          nutrition.riboflavinMg
                                              .toStringAsFixed(2),
                                          Icons.medication,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Vit B3 (ug)',
                                          nutrition.niacinMg.toStringAsFixed(2),
                                          Icons.medication,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Vit B6 (ug)',
                                          nutrition.totalB6AMg
                                              .toStringAsFixed(2),
                                          Icons.medication,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Vit C (ug)',
                                          nutrition.totalAscorbicAcidMg
                                              .toStringAsFixed(1),
                                          Icons.medication,
                                          Colors.orange,
                                        ),
                                        _buildNutritionCard(
                                          'Vit A (ug)',
                                          nutrition.vaRaeMcg.toStringAsFixed(2),
                                          Icons.medication,
                                          Colors.orange,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom description selector - only show when ingredients tab is selected
            if (!_isNutrientsSelected)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFFFF4E6), // Light orange background
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDescription,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF9500), // Orange text
                          ),
                          dropdownColor: Colors.white,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFFFF9500),
                            size: 24,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedDescription = newValue;
                              });
                            }
                          },
                          items: _descriptionOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF091242),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientItem(Ingredient ingredient, int index) {
    final isEvenRow = index % 2 == 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEvenRow ? Colors.white : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Ingredient Name with Icon
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // Small ingredient icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: Theme.of(context).primaryColorDark,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MediumText(
                    ingredient.ingredients,
                    fontSize: 14,
                    textColor: const Color(0xFF091242),
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),

          // Description
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDescription,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xffA2A2A2),
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xffA2A2A2),
                    size: 16,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedDescription = newValue;
                      });
                    }
                  },
                  items: _descriptionOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xffA2A2A2),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Unit
          Expanded(
            flex: 2,
            child: MediumText(
              ingredient.unit.isNotEmpty ? ingredient.unit : 'none',
              fontSize: 14,
              textColor: const Color(0xffA2A2A2),
              textAlign: TextAlign.center,
            ),
          ),

          // Weight (gram)
          Expanded(
            flex: 2,
            child: MediumText(
              '${ingredient.ingRawAmountsG.toStringAsFixed(2)}gm',
              fontSize: 14,
              textColor: const Color(0xffA2A2A2),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(
      String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Light gray background like tab
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to left
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Orange icon at top left
          Icon(
            Icons.local_fire_department, // Orange flame icon for all
            color: Colors.orange,
            size: 28,
          ),
          const SizedBox(height: 15),

          // Title/label first
          RegularText(
            title,
            fontSize: 12,
            textAlign: TextAlign.left,
            maxLines: 2,
          ),
          const SizedBox(height: 4),

          // Large value in primary dark color (green) - below title
          SemiBoldText(
            value,
            fontSize: 20,
            textColor: Theme.of(context).primaryColorDark,
            textAlign: TextAlign.left,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
