// lib/screens/assigned_vehicles_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignedVehiclesScreen extends StatefulWidget {
  const AssignedVehiclesScreen({super.key});

  @override
  State<AssignedVehiclesScreen> createState() => _AssignedVehiclesScreenState();
}

class _AssignedVehiclesScreenState extends State<AssignedVehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> allVehicles = [];
  List<Map<String, String>> filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
    _searchController.addListener(_filterVehicles);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _loadVehicles() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if vehicles are already stored
    final List<String>? storedVehicles = prefs.getStringList(
      'assigned_vehicles',
    );

    if (storedVehicles != null && storedVehicles.isNotEmpty) {
      setState(() {
        allVehicles = storedVehicles.map((vehicle) {
          final parts = vehicle.split('|');
          return {'name': parts[0], 'id': parts.length > 1 ? parts[1] : ''};
        }).toList();
        filteredVehicles = List.from(allVehicles);
      });
    } else {
      // Store default vehicles
      final defaultVehicles = [
        {'name': 'Nostalgia', 'id': ''},
        {'name': 'Ocean Whisper', 'id': ''},
        {'name': 'Silver Horizon', 'id': ''},
        {'name': 'Honda Civic', 'id': 'ABC 9832'},
        {'name': 'Suzuki Cultus', 'id': 'BKX 2245'},
        {'name': 'Suzuki Alto', 'id': 'MEP 4521'},
      ];

      setState(() {
        allVehicles = defaultVehicles;
        filteredVehicles = List.from(allVehicles);
      });

      // Store vehicles in SharedPreferences
      final vehicleStrings = defaultVehicles
          .map((vehicle) => '${vehicle['name']}|${vehicle['id']}')
          .toList();
      await prefs.setStringList('assigned_vehicles', vehicleStrings);
      await prefs.setInt('assigned_vehicles_count', defaultVehicles.length);
    }
  }

  _filterVehicles() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredVehicles = List.from(allVehicles);
      } else {
        filteredVehicles = allVehicles.where((vehicle) {
          final name = vehicle['name']!.toLowerCase();
          final id = vehicle['id']!.toLowerCase();
          return name.contains(query) || id.contains(query);
        }).toList();
      }
    });
  }

  _selectVehicle(String vehicleName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_vehicle', vehicleName);
    Navigator.pop(context, vehicleName);
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/assigned_vehicle_icon.png',
              height: 35,
              width: 35,
            ),
            const SizedBox(width: 12),
            Text(
              'Assigned Vehicles (${allVehicles.length})',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Vehicles',
                    hintStyle:
                        const TextStyle(color: Color(0xFF627B87), fontSize: 16),
                    suffixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Vehicle List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                final vehicle = filteredVehicles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDCDCDC)),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.1),
                    //     spreadRadius: 1,
                    //     blurRadius: 5,
                    //     offset: const Offset(0, 2),
                    //   ),
                    // ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Image.asset(
                      'assets/assigned_vehicles_default_icon.png',
                      height: 40,
                      width: 40,
                    ),
                    title: Row(
                      children: [
                        Text(
                          vehicle['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        vehicle['id']!.isNotEmpty
                            ? Text(
                                "(${vehicle['id']!})",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.black,
                      size: 25,
                    ),
                    onTap: () => _selectVehicle(vehicle['name']!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
