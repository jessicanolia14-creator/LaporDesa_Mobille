import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../viewmodels/ai_viewmodel.dart';
import '../widgets/chat_bubble.dart';

/// Halaman chat LaporDesa, menggunakan backend Flask RAG + Gemini.
class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key, this.initialQuestion = ''});

  final String initialQuestion;

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _mint = Color(0xFFEAF8EF);
  static const Color _muted = Color(0xFF68717B);

  late final AiViewModel _viewModel;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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

  void _sendQuestion(String value) {
    final String question = value.trim();

    if (question.isEmpty || _viewModel.isLoading) return;

    _viewModel.sendMessage(question).then((_) {
      if (mounted) _scrollToBottom();
    });

    _scrollToBottom();
  }

  void _send() {
    final String text = _controller.text.trim();

    if (text.isEmpty || _viewModel.isLoading) return;

    _controller.clear();
    _sendQuestion(text);
  }

  // Ikon yang sesuai dengan lima pertanyaan cepat.
  IconData _questionIcon(int index) {
    switch (index) {
      case 0:
        return Icons.description_outlined;
      case 1:
        return Icons.location_on_outlined;
      case 2:
        return Icons.camera_alt_outlined;
      case 3:
        return Icons.history_rounded;
      case 4:
        return Icons.person_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  // Avatar robot untuk bubble Pertanyaan Umum.
  Widget _buildBotAvatar() {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFFD3F7E9),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.smart_toy_outlined, color: _green, size: 23),
    );
  }

  // Setiap pertanyaan menjadi bubble kecil yang bisa diklik.
  Widget _buildQuestionBubble(String question, int index) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: _viewModel.isLoading ? null : () => _sendQuestion(question),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF8ECFAA), width: 1),
          ),
          child: Row(
            children: [
              Icon(_questionIcon(index), color: _green, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF12192B),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Satu bubble utama yang berisi bubble-bubble pertanyaan.
  Widget _buildQuickQuestionsBubble() {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBotAvatar(),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _mint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pertanyaan Umum',
                    style: GoogleFonts.poppins(
                      color: _green,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tetap memakai pertanyaan asli dari AiViewModel.
                  ...AiViewModel.quickQuestions.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: _buildQuestionBubble(entry.value, entry.key),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                // Informasi chatbot.
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF4F8F6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  child: const Text(
                    'Asisten penggunaan LaporDesa • RAG + Gemini',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: _muted),
                  ),
                ),

                // Area percakapan dan Pertanyaan Umum.
                Expanded(
                  child: AnimatedBuilder(
                    animation: _viewModel,
                    builder: (context, _) {
                      final messages = _viewModel.messages;
                      final bool showQuickQuestions =
                          _viewModel.showQuickQuestions;

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        itemCount:
                            messages.length + (showQuickQuestions ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Menampilkan chat seperti sebelumnya.
                          if (index < messages.length) {
                            return ChatBubble(message: messages[index]);
                          }

                          // Bubble Pertanyaan Umum muncul setelah
                          // pesan pembuka chatbot.
                          return _buildQuickQuestionsBubble();
                        },
                      );
                    },
                  ),
                ),

                // Indikator loading dari backend.
                AnimatedBuilder(
                  animation: _viewModel,
                  builder: (context, _) {
                    return _viewModel.isLoading
                        ? const LinearProgressIndicator(
                            minHeight: 2,
                            color: _green,
                            backgroundColor: Color(0xFFF4F8F6),
                          )
                        : const SizedBox.shrink();
                  },
                ),

                const Divider(height: 1),

                // Kolom mengetik pesan tetap dipertahankan.
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
