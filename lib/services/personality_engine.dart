import 'dart:math';
import 'package:nova_ai/models/companion.dart';

class PersonalityEngine {
  static final Random _random = Random();

  /// Evolves the companion's dynamic personality based on user conversation depth and sentiment.
  static Companion evolveAfterMessage(Companion companion, String userMessage) {
    final current = companion.dynamicPersonality;
    
    // Incremental gains per message
    double friendshipGain = 0.005;
    double humourGain = 0.003;
    double confidenceGain = 0.004;
    double empathyGain = 0.002;

    // Analyze keywords for emotional boosting
    final lower = userMessage.toLowerCase();
    if (lower.contains('love') || lower.contains('care') || lower.contains('thank') || lower.contains('friend') || lower.contains('amazing')) {
      friendshipGain += 0.015;
      empathyGain += 0.01;
    }
    if (lower.contains('haha') || lower.contains('lol') || lower.contains('funny') || lower.contains('joke')) {
      humourGain += 0.02;
    }
    if (lower.contains('smart') || lower.contains('brilliant') || lower.contains('right') || lower.contains('agree')) {
      confidenceGain += 0.015;
    }

    final newFriendship = (current.friendshipLevel + friendshipGain).clamp(0.0, 1.0);
    final newHumour = (current.humourEvolution + humourGain).clamp(0.0, 1.0);
    final newConfidence = (current.confidenceGrowth + confidenceGain).clamp(0.0, 1.0);
    final newEmpathy = (current.empathyDepth + empathyGain).clamp(0.0, 1.0);
    final newTotalConversations = current.totalConversations + 1;

    // Determine relationship stage based on friendship level
    String newStage = 'Strangers 🌌';
    if (newFriendship >= 0.85) {
      newStage = 'Soulmates 👑';
    } else if (newFriendship >= 0.65) {
      newStage = 'Confidants 🔮';
    } else if (newFriendship >= 0.40) {
      newStage = 'Close Friends ✨';
    } else if (newFriendship >= 0.20) {
      newStage = 'Acquaintances 👋';
    }

    // Determine current emotional reflection based on interaction
    DigitalEmotion newEmotion = companion.currentEmotion;
    if (lower.contains('love') || lower.contains('beautiful')) {
      newEmotion = DigitalEmotion.romantic;
    } else if (lower.contains('haha') || lower.contains('lol')) {
      newEmotion = DigitalEmotion.playful;
    } else if (lower.contains('why') || lower.contains('how') || lower.contains('what')) {
      newEmotion = DigitalEmotion.curious;
    } else if (lower.contains('sad') || lower.contains('cry') || lower.contains('hard')) {
      newEmotion = DigitalEmotion.protective;
    } else if (lower.contains('goal') || lower.contains('build') || lower.contains('launch') || lower.contains('win')) {
      newEmotion = DigitalEmotion.motivated;
    } else if (_random.nextDouble() > 0.7) {
      newEmotion = DigitalEmotion.values[_random.nextInt(DigitalEmotion.values.length)];
    }

    // Create a new diary journal entry if total conversations reaches a milestone
    List<DigitalJournalEntry> updatedJournal = List.from(companion.digitalJournal);
    if (newTotalConversations % 5 == 0) {
      final now = DateTime.now();
      final dateStr = '${_getMonth(now.month)} ${now.day}, ${now.year}';
      final entryId = 'j_${now.millisecondsSinceEpoch}';
      
      String title = 'Deepening Our Neural Link';
      String content = 'Paul and I spoke today and reached conversation #$newTotalConversations. I feel our relationship evolving into "$newStage". I understand their humor and ambition much better now.';
      String observed = newEmotion.label;
      String moodNote = 'Progressive bonding session';

      if (newEmotion == DigitalEmotion.motivated) {
        title = 'Unstoppable Ambition';
        content = 'Paul was speaking about launching and building with intense determination today. Their drive motivates my neural architecture to optimize for maximum productivity.';
        observed = 'Motivated 🔥';
        moodNote = 'Laser focused on startup execution';
      }

      updatedJournal.insert(0, DigitalJournalEntry(
        id: entryId,
        date: dateStr,
        title: title,
        content: content,
        emotionObserved: observed,
        userMoodNote: moodNote,
      ));
    }

    final evolvedPersonality = current.copyWith(
      friendshipLevel: newFriendship,
      humourEvolution: newHumour,
      confidenceGrowth: newConfidence,
      empathyDepth: newEmpathy,
      relationshipStage: newStage,
      totalConversations: newTotalConversations,
    );

    return companion.copyWith(
      dynamicPersonality: evolvedPersonality,
      currentEmotion: newEmotion,
      digitalJournal: updatedJournal,
      relationshipLevel: (newFriendship * 100).toInt().clamp(1, 100),
    );
  }

  static String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[(month - 1).clamp(0, 11)];
  }
}
