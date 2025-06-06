import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/auth_controller.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';
import 'nav_item.dart';
import 'app_logo.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onNavItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    
    return Container(
      width: 250,
      color: isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor,
      child: Column(
        children: [
          // Logo and app name
          AppLogo(email: authController.email),
          
          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                NavItem(
                  index: 0,
                  title: 'Chat',
                  icon: Icons.chat_bubble_outline,
                  isSelected: selectedIndex == 0,
                  onTap: () => onNavItemSelected(0),
                ),
                NavItem(
                  index: 1,
                  title: 'History',
                  icon: Icons.history,
                  isSelected: selectedIndex == 1,
                  onTap: () => onNavItemSelected(1),
                ),
                NavItem(
                  index: 2,
                  title: 'Privacy Settings',
                  icon: Icons.shield_outlined,
                  isSelected: selectedIndex == 2,
                  onTap: () => onNavItemSelected(2),
                ),
                NavItem(
                  index: 3,
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                  isSelected: selectedIndex == 3,
                  onTap: () => onNavItemSelected(3),
                ),
                NavItem(
                  index: 4,
                  title: 'Model Selector',
                  icon: Icons.model_training,
                  isSelected: selectedIndex == 4,
                  onTap: () => onNavItemSelected(4),
                ),
              ],
            ),
          ),
          
          // Logout button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                authController.logout();
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(
                'Logout',
                style: AppTheme.buttonTextStyle.copyWith(color: Colors.red),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
                foregroundColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}