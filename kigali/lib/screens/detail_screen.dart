import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/listing_model.dart';

class DetailScreen extends StatefulWidget {
  final Listing listing;

  const DetailScreen({super.key, required this.listing});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Position? _currentPosition;
  List<LatLng> _routePoints = [];
  bool _isNavigating = false;
  final MapController _mapController = MapController();

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
        }
        return;
      }
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      await _getRoute();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  Future<void> _getRoute() async {
    if (_currentPosition == null) return;
    setState(() {
      _isNavigating = true;
    });
    try {
      final url = 'https://router.project-osrm.org/route/v1/driving/${_currentPosition!.longitude},${_currentPosition!.latitude};${widget.listing.longitude},${widget.listing.latitude}?overview=full&geometries=geojson';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coords = data['routes'][0]['geometry']['coordinates'] as List;
        setState(() {
          _routePoints = coords.map((coord) => LatLng(coord[1], coord[0])).toList();
        });
        _mapController.move(
          LatLng(
            (_currentPosition!.latitude + widget.listing.latitude) / 2,
            (_currentPosition!.longitude + widget.listing.longitude) / 2,
          ),
          12,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get route')),
        );
      }
    }
  }

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
          widget.listing.name.isNotEmpty ? widget.listing.name : 'Service Details',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map with navigation
            Container(
              height: 300,
              margin: const EdgeInsets.only(bottom: 16),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(widget.listing.latitude, widget.listing.longitude),
                      initialZoom: 15,
                      minZoom: 5,
                      maxZoom: 18,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.kigali',
                        tileProvider: NetworkTileProvider(),
                      ),
                      if (_routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              strokeWidth: 4,
                              color: yellow,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          if (_currentPosition != null)
                            Marker(
                              point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                              width: 40,
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.my_location, color: Colors.white, size: 20),
                              ),
                            ),
                          Marker(
                            point: LatLng(widget.listing.latitude, widget.listing.longitude),
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                color: yellow,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.location_on, color: Colors.black, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Zoom controls
                  Positioned(
                    right: 16,
                    bottom: 80,
                    child: Column(
                      children: [
                        FloatingActionButton(
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
                  // My location button
                  if (_currentPosition != null)
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          _mapController.move(
                            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                            15,
                          );
                        },
                        child: Icon(Icons.my_location, color: Colors.blue),
                      ),
                    ),
                ],
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
                    widget.listing.name.isNotEmpty ? widget.listing.name : 'Unnamed Service',
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
                      widget.listing.category.isNotEmpty ? widget.listing.category : 'General',
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
                            widget.listing.address.isNotEmpty ? widget.listing.address : 'No address provided',
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
                            widget.listing.contact.isNotEmpty ? widget.listing.contact : 'No contact info',
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
                      widget.listing.description.isNotEmpty 
                          ? widget.listing.description 
                          : 'No description available for this service.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.4
                      )
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Navigate button
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
                      onPressed: _isNavigating ? null : () async {
                        await _getCurrentLocation();
                      },
                      icon: _isNavigating ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      ) : const Icon(Icons.directions),
                      label: Text(
                        _isNavigating ? 'LOADING...' : 'NAVIGATE',
                        style: const TextStyle(fontWeight: FontWeight.bold)
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
