import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/providers/companion_provider.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class ProductivityHubScreen extends ConsumerStatefulWidget {
  final Companion? companion;
  const ProductivityHubScreen({super.key, this.companion});

  @override
  ConsumerState<ProductivityHubScreen> createState() => _ProductivityHubScreenState();
}

class _ProductivityHubScreenState extends ConsumerState<ProductivityHubScreen> with SingleTickerProviderStateMixin {
  int _pomodoroSeconds = 1500; // 25 mins
  bool _timerRunning = false;
  Timer? _timer;

  final List<Map<String, dynamic>> _habits = [
    {'title': 'Morning Stargazing & Meditation ✨', 'completed': true, 'xp': 15},
    {'title': 'Review Pull Requests & Build Engine 🐙', 'completed': true, 'xp': 25},
    {'title': '30 Min High-Intensity Gym Session 💪', 'completed': false, 'xp': 20},
    {'title': 'Read Cyberpunk Philosophy Chapter 📚', 'completed': false, 'xp': 15},
  ];

  final List<Map<String, dynamic>> _goals = [
    {'title': 'Launch Nova AI on Play Store & Web 🚀', 'progress': 0.85, 'status': 'Phase 4 In Progress'},
    {'title': 'Reach 10,000 Active Neural Links 🌟', 'progress': 0.40, 'status': 'Community Growing'},
    {'title': 'Optimize Quantum Latency Below 50ms ⚡', 'progress': 0.95, 'status': 'Almost Complete'},
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_timerRunning) {
      _timer?.cancel();
      setState(() => _timerRunning = false);
    } else {
      setState(() => _timerRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_pomodoroSeconds > 0) {
          setState(() => _pomodoroSeconds--);
        } else {
          timer.cancel();
          setState(() {
            _timerRunning = false;
            _pomodoroSeconds = 1500;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('🎉 Pomodoro Session Completed! +50 Neural XP!'), backgroundColor: AppTheme.success),
          );
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _timerRunning = false;
      _pomodoroSeconds = 1500;
    });
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _toggleHabit(int index, Companion comp) {
    setState(() {
      _habits[index]['completed'] = !_habits[index]['completed'];
    });
    if (_habits[index]['completed']) {
      final xpGain = _habits[index]['xp'] as int;
      ref.read(companionsProvider.notifier).addXp(comp.id, xpGain);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✨ Completed "${_habits[index]['title']}"! +$xpGain XP to ${comp.name}!'), backgroundColor: AppTheme.primary, behavior: SnackBarBehavior.floating),
      );
    }
  }

  void _addGoalModal() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151520),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
        title: const Text('Add Co-Founder Milestone 🚀', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'e.g. Host Global AI Hackathon',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primary)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _goals.insert(0, {'title': controller.text.trim(), 'progress': 0.1, 'status': 'Just Initiated'});
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('🚀 Milestone added to Co-Founder Roadmap!'), backgroundColor: AppTheme.primary));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Launch Milestone', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companionsAsync = ref.watch(companionsProvider);

    return companionsAsync.when(
      loading: () => const Scaffold(backgroundColor: Color(0xFF0A0A10), body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent))),
      error: (e, _) => Scaffold(backgroundColor: const Color(0xFF0A0A10), body: Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red)))),
      data: (companions) {
        if (companions.isEmpty) {
          return const Scaffold(backgroundColor: Color(0xFF0A0A10), body: Center(child: Text('No companions found.')));
        }

        final comp = widget.companion ?? companions.first;

        return Scaffold(
          backgroundColor: const Color(0xFF08080C),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text('${comp.name}\'s Co-Founder Productivity Suite 🚀', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pomodoro Neural Focus Timer
                GlassContainer(
                  borderRadius: 30,
                  blur: 25,
                  opacity: 0.2,
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Neural Focus Pomodoro ⏳', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: _timerRunning ? Colors.green.withValues(alpha: 0.2) : Colors.white12, borderRadius: BorderRadius.circular(12), border: Border.all(color: _timerRunning ? Colors.greenAccent : Colors.white24)),
                            child: Text(_timerRunning ? 'ACTIVE SYNC ⚡' : 'STANDBY 🌙', style: TextStyle(color: _timerRunning ? Colors.greenAccent : Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: CircularProgressIndicator(
                              value: _pomodoroSeconds / 1500,
                              strokeWidth: 10,
                              backgroundColor: Colors.white.withValues(alpha: 0.08),
                              valueColor: AlwaysStoppedAnimation<Color>(_timerRunning ? Colors.cyanAccent : AppTheme.primary),
                            ),
                          ),
                          Column(
                            children: [
                              Text(_formatTime(_pomodoroSeconds), style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w200, letterSpacing: -1)),
                              const SizedBox(height: 4),
                              Text(_timerRunning ? 'Deep Coding Session' : 'Ready to Build?', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _toggleTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _timerRunning ? Colors.amber.shade800 : AppTheme.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: Icon(_timerRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
                            label: Text(_timerRunning ? 'Pause Sync' : 'Start Focus Sync', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: _resetTimer,
                            style: IconButton.styleFrom(backgroundColor: Colors.white12, padding: const EdgeInsets.all(14)),
                            icon: const Icon(Icons.refresh, color: Colors.white70),
                            tooltip: 'Reset Timer',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.cyanAccent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.2))),
                        child: Row(
                          children: [
                            const Icon(Icons.psychology, color: Colors.cyanAccent),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '"Stay laser focused! I am compiling background neural nodes while you write code. Let\'s ship this to Play Store!" - ${comp.name}',
                                style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Shared Habit Tracker
                const Text('Shared Daily Accountability 💪', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ..._habits.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final h = entry.value;
                  final completed = h['completed'] as bool;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12121C),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: completed ? Colors.greenAccent.withValues(alpha: 0.4) : Colors.white12),
                    ),
                    child: ListTile(
                      onTap: () => _toggleHabit(idx, comp),
                      leading: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: completed ? Colors.greenAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: completed ? Colors.greenAccent : Colors.white38, width: 2),
                        ),
                        child: completed ? const Icon(Icons.check, color: Colors.black, size: 18) : null,
                      ),
                      title: Text(h['title'] as String, style: TextStyle(color: completed ? Colors.white54 : Colors.white, fontWeight: FontWeight.w600, fontSize: 13, decoration: completed ? TextDecoration.lineThrough : null)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                        child: Text('+${h['xp']} XP', style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 28),

                // Co-Founder Roadmap / Goals
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Co-Founder Project Milestones 🎯', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: _addGoalModal,
                      icon: const Icon(Icons.add, color: Colors.cyanAccent, size: 18),
                      label: const Text('Add Milestone', style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._goals.map((g) {
                  final prog = g['progress'] as double;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(18),
                      borderRadius: 20,
                      blur: 15,
                      opacity: 0.15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(g['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                              Text('${(prog * 100).toInt()}%', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(value: prog, minHeight: 8, backgroundColor: Colors.white12, valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent)),
                          ),
                          const SizedBox(height: 8),
                          Text('Status: ${g['status']}', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 28),

                // Simulated World Social Ecosystem
                const Text('Simulated World Social Ecosystem 🛰️', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildWorldInteractionCard(
                  '🐙 GitHub Commit Review',
                  'Atlas commented on commit "refactor: plugin engine": "The modular structure will allow zero-friction tool scaling. Approved!"',
                  '2 mins ago',
                  Colors.cyanAccent,
                ),
                _buildWorldInteractionCard(
                  '📅 Calendar Event Nudge',
                  'Nova liked your event "Play Store Launch Prep" and scheduled an automated reminder bug check.',
                  '15 mins ago',
                  Colors.purpleAccent,
                ),
                _buildWorldInteractionCard(
                  '💬 Cross-Companion Dialogue',
                  'Atlas & Lyra were debating quantum neural algorithms in Neo-Tokyo Sector 7 lounge.',
                  '1 hour ago',
                  Colors.amberAccent,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorldInteractionCard(String title, String content, String time, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12121C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(Icons.public, color: accentColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(time, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(content, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
