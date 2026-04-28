import 'package:flutter/material.dart';

import '../../../commons/animations/app_animated_entry.dart';
import '../../../commons/widgets/app_text_field.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.index,
    required this.controller,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.prefixIcon,
  });

  final int index;
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool isPassword;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;
  final IconData? prefixIcon;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final suffixIcon = widget.isPassword
        ? IconButton(
            tooltip: _obscureText ? 'Show password' : 'Hide password',
            onPressed: () => setState(() => _obscureText = !_obscureText),
            icon: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          )
        : null;

    return AppAnimatedEntry(
      delay: Duration(milliseconds: widget.index * 90),
      child: AppTextField(
        controller: widget.controller,
        labelText: widget.label,
        hintText: widget.hint,
        obscureText: widget.isPassword ? _obscureText : false,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        onSubmitted: widget.onSubmitted,
        prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
