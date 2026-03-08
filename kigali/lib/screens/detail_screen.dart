import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/listing_model.dart';

class DetailScreen extends StatelessWidget {
  final Listing listing;

  const DetailScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    final navyblue = const Color(0xFF0A172F);
    final yellow = const Color(0xFFF7C351);

    return Scaffold(
      backgroundColor: navyblue,
      appBar: AppBar(
        backgroundColor: navyblue,
        foregroundColor: Colors.white,
        title: Text(
          listing.name.isNotEmpty ? listing.name : 'Service Details',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map container with OpenStreetMap only
            Container(
              height: 250,
              margin: const EdgeInsets.only(bottom: 16),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(listing.latitude, listing.longitude),
                    initialZoom: 15,
                    minZoom: 10,
                    maxZoom: 18,
                  ),
                  children: [
                    // OpenStreetMap tiles
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.kigali',
                    ),
                    // Location marker
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(listing.latitude, listing.longitude),
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: yellow,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Details section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    listing.name.isNotEmpty ? listing.name : 'Unnamed Service',
                    style: TextStyle(
                      color: yellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 8),
                  
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: yellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: yellow.withOpacity(0.3)),
                    ),
                    child: Text(
                      listing.category.isNotEmpty ? listing.category : 'General',
                      style: TextStyle(color: yellow)
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Address
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: yellow, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            listing.address.isNotEmpty ? listing.address : 'No address provided',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16
                            )
                          )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Contact
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.phone, color: yellow, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            listing.contact.isNotEmpty ? listing.contact : 'No contact info',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16
                            )
                          )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description section
                  Text(
                    'Description',
                    style: TextStyle(
                      color: yellow,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      listing.description.isNotEmpty 
                          ? listing.description 
                          : 'No description available for this service.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.4
                      )
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Location info button instead of navigation
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: yellow.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: navyblue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Show coordinates in a dialog
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: navyblue,
                            title: const Text('Location Coordinates', style: TextStyle(color: Colors.white)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Latitude: ${listing.latitude.toStringAsFixed(6)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Longitude: ${listing.longitude.toStringAsFixed(6)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK', style: TextStyle(color: yellow)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text(
                        'VIEW COORDINATES',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
