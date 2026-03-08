import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing_model.dart';
import '../providers/listing_provider.dart';
import '../services/auth_services.dart';

class AddEditListingScreen extends StatefulWidget {
  final Listing? listing;

  const AddEditListingScreen({super.key, this.listing});

  @override
  State<AddEditListingScreen> createState() => _AddEditListingScreenState();
}

class _AddEditListingScreenState extends State<AddEditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _descriptionController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  String _selectedCategory = 'Hospital';

  final List<String> _categories = ['Hospital', 'Police Station', 'Library', 'Restaurant', 'Café', 'Park', 'Tourist Attraction'];
  final navyblue = const Color(0xFF0A172F);
  final yellow = const Color(0xFFF7C351);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.listing?.name ?? '');
    _addressController = TextEditingController(text: widget.listing?.address ?? '');
    _contactController = TextEditingController(text: widget.listing?.contact ?? '');
    _descriptionController = TextEditingController(text: widget.listing?.description ?? '');
    _latController = TextEditingController(text: widget.listing?.latitude.toString() ?? '');
    _lngController = TextEditingController(text: widget.listing?.longitude.toString() ?? '');
    if (widget.listing != null) {
      _selectedCategory = widget.listing!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _saveListing() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final listingProvider = Provider.of<ListingProvider>(context, listen: false);

    final listing = Listing(
      id: widget.listing?.id ?? '',
      name: _nameController.text.trim(),
      category: _selectedCategory,
      address: _addressController.text.trim(),
      contact: _contactController.text.trim(),
      description: _descriptionController.text.trim(),
      latitude: double.parse(_latController.text.trim()),
      longitude: double.parse(_lngController.text.trim()),
      createdBy: authService.currentUser!.uid,
      timestamp: DateTime.now(),
    );

    try {
      if (widget.listing == null) {
        await listingProvider.addListing(listing);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Listing added successfully')),
          );
        }
      } else {
        await listingProvider.updateListing(widget.listing!.id, listing);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Listing updated successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyblue,
      appBar: AppBar(
        backgroundColor: navyblue,
        foregroundColor: Colors.white,
        title: Text(widget.listing == null ? 'Add Listing' : 'Edit Listing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white60)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: yellow)),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                dropdownColor: navyblue,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white60)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: yellow)),
                ),
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white60)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: yellow)),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Contact',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white60)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: yellow)),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white60)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: yellow)),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white60)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: yellow)),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => double.tryParse(v!) == null ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lngController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white60)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: yellow)),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => double.tryParse(v!) == null ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: navyblue,
                  ),
                  onPressed: _saveListing,
                  child: Text(widget.listing == null ? 'ADD LISTING' : 'UPDATE LISTING'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
