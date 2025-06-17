import 'package:flutter/material.dart';
import 'package:sodiet/view/widgets/app_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool showShadow;
  final double borderRadius;
  final EdgeInsets? margin;
  final bool isOutlined;
  final Color? borderColor;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.showShadow = false,
    this.borderRadius = 12.0,
    this.margin,
    this.isOutlined = false,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ]
            : null,
      ),
      child: TextButton(
        onPressed: onPressed as void Function()?,
        style: TextButton.styleFrom(
          backgroundColor: isOutlined
              ? Colors.transparent
              : (backgroundColor ?? Theme.of(context).primaryColor),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: isOutlined
                ? BorderSide(
                    color: Theme.of(context).primaryColorDark, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Center(
          child: MediumText(
            text,
            fontSize: 14,
            textColor: textColor ??
                (isOutlined
                    ? Theme.of(context).primaryColorDark
                    : Theme.of(context).hintColor),
          ),
        ),
      ),
    );
  }
}
