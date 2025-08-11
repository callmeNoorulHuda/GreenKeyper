import 'package:flutter/material.dart';
import '../../widgets/common/auth_layout.dart';
import '../../widgets/common/logo_header.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/text_link.dart';
import '../../widgets/auth/auth_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      showBackButton: true,
      child: Column(
        children: [
          const LogoHeader(title: 'Sign Up'),
          const SizedBox(height: 32),
          AuthForm(
            formKey: _formKey,
            buttonText: 'Sign Up',
            onSubmit: _handleSignUp,
            isLoading: _isLoading,
            fields: [
              CustomTextField(
                label: 'Full Name',
                hint: 'Enter your full name',
                prefixIcon: Icons.person_outline,
                controller: _fullNameController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true || !value!.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: 'Contact',
                hint: 'Enter your contact',
                prefixIcon: Icons.phone_outlined,
                controller: _contactController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
                validator: (value) {
                  if (value?.isEmpty ?? true || value!.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: 'Confirm Password',
                hint: 'Enter confirm password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextLink(
            text: 'Already have an account? ',
            linkText: 'Login',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
