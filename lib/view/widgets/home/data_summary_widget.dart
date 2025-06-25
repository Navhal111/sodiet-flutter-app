import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class DataSummaryWidget extends StatelessWidget {
  final String title;
  final String startValue;
  final String endValue;
  final Function() onClick;
  final String? icon;
  final Color iconBackgroundColor;
  final Color? backgroundColor;
  final Color? textColor;

  const DataSummaryWidget({
    Key? key,
    required this.title,
    required this.startValue,
    required this.endValue,
    required this.onClick,
    this.icon,
    this.iconBackgroundColor =
        const Color(0xFFE07A5F), // Coral/orange color from image
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: MediaQuery.of(context).size.width - 80,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left circle icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
              ),
              child: Center(
                child: Image.asset(
                  icon ?? 'assets/images/pulse.png',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Right text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegularText(
                    title,
                    fontSize: 14,
                    textColor: Colors.grey[600],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SemiBoldText(
                        startValue,
                        fontSize: 24,
                        textColor: textColor,
                      ),
                      const SizedBox(width: 8),
                      if (endValue.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_forward, size: 20),
                            const SizedBox(width: 8),
                            SemiBoldText(
                              endValue,
                              fontSize: 24,
                              textColor: textColor,
                            ),
                          ],
                        )
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
