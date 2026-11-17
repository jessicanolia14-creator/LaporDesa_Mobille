import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../viewmodels/ai_viewmodel.dart';
import '../widgets/chat_bubble.dart';

/// Halaman chat panduan lokal LaporDesa (belum AI online).
class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key, this.initialQuestion = ''});
  final String initialQuestion;

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  static const _green = Color(0xFF08935B);
  late final AiViewModel _viewModel;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = AiViewModel();
    if (widget.initialQuestion.trim().isNotEmpty) {
      _viewModel.sendMessage(widget.initialQuestion);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    _viewModel.sendMessage(text);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF12192B),
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          'Asisten AI LaporDesa',
          style: GoogleFonts.poppins(
            color: _green,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF4F8F6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  child: const Text(
                    'Panduan otomatis lokal • Belum terhubung ke AI online',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Color(0xFF68717B)),
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _viewModel,
                    builder: (context, _) {
                      final messages = _viewModel.messages;
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        itemCount: messages.length,
                        itemBuilder: (context, index) =>
                            ChatBubble(message: messages[index]),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Tulis pertanyaan...',
                            filled: true,
                            fillColor: const Color(0xFFEDF0F3),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _send,
                        tooltip: 'Kirim pesan',
                        style: IconButton.styleFrom(backgroundColor: _green),
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
