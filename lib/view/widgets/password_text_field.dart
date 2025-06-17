import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final bool isEnabled;
  final EdgeInsets? padding;

  const PasswordTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.padding,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hintText: "Password",
      labelText: widget.labelText,
      isPassword: _obscureText,
      focusNode: widget.focusNode,
      nextFocus: widget.nextFocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      validator: widget.validator,
      isEnabled: widget.isEnabled,
      padding: widget.padding,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Container(
          width: 60,
          padding: const EdgeInsets.only(right: 16),
          alignment: Alignment.centerRight,
          child: Text(
            _obscureText ? "Show" : "Hide",
            style: TextStyle(
              color: Theme.of(context).hintColor.withOpacity(
                  0.6), // Using primary color for better visibility
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
