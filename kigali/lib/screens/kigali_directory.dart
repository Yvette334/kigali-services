import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_services.dart';

class KigaliDirectory extends StatefulWidget {
  const KigaliDirectory({super.key});

  @override
  State<KigaliDirectory> createState() => _KigaliDirectoryState();
}

class _KigaliDirectoryState extends State<KigaliDirectory> {
  int _currentIndex = 0; // This tracks which tab is selected

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // This defines what shows in the middle of the screen
    Widget currentBody;
    if (_currentIndex == 0) {
      currentBody = _buildFirestoreList(); // Show the list on the first tab
    } else {
      currentBody = Center(child: Text('Page ${_currentIndex + 1} Content'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kigali City Services"),
        backgroundColor: const Color(0xFF0A172F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: currentBody, 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A172F),
        selectedItemColor: const Color(0xFFF7C351),
        unselectedItemColor: const Color(0xFF9E9E9E).withOpacity(0.6),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // This re-draws the screen
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Directory'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Listing'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF7C351),
        child: const Icon(Icons.add, color: Color(0xFF0A172F)),
        onPressed: () {},
      ),
    );
  }

  // This is your Firestore logic moved into a simple function
  Widget _buildFirestoreList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('services').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Error loading data"));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const Icon(Icons.location_city, color: Color(0xFF0A172F)),
                title: Text(data['name'] ?? 'No Name'),
                subtitle: Text(data['type'] ?? 'Service'),
                trailing: const Icon(Icons.map_outlined),
              ),
            );
          },
        );
      },
    );
  }
}