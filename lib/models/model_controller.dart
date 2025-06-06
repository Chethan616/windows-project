import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_rest_service.dart';
import '../services/firebase_rest_service.dart';

class AIModel {
  final String id;
  final String name;
  final String provider;
  final String description;
  final String iconData;
  final bool requiresApiKey;
  
  AIModel({
    required this.id,
    required this.name,
    required this.provider,
    required this.description,
    required this.iconData,
    this.requiresApiKey = true,
  });
}

class ModelController with ChangeNotifier {
  String _selectedModelId = 'default';
  Map<String, String> _apiKeys = {
    'Groq': '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'
  };
  final FirestoreRestService _firestoreService = FirestoreRestService();
  final FirebaseRestService _firebaseService = FirebaseRestService();
  
  String get selectedModelId => _selectedModelId;
  AIModel get selectedModel => models.firstWhere(
    (model) => model.id == _selectedModelId,
    orElse: () => models.first,
  );
  
  String? getApiKey(String provider) => _apiKeys[provider];
  
  // Predefined models grouped by provider
  final List<AIModel> models = [
    // Default model
    AIModel(
      id: 'default',
      name: 'Default',
      provider: 'WizardOS',
      description: 'Default model provided by WizardOS',
      iconData: 'auto_awesome',
      requiresApiKey: false,
    ),
    
    // Groq models
    AIModel(
      id: 'llama3-70b-8192',
      name: 'Llama 3 70B',
      provider: 'Groq',
      description: 'Meta\'s Llama 3 70B model, optimized for speed on Groq',
      iconData: 'bolt',
    ),
    AIModel(
      id: 'llama3-8b-8192',
      name: 'Llama 3 8B',
      provider: 'Groq',
      description: 'Lightweight Llama 3 model for faster responses',
      iconData: 'bolt',
    ),
    AIModel(
      id: 'mixtral-8x7b-32768',
      name: 'Mixtral 8x7B',
      provider: 'Groq',
      description: 'Mistral AI\'s powerful mixture of experts model',
      iconData: 'bolt',
    ),
    
    // OpenAI models
    AIModel(
      id: 'gpt-4o',
      name: 'GPT-4o',
      provider: 'OpenAI',
      description: 'Most advanced multimodal model with vision capabilities',
      iconData: 'psychology',
    ),
    AIModel(
      id: 'gpt-4-turbo',
      name: 'GPT-4 Turbo',
      provider: 'OpenAI',
      description: 'Powerful model with strong reasoning capabilities',
      iconData: 'psychology',
    ),
    AIModel(
      id: 'gpt-3.5-turbo',
      name: 'GPT-3.5 Turbo',
      provider: 'OpenAI',
      description: 'Fast and efficient model for most tasks',
      iconData: 'psychology',
    ),
    
    // Google models
    AIModel(
      id: 'gemini-pro',
      name: 'Gemini Pro',
      provider: 'Google',
      description: 'Google\'s advanced language model',
      iconData: 'smart_toy',
    ),
    AIModel(
      id: 'gemini-ultra',
      name: 'Gemini Ultra',
      provider: 'Google',
      description: 'Google\'s most capable multimodal model',
      iconData: 'smart_toy',
    ),
    
    // Anthropic models
    AIModel(
      id: 'claude-3-opus',
      name: 'Claude 3 Opus',
      provider: 'Anthropic',
      description: 'Anthropic\'s most powerful model',
      iconData: 'psychology_alt',
    ),
    AIModel(
      id: 'claude-3-sonnet',
      name: 'Claude 3 Sonnet',
      provider: 'Anthropic',
      description: 'Balanced performance and efficiency',
      iconData: 'psychology_alt',
    ),
    
    // DeepSeek models
    AIModel(
      id: 'deepseek-coder',
      name: 'DeepSeek Coder',
      provider: 'DeepSeek',
      description: 'Specialized for code generation and understanding',
      iconData: 'code',
    ),
  ];
  
  ModelController() {
    _loadPreferences();
  }
  
  // Modified to load from both local storage and Firestore
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedModelId = prefs.getString('selectedModelId') ?? 'llama3-70b-8192';
    
    // Load saved API keys from local storage first
    final openaiKey = prefs.getString('apiKey_OpenAI');
    final googleKey = prefs.getString('apiKey_Google');
    final anthropicKey = prefs.getString('apiKey_Anthropic');
    final deepseekKey = prefs.getString('apiKey_DeepSeek');
    final groqKey = prefs.getString('apiKey_Groq') ?? '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';
    
    if (openaiKey != null) _apiKeys['OpenAI'] = openaiKey;
    if (googleKey != null) _apiKeys['Google'] = googleKey;
    if (anthropicKey != null) _apiKeys['Anthropic'] = anthropicKey;
    if (deepseekKey != null) _apiKeys['DeepSeek'] = deepseekKey;
    if (groqKey != null) _apiKeys['Groq'] = groqKey;
    
    // Try to load from Firestore if user is authenticated
    await loadApiKeysFromFirestore();
    
    notifyListeners();
  }
  
  // New method to load API keys from Firestore
  Future<void> loadApiKeysFromFirestore() async {
    final userId = await _firebaseService.getUserId();
    if (userId == null || userId.isEmpty) return;
    
    final userData = await _firestoreService.getDocument('users', userId);
    if (userData == null) return;
    
    // Get API keys from user document
    final apiKeys = userData['apiKeys'] as Map<String, dynamic>?;
    if (apiKeys != null) {
      apiKeys.forEach((provider, key) {
        _apiKeys[provider] = key as String;
      });
      
      // Also update local storage
      final prefs = await SharedPreferences.getInstance();
      _apiKeys.forEach((provider, key) {
        prefs.setString('apiKey_$provider', key);
      });
    }
    
    notifyListeners();
  }
  
  // Modified to save to both local storage and Firestore
  Future<void> saveApiKey(String provider, String apiKey) async {
    _apiKeys[provider] = apiKey;
    
    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey_$provider', apiKey);
    
    // Save to Firestore if user is authenticated
    final userId = await _firebaseService.getUserId();
    if (userId != null && userId.isNotEmpty) {
      // Get existing user data
      final userData = await _firestoreService.getDocument('users', userId) ?? {};
      
      // Update or create apiKeys map
      Map<String, dynamic> apiKeys = (userData['apiKeys'] as Map<String, dynamic>?) ?? {};
      apiKeys[provider] = apiKey;
      
      // Update user document with new apiKeys
      await _firestoreService.setDocument('users', userId, {
        ...userData,
        'apiKeys': apiKeys,
      });
    }
    
    notifyListeners();
  }
  
  Future<void> selectModel(String modelId) async {
    _selectedModelId = modelId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedModelId', modelId);
    notifyListeners();
  }
  
  List<AIModel> getModelsByProvider(String provider) {
    return models.where((model) => model.provider == provider).toList();
  }
  
  List<String> get providers {
    final Set<String> uniqueProviders = {};
    for (var model in models) {
      uniqueProviders.add(model.provider);
    }
    return uniqueProviders.toList();
  }
}