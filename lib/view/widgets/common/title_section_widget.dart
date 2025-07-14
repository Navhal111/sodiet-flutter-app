import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class TitleSectionWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final double? imageWidth;
  final double? imageHeight;
  final double? titleFontSize;
  final double? descriptionFontSize;
  final Color? titleColor;
  final Color? descriptionColor;
  final int? maxLines;

  const TitleSectionWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.imageWidth = 100,
    this.imageHeight = 100,
    this.titleFontSize = 20,
    this.descriptionFontSize = 14,
    this.titleColor = const Color(0xFF091242),
    this.descriptionColor,
    this.maxLines = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            child: Image.asset(
              imagePath,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SemiBoldText(
                  title,
                  fontSize: titleFontSize!,
                  textColor: titleColor!,
                ),
                const SizedBox(height: 4),
                RegularText(
                  description,
                  fontSize: descriptionFontSize!,
                  textColor: descriptionColor ?? Colors.grey.shade600,
                  maxLines: maxLines,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
