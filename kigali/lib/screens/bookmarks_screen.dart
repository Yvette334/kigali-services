import 'package:flutter/material.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navyblue = const Color(0xFF0A172F);
    final yellow = const Color(0xFFF7C351);

    return Scaffold(
      backgroundColor: navyblue,
      appBar: AppBar(
        backgroundColor: navyblue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Bookmarks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark, size: 60, color: yellow),
                const SizedBox(height: 16),
                const Text('Bookmarks', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Save your favorite places for quick access', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Enable bookmarks', style: TextStyle(color: Colors.white70)),
                    const SizedBox(width: 12),
                    Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: yellow,
                      activeTrackColor: yellow.withOpacity(0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
