import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class RecipeCategoryFilterWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const RecipeCategoryFilterWidget({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return Container(
            margin: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: () => onCategorySelected(category),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: SemiBoldText(
                    category,
                    fontSize: 14,
                    textColor: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
