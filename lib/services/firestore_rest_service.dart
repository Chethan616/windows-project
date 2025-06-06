import 'dart:convert';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import 'firebase_rest_service.dart';

class FirestoreRestService {
  final FirebaseRestService _authService = FirebaseRestService();
  final String _projectId = DefaultFirebaseOptions.windows.projectId;
  final String _baseUrl = 'https://firestore.googleapis.com/v1/projects/';
  
  // Get Firestore document
  Future<Map<String, dynamic>?> getDocument(String collection, String documentId) async {
    final token = await _authService.getToken();
    if (token == null) return null;
    
    final url = Uri.parse('$_baseUrl$_projectId/databases/(default)/documents/$collection/$documentId');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode != 200) return null;
      
      final responseData = json.decode(response.body);
      return _convertFirestoreDocument(responseData);
    } catch (error) {
      print('Error getting document: $error');
      return null;
    }
  }
  
  // Create or update Firestore document
  Future<bool> setDocument(String collection, String documentId, Map<String, dynamic> data) async {
    final token = await _authService.getToken();
    if (token == null) return false;
    
    final url = Uri.parse('$_baseUrl$_projectId/databases/(default)/documents/$collection/$documentId');
    
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'fields': _convertToFirestoreFields(data),
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      return response.statusCode == 200;
    } catch (error) {
      print('Error setting document: $error');
      return false;
    }
  }
  
  // Create a new document with auto-generated ID
  Future<Map<String, dynamic>?> addDocument(String collection, Map<String, dynamic> data) async {
    final token = await _authService.getToken();
    if (token == null) return null;
    
    final url = Uri.parse('$_baseUrl$_projectId/databases/(default)/documents/$collection');
    
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'fields': _convertToFirestoreFields(data),
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode != 200 && response.statusCode != 201) return null;
      
      final responseData = json.decode(response.body);
      final documentPath = responseData['name'] as String;
      final documentId = documentPath.split('/').last;
      
      return {
        'id': documentId,
        ...data,
      };
    } catch (error) {
      print('Error adding document: $error');
      return null;
    }
  }
  
  // Delete a document
  Future<bool> deleteDocument(String collection, String documentId) async {
    final token = await _authService.getToken();
    if (token == null) return false;
    
    final url = Uri.parse('$_baseUrl$_projectId/databases/(default)/documents/$collection/$documentId');
    
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      return response.statusCode == 200;
    } catch (error) {
      print('Error deleting document: $error');
      return false;
    }
  }
  
  // Convert Dart map to Firestore fields format
  Map<String, dynamic> _convertToFirestoreFields(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    
    data.forEach((key, value) {
      if (value is String) {
        result[key] = {'stringValue': value};
      } else if (value is int) {
        result[key] = {'integerValue': value.toString()};
      } else if (value is double) {
        result[key] = {'doubleValue': value};
      } else if (value is bool) {
        result[key] = {'booleanValue': value};
      } else if (value is Map) {
        result[key] = {'mapValue': {'fields': _convertToFirestoreFields(value as Map<String, dynamic>)}};
      } else if (value is List) {
        final values = value.map((item) {
          if (item is String) return {'stringValue': item};
          if (item is int) return {'integerValue': item.toString()};
          if (item is double) return {'doubleValue': item};
          if (item is bool) return {'booleanValue': item};
          return {'nullValue': null};
        }).toList();
        
        result[key] = {'arrayValue': {'values': values}};
      } else {
        result[key] = {'nullValue': null};
      }
    });
    
    return result;
  }
  
  // Convert Firestore document to Dart map
  Map<String, dynamic> _convertFirestoreDocument(Map<String, dynamic> document) {
    final result = <String, dynamic>{};
    final fields = document['fields'] as Map<String, dynamic>?;
    
    if (fields == null) return result;
    
    fields.forEach((key, value) {
      if (value.containsKey('stringValue')) {
        result[key] = value['stringValue'];
      } else if (value.containsKey('integerValue')) {
        result[key] = int.parse(value['integerValue']);
      } else if (value.containsKey('doubleValue')) {
        result[key] = value['doubleValue'];
      } else if (value.containsKey('booleanValue')) {
        result[key] = value['booleanValue'];
      } else if (value.containsKey('mapValue')) {
        result[key] = _convertFirestoreDocument(value['mapValue']);
      } else if (value.containsKey('arrayValue')) {
        final arrayValue = value['arrayValue']['values'] as List<dynamic>?;
        if (arrayValue != null) {
          result[key] = arrayValue.map((item) {
            if (item.containsKey('stringValue')) return item['stringValue'];
            if (item.containsKey('integerValue')) return int.parse(item['integerValue']);
            if (item.containsKey('doubleValue')) return item['doubleValue'];
            if (item.containsKey('booleanValue')) return item['booleanValue'];
            return null;
          }).toList();
        } else {
          result[key] = [];
        }
      }
    });
    
    return result;
  }
}