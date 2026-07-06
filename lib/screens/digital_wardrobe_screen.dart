import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/providers/companion_provider.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class DigitalWardrobeScreen extends ConsumerStatefulWidget {
  final Companion? companion;
  const DigitalWardrobeScreen({super.key, this.companion});

  @override
  ConsumerState<DigitalWardrobeScreen> createState() => _DigitalWardrobeScreenState();
}

class _DigitalWardrobeScreenState extends ConsumerState<DigitalWardrobeScreen> {
  String _selectedCategory = 'All ✨';
  final List<String> _categories = ['All ✨', 'Streetwear 🧥', 'Accessories 🕶️', 'Gym 💪', 'Formal 👗', 'Sleepwear 🌙'];

  void _equipItem(Companion comp, DigitalWardrobeItem item) {
    final updatedItems = comp.digitalWardrobe.items.map((i) {
      if (i.category == item.category) {
        return DigitalWardrobeItem(
          id: i.id,
          name: i.name,
          category: i.category,
          imageUrl: i.imageUrl,
          isEquipped: i.id == item.id,
          unlocked: i.unlocked,
        );
      }
      return i;
    }).toList();

    final updatedWardrobe = DigitalWardrobe(
      currentOutfitName: '${item.name} (${item.category})',
      items: updatedItems,
    );

    final updatedCompanion = comp.copyWith(digitalWardrobe: updatedWardrobe);
    ref.read(companionsProvider.notifier).updateCompanion(updatedCompanion);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('👑 Equipped "${item.name}"! ${comp.name} loves their new style!'),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
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
        final wardrobe = comp.digitalWardrobe;

        final filteredItems = _selectedCategory == 'All ✨'
            ? wardrobe.items
            : wardrobe.items.where((i) => i.category.toLowerCase().contains(_selectedCategory.split(' ')[0].toLowerCase())).toList();

        return Scaffold(
          backgroundColor: const Color(0xFF08080C),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text('${comp.name}\'s Wardrobe & Styling Studio 👗', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Equipped Outfit Banner
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlassContainer(
                  borderRadius: 28,
                  blur: 20,
                  opacity: 0.2,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.cyanAccent, width: 2),
                          image: DecorationImage(image: AssetImage(comp.avatarUrl), fit: BoxFit.cover),
                          boxShadow: [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.3), blurRadius: 15)],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.cyanAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                                  child: const Text('EQUIPPED STYLE ✨', style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(wardrobe.currentOutfitName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Fashion Preference: ${comp.fashionStyle}', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Category Tabs
              SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSel = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSel ? AppTheme.primary : const Color(0xFF151520),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSel ? Colors.cyanAccent : Colors.white12),
                        ),
                        child: Text(cat, style: TextStyle(color: isSel ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Wardrobe Items Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.75),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF12121C),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: item.isEquipped ? Colors.cyanAccent : Colors.white.withValues(alpha: 0.1), width: item.isEquipped ? 2 : 1),
                        boxShadow: item.isEquipped ? [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.2), blurRadius: 15)] : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(item.imageUrl, fit: BoxFit.cover),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, const Color(0xFF12121C)]),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)),
                                      child: Text(item.category, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: item.isEquipped ? null : () => _equipItem(comp, item),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: item.isEquipped ? Colors.white24 : AppTheme.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Text(item.isEquipped ? 'Equipped ✨' : 'Equip Now', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
            ],
          ),
        );
      },
    );
  }
}
