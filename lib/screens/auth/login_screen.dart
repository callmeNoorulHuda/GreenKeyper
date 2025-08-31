import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/common/auth_layout.dart';
import '../../widgets/common/logo_header.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/text_link.dart';
import '../../widgets/auth/auth_form.dart';
import '../dashboard/demo_screen_2.dart';
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
  bool _isLoading = false;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      // Form is invalid → errors will show automatically
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    // Extract username from email (before @)
    final email = _emailController.text;
    final username = email.contains('@') ? email.split('@')[0] : email;

    // Save username to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'user_name', username.replaceAll('.', ' ').toUpperCase());
    await prefs.setBool('is_logged_in', true);

    // Initialize default vehicle data if not exists
    final existingVehicles = prefs.getStringList('assigned_vehicles');
    if (existingVehicles == null) {
      final defaultVehicles = [
        'Nostalgia|',
        'Ocean Whisper|',
        'Silver Horizon|',
        'Honda Civic|ABC 9832',
        'Suzuki Cultus|BKX 2245',
        'Suzuki Alto|MEP 4521',
      ];
      await prefs.setStringList('assigned_vehicles', defaultVehicles);
      await prefs.setInt('assigned_vehicles_count', 6);
      await prefs.setString('selected_vehicle', 'Nostalgia');
      await prefs.setInt('resolved_faults', 3);
      await prefs.setInt('pending_faults', 1);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));

      // Navigate to dashboard screen instead of demo screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DemoScreen2()),
      );
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
                prefixIcon: Icons.email_rounded,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null; // ✅ no error
                },
              ),
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                prefixIcon: Icons.lock,
                isPassword: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 chars';
                  }
                  return null;
                },
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
                  style: TextStyle(
                    color: Color(0xFF016969),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
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
