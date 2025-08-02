import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class DietRecallListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final Function(int index)? onEdit;
  final Function(int index)? onDelete;

  const DietRecallListWidget({
    Key? key,
    required this.entries,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.restaurant_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              RegularText(
                'No entries added yet',
                fontSize: 16,
                textColor: Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              RegularText(
                'Add your first food entry above',
                fontSize: 14,
                textColor: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.list_alt,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                SemiBoldText(
                  'Today\'s Entries',
                  fontSize: 16,
                  textColor: Colors.black87,
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RegularText(
                    '${entries.length} ${entries.length == 1 ? 'item' : 'items'}',
                    fontSize: 12,
                    textColor: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          // Entries List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _buildFoodEntryItem(context, entry, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFoodEntryItem(
      BuildContext context, Map<String, dynamic> entry, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Food Icon/Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getTimingColor(entry['timing']),
              borderRadius: BorderRadius.circular(10),
            ),
            child: entry['image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      entry['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          _getTimingIcon(entry['timing']),
                          color: Colors.white,
                          size: 24,
                        );
                      },
                    ),
                  )
                : Icon(
                    _getTimingIcon(entry['timing']),
                    color: Colors.white,
                    size: 24,
                  ),
          ),

          const SizedBox(width: 12),

          // Food Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SemiBoldText(
                      entry['foodName'] ?? 'Unknown Food',
                      fontSize: 16,
                      textColor: Colors.black87,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            _getTimingColor(entry['timing']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RegularText(
                        entry['timing'] ?? 'Meal',
                        fontSize: 10,
                        textColor: _getTimingColor(entry['timing']),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RegularText(
                  '${entry['quantity'] ?? '0'} ${entry['unit'] ?? 'unit'}',
                  fontSize: 14,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEdit != null)
                GestureDetector(
                  onTap: () => onEdit!(index),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              if (onEdit != null && onDelete != null) const SizedBox(width: 8),
              if (onDelete != null)
                GestureDetector(
                  onTap: () => onDelete!(index),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTimingColor(String? timing) {
    switch (timing?.toLowerCase()) {
      case 'breakfast':
        return const Color(0xFFFF9800); // Orange
      case 'lunch':
        return const Color(0xFF4CAF50); // Green
      case 'dinner':
        return const Color(0xFF2196F3); // Blue
      case 'snacks':
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF8D4E2A); // Brown
    }
  }

  IconData _getTimingIcon(String? timing) {
    switch (timing?.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny;
      case 'lunch':
        return Icons.wb_sunny_outlined;
      case 'dinner':
        return Icons.nightlight_round;
      case 'snacks':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }
}
