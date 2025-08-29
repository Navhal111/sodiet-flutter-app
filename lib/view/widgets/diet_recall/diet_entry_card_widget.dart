import 'package:flutter/material.dart';

import '../app_text.dart';

class DietEntryCardWidget extends StatelessWidget {
  final String title;
  final String? recipeCode;
  final String? subtitle;
  final String? imagePath;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final double? imageSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const DietEntryCardWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.imagePath,
    this.recipeCode,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16,
    this.imageSize = 90,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                // Food Image - Left side with no padding
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12)),
                  child: _buildImage(),
                ),

                const SizedBox(width: 12),

                // Title and Unit (subtitle) - Middle section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      MediumText(title,
                          fontSize: fontSize,
                          textColor: textColor ?? Colors.black87,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2),
                      const SizedBox(
                        height: 20,
                      ),
                      SemiBoldText(
                        subtitle ?? "",
                        fontSize: 12,
                        textColor: Theme.of(context).primaryColorDark,
                      )
                    ],
                  ),
                ),

                // Action Buttons - Right side with light orange background
                Container(
                  margin: EdgeInsets.only(right: 16, top: 40),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB74D)
                              .withOpacity(0.2), // Light orange background
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: onEdit,
                          icon: const Icon(
                            Icons.edit,
                            color: const Color(0xFFFFB74D),
                            size: 16,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB74D)
                              .withOpacity(0.2), // Light orange background
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: onDelete,
                          icon: const Icon(
                            Icons.delete,
                            color: const Color(0xFFFFB74D),
                            size: 16,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Check if imagePath is a network URL (starts with http)
    if (imagePath != null && imagePath!.startsWith('http')) {
      return Image.network(
        imagePath!,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.grey.shade400,
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Fallback to asset image or default error image
      return _buildErrorImage();
    }
  }

  Widget _buildErrorImage() {
    return Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      child: Icon(
        Icons.restaurant_menu,
        color: Colors.grey.shade400,
        size: imageSize! * 0.4,
      ),
    );
  }
}
