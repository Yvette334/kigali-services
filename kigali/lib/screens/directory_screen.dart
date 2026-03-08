import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing_model.dart';
import '../providers/listing_provider.dart';
import 'detail_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final navyblue = const Color(0xFF0A172F);
  final yellow = const Color(0xFFF7C351);
  final categories = ['All', 'Hospital', 'Police Station', 'Library', 'Restaurant', 'Café', 'Park', 'Tourist Attraction', 'others'];
  
  // Simple variables for human-like code
  List<Listing> allListings = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<ListingProvider>(
            builder: (context, provider, _) {
              return TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: yellow),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  provider.setSearchQuery(value);
                },
              );
            },
          ),
        ),
        
        // Category filters
        SizedBox(
          height: 50,
          child: Consumer<ListingProvider>(
            builder: (context, provider, _) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = provider.selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category, style: TextStyle(color: isSelected ? navyblue : Colors.white)),
                      selected: isSelected,
                      onSelected: (_) {
                        provider.setCategory(category);
                      },
                      backgroundColor: navyblue,
                      selectedColor: yellow,
                      side: BorderSide(color: isSelected ? yellow : Colors.white30),
                    ),
                  );
                },
              );
            },
          ),
        ),
        
        // Section header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Near You',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Listings list
        Expanded(
          child: Consumer<ListingProvider>(
            builder: (context, provider, _) {
              return StreamBuilder<List<Listing>>(
                stream: provider.getAllListingsStream(),
                builder: (context, snapshot) {
                  // Handle loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: yellow));
                  }
                  
                  // Handle error state
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white70)
                      )
                    );
                  }

                  // Get data
                  allListings = snapshot.data ?? [];
                  
                  // Update provider if we have data
                  if (allListings.isNotEmpty) {
                    provider.updateListings(allListings);
                  }
                  
                  // Get filtered listings
                  final listings = provider.listings;

                  // Handle empty state
                  if (listings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80, color: Colors.white24),
                          const SizedBox(height: 16),
                          const Text(
                            'No listings found',
                            style: TextStyle(color: Colors.white70, fontSize: 18)
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
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(listing: listing)
                              )
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  // Star rating
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < 4 ? Icons.star : Icons.star_border,
                                        color: yellow,
                                        size: 14,
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 8),
                                  // Rating number
                                  Text(
                                    '4.${(index % 9) + 1}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12)
                                  ),
                                  const SizedBox(width: 8),
                                  // Distance
                                  Text(
                                    '${(index * 0.3 + 0.5).toStringAsFixed(1)} km',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12)
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white54,
                            size: 14
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
