import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../repositories/ai_repository.dart';

class AiViewModel extends ChangeNotifier {
  AiViewModel({AiRepository? repository})
    : _repository = repository ?? const AiRepository() {
    _messages.add(
      const ChatMessage(
        text: 'Halo! Saya Asisten LaporDesa. Tanyakan cara membuat laporan, lokasi, foto, atau riwayat laporan.',
        role: ChatRole.assistant,
      ),
    );
  }

  final AiRepository _repository;
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void sendMessage(String text) {
    final question = text.trim();
    if (question.isEmpty) return;
    _messages.add(ChatMessage(text: question, role: ChatRole.user));
    _messages.add(
      ChatMessage(
        text: _repository.getResponse(question),
        role: ChatRole.assistant,
      ),
    );
    notifyListeners();
  }
}
