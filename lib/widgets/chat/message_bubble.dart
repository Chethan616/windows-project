import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isUser ? AppTheme.primaryGradient : null,
          color: isUser 
              ? null 
              : isError
                  ? (isDarkMode ? Colors.red.shade900 : Colors.red.shade100)
                  : (isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isUser 
                    ? Colors.white 
                    : isError
                        ? (isDarkMode ? Colors.red.shade100 : Colors.red.shade900)
                        : (isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isError)
                  Icon(
                    Icons.error_outline,
                    size: 12,
                    color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                  ),
                if (isError)
                  const SizedBox(width: 4),
                Text(
                  '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: isUser 
                        ? Colors.white.withOpacity(0.7) 
                        : isError
                            ? (isDarkMode ? Colors.red.shade300 : Colors.red.shade700)
                            : (isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}