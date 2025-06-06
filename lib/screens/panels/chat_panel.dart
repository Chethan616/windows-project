import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_controller.dart';
import '../../models/model_controller.dart';
import '../../models/chat_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/message_input.dart';
import '../../widgets/chat/mode_toggle.dart';
import '../../widgets/chat/chat_history_sidebar.dart';

class ChatPanel extends StatefulWidget {
  const ChatPanel({super.key});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  bool _isResearchMode = false;
  final TextEditingController _messageController = TextEditingController();
  bool _showChatHistory = false;
  
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
  
  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    final modelController = Provider.of<ModelController>(context, listen: false);
    final chatController = Provider.of<ChatController>(context, listen: false);
    final selectedModel = modelController.selectedModel;
    final apiKey = modelController.getApiKey(selectedModel.provider);
    
    if (apiKey == null && selectedModel.requiresApiKey) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set an API key for this provider'))
      );
      return;
    }
    
    final message = _messageController.text;
    _messageController.clear();
    
    await chatController.sendMessage(
      message: message,
      modelId: selectedModel.id,
      apiKey: apiKey ?? '',
      isWizardMode: _isResearchMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    final modelController = Provider.of<ModelController>(context);
    final selectedModel = modelController.selectedModel;
    final chatController = Provider.of<ChatController>(context);
    final currentChat = chatController.currentChat;
    final messages = currentChat?.messages ?? [];
    
    return Row(
      children: [
        // Chat history sidebar (conditionally shown)
        if (_showChatHistory)
          SizedBox(
            width: 250,
            child: ChatHistorySidebar(
              onClose: () => setState(() => _showChatHistory = false),
            ),
          ),
        
        // Main chat area
        Expanded(
          child: Column(
            children: [
              // Chat header with mode toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // History button
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () => setState(() => _showChatHistory = !_showChatHistory),
                      tooltip: 'Chat History',
                      color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Chat',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 20,
                        color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Selected model indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDarkMode 
                            ? AppTheme.primaryColor.withOpacity(0.2) 
                            : AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.model_training,
                            size: 16,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            selectedModel.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Mode toggle
                    ModeToggle(
                      isResearchMode: _isResearchMode,
                      onToggle: (value) {
                        setState(() {
                          _isResearchMode = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              // Chat messages
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 80,
                              color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Start a conversation with your magical assistant',
                              style: AppTheme.subheadingStyle.copyWith(
                                color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Using ${selectedModel.name} by ${selectedModel.provider}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode ? AppTheme.darkSecondaryTextColor : AppTheme.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            color: isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: messages.length,
                              reverse: false,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                return MessageBubble(
                                  text: message['content'],
                                  isUser: message['role'] == 'user',
                                  timestamp: DateTime.parse(message['timestamp']),
                                  isError: message['isError'] == true,
                                );
                              },
                            ),
                          ),
                          if (chatController.isLoading)
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _isResearchMode ? 'Research Mode is thinking...' : 'Thinking...',
                                        style: TextStyle(
                                          color: isDarkMode ? AppTheme.darkTextColor : AppTheme.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              
              // Message input
              MessageInput(
                controller: _messageController,
                onSend: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}