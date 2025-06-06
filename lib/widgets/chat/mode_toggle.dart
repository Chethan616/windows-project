import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';

class ModeToggle extends StatelessWidget {
  final bool isResearchMode;
  final Function(bool) onToggle;

  const ModeToggle({
    super.key,
    required this.isResearchMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildModeToggleButton(false, '📊 Standard Mode'),
          _buildModeToggleButton(true, '🔍 Research Mode'),
        ],
      ),
    );
  }

  Widget _buildModeToggleButton(bool isResearch, String label) {
    return Consumer<ThemeController>(
      builder: (context, themeController, _) {
        final isDarkMode = themeController.isDarkMode;
        final isSelected = isResearchMode == isResearch;
        
        return GestureDetector(
          onTap: () => onToggle(isResearch),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: isSelected ? AppTheme.primaryGradient : null,
              color: isSelected 
                  ? null 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected 
                    ? Colors.white 
                    : (isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}