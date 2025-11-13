/// Chatbot Screen for Gesi Halisi Application
///
/// AI-powered chatbot that speaks Swahili and helps users understand the app
/// Features:
/// - OpenAI GPT-4o-mini integration
/// - Swahili conversational interface
/// - FAQ assistance

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  // OpenAI API configuration
  // Note: In production, this should be stored securely (e.g., environment variables or backend)
  static const String _openAIApiKey = 'YOUR_OPENAI_API_KEY'; // Replace with actual key
  static const String _openAIModel = 'gpt-4o-mini';
  
  final String _systemPrompt = '''
You are a helpful Swahili assistant explaining how to use a gas cylinder verification app called "SafeCyl". 
Use simple, conversational Swahili and guide users on actions like kuscan nambari, kuthibitisha silinda, or kuuliza kuhusu usalama.

Key features of the app:
1. Thibitisha Silinda (Verify Cylinder) - Users can scan QR codes on gas cylinders to verify authenticity
2. The app uses blockchain technology to ensure cylinders are genuine
3. Users can see cylinder details like serial number, manufacturer, weight, capacity, and batch number
4. Only verified, registered cylinders will show as valid

Be friendly, helpful, and use simple Swahili. Answer questions about:
- How to scan QR codes
- What information they'll see
- How to know if a cylinder is safe
- Why verification is important
- What to do if a cylinder is invalid

Keep responses concise and easy to understand.
''';

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      ChatMessage(
        text: 'Habari! Mimi ni msaidizi wako wa SafeCyl. Niko hapa kukusaidia kuelewa jinsi ya kutumia programu hii na kuthibitisha silinda. Unaweza kuniuliza chochote!',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top App Bar
              _buildTopAppBar(),
              
              // Messages list
              Expanded(
                child: _buildMessagesList(),
              ),
              
              // Input field
              _buildInputField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkPurple.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: AppColors.glassWhiteBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentPurple.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble,
              color: AppColors.accentPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SafeCyl Msaidizi',
                  style: AppTextStyles.onboardingTitle.copyWith(fontSize: 18),
                ),
                Text(
                  'Uko mtandaoni',
                  style: TextStyle(
                    color: AppColors.safetyGreen,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isLoading && index == _messages.length) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: message.isUser
              ? AppGradients.accentGradient
              : AppGradients.glassGradient,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(
            color: message.isUser
                ? Colors.transparent
                : AppColors.glassWhiteBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: AppColors.lightGray.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: AppGradients.glassGradient,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(
            color: AppColors.glassWhiteBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: (value + index * 0.3) % 1.0,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.accentPurple,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkPurple.withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color: AppColors.glassWhiteBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                gradient: AppGradients.glassGradient,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(
                  color: AppColors.glassWhiteBorder,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: AppColors.white),
                decoration: const InputDecoration(
                  hintText: 'Andika ujumbe...',
                  hintStyle: TextStyle(color: AppColors.lightGray),
                  border: InputBorder.none,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              gradient: AppGradients.accentGradient,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: AppColors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });

    // Scroll to bottom
    _scrollToBottom();

    // Get AI response
    await _getAIResponse(text);
  }

  Future<void> _getAIResponse(String userMessage) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if API key is set
      if (_openAIApiKey == 'YOUR_OPENAI_API_KEY') {
        // Fallback to mock responses for demo purposes
        await _getMockResponse(userMessage);
        return;
      }

      // Make API call to OpenAI
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAIApiKey',
        },
        body: json.encode({
          'model': _openAIModel,
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.7,
          'max_tokens': 300,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiMessage = data['choices'][0]['message']['content'];
        
        setState(() {
          _messages.add(
            ChatMessage(
              text: aiMessage,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });
        
        _scrollToBottom();
      } else {
        throw Exception('API call failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting AI response: $e');
      await _getMockResponse(userMessage);
    }
  }

  Future<void> _getMockResponse(String userMessage) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    String response = '';
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('scan') || lowerMessage.contains('kuscan')) {
      response = 'Ili kuscan QR code:\n'
          '1. Bonyeza "Thibitisha Silinda" kwenye dashboard\n'
          '2. Ruhusu app kutumia kamera\n'
          '3. Elekeza kamera kwenye QR code iliyopo kwenye silinda\n'
          '4. App itakusaidia kuthibitisha kama ni halisi';
    } else if (lowerMessage.contains('usalama') || lowerMessage.contains('safety')) {
      response = 'Usalama ni muhimu sana! SafeCyl inakusaidia:\n'
          '• Kuthibitisha silinda ni halisi\n'
          '• Kuona taarifa za mtengenezaji\n'
          '• Kujua historia ya silinda\n'
          '• Kuepuka silinda bandia au hatari';
    } else if (lowerMessage.contains('invalid') || lowerMessage.contains('batili')) {
      response = 'Kama silinda inaonyesha "Batili":\n'
          '• Usitumie silinda hiyo\n'
          '• Inaweza kuwa bandia\n'
          '• Ripoti kwa muuzaji\n'
          '• Nunua silinda kutoka mahali pa kuaminika';
    } else if (lowerMessage.contains('taarifa') || lowerMessage.contains('information')) {
      response = 'Utaona taarifa hizi:\n'
          '• Nambari ya silinda (Serial Number)\n'
          '• Mtengenezaji (Manufacturer)\n'
          '• Uzito na uwezo\n'
          '• Batch number\n'
          '• Tarehe ya uzalishaji';
    } else {
      response = 'Asante kwa swali lako! SafeCyl inakusaidia kuthibitisha silinda za gesi. '
          'Unaweza kuscan QR code kwenye silinda na kupata taarifa kamili. '
          'Je, unahitaji msaada zaidi?';
    }

    setState(() {
      _messages.add(
        ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
