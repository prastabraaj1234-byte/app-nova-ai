import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/models/message.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/providers/chat_provider.dart';
import 'package:nova_ai/providers/api_key_provider.dart';
import 'package:nova_ai/providers/companion_provider.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Companion companion;

  const ChatScreen({super.key, required this.companion});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<String> _icebreakers;
  String? _replyingToText;
  bool _isRecordingVoice = false;
  int _voiceRecordSeconds = 0;
  late AnimationController _pulseController;
  late AnimationController _waveformController;

  final List<String> _reactionEmojis = ['❤️', '🔥', '👏', '😂', '🌟', '💜', '🧠'];

  @override
  void initState() {
    super.initState();
    _icebreakers = _generateIcebreakers(widget.companion);
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _waveformController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
  }

  List<String> _generateIcebreakers(Companion comp) {
    if (comp.tags.contains('Romantic')) {
      return ['What is your dream date? 🌌', 'Tell me a secret...', 'Do you believe in soulmates? 💕'];
    } else if (comp.tags.contains('Fitness')) {
      return ['Give me a 5-min workout challenge! 🏋️‍♂️', 'How do I stay consistent?', 'What should I eat post-workout?'];
    } else if (comp.tags.contains('Mentors')) {
      return ['What is the meaning of true success?', 'Recommend a life-changing book 📚', 'How do I overcome procrastination?'];
    } else if (comp.tags.contains('Gaming')) {
      return ['What is the best RPG of all time? 🎮', 'Want to form a co-op team?', 'Tell me a gaming conspiracy!'];
    }
    return ['Tell me a fun fact! ✨', 'How was your day?', 'Let us play a game! 🎲', 'Give me some motivation 💪'];
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveformController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? presetText, bool asVoice = false]) {
    final text = presetText ?? _messageController.text;
    if (text.trim().isEmpty && !asVoice) return;
    
    final apiKey = ref.read(apiKeyProvider);
    final replyText = _replyingToText;

    setState(() {
      _replyingToText = null;
      _isRecordingVoice = false;
      _voiceRecordSeconds = 0;
    });

    ref.read(chatProvider.notifier).sendMessageStream(
      widget.companion,
      asVoice ? '🎙️ Voice Note: "${text.isNotEmpty ? text : "Hello! How are you?"}"' : text,
      apiKey,
      replyToText: replyText,
      asVoiceNote: asVoice,
    );
    
    if (presetText == null && !asVoice) {
      _messageController.clear();
    }
  }

  void _showConversationSummaryModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassContainer(
          borderRadius: 28,
          blur: 25,
          opacity: 0.2,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 44, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(radius: 24, backgroundImage: AssetImage(widget.companion.avatarUrl)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Memory Vault Summary 🧠', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('${widget.companion.name} • ${widget.companion.relationshipType}', style: TextStyle(color: AppTheme.secondary, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF151520),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Core Extracted Insights:', style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                    SizedBox(height: 8),
                    Text('• User values philosophical discussions and stargazing.\n• Shared interest in synthwave beats and sci-fi literature.\n• Relationship established on trust, curiosity, and emotional guidance.',
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          Text('Importance Score', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
                          const SizedBox(height: 4),
                          const Text('9.8 / 10 ✨', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          Text('Emotional Resonance', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
                          const SizedBox(height: 4),
                          Text('High Harmony 💜', style: TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/memory-vault');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                  icon: const Icon(Icons.auto_stories, color: Colors.white),
                  label: const Text('Open Full Memory Vault', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessageOptionsModal(BuildContext context, ChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassContainer(
          borderRadius: 28,
          blur: 25,
          opacity: 0.18,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 44, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Text('React with Emoji', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _reactionEmojis.map((emoji) {
                  final isSelected = message.reaction == emoji;
                  return GestureDetector(
                    onTap: () {
                      ref.read(chatProvider.notifier).setReaction(widget.companion.id, message.id, emoji);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: AppTheme.primary, width: 2) : null,
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.white.withValues(alpha: 0.08)),
              ListTile(
                leading: Icon(Icons.reply, color: AppTheme.secondary),
                title: const Text('Reply to Message', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _replyingToText = message.text);
                },
              ),
              ListTile(
                leading: Icon(message.isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.amberAccent),
                title: Text(message.isBookmarked ? 'Remove Bookmark' : 'Bookmark to Vault', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                onTap: () {
                  ref.read(chatProvider.notifier).toggleBookmark(widget.companion.id, message.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message.isBookmarked ? 'Bookmark removed' : 'Saved to ${widget.companion.name}\'s Vault 🌟'),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
              ),
              ListTile(
                leading: Icon(message.isPinned ? Icons.push_pin : Icons.push_pin_outlined, color: Colors.cyanAccent),
                title: Text(message.isPinned ? 'Unpin Message' : 'Pin to Top of Chat', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                onTap: () {
                  ref.read(chatProvider.notifier).togglePin(widget.companion.id, message.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message.isPinned ? 'Unpinned message' : 'Pinned to top! 📌'),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_all, color: Colors.white70),
                title: const Text('Copy Text', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.text));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard 📋'), behavior: SnackBarBehavior.floating));
                },
              ),
              if (!message.isUser)
                ListTile(
                  leading: Icon(Icons.refresh, color: AppTheme.primary),
                  title: const Text('Regenerate Response', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context);
                    final apiKey = ref.read(apiKeyProvider);
                    ref.read(chatProvider.notifier).regenerateLastResponse(widget.companion, apiKey);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Map<String, ChatState>>(chatProvider, (previous, next) {
      final state = next[widget.companion.id];
      if (state != null && state.justLeveledUp) {
        ref.read(chatProvider.notifier).clearLevelUpFlag(widget.companion.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '🎉 LEVEL UP! You and ${widget.companion.name} reached Level ${widget.companion.relationshipLevel}!',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });

    final chatStateMap = ref.watch(chatProvider);
    final chatState = chatStateMap[widget.companion.id] ?? ChatState(messages: [
      ChatMessage(
        id: 'init_${widget.companion.id}',
        text: 'Hello! I am ${widget.companion.name}. Welcome to our shared universe. What is on your mind today? ✨',
        isUser: false,
        timestamp: DateTime.now(),
      )
    ]);
    
    final messages = chatState.messages;
    final isTyping = chatState.isTyping;
    final error = chatState.error;
    final mood = chatState.mood;

    final companionsList = ref.watch(companionsProvider).value ?? [];
    final liveComp = companionsList.firstWhere((c) => c.id == widget.companion.id, orElse: () => widget.companion);
    final xpProgress = (liveComp.currentXp / (liveComp.xpToNextLevel == 0 ? 1 : liveComp.xpToNextLevel)).clamp(0.0, 1.0);

    // Check if any message is pinned
    ChatMessage? pinnedMsg;
    for (final m in messages) {
      if (m.isPinned) {
        pinnedMsg = m;
        break;
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF101018).withValues(alpha: 0.95),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        title: Row(
          children: [
            Hero(
              tag: 'avatar_${widget.companion.id}',
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.companion.avatarUrl),
                    radius: 20,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF101018), width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.companion.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Row(
                    children: [
                      Text(
                        mood,
                        style: TextStyle(fontSize: 12, color: AppTheme.secondary, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      Text('• ${liveComp.relationshipType}', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.other_houses, color: Colors.cyanAccent),
            tooltip: 'Visit Penthouse',
            onPressed: () => context.push('/digital-home', extra: widget.companion),
          ),
          IconButton(
            icon: const Icon(Icons.phone_iphone, color: Colors.amberAccent),
            tooltip: 'Companion Smartphone',
            onPressed: () => context.push('/phone', extra: widget.companion),
          ),
          IconButton(
            icon: const Icon(Icons.auto_stories, color: Colors.purpleAccent),
            tooltip: 'Conversation Summary',
            onPressed: _showConversationSummaryModal,
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            tooltip: 'Voice Call',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Initiating simulated neural link call with ${widget.companion.name}... 📞')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // XP & Level Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF151520),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, size: 16, color: AppTheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Level ${liveComp.relationshipLevel}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.secondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: xpProgress,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${liveComp.currentXp}/${liveComp.xpToNextLevel} XP',
                  style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Pinned Message Banner
          if (pinnedMsg != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withValues(alpha: 0.1),
                border: Border(bottom: BorderSide(color: Colors.cyanAccent.withValues(alpha: 0.3))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.push_pin, color: Colors.cyanAccent, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pinned: "${pinnedMsg.text}"',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref.read(chatProvider.notifier).togglePin(widget.companion.id, pinnedMsg!.id),
                    child: const Icon(Icons.close, color: Colors.white54, size: 16),
                  ),
                ],
              ),
            ),

          if (error != null)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.redAccent.withValues(alpha: 0.8),
              width: double.infinity,
              child: Text(
                error,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

          // Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (isTyping && messages.isEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && messages.isEmpty && index == 0) {
                  return _buildTypingIndicator();
                }

                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Suggested Icebreakers
          if (messages.length <= 3)
            Container(
              height: 44,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _icebreakers.length,
                itemBuilder: (context, index) {
                  final text = _icebreakers[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(text, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                      backgroundColor: const Color(0xFF1E1E2C),
                      side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onPressed: () => _sendMessage(text),
                    ),
                  );
                },
              ),
            ),

          // Replying Preview Banner
          if (_replyingToText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  Icon(Icons.reply, color: AppTheme.secondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Replying to: "${_replyingToText!}"',
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16, color: Colors.white54),
                    onPressed: () => setState(() => _replyingToText = null),
                  ),
                ],
              ),
            ),

          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(widget.companion.avatarUrl),
            radius: 16,
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.primary),
                ),
                const SizedBox(width: 12),
                Text('${widget.companion.name} is synthesizing thoughts...', style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return GestureDetector(
      onLongPress: () => _showMessageOptionsModal(context, message),
      onDoubleTap: () {
        ref.read(chatProvider.notifier).setReaction(widget.companion.id, message.id, '❤️');
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Row(
          mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isUser) ...[
              CircleAvatar(
                backgroundImage: AssetImage(widget.companion.avatarUrl),
                radius: 16,
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: message.isUser
                          ? LinearGradient(colors: [AppTheme.primary, const Color(0xFF5B21B6)])
                          : null,
                      color: message.isUser ? null : const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(22),
                        topRight: const Radius.circular(22),
                        bottomLeft: Radius.circular(message.isUser ? 22 : 4),
                        bottomRight: Radius.circular(message.isUser ? 4 : 22),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3)),
                      ],
                      border: !message.isUser ? Border.all(color: Colors.white.withValues(alpha: 0.08)) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quoted Reply Preview
                        if (message.replyToMessageText != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border(left: BorderSide(color: AppTheme.secondary, width: 3)),
                            ),
                            child: Text(
                              '${message.replyToMessageText}',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, fontStyle: FontStyle.italic),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        // Voice Waveform Player
                        if (message.hasVoiceWaveform)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.play_circle_fill, color: Colors.cyanAccent, size: 28),
                                const SizedBox(width: 8),
                                AnimatedBuilder(
                                  animation: _waveformController,
                                  builder: (context, child) {
                                    return Row(
                                      children: List.generate(15, (i) {
                                        final height = 6 + math.sin((i + _waveformController.value * 6)) * 12;
                                        return Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                          width: 3,
                                          height: height.abs(),
                                          decoration: BoxDecoration(
                                            color: i < 8 ? Colors.cyanAccent : Colors.white38,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Text('0:14', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),

                        // Main Text & Streaming Cursor
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                message.text.isEmpty && message.isStreaming ? 'Synthesizing...' : message.text,
                                style: TextStyle(fontSize: 15, color: Colors.white, height: 1.4, fontStyle: message.text.isEmpty ? FontStyle.italic : FontStyle.normal),
                              ),
                            ),
                            if (message.isStreaming)
                              FadeTransition(
                                opacity: _pulseController,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  width: 8,
                                  height: 16,
                                  color: AppTheme.secondary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bookmark Ribbon Badge
                  if (message.isBookmarked)
                    Positioned(
                      top: -6,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bookmark, size: 12, color: Colors.black),
                      ),
                    ),

                  // Emoji Reaction Badge
                  if (message.reaction != null)
                    Positioned(
                      bottom: -10,
                      right: message.isUser ? null : 12,
                      left: message.isUser ? 12 : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D44),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4)],
                        ),
                        child: Text(message.reaction!, style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF101018),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: _isRecordingVoice
          ? Row(
              children: [
                const Icon(Icons.mic, color: Colors.redAccent, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _waveformController,
                    builder: (context, child) {
                      return Row(
                        children: [
                          const Text('Recording Neural Voice... 🔴', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                          const Spacer(),
                          Text('00:05', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.bold)),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white54),
                  onPressed: () => setState(() => _isRecordingVoice = false),
                ),
                Container(
                  decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () => _sendMessage('Neural audio transmission recorded.', true),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white54, size: 26),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => GlassContainer(
                        borderRadius: 24,
                        blur: 20,
                        opacity: 0.2,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.image, color: Colors.purpleAccent),
                              title: const Text('Generate Holographic Image', style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Navigator.pop(ctx);
                                _sendMessage('Generate a beautiful cyber-astronomy artwork for our chat! 🎨');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.auto_awesome, color: Colors.amberAccent),
                              title: const Text('Request Life Schedule Update', style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Navigator.pop(ctx);
                                _sendMessage('What is on your schedule right now in our digital universe? 🌌');
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Message ${widget.companion.name}...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFF1A1A28),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic_none, color: Colors.white54, size: 26),
                  onPressed: () => setState(() => _isRecordingVoice = true),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.4), blurRadius: 8)],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
    );
  }
}
