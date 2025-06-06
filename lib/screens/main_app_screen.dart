import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/privacy_controller.dart';
import '../models/theme_controller.dart';
import '../widgets/sidebar/sidebar.dart';
import 'panels/chat_panel.dart';
import 'panels/privacy_settings_panel.dart';
import 'panels/settings_panel.dart';
import 'panels/model_selector_panel.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final privacyController = Provider.of<PrivacyController>(context);
    final themeController = Provider.of<ThemeController>(context);
    
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            selectedIndex: _selectedIndex,
            onNavItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          
          // Main content area
          Expanded(
            child: _buildContent(_selectedIndex, privacyController, themeController),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent(int index, PrivacyController privacyController, ThemeController themeController) {
    switch (index) {
      case 0:
        return const ChatPanel();
      case 2:
        return const PrivacySettingsPanel();
      case 3:
        return const SettingsPanel();
      case 4:
        return const ModelSelectorPanel();
      default:
        return Center(
          child: Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeController.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        );
    }
  }
}