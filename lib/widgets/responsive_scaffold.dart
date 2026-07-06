import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const ResponsiveScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/memory-vault');
        break;
      case 2:
        context.push('/create-companion');
        break;
      case 3:
        context.go('/gallery');
        break;
      case 4:
        context.go('/calls');
        break;
      case 5:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 850;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            _buildDesktopSidebar(context),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildDesktopSidebar(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.all(16),
      child: GlassContainer(
        borderRadius: 28,
        blur: 25,
        opacity: 0.08,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4), blurRadius: 10)],
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'NOVA AI',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSidebarItem(context, 0, Icons.explore_outlined, Icons.explore, 'Explore'),
            _buildSidebarItem(context, 1, Icons.memory_outlined, Icons.memory, 'Memory Vault'),
            _buildSidebarItem(context, 2, Icons.add_circle_outline, Icons.add_circle, 'Create AI'),
            _buildSidebarItem(context, 3, Icons.wallpaper_outlined, Icons.wallpaper, 'Gallery'),
            _buildSidebarItem(context, 4, Icons.phone_in_talk_outlined, Icons.phone_in_talk, 'Neural Calls'),
            _buildSidebarItem(context, 5, Icons.person_outline, Icons.person, 'Profile'),
            const Spacer(),
            GestureDetector(
              onTap: () => context.push('/premium'),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.25), const Color(0xFF4C1D95).withValues(alpha: 0.25)]),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.workspace_premium, color: Theme.of(context).colorScheme.secondary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nova Plus Elite', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Play Store Live', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white54, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = currentIndex == index;
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () => _onItemTapped(context, index),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: isSelected ? Border.all(color: primary.withValues(alpha: 0.5)) : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? primary : Colors.white70,
              size: 22,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101018),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(context, 0, Icons.explore_outlined, Icons.explore, 'Explore'),
              _buildBottomNavItem(context, 1, Icons.memory_outlined, Icons.memory, 'Vault'),
              _buildBottomNavItem(context, 2, Icons.add_circle_outline, Icons.add_circle, 'Create'),
              _buildBottomNavItem(context, 3, Icons.wallpaper_outlined, Icons.wallpaper, 'Gallery'),
              _buildBottomNavItem(context, 4, Icons.phone_in_talk_outlined, Icons.phone_in_talk, 'Calls'),
              _buildBottomNavItem(context, 5, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = currentIndex == index;
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () => _onItemTapped(context, index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? primary : Colors.white60,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
