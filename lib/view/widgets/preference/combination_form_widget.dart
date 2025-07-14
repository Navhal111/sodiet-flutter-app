import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class CombinationFormWidget extends StatelessWidget {
  final String selectedFood;
  final String quantity;
  final ValueChanged<String?> onFoodChanged;
  final ValueChanged<String> onQuantityChanged;
  final VoidCallback onAddCombination;

  static const List<String> foodOptions = [
    'Masala Karela with vegetable filling recipe',
    'Biryani',
    'Rice Cooked',
    'Tomatoes',
    'Bele bhat powder'
  ];

  CombinationFormWidget({
    Key? key,
    required this.selectedFood,
    required this.quantity,
    required this.onFoodChanged,
    required this.onQuantityChanged,
    required this.onAddCombination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SemiBoldText(
            'Combination 1',
            fontSize: 18,
            textColor: const Color(0xFF091242),
          ),
          const SizedBox(height: 16),

          // Food name dropdown
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: foodOptions.contains(selectedFood) ? selectedFood : null,
              decoration: const InputDecoration(
                hintText: 'Select food item',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              items: foodOptions.map((String food) {
                return DropdownMenuItem<String>(
                  value: food,
                  child: Text(
                    food,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onFoodChanged,
              icon:
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
            ),
          ),

          const SizedBox(height: 16),

          // Quantity field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: onQuantityChanged,
              decoration: const InputDecoration(
                hintText: 'Enter quantity (e.g., 1 cup, 200g)',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Add combination button
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF9800).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onAddCombination,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  SemiBoldText(
                    'Add Combination',
                    fontSize: 16,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
