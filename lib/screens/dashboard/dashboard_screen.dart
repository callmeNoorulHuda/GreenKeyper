// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:greenkeyper/screens/dashboard/checklist_screen.dart';
import 'package:greenkeyper/widgets/common/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'assigned_vehicles_screen.dart';
import 'checklist_time_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = 'Jane Cooper';
  String selectedVehicle = 'Nostalgia';
  int assignedVehicles = 6;
  int resolvedFaults = 3;
  int pendingFaults = 1;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Jane Cooper';
      selectedVehicle = prefs.getString('selected_vehicle') ?? 'Nostalgia';
      assignedVehicles = prefs.getInt('assigned_vehicles_count') ?? 6;
      resolvedFaults = prefs.getInt('resolved_faults') ?? 3;
      pendingFaults = prefs.getInt('pending_faults') ?? 1;
    });
  }

  Widget assignedVehiclesCard() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AssignedVehiclesScreen(),
          ),
        );
        if (result != null) {
          setState(() {
            selectedVehicle = result;
          });
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('selected_vehicle', result);
        }
      },
      child: Material(
        elevation: 0.5,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 130,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row (icon + title + count)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF009494),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Assigned Vehicles',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    '${assignedVehicles}', // Changed to match design
                    style: const TextStyle(
                      color: Color(0xFFFF9800),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Vehicle images row
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox(
                  height: 43,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/profile_default_image.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 30,
                        child: Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            border: Border.all(color: Colors.white, width: 1),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/profile_default_image.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 55,
                        child: Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey[300]!, width: 1)),
                          child: const Center(
                            child: Text(
                              '+01',
                              style: TextStyle(
                                color: Color(0xFF006666),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChecklistStatusCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChecklistTimeScreen(
              vehicleName: selectedVehicle,
            ),
          ),
        );
      },
      child: Material(
        elevation: 1.5,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF009494),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Checklist Status',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // "Checked" indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/dashboard_box.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Text(
                      'Checked',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pie Chart
              SizedBox(
                height: 120,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                    startDegreeOffset: -90, // Start from top
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFFFFC977), // Teal color
                        value: 50,
                        title: '',
                        radius: 15,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFF61AAAA), // Yellow/orange color
                        value: 50,
                        title: '',
                        radius: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Legend
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF61AAAA),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Beginning of the day',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF615E83),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFC977),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'End of the day',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF615E83),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFaultStatusCard() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 144,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF009494),
                  ),
                  child: const Icon(Icons.build_rounded,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Vehicle Fault Status',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Resolved
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    'Resolved',
                    style: TextStyle(fontSize: 12, color: Color(0xFF615E83)),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    value: 0.75, // 3 out of 4

                    color: Color(0xFF018686),
                    minHeight: 8,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Text(
                  '03', // Changed to match design
                  style: TextStyle(fontSize: 12, color: Color(0xFF615E83)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Pending
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    'Pending',
                    style: TextStyle(fontSize: 12, color: Color(0xFF615E83)),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    value: 0.25, // 3 out of 4

                    color: Color(0xFFE79F31),
                    minHeight: 8,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Text(
                  '01', // Changed to match design
                  style: TextStyle(fontSize: 12, color: Color(0xFF615E83)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF057B99),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Color(0xFFF9C677)),
          onPressed: () {},
        ),
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          const Badge(
            backgroundColor: Colors.red,
            child: Icon(Icons.notifications, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/profile_default_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Container
            SizedBox(
              height: 200,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/dashboard_Frame.png'),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Hello $userName, ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        'Welcome to Greenkeyper!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Cards Layout
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column (Assigned Vehicles + Fault Status)
                Expanded(
                  child: Column(
                    children: [
                      assignedVehiclesCard(),
                      const SizedBox(height: 12),
                      buildFaultStatusCard(),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Right Column (Checklist Status)
                Expanded(
                  child: SizedBox(
                    height: 300, // Match combined height of left column
                    child: buildChecklistStatusCard(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),

            // Proceed to checklist button
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButton(
                  text: 'Proceed to Checklist',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChecklistScreen()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
