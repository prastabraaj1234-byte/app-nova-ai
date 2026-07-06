import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/models/message.dart';
import 'package:nova_ai/services/ai_service.dart';
import 'package:nova_ai/providers/companion_provider.dart';
import 'package:nova_ai/services/plugins/ai_brain_plugin.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;
  final String mood;
  final bool justLeveledUp;

  ChatState({
    required this.messages,
    this.isTyping = false,
    this.error,
    this.mood = '😊 Happy',
    this.justLeveledUp = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
    String? mood,
    bool? justLeveledUp,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error,
      mood: mood ?? this.mood,
      justLeveledUp: justLeveledUp ?? false,
    );
  }
}

class ChatNotifier extends Notifier<Map<String, ChatState>> {
  final Map<String, AIService> _aiServices = {};

  @override
  Map<String, ChatState> build() {
    return {};
  }

  ChatState _getChatState(Companion companion) {
    if (!state.containsKey(companion.id)) {
      return ChatState(
        messages: [
          ChatMessage(
            id: 'init_${companion.id}',
            text: 'Hello! I am ${companion.name}. Welcome to our shared universe. What is on your mind today? ✨',
            isUser: false,
            timestamp: DateTime.now(),
          )
        ],
        mood: _getInitialMood(companion),
      );
    }
    return state[companion.id]!;
  }

  String _getInitialMood(Companion comp) {
    if (comp.tags.contains('Romantic')) return '💖 Affectionate';
    if (comp.tags.contains('Mentors')) return '💭 Thoughtful';
    if (comp.tags.contains('Gaming')) return '🎮 Playful';
    if (comp.tags.contains('Fitness')) return '🔥 Motivated';
    return '😊 Happy';
  }

  void _updateChatState(String companionId, ChatState newState) {
    state = {
      ...state,
      companionId: newState,
    };
  }

  void clearLevelUpFlag(String companionId) {
    if (state.containsKey(companionId)) {
      _updateChatState(companionId, state[companionId]!.copyWith(justLeveledUp: false));
    }
  }

  void toggleBookmark(String companionId, String messageId) {
    if (!state.containsKey(companionId)) return;
    final currentState = state[companionId]!;
    final updatedMessages = currentState.messages.map((m) {
      if (m.id == messageId) {
        return m.copyWith(isBookmarked: !m.isBookmarked);
      }
      return m;
    }).toList();
    _updateChatState(companionId, currentState.copyWith(messages: updatedMessages));
  }

  void togglePin(String companionId, String messageId) {
    if (!state.containsKey(companionId)) return;
    final currentState = state[companionId]!;
    final updatedMessages = currentState.messages.map((m) {
      if (m.id == messageId) {
        return m.copyWith(isPinned: !m.isPinned);
      }
      return m;
    }).toList();
    _updateChatState(companionId, currentState.copyWith(messages: updatedMessages));
  }

  void setReaction(String companionId, String messageId, String? reactionEmoji) {
    if (!state.containsKey(companionId)) return;
    final currentState = state[companionId]!;
    final updatedMessages = currentState.messages.map((m) {
      if (m.id == messageId) {
        if (m.reaction == reactionEmoji) {
          return m.copyWith(clearReaction: true);
        }
        return m.copyWith(reaction: reactionEmoji);
      }
      return m;
    }).toList();
    _updateChatState(companionId, currentState.copyWith(messages: updatedMessages));
  }

  Future<void> sendMessageStream(
    Companion companion,
    String text,
    String? apiKey, {
    String? replyToText,
    bool asVoiceNote = false,
  }) async {
    if (text.trim().isEmpty) return;

    final currentState = _getChatState(companion);

    // 1. Add user message
    final userMsg = ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      replyToMessageText: replyToText,
      hasVoiceWaveform: asVoiceNote,
    );

    // Dynamic mood shift
    String updatedMood = currentState.mood;
    final lower = text.toLowerCase();
    if (lower.contains('love') || lower.contains('heart') || lower.contains('sweet')) {
      updatedMood = '💖 Affectionate';
    } else if (lower.contains('why') || lower.contains('how') || lower.contains('think')) {
      updatedMood = '💭 Thoughtful';
    } else if (lower.contains('game') || lower.contains('fun') || lower.contains('play')) {
      updatedMood = '✨ Playful';
    } else if (lower.contains('workout') || lower.contains('goal') || lower.contains('gym')) {
      updatedMood = '🔥 Motivated';
    }

