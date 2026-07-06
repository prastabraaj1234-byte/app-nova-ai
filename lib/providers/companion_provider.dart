import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/repositories/companion_repository.dart';
import 'package:nova_ai/services/personality_engine.dart';

final companionRepositoryProvider = Provider<CompanionRepository>((ref) {
  return CompanionRepository();
});

class CompanionsNotifier extends AsyncNotifier<List<Companion>> {
  @override
  Future<List<Companion>> build() async {
    final repository = ref.watch(companionRepositoryProvider);
    return repository.getCompanions();
  }

  void addCustomCompanion(Companion newCompanion) {
    if (state.hasValue) {
      final currentList = state.value!;
      state = AsyncData([...currentList, newCompanion]);
    }
  }

  void updateCompanion(Companion updated) {
    if (state.hasValue) {
      final currentList = state.value!;
      state = AsyncData(currentList.map((c) => c.id == updated.id ? updated : c).toList());
    }
  }

  void evolveCompanion(String companionId, String userMessage) {
    if (!state.hasValue) return;
    final currentList = state.value!;
    final updatedList = currentList.map((c) {
      if (c.id == companionId) {
        return PersonalityEngine.evolveAfterMessage(c, userMessage);
      }
      return c;
    }).toList();
    state = AsyncData(updatedList);
  }

  bool addXp(String companionId, int xpGain) {
    if (!state.hasValue) return false;
    final currentList = state.value!;
    bool leveledUp = false;

    final updatedList = currentList.map((c) {
      if (c.id == companionId) {
        int newXp = c.currentXp + xpGain;
        int newLevel = c.relationshipLevel;
        int newXpTarget = c.xpToNextLevel;

        if (newXp >= newXpTarget) {
          newXp = newXp - newXpTarget;
          newLevel += 1;
          newXpTarget = (newXpTarget * 1.5).round();
          leveledUp = true;
        }

        return c.copyWith(
          currentXp: newXp,
          relationshipLevel: newLevel,
          xpToNextLevel: newXpTarget,
        );
      }
      return c;
    }).toList();

    state = AsyncData(updatedList);
    return leveledUp;
  }
}

final companionsProvider = AsyncNotifierProvider<CompanionsNotifier, List<Companion>>(() {
  return CompanionsNotifier();
});

