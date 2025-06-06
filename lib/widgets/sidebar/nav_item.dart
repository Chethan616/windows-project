import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';

class NavItem extends StatelessWidget {
  final int index;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.index,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: isSelected ? AppTheme.primaryGradient : null,
        color: isSelected 
            ? null 
            : (isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor),
        boxShadow: isSelected ? [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected 
              ? Colors.white 
              : (isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : (isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: onTap,
      ),
    );
  }
}