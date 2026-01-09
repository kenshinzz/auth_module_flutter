import 'package:flutter/material.dart';

/// Theme configuration for the Auth Module.
///
/// Provides customization for colors, typography, and component styling.
///
/// Example:
/// ```dart
/// AuthTheme(
///   primaryColor: Colors.indigo,
///   backgroundColor: Colors.white,
///   inputBorderRadius: 12,
///   buttonBorderRadius: 12,
///   fontFamily: 'Poppins',
/// )
/// ```
class AuthTheme {
  /// Primary color used for buttons, links, and focus states.
  final Color primaryColor;

  /// Background color for the login screen.
  final Color? backgroundColor;

  /// Color for the title text.
  final Color? titleColor;

  /// Color for the subtitle text.
  final Color? subtitleColor;

  /// Color for input field labels.
  final Color? labelColor;

  /// Color for input field hints.
  final Color? hintColor;

  /// Color for input field text.
  final Color? inputTextColor;

  /// Border color for input fields.
  final Color? inputBorderColor;

  /// Border color for focused input fields.
  final Color? inputFocusedBorderColor;

  /// Background color for input fields.
  final Color? inputBackgroundColor;

  /// Error color for validation messages and error states.
  final Color errorColor;

  /// Background color for error message container.
  final Color? errorBackgroundColor;

  /// Color for the primary button text.
  final Color? buttonTextColor;

  /// Background color for the primary button.
  final Color? buttonBackgroundColor;

  /// Color for the checkbox.
  final Color? checkboxColor;

  /// Color for secondary text (remember me, etc.).
  final Color? secondaryTextColor;

  /// Border radius for input fields.
  final double inputBorderRadius;

  /// Border radius for buttons.
  final double buttonBorderRadius;

  /// Border radius for error message container.
  final double errorBorderRadius;

  /// Height of the primary button.
  final double buttonHeight;

  /// Font family for all text.
  final String? fontFamily;

  /// Text style for the title.
  final TextStyle? titleStyle;

  /// Text style for the subtitle.
  final TextStyle? subtitleStyle;

  /// Text style for input labels.
  final TextStyle? labelStyle;

  /// Text style for input text.
  final TextStyle? inputTextStyle;

  /// Text style for input hints.
  final TextStyle? hintStyle;

  /// Text style for the button.
  final TextStyle? buttonTextStyle;

  /// Text style for error messages.
  final TextStyle? errorTextStyle;

  /// Custom decoration for input fields.
  final InputDecoration? inputDecoration;

  /// Custom style for the primary button.
  final ButtonStyle? buttonStyle;

  /// Padding around the login form content.
  final EdgeInsets contentPadding;

  /// Maximum width of the login form.
  final double maxFormWidth;

  /// Spacing between form elements.
  final double elementSpacing;

  /// Logo widget to display above the title.
  final Widget? logo;

  /// Height of the logo.
  final double? logoHeight;

  const AuthTheme({
    this.primaryColor = Colors.blue,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
    this.labelColor,
    this.hintColor,
    this.inputTextColor,
    this.inputBorderColor,
    this.inputFocusedBorderColor,
    this.inputBackgroundColor,
    this.errorColor = Colors.red,
    this.errorBackgroundColor,
    this.buttonTextColor,
    this.buttonBackgroundColor,
    this.checkboxColor,
    this.secondaryTextColor,
    this.inputBorderRadius = 8,
    this.buttonBorderRadius = 8,
    this.errorBorderRadius = 8,
    this.buttonHeight = 50,
    this.fontFamily,
    this.titleStyle,
    this.subtitleStyle,
    this.labelStyle,
    this.inputTextStyle,
    this.hintStyle,
    this.buttonTextStyle,
    this.errorTextStyle,
    this.inputDecoration,
    this.buttonStyle,
    this.contentPadding = const EdgeInsets.all(24),
    this.maxFormWidth = 400,
    this.elementSpacing = 16,
    this.logo,
    this.logoHeight,
  });

