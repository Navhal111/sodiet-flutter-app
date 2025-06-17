import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? textInputType;
  final bool isPassword;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final bool isEnabled;
  final InputDecoration? inputDecoration;
  final EdgeInsets? padding;
  final int? maxLines;

  const CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.textInputType,
    this.isPassword = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputDecoration,
    this.padding,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        enabled: isEnabled,
        obscureText: isPassword,
        validator: validator,
        style: TextStyle(
          color: Colors
              .black, // Always use black for input text to ensure visibility
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        keyboardType: textInputType ?? TextInputType.text,
        onChanged: onChanged,
        onFieldSubmitted: (text) {
          if (onSubmitted != null) {
            onSubmitted!(text);
          } else if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        decoration: inputDecoration ??
            InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              hintText: hintText,
              labelText: labelText,
              hintStyle: TextStyle(
                color: Theme.of(context).hintColor.withOpacity(
                    0.6), // Using a definite grey shade for better visibility
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
              filled: true,
              fillColor: Theme.of(context)
                  .cardColor
                  .withOpacity(0.8), // Use light gray from theme
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
      ),
    );
  }
}
