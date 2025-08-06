import 'package:flutter/material.dart';
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
                                    if (loadingProgress == null) return child;
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
                                              AlwaysStoppedAnimation<Color>(
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
                                            textColor: Colors.grey.shade600,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey.shade200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  CustomToast.showInfo(
                                      'Ingredients data will be available soon');
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

                    // ...existing tab content sections...

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
}
