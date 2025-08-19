import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? Heading;

  const LogoHeader({super.key, this.title, this.subtitle, this.Heading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          Heading ?? 'LOGO',
          style: const TextStyle(
            fontSize: 36, // Matches 36px from design
            fontWeight: FontWeight.w600, // Semi Bold (600 weight)
            color: Color(
              0xFF006F6F,
            ), // Using the darkest teal from your color palette
            letterSpacing: 0, // Explicitly set to 0 as per design
          ),
        ),
        if (title != null) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.0,
                letterSpacing: 0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              height: 1.5,
              letterSpacing: 0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
