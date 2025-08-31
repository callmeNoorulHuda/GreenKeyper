// lib/screens/checklist_time_screen.dart
import 'package:flutter/material.dart';
import 'checklist_screen.dart';

class ChecklistTimeScreen extends StatelessWidget {
  final String vehicleName;

  const ChecklistTimeScreen({
    super.key,
    required this.vehicleName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xFFD9D9D9),
              height: 1,
            )),
        title: Row(
          children: [
            Image.asset(
              "assets/checklisttime_icon.png",
              height: 35,
            ),
            const SizedBox(width: 8),
            const Text(
              "Checklist Time",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Assigned Vehicle
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/assigned_vehicle_icon.png",
                        height: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Assigned vehicle",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vehicleName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Select checklist time banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.list_alt, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Select your checklist time",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Beginning of the Day Card
            _checklistCard(
              context,
              title: "Beginning of the Day",
              questions: 30,
              completed: true,
              gradient: const LinearGradient(
                colors: [Color(0xFF057B99), Color(0xFF128BAA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              icon: Icons.wb_sunny,
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChecklistScreen()),
              ),
            ),

            const SizedBox(height: 16),

            // End of the Day Card
            _checklistCard(
              context,
              title: "End of the Day",
              questions: 30,
              completed: false,
              gradient: null,
              icon: Icons.nightlight_round,
              iconColor: Colors.deepPurple,
              textColor: Colors.black87,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChecklistScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checklistCard(
    BuildContext context, {
    required String title,
    required int questions,
    required bool completed,
    Gradient? gradient,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(15),
          border:
              gradient == null ? Border.all(color: Colors.grey.shade300) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Checklist Questions $questions",
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.8),
              ),
            ),
            if (completed) ...[
              const SizedBox(height: 6),
              Text(
                "Completed",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.arrow_forward,
                  size: 22, color: textColor.withOpacity(0.9)),
            )
          ],
        ),
      ),
    );
  }
}
