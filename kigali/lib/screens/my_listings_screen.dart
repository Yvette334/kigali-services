import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing_model.dart';
import '../providers/listing_provider.dart';
import '../services/auth_services.dart';
import 'add_edit_listing_screen.dart';
import 'detail_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navyblue = const Color(0xFF0A172F);
    final yellow = const Color(0xFFF7C351);
    final authService = Provider.of<AuthService>(context);

    // Check if user is logged in
    if (authService.currentUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, size: 80, color: Colors.white24),
            const SizedBox(height: 16),
            const Text(
              'Please log in to view your listings',
              style: TextStyle(color: Colors.white70, fontSize: 18)
            ),
          ],
        ),
      );
    }

    // Get user's listings
    return StreamBuilder<List<Listing>>(
      stream: Provider.of<ListingProvider>(context, listen: false)
          .getUserListingsStream(authService.currentUser!.uid),
      builder: (context, snapshot) {
        // Show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: yellow));
        }
        
        // Show error message
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16)
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MyListingsScreen())
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: yellow),
                  child: Text('Retry', style: TextStyle(color: navyblue)),
                ),
              ],
            ),
          );
        }

        // Get listings data
        final listings = snapshot.data ?? [];

        // Show empty state
        if (listings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list_alt, size: 80, color: Colors.white24),
                const SizedBox(height: 16),
                const Text(
                  'No listings yet',
                  style: TextStyle(color: Colors.white70, fontSize: 18)
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEditListingScreen())
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: yellow),
                  child: Text('Add Your First Listing', style: TextStyle(color: navyblue)),
                ),
              ],
            ),
          );
        }

        // Show listings
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final listing = listings[index];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailScreen(listing: listing))
                  );
                },
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: yellow.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: yellow.withOpacity(0.3)),
                  ),
                  child: Icon(Icons.location_city, color: yellow),
                ),
                title: Text(
                  listing.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
                subtitle: Text(
                  listing.category,
                  style: const TextStyle(color: Colors.white70)
                ),
                trailing: PopupMenuButton(
                  color: navyblue,
                  icon: const Icon(Icons.more_vert, color: Colors.white70),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Edit', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditListingScreen(listing: listing)
                          )
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      onTap: () => _showDeleteDialog(context, listing.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    final navyblue = const Color(0xFF0A172F);
    final yellow = const Color(0xFFF7C351);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: navyblue,
        title: const Text('Delete Listing', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this listing?',
          style: TextStyle(color: Colors.white70)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await Provider.of<ListingProvider>(context, listen: false).deleteListing(id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Listing deleted successfully'),
                      backgroundColor: yellow,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting listing: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
