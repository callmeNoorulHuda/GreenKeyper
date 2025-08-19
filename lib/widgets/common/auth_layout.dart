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
    final imageHeight = screenHeight * 0.30;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffFFFFFF), Color(0xffEDEDED), Color(0xffD8DBD8)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // 🔹 Use Stack to layer image and back button
                Stack(
                  children: [
                    Container(
                      height: imageHeight,
                      width: screenWidth,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/banner1-min 3.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (showBackButton)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: IconButton(
                          onPressed:
                              onBackPressed ?? () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black, // White looks better on banner
                            size: 28,
                          ),
                        ),
                      ),
                  ],
                ),

                // Content Card with overlap effect
                Transform.translate(
                  offset: const Offset(0, -110),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      color: Colors.white.withAlpha(240),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            child,
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
