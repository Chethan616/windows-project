import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class PrivacyController with ChangeNotifier {
  bool _privacyMode = false;
  bool _bubbleVisible = false;
  
  bool get privacyMode => _privacyMode;
  bool get bubbleVisible => _bubbleVisible;
  
  void togglePrivacyMode(bool value) {
    _privacyMode = value;
    notifyListeners();
    _applyPrivacyState();
    
    // Visual feedback
    HapticFeedback.mediumImpact();
  }
  
  void toggleBubbleVisibility(bool value) {
    _bubbleVisible = value;
    notifyListeners();
  }
  
  void _applyPrivacyState() {
    // This would be implemented with actual platform-specific code
    if (Platform.isWindows) {
      // Windows implementation
      print('Setting Windows privacy mode: $_privacyMode');
    } else if (Platform.isMacOS) {
      // macOS implementation
      print('Setting macOS privacy mode: $_privacyMode');
    }
  }
}