import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class DishesSectionWidget extends StatelessWidget {
  final String sortBy;
  final VoidCallback onSortTap;

  const DishesSectionWidget({
    Key? key,
    this.sortBy = 'Time',
    required this.onSortTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SemiBoldText(
          'All Dishes',
          fontSize: 18,
          textColor: const Color(0xFF091242),
        ),
        GestureDetector(
          onTap: onSortTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RegularText(
                  'Sort by: ',
                  fontSize: 14,
                  textColor: Colors.grey.shade600,
                ),
                SemiBoldText(
                  sortBy,
                  fontSize: 14,
                  textColor: Colors.black87,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
