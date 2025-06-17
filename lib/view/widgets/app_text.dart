import 'package:flutter/material.dart';

enum FontType {
  Regular,
  Medium,
  SemiBold,
  Bold,
}

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? textColor;
  final FontType fontType;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final TextDecoration? decoration;
  final double? letterSpacing;

  const AppText(
    this.text, {
    Key? key,
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.fontType = FontType.Regular,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.decoration,
    this.letterSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: fontSize,
        color: textColor,
        fontWeight: _getFontWeight(),
        height: height,
        decoration: decoration,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  FontWeight _getFontWeight() {
    switch (fontType) {
      case FontType.Regular:
        return FontWeight.w400;
      case FontType.Medium:
        return FontWeight.w500;
      case FontType.SemiBold:
        return FontWeight.w600;
      case FontType.Bold:
        return FontWeight.w700;
      default:
        return FontWeight.w400;
    }
  }
}

// Convenience classes for common text styles
class RegularText extends AppText {
  RegularText(
    String text, {
    Key? key,
    double? fontSize,
    Color? textColor,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) : super(
          text,
          key: key,
          fontSize: fontSize,
          textColor: textColor,
          fontType: FontType.Regular,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          height: height,
          decoration: decoration,
          letterSpacing: letterSpacing,
        );
}

class MediumText extends AppText {
  MediumText(
    String text, {
    Key? key,
    double? fontSize,
    Color? textColor,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) : super(
          text,
          key: key,
          fontSize: fontSize,
          textColor: textColor,
          fontType: FontType.Medium,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          height: height,
          decoration: decoration,
          letterSpacing: letterSpacing,
        );
}

class SemiBoldText extends AppText {
  SemiBoldText(
    String text, {
    Key? key,
    double? fontSize,
    Color? textColor,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) : super(
          text,
          key: key,
          fontSize: fontSize,
          textColor: textColor,
          fontType: FontType.SemiBold,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          height: height,
          decoration: decoration,
          letterSpacing: letterSpacing,
        );
}

class BoldText extends AppText {
  BoldText(
    String text, {
    Key? key,
    double? fontSize,
    Color? textColor,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) : super(
          text,
          key: key,
          fontSize: fontSize,
          textColor: textColor,
          fontType: FontType.Bold,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          height: height,
          decoration: decoration,
          letterSpacing: letterSpacing,
        );
}