    // 2. Create placeholder AI message
    final aiMsgId = 'ai_${DateTime.now().millisecondsSinceEpoch}';
    final placeholderAiMsg = ChatMessage(
      id: aiMsgId,
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      isStreaming: true,
    );

    _updateChatState(companion.id, currentState.copyWith(
      messages: [placeholderAiMsg, userMsg, ...currentState.messages],
      isTyping: true,
      error: null,
      mood: updatedMood,
    ));

    final effectiveKey = (apiKey != null && apiKey.trim().isNotEmpty)
        ? apiKey.trim()
        : 'PROTOTYPE_SIMULATED_MODE';

    try {
      if (!_aiServices.containsKey(companion.id) || _aiServices[companion.id]!.apiKey != effectiveKey) {
        _aiServices[companion.id] = AIService(apiKey: effectiveKey, companion: companion);
      }

      // Check modular AI Brain plugins for autonomous telemetry injection
      final pluginTelemetry = await PluginRegistry().executeMatchingPlugin(text);
      final enrichedPrompt = pluginTelemetry != null
          ? '$text\n\n[SYSTEM INJECTION: The following real-time telemetry was retrieved by your modular AI Brain tool plugin: "$pluginTelemetry". Synthesize this naturally into your conversational response as ${companion.name}.]'
          : text;

      final stream = _aiServices[companion.id]!.sendMessageStream(enrichedPrompt);
      String accumulatedText = '';

      await for (final chunk in stream) {
        accumulatedText += chunk;
        final currentMsgs = _getChatState(companion).messages;
        final updatedMsgs = currentMsgs.map((m) {
          if (m.id == aiMsgId) {
            return m.copyWith(text: accumulatedText, isStreaming: true);
          }
          return m;
        }).toList();

        _updateChatState(companion.id, _getChatState(companion).copyWith(
          messages: updatedMsgs,
          isTyping: true,
        ));
      }

      // Finish streaming
      final finalMsgs = _getChatState(companion).messages.map((m) {
        if (m.id == aiMsgId) {
          return m.copyWith(isStreaming: false);
        }
        return m;
      }).toList();

      // Evolve dynamic personality, humor, relationship stage, and journal entries
      ref.read(companionsProvider.notifier).evolveCompanion(companion.id, text);
      final leveledUp = ref.read(companionsProvider.notifier).addXp(companion.id, 25);

      _updateChatState(companion.id, _getChatState(companion).copyWith(
        messages: finalMsgs,
        isTyping: false,
        justLeveledUp: leveledUp,
      ));
    } catch (e) {
      final finalMsgs = _getChatState(companion).messages.map((m) {
        if (m.id == aiMsgId) {
          return m.copyWith(
            text: 'I lost connection to the astral data stream. Check API settings! ($e)',
            isStreaming: false,
          );
        }
        return m;
      }).toList();

      _updateChatState(companion.id, _getChatState(companion).copyWith(
        messages: finalMsgs,
        isTyping: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> regenerateLastResponse(Companion companion, String? apiKey) async {
    final currentState = _getChatState(companion);
    if (currentState.messages.isEmpty) return;

    // Find last user message
    ChatMessage? lastUserMsg;
    for (final msg in currentState.messages) {
      if (msg.isUser) {
        lastUserMsg = msg;
        break;
      }
    }

    if (lastUserMsg == null) return;

    // Remove any AI messages after the last user message
    final lastUserIndex = currentState.messages.indexOf(lastUserMsg);
    final trimmedMessages = currentState.messages.sublist(lastUserIndex);

    _updateChatState(companion.id, currentState.copyWith(messages: trimmedMessages));

    await sendMessageStream(companion, lastUserMsg.text, apiKey);
  }

  // Legacy method fallback
  Future<void> sendMessage(Companion companion, String text, String? apiKey) async {
    await sendMessageStream(companion, text, apiKey);
  }
}

final chatProvider = NotifierProvider<ChatNotifier, Map<String, ChatState>>(() {
  return ChatNotifier();
});
