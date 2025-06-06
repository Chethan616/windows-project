import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/model_controller.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/models/model_card.dart';
import '../../widgets/models/api_key_dialog.dart';

class ModelSelectorPanel extends StatefulWidget {
  const ModelSelectorPanel({Key? key}) : super(key: key);

  @override
  State<ModelSelectorPanel> createState() => _ModelSelectorPanelState();
}

class _ModelSelectorPanelState extends State<ModelSelectorPanel> {
  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    final modelController = Provider.of<ModelController>(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Model Selector',
            style: AppTheme.headingStyle.copyWith(
              color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose an AI model to power your assistant',
            style: AppTheme.subheadingStyle.copyWith(
              color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: ListView(
              children: [
                // Default model card
                ModelCard(
                  provider: 'WizardOS',
                  models: modelController.getModelsByProvider('WizardOS'),
                  showApiKeyDialog: _showApiKeyDialog,
                ),
                
                // OpenAI models card
                ModelCard(
                  provider: 'OpenAI',
                  models: modelController.getModelsByProvider('OpenAI'),
                  showApiKeyDialog: _showApiKeyDialog,
                ),
                
                // Google models card
                ModelCard(
                  provider: 'Google',
                  models: modelController.getModelsByProvider('Google'),
                  showApiKeyDialog: _showApiKeyDialog,
                ),
                
                // Anthropic models card
                ModelCard(
                  provider: 'Anthropic',
                  models: modelController.getModelsByProvider('Anthropic'),
                  showApiKeyDialog: _showApiKeyDialog,
                ),
                
                // DeepSeek models card
                ModelCard(
                  provider: 'DeepSeek',
                  models: modelController.getModelsByProvider('DeepSeek'),
                  showApiKeyDialog: _showApiKeyDialog,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showApiKeyDialog(String provider, String? currentKey) {
    final BuildContext currentContext = context;
    showDialog(
      context: currentContext,
      builder: (context) => ApiKeyDialog(
        provider: provider,
        currentKey: currentKey,
      ),
    );
  }
}