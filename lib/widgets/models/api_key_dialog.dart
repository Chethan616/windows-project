import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/model_controller.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';

class ApiKeyDialog extends StatelessWidget {
  final String provider;
  final String? currentKey;

  const ApiKeyDialog({
    super.key,
    required this.provider,
    this.currentKey,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    final modelController = Provider.of<ModelController>(context, listen: false);
    final TextEditingController apiKeyController = TextEditingController(text: currentKey);
    
    return AlertDialog(
      backgroundColor: isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor,
      title: Text(
        '$provider API Key',
        style: TextStyle(
          color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your $provider API key to use their models',
            style: TextStyle(
              color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: apiKeyController,
            decoration: InputDecoration(
              hintText: 'Enter API key',
              hintStyle: TextStyle(
                color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
            ),
            style: TextStyle(
              color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (apiKeyController.text.isNotEmpty) {
              modelController.saveApiKey(provider, apiKeyController.text);
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}