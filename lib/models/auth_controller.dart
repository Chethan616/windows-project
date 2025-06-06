import 'package:flutter/material.dart';
import '../services/firebase_rest_service.dart';
import '../services/firestore_rest_service.dart';

class AuthController with ChangeNotifier {
  final FirebaseRestService _firebaseService = FirebaseRestService();
  final FirestoreRestService _firestoreService = FirestoreRestService();
  
  bool _isLoggedIn = false;
  String _email = '';
  String _fullName = '';
  String _userId = '';
  
  bool get isLoggedIn => _isLoggedIn;
  String get email => _email;
  String get fullName => _fullName;
  String get userId => _userId;
  
  // Initialize auth state
  Future<void> initAuth() async {
    final isAuth = await _firebaseService.isAuthenticated();
    if (isAuth) {
      _isLoggedIn = true;
      _userId = await _firebaseService.getUserId() ?? '';
      
      // Get user profile from Firestore
      if (_userId.isNotEmpty) {
        final userData = await _firestoreService.getDocument('users', _userId);
        if (userData != null) {
          _email = userData['email'] ?? '';
          _fullName = userData['fullName'] ?? '';
        }
      }
      
      notifyListeners();
    }
  }
  
  Future<bool> login(String email, String password) async {
    final result = await _firebaseService.signIn(email, password);
    
    if (result['success']) {
      _isLoggedIn = true;
      _email = email;
      _userId = result['userId'];
      
      // Get user profile from Firestore
      final userData = await _firestoreService.getDocument('users', _userId);
      if (userData != null) {
        _fullName = userData['fullName'] ?? '';
      }
      
      notifyListeners();
      return true;
    }
    return false;
  }
  
  Future<bool> signup(String fullName, String email, String password) async {
    final result = await _firebaseService.signUp(email, password);
    
    if (result['success']) {
      _isLoggedIn = true;
      _email = email;
      _fullName = fullName;
      _userId = result['userId'];
      
      // Create user profile in Firestore
      await _firestoreService.setDocument('users', _userId, {
        'email': email,
        'fullName': fullName,
        'createdAt': DateTime.now().toIso8601String(),
      });
      
      notifyListeners();
      return true;
    }
    return false;
  }
  
  Future<void> logout() async {
    await _firebaseService.signOut();
    _isLoggedIn = false;
    _email = '';
    _fullName = '';
    _userId = '';
    notifyListeners();
  }
}