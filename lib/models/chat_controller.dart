import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../services/groq_api_service.dart';

class Chat {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<Map<String, dynamic>> messages;
  
  Chat({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });
}

class ChatController with ChangeNotifier {
  final GroqApiService _groqService = GroqApiService();
  final List<Chat> _chats = [];
  String? _currentChatId;
  bool _isLoading = false;
  
  List<Chat> get chats => List.unmodifiable(_chats);
  String? get currentChatId => _currentChatId;
  bool get isLoading => _isLoading;
  
  Chat? get currentChat {
    if (_currentChatId == null) return null;
    try {
      return _chats.firstWhere((chat) => chat.id == _currentChatId);
    } catch (e) {
      return null;
    }
  }
  
  ChatController() {
    _loadChats();
  }
  
  Future<void> _loadChats() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final chatIds = await _groqService.getAllChatIds();
      _chats.clear();
      
      for (final chatId in chatIds) {
        final messages = await _groqService.loadChatHistory(chatId);
        String title = 'New Chat';
        
        // Try to generate a title from the first user message
        if (messages.isNotEmpty) {
          final firstUserMsg = messages.firstWhere(
            (msg) => msg['role'] == 'user',
            orElse: () => {'content': 'New Chat'},
          );
          
          title = firstUserMsg['content'].toString();
          if (title.length > 30) {
            title = '${title.substring(0, 27)}...';
          }
        }
        
        _chats.add(Chat(
          id: chatId,
          title: title,
          createdAt: DateTime.now(), // We don't have actual creation time
          messages: messages,
        ));
      }
      
      // Sort chats by creation time (newest first)
      _chats.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // Set current chat to the most recent one, or create a new one if none exists
      if (_chats.isNotEmpty && _currentChatId == null) {
        _currentChatId = _chats.first.id;
      }
    } catch (e) {
      print('Error loading chats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> createNewChat() async {
    final chatId = const Uuid().v4();
    final newChat = Chat(
      id: chatId,
      title: 'New Chat',
      createdAt: DateTime.now(),
      messages: [],
    );
    
    _chats.insert(0, newChat);
    _currentChatId = chatId;
    await _groqService.saveChatHistory(chatId, []);
    notifyListeners();
  }
  
  Future<void> selectChat(String chatId) async {
    _currentChatId = chatId;
    notifyListeners();
  }
  
  Future<void> deleteChat(String chatId) async {
    _chats.removeWhere((chat) => chat.id == chatId);
    
    if (_currentChatId == chatId) {
      _currentChatId = _chats.isNotEmpty ? _chats.first.id : null;
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history_$chatId');
    
    notifyListeners();
  }
  
  Future<Map<String, dynamic>?> sendMessage({
    required String message,
    required String modelId,
    required String apiKey,
    required bool isWizardMode,
  }) async {
    if (_currentChatId == null) {
      await createNewChat();
    }
    
    final chatIndex = _chats.indexWhere((chat) => chat.id == _currentChatId);
    if (chatIndex == -1) return null;
    
    // Add user message
    final userMessage = {
      'role': 'user',
      'content': message,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _chats[chatIndex].messages.add(userMessage);
    notifyListeners();
    
    // Save to storage
    await _groqService.saveChatHistory(_currentChatId!, _chats[chatIndex].messages);
    
    // Update chat title if this is the first message
    if (_chats[chatIndex].messages.length == 1) {
      final title = message.length > 30 ? '${message.substring(0, 27)}...' : message;
      _chats[chatIndex] = Chat(
        id: _chats[chatIndex].id,
        title: title,
        createdAt: _chats[chatIndex].createdAt,
        messages: _chats[chatIndex].messages,
      );
      notifyListeners();
    }
    
    try {
      _isLoading = true;
      notifyListeners();
      
      // Handle default model locally
      if (modelId == 'default') {
        await Future.delayed(const Duration(seconds: 1)); // Simulate processing time
        
        final defaultResponse = {
          'role': 'assistant',
          'content': isWizardMode 
              ? 'Research Mode: I\'m here to help with in-depth analysis and detailed responses. However, you\'ll need to set up a valid API key to access advanced models. Would you like me to guide you through the setup?'
              : 'Standard Mode: I can help with general questions. For more advanced capabilities, switch to Research Mode and set up an API key in the settings.',
          'timestamp': DateTime.now().toIso8601String(),
        };
        
        _chats[chatIndex].messages.add(defaultResponse);
        await _groqService.saveChatHistory(_currentChatId!, _chats[chatIndex].messages);
        return {'choices': [{'message': {'content': defaultResponse['content']}}]};
      } else {
        // Prepare messages for API (without timestamps)
        final apiMessages = _chats[chatIndex].messages.map((msg) => {
          'role': msg['role'],
          'content': msg['content'],
        }).toList();
        
        // Call API for non-default models
        final response = await _groqService.sendMessage(
          apiKey: apiKey,
          messages: apiMessages,
          modelId: modelId,
          isWizardMode: isWizardMode,
        );
        
        // Add assistant response
        if (response.containsKey('choices') && 
            response['choices'] is List && 
            response['choices'].isNotEmpty) {
          
          final assistantMessage = {
            'role': 'assistant',
            'content': response['choices'][0]['message']['content'],
            'timestamp': DateTime.now().toIso8601String(),
          };
          
          _chats[chatIndex].messages.add(assistantMessage);
          await _groqService.saveChatHistory(_currentChatId!, _chats[chatIndex].messages);
        }
        
        return response;
      }
    } catch (e) {
      print('Error sending message: $e');
      
      // Add error message
      final errorMessage = {
        'role': 'assistant',
        'content': 'Sorry, I encountered an error: $e',
        'timestamp': DateTime.now().toIso8601String(),
        'isError': true,
      };
      
      _chats[chatIndex].messages.add(errorMessage);
      await _groqService.saveChatHistory(_currentChatId!, _chats[chatIndex].messages);
      
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}