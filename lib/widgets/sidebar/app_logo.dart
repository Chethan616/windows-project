import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final String email;

  const AppLogo({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'WizardOS',
            style: AppTheme.headingStyle.copyWith(
              fontSize: 20,
              color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
            ),
          ),
          Text(
            email,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 14,
              color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}