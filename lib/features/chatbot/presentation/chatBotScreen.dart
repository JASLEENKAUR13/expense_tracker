import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/theme/AppPallete.dart';
import '../../Expense/provider/ExpenseListProvider.dart';
import '../../profile/provider/profile_provider.dart';
import '../Provider/chatbot_provider.dart';


class chatBotScreen extends ConsumerStatefulWidget {
  const chatBotScreen({super.key});

  @override
  ConsumerState<chatBotScreen> createState() => _chatBotScreenState();
}

class _chatBotScreenState extends ConsumerState<chatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  void _scrollToBottom(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(_scrollController.hasClients){
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
});
  }

  // ── Send message ─────────────────────────────
  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final notifier = ref.read(ChatbotProvider.notifier);
    final expenses = ref.read(ItemListProvider);
    final profileAsync = ref.read(profileProvider);

    profileAsync.whenData((profile) {
      if (profile == null) return;
      notifier.sendMessage(text, expenses, profile);
      _controller.clear();
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(ChatbotProvider);
    final notifier = ref.read(ChatbotProvider.notifier);

    // scroll to bottom whenever messages change
    if (messages.isNotEmpty) _scrollToBottom();

    return Scaffold(
      backgroundColor: AppPallete.background,

      // ── AppBar ──────────────────────────────
      appBar: AppBar(

        centerTitle: true,

        title:Text(
                "AI Assistant",
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.textPrimary,
                ),
              ),
        actions: [
          // clear chat button
          IconButton(
            onPressed: () => ref.read(ChatbotProvider.notifier).clearchat(),
            icon: Icon(Icons.refresh_rounded,
                color: AppPallete.textSecondary, size: 20.sp),
          ),
        ],
      ),

      // ── Body ────────────────────────────────
      body: Column(
        children: [

          // 1. Messages list
          Expanded(
            child: messages.isEmpty
                ? _emptyState()
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 12.h),
              itemCount: messages.length,
              itemBuilder: (_, i) =>
                  _buildMessageBubble(messages[i]),
            ),
          ),

          // 2. Typing indicator
          if (notifier.isLoading) _typingIndicator(),

          // 3. Input box
          _inputBox(),
        ],
      ),
    );
  }

  // ── Empty state ──────────────────────────────
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppPallete.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.smart_toy,
                color: AppPallete.primaryBlue, size: 40.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            "Hi! I'm your finance assistant",
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppPallete.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Ask me anything about your expenses",
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppPallete.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          // suggestion chips
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.center,
            children: [
              _chip("How much did I spend this week?"),
              _chip("What's my biggest category?"),
              _chip("Am I within budget?"),
              _chip("How much have I saved?"),
            ],
          ),
        ],
      ),
    );
  }

  // ── Suggestion chip ──────────────────────────
  Widget _chip(String text) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
        _send();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppPallete.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
              color: AppPallete.primaryBlue.withOpacity(0.3), width: 1),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppPallete.primaryBlue,
          ),
        ),
      ),
    );
  }

  // ── Message bubble ───────────────────────────
  Widget _buildMessageBubble(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppPallete.primaryBlue : AppPallete.cardWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
            bottomRight: Radius.circular(isUser ? 4.r : 16.r),
          ),
        ),
        child: Text(
          message['content'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: AppPallete.textPrimary,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  // ── Typing indicator ─────────────────────────
  Widget _typingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppPallete.cardWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(4.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _animatedDot(0),
                SizedBox(width: 4.w),
                _animatedDot(200),
                SizedBox(width: 4.w),
                _animatedDot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Animated dot ─────────────────────────────
  Widget _animatedDot(int delayMs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (_, value, __) {
        return Container(
          width: 7.w,
          height: 7.w,
          decoration: BoxDecoration(
            color: AppPallete.textSecondary.withOpacity(value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  // ── Input box ────────────────────────────────
  Widget _inputBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppPallete.cardWhite,
        border: Border(
          top: BorderSide(color: AppPallete.surface, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: GoogleFonts.poppins(
                color: AppPallete.textPrimary,
                fontSize: 14.sp,
              ),
              onSubmitted: (_) => _send(),
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: "Ask about your expenses...",
                hintStyle: GoogleFonts.poppins(
                  color: AppPallete.textSecondary,
                  fontSize: 13.sp,
                ),
                filled: true,
                fillColor: AppPallete.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: _send,
            child: Container(
              padding: EdgeInsets.all(11.w),
              decoration: BoxDecoration(
                color: AppPallete.primaryBlue,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.send_rounded,
                  color: Colors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}