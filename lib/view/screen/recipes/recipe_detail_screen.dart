import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Image
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.grey.shade100,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          widget.recipe['imagePath'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade400,
                                size: 60,
                              ),
                            );
                          },
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
                            widget.recipe['name'],
                            fontSize: 20,
                            textColor: const Color(0xFF091242),
                          ),
                          const SizedBox(height: 8),
                          RegularText(
                            'Alternate Recipe',
                            fontSize: 14,
                            textColor: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _isExpanded
                                      ? 'Lorem Ipsum is simply dummy text of the #printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                                      : 'Lorem Ipsum is simply dummy text of the #printing and typesetting industry. Lorem Ipsum has been ',
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
                                        color: Theme.of(context).primaryColor,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _isNutrientsSelected
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
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
                                  setState(() {
                                    _isNutrientsSelected = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: !_isNutrientsSelected
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.3)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: !_isNutrientsSelected
                                        ? Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: SemiBoldText(
                                      'Ingredients',
                                      fontSize: 14,
                                      textColor: !_isNutrientsSelected
                                          ? Theme.of(context).primaryColorDark
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

                    const SizedBox(height: 24),

                    // Nutrients Grid
                    if (_isNutrientsSelected) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                          children: [
                            _buildNutrientCard('🔥', 'Energy Kcal', '2206'),
                            _buildNutrientCard('🔥', 'Protein (g)', '3.44'),
                            _buildNutrientCard('🔥', 'Fat (g)', '3.55'),
                            _buildNutrientCard('🔥', 'Iron (mg)', '2.7'),
                            _buildNutrientCard('🦴', 'Calcium (mg)', '44.96'),
                            _buildNutrientCard(
                                '🔥', 'Dietary Fiber (g)', '6.43'),
                            _buildNutrientCard('🔥', 'Magnesium (mg)', '56.15'),
                            _buildNutrientCard('🦴', 'Folate (ug)', '74.61'),
                            _buildNutrientCard('💊', 'Vit B12 (ug)', '0.0'),
                            _buildNutrientCard('💊', 'Vit B1 (ug)', '0.09'),
                            _buildNutrientCard('💊', 'Vit B2 (ug)', '0.07'),
                            _buildNutrientCard('💊', 'Vit B3 (ug)', '0.61'),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Ingredients Table
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: SemiBoldText(
                                      'Ingredient',
                                      fontSize: 14,
                                      textColor: Colors.grey.shade700,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: SemiBoldText(
                                      'Quantity',
                                      fontSize: 14,
                                      textColor: Colors.grey.shade700,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SemiBoldText(
                                      'Unit',
                                      fontSize: 14,
                                      textColor: Colors.grey.shade700,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SemiBoldText(
                                      'Weight (gram)',
                                      fontSize: 14,
                                      textColor: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Separator line
                            Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 8),
                            // Table Rows
                            _buildIngredientRow(
                              'assets/images/food/food2.png',
                              'Rice Cooked',
                              '0.63',
                              'cup',
                              '28.10gm',
                              isEven: false,
                            ),
                            _buildIngredientRow(
                              'assets/images/food/food1.png',
                              'Tomatoes',
                              '0.75',
                              'none',
                              '78.70gm',
                              isEven: true,
                            ),
                            _buildIngredientRow(
                              'assets/images/food/food2.png',
                              'Bele bhat powder',
                              '0.75',
                              'tablespoon',
                              '3.26gm',
                              isEven: false,
                            ),
                            _buildIngredientRow(
                              'assets/images/food/food1.png',
                              'Rice Cooked',
                              '0.63',
                              'cup',
                              '28.10gm',
                              isEven: true,
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard(String icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon on the left
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumText(
                  label,
                  fontSize: 12,
                  textColor: Colors.black,
                  maxLines: 2,
                ),
                const SizedBox(height: 2),
                SemiBoldText(
                  value,
                  fontSize: 18,
                  textColor: Theme.of(context).primaryColorDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(
    String imagePath,
    String ingredient,
    String quantity,
    String unit,
    String weight, {
    required bool isEven,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          decoration: BoxDecoration(
            color: isEven ? Colors.white : Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RegularText(
                        ingredient,
                        fontSize: 12,
                        textColor: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: RegularText(
                  quantity,
                  fontSize: 12,
                  textColor: Colors.grey.shade700,
                ),
              ),
              Expanded(
                flex: 1,
                child: RegularText(
                  unit,
                  fontSize: 12,
                  textColor: Colors.grey.shade700,
                ),
              ),
              Expanded(
                flex: 1,
                child: RegularText(
                  weight,
                  fontSize: 12,
                  textColor: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        // Separator line
        Container(
          height: 1,
          color: Colors.grey.shade300,
          margin: const EdgeInsets.only(top: 0),
        ),
      ],
    );
  }
}
