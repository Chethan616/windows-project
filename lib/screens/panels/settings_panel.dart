import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';
import 'dart:io' show Platform;

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: AppTheme.headingStyle.copyWith(
              color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 24),
          
          // Appearance card
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.palette_outlined,
                        color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Appearance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                    ),
                  ),
                  subtitle: Text(
                    isDarkMode ? 'Currently using dark theme' : 'Currently using light theme',
                    style: TextStyle(
                      color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                    ),
                  ),
                  trailing: Switch(
                    value: isDarkMode,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      themeController.toggleTheme(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Hotkeys card
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard,
                        color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Hotkeys',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Toggle App Visibility',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                    ),
                  ),
                  subtitle: Text(
                    Platform.isMacOS ? '⌘ + H' : 'Ctrl + H',
                    style: TextStyle(
                      color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDarkMode 
                          ? AppTheme.darkBackgroundColor 
                          : AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDarkMode 
                            ? AppTheme.darkBorderColor 
                            : AppTheme.borderColor,
                      ),
                    ),
                    child: Text(
                      'System-wide',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode 
                            ? AppTheme.darkSecondaryTextColor 
                            : AppTheme.secondaryTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}