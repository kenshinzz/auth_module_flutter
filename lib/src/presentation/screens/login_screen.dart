import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/user.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatelessWidget {
  final void Function(User user)? onLoginSuccess;
  final VoidCallback? onForgotPassword;
  final String? title;
  final String? subtitle;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
    this.onForgotPassword,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Consumer<LoginViewModel>(
                builder: (context, viewModel, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 40),
                      _buildEmailField(viewModel),
                      const SizedBox(height: 16),
                      _buildPasswordField(viewModel),
                      const SizedBox(height: 16),
                      _buildRememberMeAndForgot(context, viewModel),
                      const SizedBox(height: 24),
                      _buildErrorMessage(viewModel),
                      _buildLoginButton(context, viewModel),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          title ?? 'Welcome Back',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildEmailField(LoginViewModel viewModel) {
    final isLoading = viewModel.state == LoginState.loading;

    return AuthTextField(
      label: 'Email',
      hint: 'Enter your email',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      errorText: viewModel.emailError,
      enabled: !isLoading,
      onChanged: viewModel.setEmail,
    );
  }

  Widget _buildPasswordField(LoginViewModel viewModel) {
    final isLoading = viewModel.state == LoginState.loading;

    return AuthTextField(
      label: 'Password',
      hint: 'Enter your password',
      obscureText: viewModel.obscurePassword,
      textInputAction: TextInputAction.done,
      errorText: viewModel.passwordError,
      enabled: !isLoading,
      onChanged: viewModel.setPassword,
      suffixIcon: IconButton(
        icon: Icon(
          viewModel.obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: isLoading ? null : viewModel.togglePasswordVisibility,
      ),
    );
  }

  Widget _buildRememberMeAndForgot(BuildContext context, LoginViewModel viewModel) {
    final isLoading = viewModel.state == LoginState.loading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: viewModel.rememberMe,
                onChanged: isLoading
                    ? null
                    : (value) => viewModel.setRememberMe(value ?? false),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        if (onForgotPassword != null)
          TextButton(
            onPressed: isLoading ? null : onForgotPassword,
            child: const Text('Forgot Password?'),
          ),
      ],
    );
  }

  Widget _buildErrorMessage(LoginViewModel viewModel) {
    if (viewModel.errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                viewModel.errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginViewModel viewModel) {
    final isLoading = viewModel.state == LoginState.loading;

    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                final success = await viewModel.login();
                if (success && viewModel.user != null && onLoginSuccess != null) {
                  onLoginSuccess!(viewModel.user!);
                }
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
