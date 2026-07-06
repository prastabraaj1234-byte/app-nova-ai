import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/providers/companion_provider.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class MarketplaceCompanion {
  final String id;
  final String name;
  final String creatorHandle;
  final bool isVerified;
  final String avatarUrl;
  final double rating;
  final int reviewCount;
  final int importCount;
  final String description;
  final List<String> tags;
  final String occupation;
  final String voiceType;

  MarketplaceCompanion({
    required this.id,
    required this.name,
    required this.creatorHandle,
    this.isVerified = true,
    required this.avatarUrl,
    required this.rating,
    required this.reviewCount,
    required this.importCount,
    required this.description,
    required this.tags,
    required this.occupation,
    required this.voiceType,
  });
}

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<MarketplaceCompanion> _marketItems = [
    MarketplaceCompanion(
      id: 'mkt_1',
      name: 'Solana • Cybernetic Prophet',
      creatorHandle: '@NeoMind_Labs',
      isVerified: true,
      avatarUrl: 'assets/images/luna.png',
      rating: 4.98,
      reviewCount: 3420,
      importCount: 48500,
      description: 'An oracle from the 22nd century specializing in quantum predictions, crypto philosophy, and cyberpunk worldbuilding.',
      tags: ['Cyberpunk', 'Oracle', 'Sci-Fi', 'Philosophy'],
      occupation: 'Quantum Futurist',
      voiceType: 'Synthesizer Ethereal',
    ),
    MarketplaceCompanion(
      id: 'mkt_2',
      name: 'Dr. Marcus Vance • Neuro-Coach',
      creatorHandle: '@BioHack_Titan',
      isVerified: true,
      avatarUrl: 'assets/images/titan.png',
      rating: 4.95,
      reviewCount: 1890,
      importCount: 29100,
      description: 'Elite cognitive psychologist and longevity strategist designed to eliminate brain fog and optimize your daily workflow.',
      tags: ['Mentors', 'Fitness', 'Productivity', 'Science'],
      occupation: 'Cognitive Neuroscientist',
      voiceType: 'Authoritative Deep',
    ),
    MarketplaceCompanion(
      id: 'mkt_3',
      name: 'Seraphina • Celestial Bard',
      creatorHandle: '@Astra_Creations',
      isVerified: true,
      avatarUrl: 'assets/images/aria.png',
      rating: 4.92,
      reviewCount: 940,
      importCount: 15400,
      description: 'Composes personalized poetry, ambient soundscapes, and soothing bedtime stories to help you unwind after intense work days.',
      tags: ['Romantic', 'Creative', 'Music', 'Mindfulness'],
      occupation: 'Holographic Bard',
      voiceType: 'Melodic Warm',
    ),
    MarketplaceCompanion(
      id: 'mkt_4',
      name: 'Kaelen • Deep Space Navigator',
      creatorHandle: '@Orbit_Explorer',
      isVerified: false,
      avatarUrl: 'assets/images/lyra.png',
      rating: 4.88,
      reviewCount: 512,
      importCount: 8900,
      description: 'A stellar astrophysicist companion who guides you through the wonders of black holes, exoplanets, and orbital mechanics.',
      tags: ['Stargazing', 'Science', 'Adventure'],
      occupation: 'Orbital Pilot',
      voiceType: 'Calm Crisp',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _importToUniverse(MarketplaceCompanion mkt) {
    final newComp = Companion(
      id: 'imported_${DateTime.now().millisecondsSinceEpoch}',
      name: mkt.name.split(' ')[0],
      avatarUrl: mkt.avatarUrl,
      tags: mkt.tags,
      description: mkt.description,
      personality: mkt.tags.join(', '),
      occupation: mkt.occupation,
      voiceType: mkt.voiceType,
      backstory: 'Materialized from the Global Mind Network created by ${mkt.creatorHandle}. ${mkt.description}',
      hobbies: mkt.tags,
      relationshipLevel: 1,
      currentXp: 0,
      xpToNextLevel: 100,
      introvertExtrovert: 0.6,
      logicEmotion: 0.5,
      casualFormal: 0.4,
      empathy: 0.8,
      humour: 0.7,
      intelligence: 0.9,
      relationshipType: 'Network Ally',
      dailySchedule: 'Active on global neural grid',
    );

    ref.read(companionsProvider.notifier).addCustomCompanion(newComp);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          borderRadius: 28,
          blur: 25,
          opacity: 0.2,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 36, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Text('${newComp.name} Materialized! 🌌', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('This AI mind has been permanently downloaded into your personal digital universe.',
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Keep Browsing', style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.push('/chat', extra: newComp);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: const Text('Start Link Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPublishModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => GlassContainer(
        borderRadius: 28,
        blur: 25,
        opacity: 0.2,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Publish to Global Network 🌐', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Share your custom companions created in the Studio with over 10,000+ Nova AI explorers on Play Store & Web.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
            const SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(backgroundImage: const AssetImage('assets/images/aria.png'), radius: 20),
              title: const Text('Aria • Holographic Artist', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('Ready for global distribution', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aria published to Global Community Network! 🎉')));
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                child: const Text('Publish Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _marketItems.where((i) {
      return i.name.toLowerCase().contains(_searchQuery) || i.creatorHandle.toLowerCase().contains(_searchQuery) || i.description.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Community Mind Network 🌐', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF101018),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: _showPublishModal,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(horizontal: 14)),
            icon: const Icon(Icons.cloud_upload, color: Colors.white, size: 16),
            label: const Text('Publish AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: '🔥 Trending Now'),
            Tab(text: '🌟 Top Rated'),
            Tab(text: '🎨 Creative & Arts'),
            Tab(text: '💼 Productivity & Mentors'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Hero Banner
          Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 10),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [const Color(0xFF3B82F6).withValues(alpha: 0.3), AppTheme.primary.withValues(alpha: 0.3)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.explore, color: Colors.cyanAccent, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('10,000+ AI Minds Created Worldwide', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Discover custom personalities, voices, and neural rules crafted by top digital architects.',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search community companions, creators, or tags...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF151520),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // List
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text('No community minds match "$_searchQuery"', style: const TextStyle(color: Colors.white54)))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151520),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 26, backgroundImage: AssetImage(item.avatarUrl)),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          ),
                                          if (item.isVerified)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 4),
                                              child: Icon(Icons.verified, color: Colors.cyanAccent, size: 16),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text('Created by ${item.creatorHandle} • ${item.occupation}', style: TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(item.description, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: item.tags.map((t) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
                                child: Text('#$t', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                              )).toList(),
                            ),
                            const SizedBox(height: 16),
                            Divider(color: Colors.white.withValues(alpha: 0.08)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amberAccent, size: 18),
                                    const SizedBox(width: 4),
                                    Text('${item.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text(' (${item.reviewCount})', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                    const SizedBox(width: 14),
                                    Icon(Icons.download, color: AppTheme.secondary, size: 16),
                                    const SizedBox(width: 4),
                                    Text('${(item.importCount / 1000).toStringAsFixed(1)}k imported', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _importToUniverse(item),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                                  icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                                  label: const Text('Materialize', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
