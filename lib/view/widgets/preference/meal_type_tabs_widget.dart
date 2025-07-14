import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class MealTypeTabsWidget extends StatelessWidget {
  final String selectedMealType;
  final ValueChanged<String> onMealTypeSelected;
  final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  MealTypeTabsWidget({
    Key? key,
    required this.selectedMealType,
    required this.onMealTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: mealTypes.map((mealType) {
          final isSelected = mealType == selectedMealType;
          return Expanded(
            child: GestureDetector(
              onTap: () => onMealTypeSelected(mealType),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColorDark.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColorDark
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: SemiBoldText(
                    mealType,
                    fontSize: 14,
                    textColor: isSelected
                        ? Theme.of(context).primaryColorDark
                        : const Color(0xFF091242),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
