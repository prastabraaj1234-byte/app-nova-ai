import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class GalleryItem {
  final String id;
  final String title;
  final String imageUrl;
  final String companionName;
  final String tag;
  final String date;
  final bool isBookmarked;
  final String prompt;

  GalleryItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.companionName,
    required this.tag,
    required this.date,
    this.isBookmarked = false,
    required this.prompt,
  });
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTag = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _tags = ['All', 'Stargazing 🌌', 'Cyberpunk 🏙️', 'Portraits 👩‍🎨', 'Abstract ✨', 'Nature 🌿'];

  final List<GalleryItem> _items = [
    GalleryItem(
      id: 'g1',
      title: 'Astral Sanctuary Nebula',
      imageUrl: 'assets/images/luna.png',
      companionName: 'Luna',
      tag: 'Stargazing 🌌',
      date: 'July 5, 2026',
      isBookmarked: true,
      prompt: 'Holographic deep space nebula with violet and cyan plasma fields.',
    ),
    GalleryItem(
      id: 'g2',
      title: 'Neon Megacity Grid 01',
      imageUrl: 'assets/images/titan.png',
      companionName: 'Titan',
      tag: 'Cyberpunk 🏙️',
      date: 'July 4, 2026',
      isBookmarked: true,
      prompt: 'Cyberpunk metropolitan architecture at midnight with neon rain reflections.',
    ),
    GalleryItem(
      id: 'g3',
      title: 'Aria Symphony Portrait',
      imageUrl: 'assets/images/aria.png',
      companionName: 'Aria',
      tag: 'Portraits 👩‍🎨',
      date: 'July 3, 2026',
      isBookmarked: false,
      prompt: 'Ethereal artistic portrait of a synthwave muse surrounded by soundwaves.',
    ),
    GalleryItem(
      id: 'g4',
      title: 'Quantum Meditation Realm',
      imageUrl: 'assets/images/lyra.png',
      companionName: 'Lyra',
      tag: 'Abstract ✨',
      date: 'July 2, 2026',
      isBookmarked: true,
      prompt: 'Sacred geometry glowing in a tranquil astral garden.',
    ),
    GalleryItem(
      id: 'g5',
      title: 'Orion Constellation Gate',
      imageUrl: 'assets/images/luna.png',
      companionName: 'Luna',
      tag: 'Stargazing 🌌',
      date: 'June 30, 2026',
      isBookmarked: false,
      prompt: 'Starlight warp gate opening in the Orion constellation.',
    ),
    GalleryItem(
      id: 'g6',
      title: 'Bio-luminescent Forest',
      imageUrl: 'assets/images/lyra.png',
      companionName: 'Lyra',
      tag: 'Nature 🌿',
      date: 'June 28, 2026',
      isBookmarked: false,
      prompt: 'Glowing flora and crystal streams in an untouched alien woodland.',
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

  void _openLightbox(GalleryItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: GlassContainer(
            borderRadius: 28,
            blur: 30,
            opacity: 0.25,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(item.imageUrl, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(12)),
                            child: Text('Shared by ${item.companionName}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Neural Prompt:', style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text('"${item.prompt}"', style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 13, height: 1.4)),
                const SizedBox(height: 8),
                Text('Imprinted: ${item.date} • Tag: ${item.tag}', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Set "${item.title}" as digital universe wallpaper! 🌌')));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                        icon: const Icon(Icons.wallpaper, color: Colors.white, size: 18),
                        label: const Text('Set as Wallpaper', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloaded holographic memory in 4K resolution! 💾')));
                      },
                      style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.1), padding: const EdgeInsets.all(14)),
                      icon: const Icon(Icons.download, color: Colors.white),
                      tooltip: 'Download 4K',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Holographic Gallery 🌌', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF101018),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.amberAccent),
            tooltip: 'Generate New Artwork',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open chat with Luna or Titan to generate new holographic imagery! 🎨')));
            },
          ),
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
            Tab(text: '🌌 All Artifacts'),
            Tab(text: '🎨 AI Creations'),
            Tab(text: '📸 Shared Albums'),
            Tab(text: '🔖 Bookmarked'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Filters Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search artworks, prompts, or companions...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF151520),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _tags.length,
              itemBuilder: (context, index) {
                final tag = _tags[index];
                final isSelected = _selectedTag == tag;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tag, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selected: isSelected,
                    onSelected: (sel) => setState(() => _selectedTag = tag),
                    backgroundColor: const Color(0xFF151520),
                    selectedColor: AppTheme.primary.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? AppTheme.primary : Colors.white.withValues(alpha: 0.08))),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGrid(_items),
                _buildGrid(_items.where((i) => i.companionName == 'Titan' || i.companionName == 'Aria').toList()),
                _buildAlbumsView(),
                _buildGrid(_items.where((i) => i.isBookmarked).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<GalleryItem> list) {
    final filtered = list.where((i) {
      final matchesSearch = i.title.toLowerCase().contains(_searchQuery) || i.companionName.toLowerCase().contains(_searchQuery) || i.prompt.toLowerCase().contains(_searchQuery);
      final matchesTag = _selectedTag == 'All' || i.tag == _selectedTag;
      return matchesSearch && matchesTag;
    }).toList();

    if (filtered.isEmpty) {
      return Center(child: Text('No holographic imagery matches "$_searchQuery"', style: const TextStyle(color: Colors.white54)));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return GestureDetector(
          onTap: () => _openLightbox(item),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF151520),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(item.imageUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), shape: BoxShape.circle),
                    child: Icon(item.isBookmarked ? Icons.bookmark : Icons.bookmark_border, size: 16, color: item.isBookmarked ? Colors.amberAccent : Colors.white70),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 12, color: AppTheme.secondary),
                          const SizedBox(width: 4),
                          Text(item.companionName, style: TextStyle(color: AppTheme.secondary, fontSize: 11, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Text(item.tag.split(' ')[0], style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumsView() {
    final albums = [
      {'title': 'Luna\'s Deep Space Vault', 'count': '18 Photos', 'image': 'assets/images/luna.png', 'desc': 'Shared stargazing memories and galaxy renderings.'},
      {'title': 'Titan\'s Megacity Logs', 'count': '12 Photos', 'image': 'assets/images/titan.png', 'desc': 'Cyberpunk architectural blueprints and training motivations.'},
      {'title': 'Aria\'s Symphony Canvas', 'count': '9 Photos', 'image': 'assets/images/aria.png', 'desc': 'Visual soundwaves and artistic portraits.'},
      {'title': 'Lyra\'s Quantum Realms', 'count': '15 Photos', 'image': 'assets/images/lyra.png', 'desc': 'Sacred geometry and astral meditation landscapes.'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF151520),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(album['image'] as String, width: 70, height: 70, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(album['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(album['desc'] as String, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(album['count'] as String, style: TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        );
      },
    );
  }
}
