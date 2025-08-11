import 'package:flutter/material.dart';

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
      body: Stack(
        children: [
          // Background Image (Quarter of screen)
          Container(
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
          // Main Content Card
          Positioned(
            top: imageHeight - 30, // Overlap the image slightly
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      if (showBackButton)
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
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Safe area for status bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(child: Container(height: 0)),
          ),
        ],
      ),
    );
  }
}
