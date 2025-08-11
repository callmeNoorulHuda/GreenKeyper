import 'package:flutter/material.dart';
import '../../widgets/common/auth_layout.dart';
import '../../widgets/common/logo_header.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/text_link.dart';
import '../../widgets/auth/auth_form.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showEmailError = false;
  bool _showPasswordError = false;
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() {
      _showEmailError =
          _emailController.text.isEmpty || !_emailController.text.contains('@');
      _showPasswordError = _passwordController.text.isEmpty;
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (!_showEmailError && !_showPasswordError) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful!')));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const LogoHeader(title: 'Welcome to Greenkeyper!'),
          const SizedBox(height: 40),
          AuthForm(
            formKey: _formKey,
            buttonText: 'Login',
            onSubmit: _handleLogin,
            isLoading: _isLoading,
            fields: [
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                showError: _showEmailError,
                errorText: 'Invalid Email',
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
                showError: _showPasswordError,
                errorText: 'Invalid Password!',
              ),
            ],
            additionalWidget: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xFF4A9B8F), fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextLink(
            text: "Don't have an account? ",
            linkText: 'Sign up',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
