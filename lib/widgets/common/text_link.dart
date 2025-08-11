import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onPressed;
  final MainAxisAlignment alignment;

  const TextLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onPressed,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
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
