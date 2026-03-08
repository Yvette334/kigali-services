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
  int _currentIndex = 0;
  final  navyblue = const Color(0xFF0A172F);
  final  yellow = const Color(0xFFF7C351); 

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    Widget currentBody;
    if (_currentIndex == 0) {
      currentBody = _buildFirestoreList(); 
    }else if(_currentIndex == 1){
      currentBody = _buildDetailedListing();
    }else {
      currentBody = Center(child: Text('Page ${_currentIndex + 1} Content', style: TextStyle(color: Colors.white)));
    }

    return Scaffold(
      backgroundColor: navyblue,
      appBar: AppBar(
      backgroundColor: navyblue,
        title: const Text("Kigali City Services"),
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
            _currentIndex = index; 
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
  Widget _buildDetailedListing(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('services').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Error loading data', style: TextStyle(color: Colors.white70)));
        if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(color: yellow,));

        final docs = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data['name'] ?? 'Kigali Service',
                              )
                              )
                          ]
                        )
                      ],
                    ),
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }
}