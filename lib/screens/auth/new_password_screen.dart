import 'package:flutter/material.dart';
import '../../widgets/common/auth_layout.dart';
import '../../widgets/common/logo_header.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/auth/auth_form.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _handleSavePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Row(
            children: [
              Icon(Icons.celebration, color: Colors.orange),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Congratulations! Your password has changed.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF4A9B8F)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
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
          const LogoHeader(
            title: 'New Password',
            subtitle: 'Please add new credentials to change password.',
          ),
          const SizedBox(height: 32),
          AuthForm(
            formKey: _formKey,
            buttonText: 'Save',
            onSubmit: _handleSavePassword,
            isLoading: _isLoading,
            fields: [
              CustomTextField(
                label: 'Password',
                hint: '••••••••',
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
                hint: '••••••••',
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
        ],
      ),
    );
  }
}
