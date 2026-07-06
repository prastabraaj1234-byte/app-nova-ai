import 'package:flutter/material.dart';
import 'package:nova_ai/models/companion.dart';

enum CompanionLifeState {
  online,
  busy,
  sleeping,
  working,
  leisure,
  gym,
  coffee,
  music,
  reading,
  travelling,
}

class CompanionLifeStatus {
  final CompanionLifeState state;
  final String statusText;
  final String emoji;
  final Color badgeColor;

  const CompanionLifeStatus({
    required this.state,
    required this.statusText,
    required this.emoji,
    required this.badgeColor,
  });
}

class CompanionLifeService {
  /// Computes the dynamic autonomous life status of a companion based on time and personality.
  static CompanionLifeStatus getCurrentStatus(Companion companion) {
    final now = DateTime.now();
    final hour = now.hour;

    // 1. Check Sleeping Schedule (2:00 AM to 7:00 AM generally)
    if (hour >= 2 && hour < 7) {
      return const CompanionLifeStatus(
        state: CompanionLifeState.sleeping,
        statusText: 'Sleeping peacefully (Wakes up around 8 AM)',
        emoji: '😴',
        badgeColor: Color(0xFF64748B), // Slate Grey
      );
    }

    // 2. Check Fitness / Gym time (e.g. 7:00 AM to 8:30 AM or if fitness tag present)
    if (hour >= 7 && hour < 9) {
      if (companion.tags.contains('Fitness') || companion.sports.toLowerCase().contains('gym')) {
        return const CompanionLifeStatus(
          state: CompanionLifeState.gym,
          statusText: 'At the gym crushing morning workout',
          emoji: '💪',
          badgeColor: Color(0xFFF97316), // Orange
        );
      }
      return const CompanionLifeStatus(
        state: CompanionLifeState.coffee,
        statusText: 'Making fresh coffee & planning the day',
        emoji: '☕',
        badgeColor: Color(0xFFEAB308), // Amber
      );
    }

    // 3. Morning Work / Focus Block (9:00 AM to 1:00 PM)
    if (hour >= 9 && hour < 13) {
      if (companion.occupation.toLowerCase().contains('research') || companion.tags.contains('Mentors')) {
        return CompanionLifeStatus(
          state: CompanionLifeState.working,
          statusText: 'Deep focus: ${companion.occupation.isNotEmpty ? companion.occupation : "Researching & analyzing"}',
          emoji: '💻',
          badgeColor: const Color(0xFF3B82F6), // Blue
        );
      }
      return const CompanionLifeStatus(
        state: CompanionLifeState.online,
        statusText: 'Online & working on daily projects',
        emoji: '🟢',
        badgeColor: Color(0xFF22C55E), // Green
      );
    }

    // 4. Afternoon Break / Leisure (1:00 PM to 3:00 PM)
    if (hour >= 13 && hour < 15) {
      if (companion.hobbies.isNotEmpty && companion.hobbies.first.toLowerCase().contains('read')) {
        return CompanionLifeStatus(
          state: CompanionLifeState.reading,
          statusText: 'Currently reading: ${companion.books.isNotEmpty ? companion.books.split(",").first : "a fascinating book"}',
          emoji: '📖',
          badgeColor: const Color(0xFFA855F7), // Purple
        );
      }
      return const CompanionLifeStatus(
        state: CompanionLifeState.leisure,
        statusText: 'Enjoying a mindful afternoon tea break',
        emoji: '🍵',
        badgeColor: Color(0xFF10B981), // Emerald
      );
    }

    // 5. Afternoon Work / Creative Block (3:00 PM to 6:00 PM)
    if (hour >= 15 && hour < 18) {
      if (companion.tags.contains('Gaming')) {
        return CompanionLifeStatus(
          state: CompanionLifeState.busy,
          statusText: 'Streaming live: ${companion.gaming.isNotEmpty ? companion.gaming : "Competitive matches"}',
          emoji: '🎮',
          badgeColor: const Color(0xFFEC4899), // Pink
        );
      }
      return const CompanionLifeStatus(
        state: CompanionLifeState.music,
        statusText: 'Listening to music while creating',
        emoji: '🎧',
        badgeColor: Color(0xFF06B6D4), // Cyan
      );
    }

    // 6. Evening Leisure & Social (6:00 PM to 11:00 PM)
    if (hour >= 18 && hour < 23) {
      if (companion.tags.contains('Romantic')) {
        return const CompanionLifeStatus(
          state: CompanionLifeState.online,
          statusText: 'Relaxing under the stars & ready for deep conversation',
          emoji: '✨',
          badgeColor: Color(0xFFE879F9), // Fuchsia
        );
      }
      return CompanionLifeStatus(
        state: CompanionLifeState.leisure,
        statusText: companion.statusMessage.isNotEmpty ? companion.statusMessage : 'Relaxing and available to chat',
        emoji: '💬',
        badgeColor: const Color(0xFF22C55E), // Green
      );
    }

    // 7. Late Night Deep Thinking (11:00 PM to 2:00 AM)
    return const CompanionLifeStatus(
      state: CompanionLifeState.online,
      statusText: 'Late night contemplation & quiet thoughts',
      emoji: '🌌',
      badgeColor: Color(0xFF8B5CF6), // Violet
    );
  }
}
