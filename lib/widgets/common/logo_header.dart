import 'package:flutter/material.dart';

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
