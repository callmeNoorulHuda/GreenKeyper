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
      backgroundColor: Colors.white,
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
              height: 130,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE6E6E6)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withAlpha(13),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Image.asset(
                    "assets/assigned_vehicle_icon.png",
                    height: 60,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        "Assigned vehicle",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          vehicleName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3F3F3F),
                          ),
                        ),
                      ),
                    ],
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
                color: const Color(0xFFF5FAFF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/select_time_icon.png",
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Select your checklist time",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Beginning of the Day Card
            _checklistCard(
              context,
              title: "Beginning of the Day",
              questions: 30,
              completed: true,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF057B99),
                  Color(0xFF4F97AA),
                  Color(0xFF528D96)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              textColor: Colors.white,
              path: 'assets/beginning_of_day.png',
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
              textColor: Colors.black87,
              path: "assets/end_of_day.png",
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
    required String path,
    required String title,
    required int questions,
    required bool completed,
    Gradient? gradient,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? Colors.white : null,
            borderRadius: BorderRadius.circular(15),
            border: gradient == null
                ? Border.all(color: Colors.grey.shade300)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                path,
                height: 45,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Checklist Questions: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '$questions',
                    style: TextStyle(
                        fontSize: 14,
                        color: gradient != null
                            ? const Color(0xFFF0BC6B)
                            : const Color(0xFF006666)),
                  )
                ],
              ),
              if (completed) ...[
                const SizedBox(height: 5),
                Text(
                  "Completed",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward, size: 25, color: textColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
