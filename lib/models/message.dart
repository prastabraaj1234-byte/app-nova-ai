class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isStreaming;
  final String? reaction;
  final bool isBookmarked;
  final bool isPinned;
  final String? replyToMessageText;
  final bool hasVoiceWaveform;
  final String? generatedImageUrl;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isStreaming = false,
    this.reaction,
    this.isBookmarked = false,
    this.isPinned = false,
    this.replyToMessageText,
    this.hasVoiceWaveform = false,
    this.generatedImageUrl,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isStreaming,
    String? reaction,
    bool? isBookmarked,
    bool? isPinned,
    String? replyToMessageText,
    bool? hasVoiceWaveform,
    String? generatedImageUrl,
    bool clearReaction = false,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isStreaming: isStreaming ?? this.isStreaming,
      reaction: clearReaction ? null : (reaction ?? this.reaction),
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isPinned: isPinned ?? this.isPinned,
      replyToMessageText: replyToMessageText ?? this.replyToMessageText,
      hasVoiceWaveform: hasVoiceWaveform ?? this.hasVoiceWaveform,
      generatedImageUrl: generatedImageUrl ?? this.generatedImageUrl,
    );
  }
}
