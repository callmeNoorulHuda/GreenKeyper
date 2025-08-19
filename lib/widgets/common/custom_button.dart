import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final List<Color>? gradientColors; // New parameter for gradient
  final Color? textColor;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.gradientColors, // Optional custom gradient
    this.textColor,
    this.height,
    this.width,
    this.padding,
    this.borderRadius = 10, // Matches your 10px radius
  });

  @override
  Widget build(BuildContext context) {
    // Default gradient colors (from your design)
    final colors =
        gradientColors ??
        [
          const Color(0xFF006F6F),
          const Color(0xFF029090),
          const Color(0xFF019090),
          const Color(0xFF016F6F),
        ];

    return Container(
      width: width ?? 339,
      height: height ?? 50.07,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Critical for gradient visibility
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? EdgeInsets.zero,
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: textColor ?? Colors.white,
                strokeWidth: 2,
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}
