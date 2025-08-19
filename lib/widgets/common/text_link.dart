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
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
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
              color: Color(0xff016969),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
