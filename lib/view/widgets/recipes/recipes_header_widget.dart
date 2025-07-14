import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class RecipesHeaderWidget extends StatelessWidget {
  final VoidCallback onAddRecipeTap;

  const RecipesHeaderWidget({
    Key? key,
    required this.onAddRecipeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Menu Icon/Illustration
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.menu_book_outlined,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),

          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SemiBoldText(
                  'Recipes',
                  fontSize: 20,
                  textColor: const Color(0xFF091242),
                ),
                const SizedBox(height: 4),
                RegularText(
                  'All your recipes will be shown here, you can view or manage your recipes here.',
                  fontSize: 12,
                  textColor: Colors.grey.shade600,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                // Add Recipe Button
                GestureDetector(
                  onTap: onAddRecipeTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFFF9500), // Orange color like in screenshot
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        MediumText(
                          'Add new recipe',
                          fontSize: 12,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
