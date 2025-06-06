import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroqApiService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  
  // Store chat history
  Future<void> saveChatHistory(String chatId, List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history_$chatId', json.encode(messages));
  }
  
  // Load chat history
  Future<List<Map<String, dynamic>>> loadChatHistory(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('chat_history_$chatId');
    
    if (historyString == null) return [];
    
    try {
      final List<dynamic> decoded = json.decode(historyString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading chat history: $e');
      return [];
    }
  }
  
  // Get all chat IDs
  Future<List<String>> getAllChatIds() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    return keys
        .where((key) => key.startsWith('chat_history_'))
        .map((key) => key.substring('chat_history_'.length))
        .toList();
  }
  
  // Send message to Groq API
  Future<Map<String, dynamic>> sendMessage({
    required String apiKey,
    required List<Map<String, dynamic>> messages,
    required String modelId,
    required bool isWizardMode,
  }) async {
    try {
      // Add system message for wizard mode
      final List<Map<String, dynamic>> messageList = [];
      
      if (isWizardMode) {
        messageList.add({
          'role': 'system',
          'content': 'You are Gandalf the Grey, a wise and powerful wizard from Middle-earth. '
              'Respond to all queries with wisdom, occasional humor, and references to your '
              'magical knowledge. Use phrases like "You shall not pass!" when appropriate, '
              'and speak in a manner befitting a wizard of your stature.'
        });
      }
      
      // Add conversation history
      messageList.addAll(messages);
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': modelId,
          'messages': messageList,
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get response from Groq API: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when calling Groq API: $e');
      throw Exception('Failed to communicate with Groq API: $e');
    }
  }
}