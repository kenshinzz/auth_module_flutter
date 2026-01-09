import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/generated/auth_l10n.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/theme/auth_theme.dart';
import '../../domain/entities/user.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends ConsumerWidget {
  final void Function(User user)? onLoginSuccess;
  final String? title;
  final String? subtitle;

  /// Custom theme for this screen. If null, uses AuthThemeProvider or defaults.
  final AuthTheme? theme;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
    this.title,
    this.subtitle,
    this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authTheme =
        theme ?? AuthThemeProvider.maybeOf(context) ?? const AuthTheme();
    final l10n = AuthL10n.of(context);
    final viewModel = ref.watch(loginViewModelProvider);

    return Scaffold(
      backgroundColor: authTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: authTheme.contentPadding,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: authTheme.maxFormWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, authTheme, l10n),
                  SizedBox(height: authTheme.elementSpacing * 2.5),
                  _buildEmailField(context, viewModel, authTheme, l10n),
                  SizedBox(height: authTheme.elementSpacing),
                  _buildPasswordField(context, viewModel, authTheme, l10n),
                  SizedBox(height: authTheme.elementSpacing),
                  _buildRememberMe(context, viewModel, authTheme, l10n),
                  SizedBox(height: authTheme.elementSpacing * 1.5),
                  _buildErrorMessage(context, viewModel, authTheme),
                  _buildLoginButton(context, viewModel, authTheme, l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AuthTheme authTheme,
    AuthL10n? l10n,
  ) {
    final displayTitle = title ?? l10n?.signInTitle ?? 'Welcome Back';
    final displaySubtitle = subtitle ?? l10n?.signInSubtitle ?? '';

    return Column(
      children: [
        if (authTheme.logo != null) ...[
          SizedBox(height: authTheme.logoHeight, child: authTheme.logo),
          SizedBox(height: authTheme.elementSpacing * 1.5),
        ],
        Text(
          displayTitle,
          style:
              authTheme.titleStyle ??
              TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: authTheme.titleColor,
                fontFamily: authTheme.fontFamily,
              ),
          textAlign: TextAlign.center,
        ),
        if (displaySubtitle.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            displaySubtitle,
            style:
                authTheme.subtitleStyle ??
                TextStyle(
                  fontSize: 16,
                  color: authTheme.subtitleColor ?? Colors.grey.shade600,
                  fontFamily: authTheme.fontFamily,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildEmailField(
    BuildContext context,
    LoginViewModel viewModel,
    AuthTheme authTheme,
    AuthL10n? l10n,
  ) {
    final isLoading = viewModel.state == LoginState.loading;

    return AuthTextField(
      label: l10n?.emailLabel ?? 'Email',
      hint: l10n?.emailHint ?? 'Enter your email',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      errorText: viewModel.emailError != null
          ? (l10n?.emailInvalid ?? 'Please enter a valid email')
          : null,
      enabled: !isLoading,
      onChanged: viewModel.setEmail,
      theme: authTheme,
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    LoginViewModel viewModel,
    AuthTheme authTheme,
    AuthL10n? l10n,
  ) {
    final isLoading = viewModel.state == LoginState.loading;

    return AuthTextField(
      label: l10n?.passwordLabel ?? 'Password',
      hint: l10n?.passwordHint ?? 'Enter your password',
      obscureText: viewModel.obscurePassword,
      textInputAction: TextInputAction.done,
      errorText: viewModel.passwordError != null
          ? (l10n?.passwordTooShort ?? 'Password must be at least 6 characters')
          : null,
      enabled: !isLoading,
      onChanged: viewModel.setPassword,
      theme: authTheme,
      suffixIcon: IconButton(
        icon: Icon(
          viewModel.obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: authTheme.hintColor ?? Colors.grey,
        ),
        onPressed: isLoading ? null : viewModel.togglePasswordVisibility,
      ),
    );
  }

  Widget _buildRememberMe(
    BuildContext context,
    LoginViewModel viewModel,
    AuthTheme authTheme,
    AuthL10n? l10n,
  ) {
    final isLoading = viewModel.state == LoginState.loading;

    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: viewModel.rememberMe,
            onChanged: isLoading
                ? null
                : (value) => viewModel.setRememberMe(value ?? false),
            activeColor: authTheme.checkboxColor ?? authTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l10n?.rememberMe ?? 'Remember me',
          style: TextStyle(
            color: authTheme.secondaryTextColor,
            fontFamily: authTheme.fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(
    BuildContext context,
    LoginViewModel viewModel,
    AuthTheme authTheme,
  ) {
    if (viewModel.errorMessage == null) return const SizedBox.shrink();

    final errorBgColor =
        authTheme.errorBackgroundColor ??
        authTheme.errorColor.withValues(alpha: 0.1);

    return Padding(
      padding: EdgeInsets.only(bottom: authTheme.elementSpacing),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: errorBgColor,
          borderRadius: BorderRadius.circular(authTheme.errorBorderRadius),
          border: Border.all(
            color: authTheme.errorColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: authTheme.errorColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                viewModel.errorMessage!,
                style:
                    authTheme.errorTextStyle ??
                    TextStyle(
                      color: authTheme.errorColor,
                      fontFamily: authTheme.fontFamily,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    LoginViewModel viewModel,
    AuthTheme authTheme,
    AuthL10n? l10n,
  ) {
    final isLoading = viewModel.state == LoginState.loading;

    return SizedBox(
      height: authTheme.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                final success = await viewModel.login();
                if (success &&
                    viewModel.user != null &&
                    onLoginSuccess != null) {
                  onLoginSuccess!(viewModel.user!);
                }
              },
        style:
            authTheme.buttonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor:
                  authTheme.buttonBackgroundColor ?? authTheme.primaryColor,
              foregroundColor: authTheme.buttonTextColor ?? Colors.white,
              disabledBackgroundColor:
                  (authTheme.buttonBackgroundColor ?? authTheme.primaryColor)
                      .withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  authTheme.buttonBorderRadius,
                ),
              ),
            ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    authTheme.buttonTextColor ?? Colors.white,
                  ),
                ),
              )
            : Text(
                l10n?.signInButton ?? 'Sign In',
                style:
                    authTheme.buttonTextStyle ??
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: authTheme.fontFamily,
                    ),
              ),
      ),
    );
  }
}
