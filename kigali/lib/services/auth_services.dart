
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Get current user
  User? get currentUser => _auth.currentUser;


  // Stream of user authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> reloadUser() async{
    await _auth.currentUser?.reload();
    notifyListeners();
  }
  // Sign in with email and password
  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // STUDENTS: Implement Firebase sign-in
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e){
      return e.toString();
    }
  }


  // Create a new account with email and password
  Future<String?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // STUDENTS: Implement Firebase user creation
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
      await result.user!.sendEmailVerification();
      await _firestore.collection('users').doc(result.user!.uid).set({
        'name': name,
        'email': email,
        'uid': result.user!.uid,
      });
      notifyListeners();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e){
      return e.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    // STUDENTS: Implement sign out
    await _auth.signOut();
    notifyListeners();
  }
}