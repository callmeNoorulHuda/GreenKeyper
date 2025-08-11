import 'package:flutter/material.dart';
import '../../widgets/common/auth_layout.dart';
import '../../widgets/common/logo_header.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/auth/auth_form.dart';
import 'new_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  int _currentStep = 0;
  bool _isLoading = false;

  void _handleSendCode() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _currentStep = 1;
    });
  }

  void _handleConfirmCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      showBackButton: true,
      child: Column(
        children: [
          LogoHeader(
            title: 'Forgot Password',
            subtitle: _currentStep == 0
                ? 'Please enter your email to request a password reset'
                : 'Please enter the code sent to your email.',
          ),
          const SizedBox(height: 32),
          if (_currentStep == 0)
            AuthForm(
              formKey: _formKey,
              buttonText: 'Send Code',
              onSubmit: _handleSendCode,
              isLoading: _isLoading,
              fields: [
                CustomTextField(
                  label: 'Email',
                  hint: 'abc@gmail.com',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            )
          else
            AuthForm(
              formKey: _formKey,
              buttonText: 'Confirm',
              onSubmit: _handleConfirmCode,
              fields: [
                CustomTextField(
                  label: 'Email',
                  hint: 'abc@gmail.com',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  label: 'Enter Code',
                  hint: '45263',
                  prefixIcon: Icons.security,
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
