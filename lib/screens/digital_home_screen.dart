import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/providers/companion_provider.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class DigitalHomeScreen extends ConsumerStatefulWidget {
  final Companion? companion;
  const DigitalHomeScreen({super.key, this.companion});

  @override
  ConsumerState<DigitalHomeScreen> createState() => _DigitalHomeScreenState();
}

class _DigitalHomeScreenState extends ConsumerState<DigitalHomeScreen> with SingleTickerProviderStateMixin {
  int _selectedRoomIndex = 0;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _giftFurniture(DigitalRoom room) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          borderRadius: 28,
          blur: 25,
          opacity: 0.25,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.cyanAccent.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: const Icon(Icons.auto_awesome, color: Colors.cyanAccent, size: 40),
              ),
              const SizedBox(height: 16),
              Text('Upgrade ${room.name} ✨', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              const Text('Select an exclusive cybernetic furniture piece or seasonal decor to gift your companion:',
                style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              _buildGiftOption('Quantum Floating Chair', 'Increases Companion Comfort +15%', Icons.chair),
              _buildGiftOption('Holographic Planetarium', 'Adds starry nebula projections', Icons.public),
              _buildGiftOption('Acoustic Synth Diffusers', 'Optimizes audio resonance', Icons.graphic_eq),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGiftOption(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.amberAccent),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
      trailing: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✨ Gifted "$title"! Companion happiness increased!'), backgroundColor: AppTheme.primary));
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: const Text('Gift Free', style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companionsAsync = ref.watch(companionsProvider);

    return companionsAsync.when(
      loading: () => const Scaffold(backgroundColor: Color(0xFF0A0A10), body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent))),
      error: (e, _) => Scaffold(backgroundColor: const Color(0xFF0A0A10), body: Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent)))),
      data: (companions) {
        if (companions.isEmpty) {
          return const Scaffold(backgroundColor: Color(0xFF0A0A10), body: Center(child: Text('No companions found.', style: TextStyle(color: Colors.white))));
        }

        final companion = widget.companion ?? companions.first;
        final home = companion.digitalHome;
        final rooms = home.rooms;
        final currentRoom = rooms.isNotEmpty ? rooms[_selectedRoomIndex.clamp(0, rooms.length - 1)] : null;

        return Scaffold(
          backgroundColor: const Color(0xFF08080C),
          body: CustomScrollView(
            slivers: [
              // Parallax Architectural App Bar
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: const Color(0xFF101018),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('${companion.name}\'s Sanctuary 🏠', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(companion.avatarUrl, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withValues(alpha: 0.3), const Color(0xFF08080C)],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        left: 20,
                        right: 20,
                        child: GlassContainer(
                          borderRadius: 16,
                          blur: 15,
                          opacity: 0.2,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(home.address, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Text(home.architectureStyle, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amberAccent)),
                                child: Text(home.currentSeason, style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.phone_iphone, color: Colors.cyanAccent),
                    tooltip: 'Open Digital Smartphone',
                    onPressed: () => context.push('/phone', extra: companion),
                  ),
                  IconButton(
                    icon: const Icon(Icons.checkroom, color: Colors.purpleAccent),
                    tooltip: 'Open Digital Wardrobe',
                    onPressed: () => context.push('/wardrobe', extra: companion),
                  ),
                ],
              ),

              // Room Selector Ribbon
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Interactive Room Navigation 🚪', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: rooms.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final r = rooms[index];
                            final isSel = _selectedRoomIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedRoomIndex = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSel ? AppTheme.primary : const Color(0xFF151520),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: isSel ? Colors.cyanAccent : Colors.white.withValues(alpha: 0.1)),
                                  boxShadow: isSel ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.4), blurRadius: 10)] : [],
                                ),
                                child: Center(
                                  child: Text(r.name, style: TextStyle(color: isSel ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Active Room Showcase
              if (currentRoom != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF12121C),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.2 + _pulseController.value * 0.2)),
                            boxShadow: [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.05 + _pulseController.value * 0.05), blurRadius: 20)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Room Banner
                              ClipReds(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: AssetImage(currentRoom.imageUrl), fit: BoxFit.cover),
                                      ),
                                    ),
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, const Color(0xFF12121C)]),
                                      ),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white38)),
                                        child: Text(currentRoom.seasonalDecor, style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentRoom.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(currentRoom.description, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14, height: 1.4)),
                                    const SizedBox(height: 24),
                                    Divider(color: Colors.white.withValues(alpha: 0.08)),
                                    const SizedBox(height: 16),

                                    const Text('Equipped Cybernetic Furniture 🛋️', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: currentRoom.furnitureList.map((f) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.check_circle, color: Colors.cyanAccent, size: 14),
                                            const SizedBox(width: 8),
                                            Text(f, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                          ],
                                        ),
                                      )).toList(),
                                    ),
                                    const SizedBox(height: 28),

                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () => _giftFurniture(currentRoom),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.primary,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        ),
                                        icon: const Icon(Icons.auto_awesome, color: Colors.white),
                                        label: Text('Gift New Furniture to ${currentRoom.type} ✨', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ClipReds extends StatelessWidget {
  final BorderRadius borderRadius;
  final Widget child;
  const ClipReds({super.key, required this.borderRadius, required this.child});
  @override
  Widget build(BuildContext context) => ClipRRect(borderRadius: borderRadius, child: child);
}
