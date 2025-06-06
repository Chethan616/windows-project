import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_controller.dart';
import '../../models/chat_controller.dart';
import '../../theme/app_theme.dart';

class ChatHistorySidebar extends StatelessWidget {
  final VoidCallback onClose;

  const ChatHistorySidebar({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    final chatController = Provider.of<ChatController>(context);
    
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.1) 
                      : Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Chat History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                ),
              ],
            ),
          ),
          
          // New chat button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                chatController.createNewChat();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('New Chat'),
                ],
              ),
            ),
          ),
          
          // Chat list
          Expanded(
            child: chatController.chats.isEmpty
                ? Center(
                    child: Text(
                      'No chats yet',
                      style: TextStyle(
                        color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: chatController.chats.length,
                    itemBuilder: (context, index) {
                      final chat = chatController.chats[index];
                      final isSelected = chat.id == chatController.currentChatId;
                      
                      return ListTile(
                        title: Text(
                          chat.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          '${chat.messages.length} messages',
                          style: TextStyle(
                            color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                        leading: Icon(
                          Icons.chat_bubble_outline,
                          color: isSelected 
                              ? AppTheme.primaryColor 
                              : (isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor),
                        ),
                        selected: isSelected,
                        selectedTileColor: isDarkMode 
                            ? AppTheme.primaryColor.withOpacity(0.1) 
                            : AppTheme.primaryColor.withOpacity(0.05),
                        onTap: () => chatController.selectChat(chat.id),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => chatController.deleteChat(chat.id),
                          color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}