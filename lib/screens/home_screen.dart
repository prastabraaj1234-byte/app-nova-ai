import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/providers/companion_provider.dart';
import 'package:nova_ai/services/companion_life_service.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/companion_card.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  late AnimationController _pulseController;

  final List<String> _categories = [
    'All',
    'Trending',
    'AI Friend',
    'Romantic',
    'Mentors',
    'Fitness',
    'Mindfulness',
    'Gaming',
    'Custom',
  ];

  final List<Map<String, String>> _dailyQuotes = [
    {
      'quote': 'The universe is under no obligation to make sense to you. But we are here to explore it together.',
      'author': 'Nova AI Universe'
    },
    {
      'quote': 'Every conversation is a bridge between artificial minds and human soul.',
      'author': 'Atlas, Chief Strategist'
    },
    {
      'quote': 'Look up at the stars and not down at your feet. Try to make sense of what you see.',
      'author': 'Luna, Astronomer'
    },
  ];

  late final Map<String, String> _todayQuote;

  @override
  void initState() {
    super.initState();
    _todayQuote = _dailyQuotes[math.Random().nextInt(_dailyQuotes.length)];
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showCompanionStoryModal(BuildContext context, Companion companion) {
    final status = CompanionLifeService.getCurrentStatus(companion);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return GlassContainer(
          borderRadius: 32,
          blur: 30,
          opacity: 0.2,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.primary, AppTheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(companion.avatarUrl),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(status.emoji, style: const TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                companion.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              if (companion.occupation.isNotEmpty)
                Text(
                  companion.occupation,
                  style: TextStyle(color: AppTheme.secondary, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: status.badgeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: status.badgeColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_filled, size: 14, color: status.badgeColor),
                    const SizedBox(width: 6),
                    Text(status.statusText, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      '"${companion.statusMessage}"',
                      style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    if (companion.hobbies.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: companion.hobbies.take(4).map((h) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('#$h', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/chat', extra: companion);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.chat_bubble, color: Colors.white),
                  label: Text('Enter Universe with ${companion.name} 🚀', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final companionsAsync = ref.watch(companionsProvider);
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1200 ? 4 : (width >= 800 ? 3 : 2);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF97316).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFF97316).withValues(alpha: 0.4)),
                              ),
                              child: const Row(
                                children: [
                                  Text('🔥', style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 4),
                                  Text('7 Day Streak', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
                              ),
                              child: const Row(
                                children: [
                                  Text('✨', style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 4),
                                  Text('1,420 XP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Digital Universe Hub 🌌',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.secondary]),
                          boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 10)],
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Parallax Hero & Quote Section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1E1B4B),
                          Color.lerp(const Color(0xFF31106A), const Color(0xFF4C1D95), _pulseController.value)!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('🌟 DAILY INSPIRATION', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                            ),
                            const Spacer(),
                            const Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 20),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '"${_todayQuote['quote']}"',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, height: 1.4),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '— ${_todayQuote['author']}',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  companionsAsync.whenData((comps) {
                                    if (comps.isNotEmpty) {
                                      context.push('/chat', extra: comps.first);
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1E1B4B),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.play_arrow_rounded, size: 22),
                                label: const Text('Resume Last Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: IconButton(
                                onPressed: () => context.push('/memory-vault'),
                                icon: const Icon(Icons.auto_stories, color: Colors.white),
                                tooltip: 'Memory Vault',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: IconButton(
                                onPressed: () => context.push('/marketplace'),
                                icon: const Icon(Icons.storefront, color: Colors.cyanAccent),
                                tooltip: 'Community AI Marketplace',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Interactive Digital Human Lifestyle Hub
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interactive Digital Lifestyles 🌐',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    companionsAsync.when(
                      data: (companions) {
                        final comp = companions.isNotEmpty ? companions.first : null;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildLifestyleCard(
                                    context,
                                    'Visit Home 🏠',
                                    'Penthouse Tour',
                                    Icons.other_houses,
                                    Colors.amberAccent,
                                    () => context.push('/digital-home', extra: comp),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildLifestyleCard(
                                    context,
                                    'Smartphone 📱',
                                    'Check Apps & OS',
                                    Icons.phone_iphone,
                                    Colors.cyanAccent,
                                    () {
                                      if (comp != null) context.push('/phone', extra: comp);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildLifestyleCard(
                                    context,
                                    'Wardrobe 👗',
                                    'Style Studio',
                                    Icons.checkroom,
                                    Colors.purpleAccent,
                                    () => context.push('/wardrobe', extra: comp),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildLifestyleCard(
                                    context,
                                    'Co-Founder Hub 🚀',
                                    'Pomodoro & Goals',
                                    Icons.rocket_launch,
                                    Colors.greenAccent,
                                    () => context.push('/productivity', extra: comp),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),

            // Live Autonomous Status Feed ("Live Companions")
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Live Companion Activities 🛰️',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Real-time schedule',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            companionsAsync.when(
              data: (companions) => SliverToBoxAdapter(
                child: SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: companions.length,
                    itemBuilder: (context, index) {
                      final comp = companions[index];
                      final status = CompanionLifeService.getCurrentStatus(comp);
                      return GestureDetector(
                        onTap: () => _showCompanionStoryModal(context, comp),
                        child: Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF151520),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundImage: AssetImage(comp.avatarUrl),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: status.badgeColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFF151520), width: 2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(comp.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1),
                                        Text(comp.relationshipType, style: TextStyle(color: AppTheme.secondary, fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                  Text(status.emoji, style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                status.statusText,
                                style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              loading: () => const SliverToBoxAdapter(child: SizedBox(height: 140)),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox(height: 140)),
            ),

            // Today's Memories & Progress Hub
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Today\'s Memories & Highlights 📖', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => context.push('/memory-vault'),
                      child: Text('View Vault', style: TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.psychology_alt, color: Colors.cyanAccent, size: 20),
                                SizedBox(width: 8),
                                Text('Memory Synthesizer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text('3 new memories extracted today from your deep chats with Luna & Nova.', style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.cyanAccent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('Importance Score: 9.8 / 10 ✨', style: TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.track_changes, color: Colors.pinkAccent, size: 20),
                                SizedBox(width: 8),
                                Text('Daily Goal Hub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text('Discuss quantum dreams with Luna or finish workout discipline with Titan.', style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.pinkAccent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('Progress: 2 / 3 Completed 🔥', style: TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar & Filter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search companions, vibes, or schedule states...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white54, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF151520),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // Category Filter Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    final primary = AppTheme.primary;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = cat);
                        },
                        backgroundColor: const Color(0xFF151520),
                        selectedColor: primary.withValues(alpha: 0.3),
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: isSelected ? primary : Colors.white.withValues(alpha: 0.08)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Companion Grid Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Text('All Digital Minds 💫', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            // Companion Grid
            companionsAsync.when(
              data: (companions) {
                final filtered = companions.where((comp) {
                  final matchesSearch = comp.name.toLowerCase().contains(_searchQuery) ||
                      comp.description.toLowerCase().contains(_searchQuery) ||
                      comp.personality.toLowerCase().contains(_searchQuery) ||
                      comp.tags.any((t) => t.toLowerCase().contains(_searchQuery));
                  
                  final matchesCat = _selectedCategory == 'All' || comp.tags.contains(_selectedCategory);
                  return matchesSearch && matchesCat;
                }).toList();

                if (filtered.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 56, color: Colors.white.withValues(alpha: 0.2)),
                            const SizedBox(height: 16),
                            Text('No digital minds found matching "$_searchQuery"', style: const TextStyle(color: Colors.white54, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return CompanionCard(
                          companion: filtered[index],
                          onTap: () {
                            context.push('/chat', extra: filtered[index]);
                          },
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                );
              },
              loading: () => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  ),
                ),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Text('Error loading universe: $error', style: const TextStyle(color: Colors.redAccent)),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-companion'),
        backgroundColor: AppTheme.primary,
        elevation: 8,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text('Create AI Partner ✨', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }

  Widget _buildLifestyleCard(BuildContext context, String title, String subtitle, IconData icon, Color accentColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 20,
        blur: 15,
        opacity: 0.15,
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
