import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../repositories/chat_repository.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late final ChatRepository _chatRepository;
  final List<Message> _messages = [];
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Initialize repository with your ApiService
    _chatRepository = ChatRepository();
  }
  
  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    
    // Add user message
    final userMessage = Message(
      text: text,
      isUser: true,
      status: MessageStatus.sent,
    );
    
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    
    _textController.clear();
    
    // Scroll to bottom after adding the message
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    
    try {
      // Get response via repository
      final botMessage = await _chatRepository.sendQuery(text);
      
      setState(() {
        _messages.add(botMessage);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(
          text: "Failed to process your request: ${e.toString()}",
          isUser: false,
          status: MessageStatus.error,
        ));
        _isLoading = false;
      });
    }
    
    // Scroll to bottom after adding the response
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _messages.clear();
              });
            },
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom:100.0, top: 16.0, left: 25.0, right: 25.0),
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty 
                  ? _buildEmptyState()
                  : _buildChatList(),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: LinearProgressIndicator(),
              ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Ask me anything about your data',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return MessageBubble(message: message);
      },
    );
  }
  
  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Ask a question...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
              minLines: 1,
              maxLines: 4,
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: _sendMessage,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  
  const MessageBubble({
    super.key,
    required this.message,
  });
  
  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final theme = Theme.of(context);
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isUser 
              ? theme.colorScheme.primary 
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              message.text,
              style: TextStyle(
                color: isUser 
                    ? theme.colorScheme.onPrimary 
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 10.0,
                    color: isUser 
                        ? theme.colorScheme.onPrimary.withOpacity(0.7)
                        : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
                if (isUser) ...[
                  const SizedBox(width: 4.0),
                  Icon(
                    _getStatusIcon(message.status),
                    size: 12.0,
                    color: theme.colorScheme.onPrimary.withOpacity(0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.error:
        return Icons.error_outline;
    }
  }
}