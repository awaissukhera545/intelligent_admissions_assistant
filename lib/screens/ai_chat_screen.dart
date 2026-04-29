import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final List<_ChatMessage> _messages = [];

  // Hot topic suggestions
  static const List<String> _suggestions = [
    'What programs does UAF Burewala offer?',
    'How is aggregate calculated?',
    'When do admissions start?',
    'What is the fee for BS Computer Science?',
    'What documents are needed for admission?',
    'What is the merit criteria?',
    'Is hostel facility available?',
    'How to apply for admission?',
  ];

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text.trim(), isUser: true));
      _messageCtrl.clear();
    });

    _scrollToBottom();

    // Simulate AI response after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          text: _getAIResponse(text),
          isUser: false,
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// TODO: Connect your AI API here.
  /// Replace this method body with an HTTP POST to your AI endpoint.
  /// Example:
  /// ```dart
  /// final response = await http.post(
  ///   Uri.parse('https://your-api.com/chat'),
  ///   headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer YOUR_KEY'},
  ///   body: jsonEncode({'message': question}),
  /// );
  /// final data = jsonDecode(response.body);
  /// return data['reply'];
  /// ```
  String _getAIResponse(String question) {
    // Placeholder responses — replace with real API integration
    final q = question.toLowerCase();

    if (q.contains('program') || q.contains('offer') || q.contains('degree')) {
      return 'UAF Burewala Campus offers 14 degree programs including BS Software Engineering, BS Computer Science, BS IT, BBA, BBA Agri-Business, BSc (Hons) Agriculture, BS Mathematics, BS Chemistry, BS Botany, BS Zoology, BS Human Nutrition & Dietetics, BS Food Science & Technology, BS English, and BS Sociology. You can explore all programs in the "Explore" section of the app.';
    }
    if (q.contains('aggregate') || q.contains('calculat')) {
      return 'The aggregate is calculated using the formula:\n\n• 30% Matric Marks\n• 30% Intermediate Marks\n• 40% Entry Test Marks\n\nYou can use the Aggregate Calculator in the Eligibility section to calculate your exact aggregate.';
    }
    if (q.contains('admission') || q.contains('start') || q.contains('apply')) {
      return 'Admissions for Fall 2026 are expected to start around August 2026. Keep checking the "Application Tracker" section for the latest updates and dates. You can apply through the UAF online admission portal at admissions.uaf.edu.pk.';
    }
    if (q.contains('fee') || q.contains('cost')) {
      return 'Fee structures vary by program. Generally, first semester fees range from PKR 35,000 to PKR 52,000, with subsequent semester fees being lower. You can check exact fees for any program by tapping on it in the "Explore" section.';
    }
    if (q.contains('document') || q.contains('required')) {
      return 'Common documents needed for admission include:\n\n1. Matric Certificate & DMC\n2. Intermediate Certificate & DMC\n3. CNIC / B-Form copy\n4. Domicile Certificate\n5. Recent passport-size photographs\n6. Character Certificate\n7. Migration Certificate (if applicable)\n\nPlease check the official UAF website for the complete and updated list.';
    }
    if (q.contains('merit') || q.contains('criteria')) {
      return 'Merit is determined based on the aggregate score calculated as 30% Matric + 30% Inter + 40% Entry Test marks. Different programs have different merit cutoffs that vary each year depending on the number of applicants and available seats.';
    }
    if (q.contains('hostel') || q.contains('accommodation')) {
      return 'UAF Burewala Campus provides hostel facilities for both male and female students, subject to availability. Hostel fees are charged separately. Contact the campus administration for hostel availability and fee details.';
    }

    return 'Thank you for your question! AI-powered responses will be available soon once the AI service is connected. In the meantime, you can explore the app features for detailed information about programs, eligibility, and admissions.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.divider, width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.textDark),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Assistant',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Ask anything about admissions',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Chat Area ─────────────────────────────────────────
            Expanded(
              child: _messages.isEmpty ? _buildEmptyState() : _buildChatList(),
            ),

            // ── Suggestion Chips (only when no messages) ─────────
            if (_messages.isEmpty) _buildSuggestionChips(),

            // ── Input Bar ─────────────────────────────────────────
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.chat_bubble_outline_rounded,
                  color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              'How can I help you?',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask me anything about UAF Burewala admissions, programs, eligibility, or fee structure.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textGrey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return _buildMessageBubble(msg);
      },
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.chatUserBubble : AppColors.chatAiBubble,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!msg.isUser) ...[
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 8, top: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 14),
              ),
            ],
            Flexible(
              child: Text(
                msg.text,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: msg.isUser ? Colors.white : AppColors.textDark,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _suggestions.take(6).map((suggestion) {
          return GestureDetector(
            onTap: () => _sendMessage(suggestion),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryPale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      color: AppColors.primary, size: 14),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      suggestion,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.chatInputBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                controller: _messageCtrl,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textDark),
                maxLines: 3,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
                decoration: InputDecoration(
                  hintText: 'Type your question...',
                  hintStyle: GoogleFonts.poppins(
                      color: AppColors.textGrey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(_messageCtrl.text),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chat Message Model ──────────────────────────────────────────────────────

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}
