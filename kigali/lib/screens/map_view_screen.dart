import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/listing_model.dart';
import '../providers/listing_provider.dart';
import 'detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final MapController _mapController = MapController();
  final  yellow = const Color.fromARGB(255, 28, 14, 98);

  @override
  Widget build(BuildContext context) {
    final listingProvider = Provider.of<ListingProvider>(context, listen: false);

    return Scaffold(
      body: StreamBuilder<List<Listing>>(
        stream: listingProvider.getAllListingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: yellow));
          }

          final listings = snapshot.data ?? [];
          
          // 1. Generate markers list
          final markers = listings.map((listing) {
            return Marker(
              point: LatLng(listing.latitude, listing.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(listing: listing)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: yellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.location_on, color: Colors.black, size: 20),
                ),
              ),
            );
          }).toList();

          // 2. The Stack correctly layers UI on top of the Map
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(-1.9441, 30.0619),
                  initialZoom: 12,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.kigali',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
              
              // 3. Zoom Controls (Cleanly positioned on the right)
              Positioned(
                right: 16,
                bottom: 40, // Adjusted so it doesn't overlap BottomNavBar
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: "zoomIn",
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        final zoom = _mapController.camera.zoom + 1;
                        _mapController.move(_mapController.camera.center, zoom);
                      },
                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: "zoomOut",
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        final zoom = _mapController.camera.zoom - 1;
                        _mapController.move(_mapController.camera.center, zoom);
                      },
                      child: const Icon(Icons.remove, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}