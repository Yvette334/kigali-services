import 'package:flutter/material.dart';
import 'directory_screen.dart';
import 'my_listings_screen.dart';
import 'map_view_screen.dart';
import 'settings_screen.dart';
import 'add_edit_listing_screen.dart';

class KigaliDirectory extends StatefulWidget {
  const KigaliDirectory({super.key});

  @override
  State<KigaliDirectory> createState() => _KigaliDirectoryState();
}

class _KigaliDirectoryState extends State<KigaliDirectory> {
  int _currentIndex = 0;
  final navyblue = const Color(0xFF0A172F);
  final yellow = const Color(0xFFF7C351);

  final List<Widget> _screens = [
    const DirectoryScreen(),
    const MyListingsScreen(),
    const MapViewScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = ['Directory', 'My Listings', 'Map View', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyblue,
      appBar: AppBar(
        backgroundColor: navyblue,
        title: Center(
          child: Text(
            _titles[_currentIndex],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          )
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: navyblue,
        selectedItemColor: yellow,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Directory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _currentIndex < 2
          ? FloatingActionButton(
              backgroundColor: yellow,
              child: Icon(Icons.add, color: navyblue),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditListingScreen())),
            )
          : null,
    );
  }
}