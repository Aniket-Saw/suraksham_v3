import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// In a real app, load this from secure storage or environment variables
const String _apiKey = 'AIzaSyDCdhwScTiKELxcI7dPhz0VjyKgO2f6IY8';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(apiKey: _apiKey);
});

class GeminiService {
  final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService({required String apiKey})
    : _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        systemInstruction: Content.system(
          "You are the Suraksham Safety AI. Your goal is to provide "
          "accurate, localized, and actionable disaster preparedness advice. "
          "Always prioritize immediate physical safety. If you don't know "
          "an answer, advise the user to contact local emergency services.",
        ),
      ) {
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String text) async {
    try {
      final response = await _chat.sendMessage(Content.text(text));
      return response.text ?? 'I experienced an error processing your request.';
    } catch (e) {
      return 'Sorry, I am having trouble connecting right now. Please try again later. ($e)';
    }
  }
}
