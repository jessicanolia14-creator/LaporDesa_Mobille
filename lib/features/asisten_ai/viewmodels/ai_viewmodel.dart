import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../repositories/ai_repository.dart';

class AiViewModel extends ChangeNotifier {
  AiViewModel({AiRepository? repository})
      : _repository = repository ?? const AiRepository() {
    _messages.add(
      const ChatMessage(
        text: 'Halo! Saya Asisten LaporDesa. Ada yang bisa saya bantu mengenai penggunaan aplikasi?',
        role: ChatRole.assistant,
      ),
    );
  }

  static const List<String> quickQuestions = [
    'Bagaimana cara membuat laporan?',
    'Bagaimana cara menentukan lokasi laporan?',
    'Bagaimana cara menambahkan foto laporan?',
    'Bagaimana cara melihat riwayat laporan?',
    'Bagaimana cara mengubah data profil akun?',
  ];

  final AiRepository _repository;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _hasSentMessage = false;
  bool _disposed = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  bool get showQuickQuestions => !_hasSentMessage;

  Future<void> sendMessage(String text) async {
    final question = text.trim();
    if (question.isEmpty || _isLoading || _disposed) return;
    _messages.add(ChatMessage(text: question, role: ChatRole.user));
    _hasSentMessage = true;
    _isLoading = true;
    notifyListeners();
    try {
      final answer = await _repository.getResponse(question);
      if (_disposed) return;
      _messages.add(ChatMessage(text: answer, role: ChatRole.assistant));
    } catch (_) {
      if (_disposed) return;
      _messages.add(const ChatMessage(
        text: 'Maaf ya, chatbot belum bisa dihubungi. Pastikan server Flask aktif dan coba lagi. 😊',
        role: ChatRole.assistant,
      ));
    } finally {
      if (!_disposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
