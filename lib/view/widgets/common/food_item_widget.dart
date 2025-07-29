import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class FoodItemWidget extends StatelessWidget {
  final String itemName;
  final String quantity;
  final String? imagePath;
  final IconData? itemIcon;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color backgroundColor;
  final Color textColor;

  const FoodItemWidget({
    Key? key,
    required this.itemName,
    required this.quantity,
    this.imagePath,
    this.itemIcon,
    this.onEdit,
    this.onDelete,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
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
      child: Row(
        children: [
          // Item Image/Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF8D4E2A), // Coffee brown color
              borderRadius: BorderRadius.circular(8),
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          itemIcon ?? Icons.fastfood,
                          color: Colors.white,
                          size: 24,
                        );
                      },
                    ),
                  )
                : Icon(
                    itemIcon ?? Icons.local_cafe,
                    color: Colors.white,
                    size: 24,
                  ),
          ),

          const SizedBox(width: 12),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SemiBoldText(
                  itemName,
                  fontSize: 16,
                  textColor: textColor,
                ),
                const SizedBox(height: 4),
                RegularText(
                  quantity,
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
                  onTap: onEdit,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800),
                      borderRadius: BorderRadius.circular(6),
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
                  onTap: onDelete,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800),
                      borderRadius: BorderRadius.circular(6),
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
}

// Alternative simplified version for just display
class SimpleFoodItemWidget extends StatelessWidget {
  final String itemName;
  final String quantity;
  final String? imagePath;
  final IconData? itemIcon;
  final Color itemColor;

  const SimpleFoodItemWidget({
    Key? key,
    required this.itemName,
    required this.quantity,
    this.imagePath,
    this.itemIcon,
    this.itemColor = const Color(0xFF8D4E2A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          // Item Image/Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: itemColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          itemIcon ?? Icons.fastfood,
                          color: Colors.white,
                          size: 24,
                        );
                      },
                    ),
                  )
                : Icon(
                    itemIcon ?? Icons.local_cafe,
                    color: Colors.white,
                    size: 24,
                  ),
          ),

          const SizedBox(width: 12),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SemiBoldText(
                  itemName,
                  fontSize: 16,
                  textColor: Colors.black87,
                ),
                const SizedBox(height: 4),
                RegularText(
                  quantity,
                  fontSize: 14,
                  textColor: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
