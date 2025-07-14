import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class CombinationsListWidget extends StatelessWidget {
  final List<Map<String, String>> combinations;
  final ValueChanged<int> onDeleteCombination;

  const CombinationsListWidget({
    Key? key,
    required this.combinations,
    required this.onDeleteCombination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (combinations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        SemiBoldText(
          'Combinations',
          fontSize: 18,
          textColor: const Color(0xFF091242),
        ),
        const SizedBox(height: 16),
        ...combinations.asMap().entries.map((entry) {
          final index = entry.key;
          final combination = entry.value;
          return _buildCombinationItem(index, combination);
        }).toList(),
      ],
    );
  }

  Widget _buildCombinationItem(int index, Map<String, String> combination) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: SemiBoldText(
                '${index + 1}',
                fontSize: 12,
                textColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '- ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RegularText(
                  '${combination['food']}',
                  fontSize: 14,
                  textColor: const Color(0xFF091242),
                  maxLines: 2,
                ),
                if (combination['quantity']?.isNotEmpty == true)
                  RegularText(
                    'Quantity: ${combination['quantity']}',
                    fontSize: 12,
                    textColor: Colors.grey.shade600,
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onDeleteCombination(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red.shade400,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
