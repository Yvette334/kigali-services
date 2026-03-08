import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class ListingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Listing> _allListings = [];
  List<Listing> _filteredListings = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Listing> get listings => _filteredListings;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  Stream<List<Listing>> getAllListingsStream() {
    return _firestoreService.getAllListings();
  }

  Stream<List<Listing>> getUserListingsStream(String uid) {
    return _firestoreService.getUserListings(uid);
  }

  void updateListings(List<Listing> newListings) {
    _allListings = newListings;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredListings = _allListings.where((listing) {
      bool matchesSearch = _searchQuery.isEmpty || listing.name.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory = _selectedCategory == 'All' || listing.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    notifyListeners();
  }

  Future<void> addListing(Listing listing) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.addListing(listing);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateListing(String id, Listing listing) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.updateListing(id, listing);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteListing(String id) async {
    _isLoading = true;
    notifyListeners();
    await _firestoreService.deleteListing(id);
    _isLoading = false;
    notifyListeners();
  }
}
