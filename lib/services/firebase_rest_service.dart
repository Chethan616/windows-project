import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase_options.dart';

class FirebaseRestService {
  // Firebase project configuration
  final String _apiKey = DefaultFirebaseOptions.windows.apiKey;
  final String _projectId = DefaultFirebaseOptions.windows.projectId;
  
  // Auth endpoints
  final String _signUpUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp';
  final String _signInUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';
  
  // Token storage keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _expiryTimeKey = 'expiry_time';
  static const String _userIdKey = 'user_id';
  
  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTimeString = prefs.getString(_expiryTimeKey);
    
    // Check if token is expired
    if (expiryTimeString != null) {
      final expiryTime = DateTime.parse(expiryTimeString);
      if (expiryTime.isBefore(DateTime.now())) {
        // Token expired, clear it
        await _clearAuthData();
        return null;
      }
    }
    
    return prefs.getString(_tokenKey);
  }
  
  // Get user ID
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }
  
  // Sign up with email and password
  Future<Map<String, dynamic>> signUp(String email, String password) async {
    final url = Uri.parse('$_signUpUrl?key=$_apiKey');
    
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        return {
          'success': false,
          'error': responseData['error']['message'] ?? 'Authentication failed',
        };
      }
      
      // Store auth data
      await _storeAuthData(responseData);
      
      return {
        'success': true,
        'userId': responseData['localId'],
        'email': email,
      };
    } catch (error) {
      return {
        'success': false,
        'error': 'Network error occurred. Please check your connection.',
      };
    }
  }
  
  // Sign in with email and password
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url = Uri.parse('$_signInUrl?key=$_apiKey');
    
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode != 200) {
        return {
          'success': false,
          'error': responseData['error']['message'] ?? 'Authentication failed',
        };
      }
      
      // Store auth data
      await _storeAuthData(responseData);
      
      return {
        'success': true,
        'userId': responseData['localId'],
        'email': email,
      };
    } catch (error) {
      return {
        'success': false,
        'error': 'Network error occurred. Please check your connection.',
      };
    }
  }
  
  // Store authentication data
  Future<void> _storeAuthData(Map<String, dynamic> authData) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Calculate expiry time
    final expiresIn = int.parse(authData['expiresIn']);
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
    
    await prefs.setString(_tokenKey, authData['idToken']);
    await prefs.setString(_refreshTokenKey, authData['refreshToken']);
    await prefs.setString(_expiryTimeKey, expiryTime.toIso8601String());
    await prefs.setString(_userIdKey, authData['localId']);
  }
  
  // Clear authentication data (logout)
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_expiryTimeKey);
    await prefs.remove(_userIdKey);
  }
  
  // Sign out
  Future<void> signOut() async {
    await _clearAuthData();
  }
  
  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}