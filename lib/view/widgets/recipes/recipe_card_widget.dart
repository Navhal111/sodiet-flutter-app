import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class RecipeCardWidget extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback? onTap;

  const RecipeCardWidget({
    Key? key,
    required this.recipe,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              child: Container(
                height: 170,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: Image.asset(
                  recipe['imagePath'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print(
                        'Error loading image: ${recipe['imagePath']}, Error: $error');
                    return Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey.shade400,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Recipe Info
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SemiBoldText(
                    recipe['name'],
                    fontSize: 14,
                    textColor: const Color(0xFF091242),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  RegularText(
                    recipe['description'],
                    fontSize: 14,
                    textColor: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Calories
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 12,
                              color: Colors.orange.shade600,
                            ),
                            const SizedBox(width: 2),
                            MediumText(
                              '${recipe['calories']} kcal',
                              fontSize: 10,
                              textColor: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Cooking Time
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 2),
                            MediumText(
                              '${recipe['cookingTime']}min',
                              fontSize: 10,
                              textColor: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
