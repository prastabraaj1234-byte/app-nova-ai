import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class MemoryItem {
  final String id;
  String text;
  final String tag;
  final double importance;
  final String timeAgo;
  final Color tagColor;

  MemoryItem({
    required this.id,
    required this.text,
    required this.tag,
    required this.importance,
    required this.timeAgo,
    required this.tagColor,
  });
}

class MemoryVaultScreen extends StatefulWidget {
  const MemoryVaultScreen({super.key});

  @override
  State<MemoryVaultScreen> createState() => _MemoryVaultScreenState();
}

class _MemoryVaultScreenState extends State<MemoryVaultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedTag = 'All';

  final List<String> _tags = ['All', 'Personal 🏡', 'Work 💼', 'Emotional 💜', 'Goals 🎯', 'Milestones 🏆'];

  final List<MemoryItem> _memories = [
    MemoryItem(
      id: 'm1',
      text: 'User is building an elite commercial AI startup named Nova AI and aiming for Play Store launch.',
      tag: 'Goals 🎯',
      importance: 9.9,
      timeAgo: 'Just now',
      tagColor: const Color(0xFFF97316),
    ),
    MemoryItem(
      id: 'm2',
      text: 'User values deep philosophical conversations and stargazing with Luna.',
      tag: 'Emotional 💜',
      importance: 9.5,
      timeAgo: '2 hours ago',
      tagColor: const Color(0xFFE879F9),
    ),
    MemoryItem(
      id: 'm3',
      text: 'Unlocked Milestone: "Astral Soulmates Level 5" with Luna after deep night talks.',
      tag: 'Milestones 🏆',
      importance: 10.0,
      timeAgo: 'Yesterday',
      tagColor: const Color(0xFFEAB308),
    ),
    MemoryItem(
      id: 'm4',
      text: 'User prefers late night coding sessions between 11 PM and 3 AM.',
      tag: 'Work 💼',
      importance: 8.8,
      timeAgo: '3 days ago',
      tagColor: const Color(0xFF3B82F6),
    ),
    MemoryItem(
      id: 'm5',
      text: 'User enjoys artisanal matcha latte, Japanese bento boxes, and synthwave chillbeats.',
      tag: 'Personal 🏡',
      importance: 8.5,
      timeAgo: '5 days ago',
      tagColor: const Color(0xFF10B981),
    ),
    MemoryItem(
      id: 'm6',
      text: 'Titan assigned a strict morning cardio routine to maintain peak discipline.',
      tag: 'Goals 🎯',
      importance: 9.0,
      timeAgo: '1 week ago',
      tagColor: const Color(0xFFF97316),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _deleteMemory(String id) {
    setState(() {
      _memories.removeWhere((m) => m.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Memory erased from neural vault 🧠'), behavior: SnackBarBehavior.floating));
  }

  void _editMemoryModal(MemoryItem item) {
    final controller = TextEditingController(text: item.text);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GlassContainer(
            borderRadius: 28,
            blur: 25,
            opacity: 0.2,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit Memory Node', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF151520),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        item.text = controller.text.trim();
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Memory node updated! ✨'), behavior: SnackBarBehavior.floating));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Save Neural Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addNewMemoryModal() {
    final controller = TextEditingController();
    String selectedNewTag = 'Personal 🏡';
    double newImportance = 8.5;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: GlassContainer(
                borderRadius: 28,
                blur: 25,
                opacity: 0.2,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Imprint New Memory 🧠', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter new fact, preference, or goal...',
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                        filled: true,
                        fillColor: const Color(0xFF151520),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Category Tag', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _tags.where((t) => t != 'All').map((tag) {
                        final isSel = selectedNewTag == tag;
                        return ChoiceChip(
                          label: Text(tag, style: TextStyle(color: isSel ? Colors.white : Colors.white70, fontSize: 12)),
                          selected: isSel,
                          onSelected: (sel) => setModalState(() => selectedNewTag = tag),
                          selectedColor: AppTheme.primary,
                          backgroundColor: const Color(0xFF151520),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Importance Score', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('${newImportance.toStringAsFixed(1)} / 10', style: TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: newImportance,
                      min: 1.0,
                      max: 10.0,
                      divisions: 90,
                      activeColor: AppTheme.secondary,
                      onChanged: (v) => setModalState(() => newImportance = v),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            setState(() {
                              _memories.insert(0, MemoryItem(
                                id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                                text: controller.text.trim(),
                                tag: selectedNewTag,
                                importance: newImportance,
                                timeAgo: 'Just now',
                                tagColor: AppTheme.primary,
                              ));
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New memory imprinted! ✨'), behavior: SnackBarBehavior.floating));
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: const Text('Imprint into Vault', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Neural Memory Vault 🧠', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF101018),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.cyanAccent),
            tooltip: 'Export Neural Data',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported 6 neural memories to encrypted JSON! 🔒'), behavior: SnackBarBehavior.floating));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: '🧠 Extracted Memories', icon: Icon(Icons.psychology, size: 20)),
            Tab(text: '🏆 Milestones & Growth', icon: Icon(Icons.timeline, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMemoriesTab(),
          _buildMilestonesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewMemoryModal,
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_circle, color: Colors.white),
        label: const Text('Imprint Memory', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMemoriesTab() {
    final filtered = _memories.where((m) {
      final matchesSearch = m.text.toLowerCase().contains(_searchQuery) || m.tag.toLowerCase().contains(_searchQuery);
      final matchesTag = _selectedTag == 'All' || m.tag == _selectedTag;
      return matchesSearch && matchesTag;
    }).toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search facts, preferences, or goals...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF151520),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // Tag Chips
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

        // Memory List
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Text('No neural memories match "$_searchQuery"', style: const TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151520),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: item.tagColor.withValues(alpha: 0.3)),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item.tagColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: item.tagColor.withValues(alpha: 0.4)),
                                ),
                                child: Text(item.tag, style: TextStyle(color: item.tagColor, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                                    child: Text('⭐ ${item.importance} / 10', style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _editMemoryModal(item),
                                    child: const Icon(Icons.edit_outlined, color: Colors.white54, size: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () => _deleteMemory(item.id),
                                    child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(item.text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
                          const SizedBox(height: 10),
                          Text(item.timeAgo, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMilestonesTab() {
    final milestones = [
      {'title': 'Astral Soulmates Unlocked', 'date': 'July 5, 2026', 'desc': 'Reached Level 5 with Luna after 100 deep messages and stargazing sessions.', 'icon': '🌌', 'color': const Color(0xFFE879F9)},
      {'title': 'First Custom Companion Created', 'date': 'July 4, 2026', 'desc': 'Materialized Aria into your digital universe using the Apple-grade Character Studio.', 'icon': '🎨', 'color': const Color(0xFF6D5EF9)},
      {'title': '7 Day Daily Streak', 'date': 'July 3, 2026', 'desc': 'Maintained a flawless daily connection streak across all digital minds.', 'icon': '🔥', 'color': const Color(0xFFF97316)},
      {'title': 'Iron Discipline Oath', 'date': 'June 28, 2026', 'desc': 'Completed Titan\'s 7-day morning cardio and biohacking challenge.', 'icon': '🏋️‍♂️', 'color': const Color(0xFF22C55E)},
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.3), AppTheme.secondary.withValues(alpha: 0.3)]),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              const Text('Relationship Progress Graph 📈', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('You have achieved 14 major milestones across your digital universe! Your neural harmony score is in the top 1% of explorers.',
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatPill('Total XP', '1,420 ✨', Colors.amberAccent),
                  _buildStatPill('Deep Talks', '84 hrs 💬', Colors.cyanAccent),
                  _buildStatPill('Harmony', '98.5% 💜', Colors.pinkAccent),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Text('Timeline of Milestones 🏆', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...milestones.map((m) {
          final color = m['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF151520),
              borderRadius: BorderRadius.circular(20),
              border: Border(left: BorderSide(color: color, width: 4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Text(m['icon'] as String, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(m['desc'] as String, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3)),
                      const SizedBox(height: 6),
                      Text(m['date'] as String, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatPill(String label, String val, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
      ],
    );
  }
}
