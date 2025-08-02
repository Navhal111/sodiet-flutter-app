import 'package:flutter/material.dart';
import '../../widgets/app_text.dart';

class DietRecallListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const DietRecallListWidget({
    Key? key,
    required this.entries,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  Color _getTimingColor(String timing) {
    switch (timing) {
      case 'Breakfast':
        return const Color(0xFFFFEB3B); // Yellow
      case 'Lunch':
        return const Color(0xFFFF9800); // Orange
      case 'Dinner':
        return const Color(0xFF9C27B0); // Purple
      case 'Snaks':
        return const Color(0xFF4CAF50); // Green
      default:
        return const Color(0xFF2196F3); // Blue
    }
  }

  String _getTimingIcon(String timing) {
    switch (timing) {
      case 'Breakfast':
        return 'assets/icons/breakfast.png';
      case 'Lunch':
        return 'assets/icons/lunch.png';
      case 'Dinner':
        return 'assets/icons/dinner.png';
      case 'Snaks':
        return 'assets/icons/snaks.png';
      default:
        return 'assets/icons/breakfast.png';
    }
  }

  String _getUnitIcon(String unit) {
    switch (unit) {
      case 'Cup':
        return 'assets/units/cup.png';
      case 'Bowl':
        return 'assets/units/bowl.png';
      case 'Spoon':
        return 'assets/units/spoon.png';
      case 'Plate':
        return 'assets/units/plate.png';
      case 'Glass':
        return 'assets/units/glass.png';
      case 'Piece':
        return 'assets/units/piece.png';
      default:
        return 'assets/units/cup.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            RegularText(
              'No diet entries yet',
              fontSize: 16,
              textColor: Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            RegularText(
              'Add your first meal to get started',
              fontSize: 14,
              textColor: Colors.grey.shade500,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.list_alt,
                color: const Color(0xFF4CAF50),
                size: 20,
              ),
              const SizedBox(width: 8),
              SemiBoldText(
                'Diet Entries (${entries.length})',
                fontSize: 16,
                textColor: Colors.grey.shade800,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final timingColor =
                  _getTimingColor(entry['timing'] ?? 'Breakfast');

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Timing and Actions
                    Row(
                      children: [
                        // Timing Icon and Label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: timingColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: timingColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                child: Image.asset(
                                  _getTimingIcon(
                                      entry['timing'] ?? 'Breakfast'),
                                  width: 16,
                                  height: 16,
                                  color: timingColor,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.restaurant,
                                      color: timingColor,
                                      size: 16,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              MediumText(
                                entry['timing'] ?? 'Breakfast',
                                fontSize: 12,
                                textColor: timingColor,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        // Action Buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit Button
                            GestureDetector(
                              onTap: () => onEdit(index),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF2196F3).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF2196F3),
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Delete Button
                            GestureDetector(
                              onTap: () => onDelete(index),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFF44336).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Color(0xFFF44336),
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Food Information
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Food Icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            color: Color(0xFF4CAF50),
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Food Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Food Name
                              SemiBoldText(
                                entry['foodName'] ?? 'Unknown Food',
                                fontSize: 16,
                                textColor: Colors.grey.shade800,
                              ),

                              const SizedBox(height: 4),

                              // Quantity and Unit
                              Row(
                                children: [
                                  // Unit Icon
                                  Container(
                                    width: 16,
                                    height: 16,
                                    child: Image.asset(
                                      _getUnitIcon(entry['unit'] ?? 'Cup'),
                                      width: 16,
                                      height: 16,
                                      color: const Color(0xFF4CAF50),
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.dining,
                                          color: Color(0xFF4CAF50),
                                          size: 16,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  MediumText(
                                    '${entry['quantity'] ?? '0'} ${entry['unit'] ?? 'Cup'}',
                                    fontSize: 14,
                                    textColor: const Color(0xFF4CAF50),
                                  ),
                                ],
                              ),

                              if (entry['date'] != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    RegularText(
                                      entry['date'],
                                      fontSize: 12,
                                      textColor: Colors.grey.shade600,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