  /// Creates a copy of this theme with the given fields replaced.
  AuthTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? titleColor,
    Color? subtitleColor,
    Color? labelColor,
    Color? hintColor,
    Color? inputTextColor,
    Color? inputBorderColor,
    Color? inputFocusedBorderColor,
    Color? inputBackgroundColor,
    Color? errorColor,
    Color? errorBackgroundColor,
    Color? buttonTextColor,
    Color? buttonBackgroundColor,
    Color? checkboxColor,
    Color? secondaryTextColor,
    double? inputBorderRadius,
    double? buttonBorderRadius,
    double? errorBorderRadius,
    double? buttonHeight,
    String? fontFamily,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? labelStyle,
    TextStyle? inputTextStyle,
    TextStyle? hintStyle,
    TextStyle? buttonTextStyle,
    TextStyle? errorTextStyle,
    InputDecoration? inputDecoration,
    ButtonStyle? buttonStyle,
    EdgeInsets? contentPadding,
    double? maxFormWidth,
    double? elementSpacing,
    Widget? logo,
    double? logoHeight,
  }) {
    return AuthTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      labelColor: labelColor ?? this.labelColor,
      hintColor: hintColor ?? this.hintColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      inputBorderColor: inputBorderColor ?? this.inputBorderColor,
      inputFocusedBorderColor:
          inputFocusedBorderColor ?? this.inputFocusedBorderColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      errorColor: errorColor ?? this.errorColor,
      errorBackgroundColor: errorBackgroundColor ?? this.errorBackgroundColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      buttonBackgroundColor:
          buttonBackgroundColor ?? this.buttonBackgroundColor,
      checkboxColor: checkboxColor ?? this.checkboxColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      inputBorderRadius: inputBorderRadius ?? this.inputBorderRadius,
      buttonBorderRadius: buttonBorderRadius ?? this.buttonBorderRadius,
      errorBorderRadius: errorBorderRadius ?? this.errorBorderRadius,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      inputTextStyle: inputTextStyle ?? this.inputTextStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      inputDecoration: inputDecoration ?? this.inputDecoration,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      contentPadding: contentPadding ?? this.contentPadding,
      maxFormWidth: maxFormWidth ?? this.maxFormWidth,
      elementSpacing: elementSpacing ?? this.elementSpacing,
      logo: logo ?? this.logo,
      logoHeight: logoHeight ?? this.logoHeight,
    );
  }

  /// Default light theme.
  static const light = AuthTheme(
    primaryColor: Color(0xFF2196F3),
    backgroundColor: Colors.white,
    titleColor: Color(0xFF212121),
    subtitleColor: Color(0xFF757575),
    labelColor: Color(0xFF424242),
    hintColor: Color(0xFF9E9E9E),
    inputTextColor: Color(0xFF212121),
    inputBorderColor: Color(0xFFE0E0E0),
    errorColor: Color(0xFFD32F2F),
    errorBackgroundColor: Color(0xFFFFEBEE),
    buttonTextColor: Colors.white,
    secondaryTextColor: Color(0xFF757575),
  );

  /// Default dark theme.
  static const dark = AuthTheme(
    primaryColor: Color(0xFF64B5F6),
    backgroundColor: Color(0xFF121212),
    titleColor: Color(0xFFFFFFFF),
    subtitleColor: Color(0xFFB0B0B0),
    labelColor: Color(0xFFE0E0E0),
    hintColor: Color(0xFF757575),
    inputTextColor: Color(0xFFFFFFFF),
    inputBorderColor: Color(0xFF424242),
    inputBackgroundColor: Color(0xFF1E1E1E),
    errorColor: Color(0xFFEF5350),
    errorBackgroundColor: Color(0xFF2D1F1F),
    buttonTextColor: Color(0xFF121212),
    secondaryTextColor: Color(0xFFB0B0B0),
  );
}

/// InheritedWidget to provide AuthTheme down the widget tree.
class AuthThemeProvider extends InheritedWidget {
  final AuthTheme theme;

  const AuthThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  static AuthTheme of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AuthThemeProvider>();
    return provider?.theme ?? const AuthTheme();
  }

  static AuthTheme? maybeOf(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AuthThemeProvider>();
    return provider?.theme;
  }

  @override
  bool updateShouldNotify(AuthThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
