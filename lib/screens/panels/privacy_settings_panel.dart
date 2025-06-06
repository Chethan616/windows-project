import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/privacy_controller.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';
import 'dart:io' show Platform;

class PrivacySettingsPanel extends StatelessWidget {
  const PrivacySettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final privacyController = Provider.of<PrivacyController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Settings',
            style: AppTheme.headingStyle.copyWith(
              color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 24),
          
          // Cloaking Mode card
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
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      privacyController.privacyMode 
                          ? Icons.shield 
                          : Icons.shield_outlined,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(
                    'Cloaking Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                    ),
                  ),
                  subtitle: Text(
                    'Hide bubble from screen recordings',
                    style: TextStyle(
                      color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                    ),
                  ),
                  trailing: Switch(
                    value: privacyController.privacyMode,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      privacyController.togglePrivacyMode(value);
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'When enabled, WizardOS bubble becomes invisible to screen recording and sharing tools while remaining visible to you',
                    style: AppTheme.bodyStyle.copyWith(
                      color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Bubble Visibility card
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
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      privacyController.bubbleVisible 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(
                    'Bubble Visibility',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                    ),
                  ),
                  subtitle: Text(
                    'Show floating bubble on desktop',
                    style: TextStyle(
                      color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                    ),
                  ),
                  trailing: Switch(
                    value: privacyController.bubbleVisible,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      privacyController.toggleBubbleVisibility(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Platform-specific tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Platform Tips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Platform.isWindows
                            ? 'Works best with OBS Studio, Zoom, and Windows Game Bar.'
                            : 'Works best with QuickTime Player, Zoom, and macOS screen sharing.',
                        style: AppTheme.bodyStyle.copyWith(
                          color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                        ),
                      ),
                    ],
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