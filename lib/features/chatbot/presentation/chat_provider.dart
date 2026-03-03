import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/gemini_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatMessagesNotifier extends Notifier<List<ChatMessage>> {
  bool _isLoading = false;

  @override
  List<ChatMessage> build() {
    return [
      ChatMessage(
        text:
            "Hello! I am Suraksham, your AI Safety Assistant. How can I help you prepare today?",
        isUser: false,
      ),
    ];
  }

  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    state = [...state, ChatMessage(text: text, isUser: true)];
    _isLoading = true;
    ref.notifyListeners();

    try {
      final gemini = ref.read(geminiServiceProvider);
      final response = await gemini.sendMessage(text);
      state = [...state, ChatMessage(text: response, isUser: false)];
    } finally {
      _isLoading = false;
    }
  }
}

final chatMessagesProvider =
    NotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(() {
      return ChatMessagesNotifier();
    });
