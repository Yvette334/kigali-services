import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Listing>> getAllListings() {
    return _db.collection('services').orderBy('timestamp', descending: true).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Listing.fromFirestore(doc)).toList()
    );
  }

  Stream<List<Listing>> getUserListings(String uid) {
    
return _db.collection('services').where('createdBy', isEqualTo: uid).snapshots().map(
  (snapshot) {
    final listings = snapshot.docs.map((doc) => Listing.fromFirestore(doc)).toList();
    listings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return listings;
  }
);
  }

  Future<void> addListing(Listing listing) async {
    await _db.collection('services').add(listing.toMap());
  }

  Future<void> updateListing(String id, Listing listing) async {
    await _db.collection('services').doc(id).update(listing.toMap());
  }

  Future<void> deleteListing(String id) async {
    await _db.collection('services').doc(id).delete();
  }
}
