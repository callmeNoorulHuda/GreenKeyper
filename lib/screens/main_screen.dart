import 'package:flutter/material.dart';
import 'package:greenkeyper/screens/edit_profile_screen.dart';

import 'checklist_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of your main screens
  final List<Widget> _screens = [
    const ChecklistScreen(),
    const EditProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Show selected screen
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 70,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Stack(
              children: [
                BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: const Color(0xFFE79F31), // active color
                  unselectedItemColor:
                      const Color(0xFF006666), // inactive color
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        size: 35,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
                        size: 35,
                      ),
                      label: '',
                    ),
                  ],
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 0.5,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 1, color: Colors.grey.shade300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
