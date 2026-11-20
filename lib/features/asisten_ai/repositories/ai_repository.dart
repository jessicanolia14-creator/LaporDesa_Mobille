import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Android Emulator menuju Flask di laptop host. Gemini key hanya di backend.
class AiRepository {
  const AiRepository({this.baseUrl = 'http://10.0.2.2:5000'});
  final String baseUrl;

  Future<String> getResponse(String question) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.postUrl(Uri.parse('$baseUrl/api/chat'));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({'question': question}));
      final response = await request.close().timeout(const Duration(seconds: 90));
      final raw = await utf8.decoder.bind(response).join();
      final data = jsonDecode(raw);
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Format respons backend tidak sesuai.');
      }
      if (response.statusCode != HttpStatus.ok) {
        throw Exception(data['error'] ?? 'Chatbot belum bisa menjawab.');
      }
      final answer = data['answer'];
      if (answer is! String || answer.trim().isEmpty) {
        throw const FormatException('Jawaban backend kosong.');
      }
      return answer;
    } finally {
      client.close(force: true);
    }
  }
}
