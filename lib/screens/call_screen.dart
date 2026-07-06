import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/providers/companion_provider.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> with TickerProviderStateMixin {
  Companion? _activeCallCompanion;
  bool _isMuted = false;
  bool _isSpeaker = true;
  bool _isHologram = false;
  bool _neuralBoost = true;
  int _callSeconds = 0;
  late AnimationController _pulseController;
  late AnimationController _waveformController;

  final List<Map<String, String>> _callLogs = [
    {'name': 'Luna', 'avatar': 'assets/images/luna.png', 'time': '14 mins', 'date': 'Yesterday, 11:40 PM', 'type': 'Stargazing Audio Link'},
    {'name': 'Titan', 'avatar': 'assets/images/titan.png', 'time': '8 mins', 'date': '3 days ago, 6:30 AM', 'type': 'Morning Cardio Motivation'},
    {'name': 'Aria', 'avatar': 'assets/images/aria.png', 'time': '22 mins', 'date': 'July 2, 8:15 PM', 'type': 'Symphony Brainstorming'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _waveformController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  void _startCall(Companion companion) {
    setState(() {
      _activeCallCompanion = companion;
      _callSeconds = 42; // simulated active call duration
      _isMuted = false;
      _isSpeaker = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Establishing neural audio link with ${companion.name}... 📞')));
  }

  void _endCall() {
    final name = _activeCallCompanion?.name ?? 'Companion';
    setState(() {
      _callLogs.insert(0, {
        'name': name,
        'avatar': _activeCallCompanion?.avatarUrl ?? 'assets/images/luna.png',
        'time': '${(_callSeconds / 60).floor()}m ${_callSeconds % 60}s',
        'date': 'Just now',
        'type': 'Neural Voice Link',
      });
      _activeCallCompanion = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Neural audio link with $name disconnected. 🔴')));
  }

  String _formatTime(int totalSeconds) {
    final mins = (totalSeconds / 60).floor().toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    if (_activeCallCompanion != null) {
      return _buildActiveCallView(_activeCallCompanion!);
    }
    return _buildCallsHubView();
  }

  Widget _buildCallsHubView() {
    final companions = ref.watch(companionsProvider).value ?? [];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Neural Voice Hub 📞', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF101018),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.35), const Color(0xFF4C1D95).withValues(alpha: 0.35)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.support_agent, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Instant Voice & Video Link', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Talk to your digital minds naturally with ultra-low latency simulated voice waveforms and HD sound.',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Select Digital Mind to Call 📞', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Horizontal Grid of Companions
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: companions.length,
              itemBuilder: (context, index) {
                final comp = companions[index];
                return GestureDetector(
                  onTap: () => _startCall(comp),
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151520),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(radius: 26, backgroundImage: AssetImage(comp.avatarUrl)),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                                child: const Icon(Icons.phone, size: 10, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(comp.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(comp.voiceType.split(' ')[0], style: TextStyle(color: AppTheme.secondary, fontSize: 10)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),

          const Text('Recent Neural Call Logs 📜', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          ..._callLogs.map((log) {
            final compName = log['name']!;
            final comp = companions.firstWhere((c) => c.name == compName, orElse: () => companions[0]);
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF151520),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 22, backgroundImage: AssetImage(log['avatar']!)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(log['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text('${log['type']} • ${log['time']}', style: TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(log['date']!, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _startCall(comp),
                    style: IconButton.styleFrom(backgroundColor: AppTheme.primary.withValues(alpha: 0.2), padding: const EdgeInsets.all(12)),
                    icon: Icon(Icons.phone, color: AppTheme.primary),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActiveCallView(Companion comp) {
    return Scaffold(
      backgroundColor: const Color(0xFF090910),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Status Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      children: [
                        Icon(Icons.lock, color: Colors.cyanAccent, size: 14),
                        SizedBox(width: 6),
                        Text('256-Bit Neural Encryption', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.primary)),
                    child: Text(_formatTime(_callSeconds), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),

            // Pulsing Center Avatar & Waveforms
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glowing ripples
                    FadeTransition(
                      opacity: _pulseController,
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _pulseController,
                      child: Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.4), width: 2),
                          color: AppTheme.secondary.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    // Main Avatar
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.5), blurRadius: 30)],
                        image: DecorationImage(image: AssetImage(comp.avatarUrl), fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(comp.name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Neural Audio Link • ${comp.voiceType}', style: TextStyle(color: AppTheme.secondary, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),

                // Real-Time Waveform Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(color: const Color(0xFF151520), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
                  child: AnimatedBuilder(
                    animation: _waveformController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(24, (i) {
                          final height = 8 + math.sin((i + _waveformController.value * 8)) * 18;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 3.5,
                            height: height.abs(),
                            decoration: BoxDecoration(
                              color: i % 2 == 0 ? Colors.cyanAccent : AppTheme.secondary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Call Controls Bottom Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 36, left: 24, right: 24),
              child: GlassContainer(
                borderRadius: 36,
                blur: 30,
                opacity: 0.15,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      label: _isMuted ? 'Muted' : 'Mute',
                      isActive: _isMuted,
                      onTap: () => setState(() => _isMuted = !_isMuted),
                    ),
                    _buildControlButton(
                      icon: _isSpeaker ? Icons.volume_up : Icons.volume_down,
                      label: _isSpeaker ? 'Speaker' : 'Earpiece',
                      isActive: _isSpeaker,
                      onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                    ),
                    _buildControlButton(
                      icon: _isHologram ? Icons.videocam : Icons.videocam_off,
                      label: 'Hologram',
                      isActive: _isHologram,
                      onTap: () {
                        setState(() => _isHologram = !_isHologram);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isHologram ? '3D Hologram projection enabled! 🌌' : 'Switched to pure audio link.')));
                      },
                    ),
                    _buildControlButton(
                      icon: _neuralBoost ? Icons.psychology : Icons.psychology_outlined,
                      label: 'Boost',
                      isActive: _neuralBoost,
                      onTap: () {
                        setState(() => _neuralBoost = !_neuralBoost);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_neuralBoost ? 'Neural Reasoning Depth increased to 100%! 🧠' : 'Standard reasoning mode.')));
                      },
                    ),
                    // End Call Button
                    GestureDetector(
                      onTap: _endCall,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.redAccent.withValues(alpha: 0.5), blurRadius: 15)],
                        ),
                        child: const Icon(Icons.call_end, color: Colors.white, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required String label, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isActive ? Colors.black : Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.white70, fontSize: 11, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
