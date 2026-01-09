import 'package:flutter/material.dart';

import '../../core/theme/auth_theme.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onToggleObscure;
  final Widget? suffixIcon;
  final bool enabled;

  /// Custom theme for this field. If null, uses AuthThemeProvider or defaults.
  final AuthTheme? theme;

  const AuthTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onToggleObscure,
    this.suffixIcon,
    this.enabled = true,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final authTheme =
        theme ?? AuthThemeProvider.maybeOf(context) ?? const AuthTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              authTheme.labelStyle ??
              TextStyle(
                fontWeight: FontWeight.w500,
                color: authTheme.labelColor,
                fontFamily: authTheme.fontFamily,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          style:
              authTheme.inputTextStyle ??
              TextStyle(
                color: authTheme.inputTextColor,
                fontFamily: authTheme.fontFamily,
              ),
          decoration:
              authTheme.inputDecoration?.copyWith(
                hintText: hint,
                errorText: errorText,
                suffixIcon: suffixIcon,
              ) ??
              InputDecoration(
                hintText: hint,
                errorText: errorText,
                hintStyle:
                    authTheme.hintStyle ??
                    TextStyle(
                      color: authTheme.hintColor ?? Colors.grey.shade500,
                      fontFamily: authTheme.fontFamily,
                    ),
                filled: authTheme.inputBackgroundColor != null,
                fillColor: authTheme.inputBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    authTheme.inputBorderRadius,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    authTheme.inputBorderRadius,
                  ),
                  borderSide: BorderSide(
                    color: authTheme.inputBorderColor ?? Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    authTheme.inputBorderRadius,
                  ),
                  borderSide: BorderSide(
                    color:
                        authTheme.inputFocusedBorderColor ??
                        authTheme.primaryColor,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    authTheme.inputBorderRadius,
                  ),
                  borderSide: BorderSide(color: authTheme.errorColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    authTheme.inputBorderRadius,
                  ),
                  borderSide: BorderSide(color: authTheme.errorColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: suffixIcon,
              ),
        ),
      ],
    );
  }
}
