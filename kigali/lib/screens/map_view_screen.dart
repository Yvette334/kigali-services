import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/listing_model.dart';
import '../providers/listing_provider.dart';
import 'detail_screen.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final yellow = const Color(0xFFF7C351);
    final listingProvider = Provider.of<ListingProvider>(context, listen: false);

    return StreamBuilder<List<Listing>>(
      stream: listingProvider.getAllListingsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: yellow));
        }

        final listings = snapshot.data ?? [];
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
                child: Icon(
                  Icons.location_on,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          );
        }).toList();

        return FlutterMap(
          options: MapOptions(
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
        );
      },
    );
  }
}
