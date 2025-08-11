import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greenkeyper',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Roboto'),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Reusable Custom Text Field Widget
class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool showError;
  final String? errorText;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.showError = false,
    this.errorText,
    this.keyboardType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(widget.prefixIcon, color: const Color(0xFF4A9B8F)),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4A9B8F), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        if (widget.showError && widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Text(
                  widget.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Reusable Custom Button Widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF4A9B8F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: textColor ?? Colors.white,
                strokeWidth: 2,
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}

// Reusable Auth Layout Widget with Stack and Media Query
class AuthLayout extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AuthLayout({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenHeight * 0.25; // Quarter of screen

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Background Image (Quarter of screen)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: imageHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main Content Card
          Positioned(
            top: imageHeight - 40, // Overlap the image slightly
            left: 16,
            right: 16,
            bottom: 0,
            child: Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showBackButton) ...[
                      Row(
                        children: [
                          IconButton(
                            onPressed:
                                onBackPressed ?? () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                    child,
                    const SizedBox(height: 20), // Extra bottom padding
                  ],
                ),
              ),
            ),
          ),
          // Safe area for status bar
          SafeArea(child: Container()),
        ],
      ),
    );
  }
}

// Reusable Logo Header Widget
class LogoHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const LogoHeader({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'LOGO',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A9B8F),
            letterSpacing: 3,
          ),
        ),
        if (title != null) ...[
          const SizedBox(height: 16),
          Text(
            title!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

// Reusable Text Link Widget
class TextLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onPressed;

  const TextLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Colors.black54)),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            linkText,
            style: const TextStyle(
              color: Color(0xFF4A9B8F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// Login Screen
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            const LogoHeader(title: 'Welcome to Greenkeyper!'),
            const SizedBox(height: 30),
            CustomTextField(
              label: 'Email',
              hint: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              controller: _emailController,
              showError: _showEmailError,
              errorText: 'Invalid Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Password',
              hint: 'Enter your password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              controller: _passwordController,
              showError: _showPasswordError,
              errorText: 'Invalid Password!',
            ),
            const SizedBox(height: 8),
            Align(
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
            const SizedBox(height: 24),
            CustomButton(
              text: 'Login',
              onPressed: _handleLogin,
              isLoading: _isLoading,
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
      ),
    );
  }
}

// Sign Up Screen
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const LogoHeader(title: 'Sign Up'),
            const SizedBox(height: 32),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 32),
            CustomButton(
              text: 'Sign Up',
              onPressed: _handleSignUp,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            TextLink(
              text: 'Already have an account? ',
              linkText: 'Login',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// Forgot Password Screen
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            LogoHeader(
              title: 'Forgot Password',
              subtitle: _currentStep == 0
                  ? 'Please enter your email to request a password reset'
                  : 'Please enter the code sent to your email.',
            ),
            const SizedBox(height: 32),
            if (_currentStep == 0) ...[
              CustomTextField(
                label: 'Email',
                hint: 'abc@gmail.com',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Send Code',
                onPressed: _handleSendCode,
                isLoading: _isLoading,
              ),
            ] else ...[
              CustomTextField(
                label: 'Email',
                hint: 'abc@gmail.com',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Enter Code',
                hint: '45263',
                prefixIcon: Icons.security,
                controller: _codeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              CustomButton(text: 'Confirm', onPressed: _handleConfirmCode),
            ],
          ],
        ),
      ),
    );
  }
}

// New Password Screen
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const LogoHeader(
              title: 'New Password',
              subtitle: 'Please add new credentials to change password.',
            ),
            const SizedBox(height: 32),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 32),
            CustomButton(
              text: 'Save',
              onPressed: _handleSavePassword,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
