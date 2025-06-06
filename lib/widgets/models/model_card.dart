import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/model_controller.dart';
import '../../models/theme_controller.dart';
import '../../theme/app_theme.dart';

class ModelCard extends StatelessWidget {
  final String provider;
  final List<AIModel> models;
  final Function(String, String?) showApiKeyDialog;

  const ModelCard({
    super.key,
    required this.provider,
    required this.models,
    required this.showApiKeyDialog,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    final modelController = Provider.of<ModelController>(context);
    final apiKey = modelController.getApiKey(provider);
    final needsApiKey = provider != 'WizardOS';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Provider header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Text(
                  provider,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                if (needsApiKey)
                  TextButton.icon(
                    onPressed: () {
                      showApiKeyDialog(provider, apiKey);
                    },
                    icon: const Icon(
                      Icons.key,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: Text(
                      apiKey != null ? 'Update API Key' : 'Add API Key',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
              ],
            ),
          ),
          
          // Models list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: models.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final model = models[index];
              final isSelected = modelController.selectedModelId == model.id;
              
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.primaryColor 
                        : AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: isSelected ? Colors.white : AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  model.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                  ),
                ),
                subtitle: Text(
                  model.description,
                  style: TextStyle(
                    color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                  ),
                ),
                trailing: isSelected
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Selected',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      )
                    : (model.requiresApiKey && apiKey == null)
                        ? Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber,
                            size: 20,
                          )
                        : null,
                onTap: () {
                  if (model.requiresApiKey && apiKey == null) {
                    showApiKeyDialog(provider, null);
                  } else {
                    modelController.selectModel(model.id);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}