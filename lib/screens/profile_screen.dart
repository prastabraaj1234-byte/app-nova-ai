import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/providers/theme_provider.dart';
import 'package:nova_ai/providers/api_key_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAccent = ref.watch(themeAccentProvider);
    final apiKey = ref.watch(apiKeyProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: const Icon(Icons.person, size: 48, color: Colors.white54),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Paul',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Nova AI Explorer (Free Plan)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            GestureDetector(
              onTap: () => context.push('/premium'),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium, color: Colors.white, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Upgrade to Nova Plus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('Unlock unlimited AI memory & voice calls', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Mood Tracker Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daily Mood Tracker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMoodIcon(context, 'Great', Icons.sentiment_very_satisfied, Colors.green),
                      _buildMoodIcon(context, 'Good', Icons.sentiment_satisfied, Colors.blue),
                      _buildMoodIcon(context, 'Okay', Icons.sentiment_neutral, Colors.amber),
                      _buildMoodIcon(context, 'Bad', Icons.sentiment_dissatisfied, Colors.orange),
                      _buildMoodIcon(context, 'Awful', Icons.sentiment_very_dissatisfied, Colors.red),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            
            // Theme Selection Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('App Theme Accent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: AppAccent.values.map((accent) {
                      final isSelected = currentAccent == accent;
                      return GestureDetector(
                        onTap: () {
                          ref.read(themeAccentProvider.notifier).updateTheme(accent);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: accent.color,
                            shape: BoxShape.circle,
                            border: isSelected 
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                            boxShadow: isSelected
                                ? [BoxShadow(color: accent.color.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)]
                                : [],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // API Key Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.security, color: Colors.amber, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Connection: Managed by Nova Security Gateway',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Client-side API key storage is disabled for security.',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            
            _buildListTile(context, Icons.emoji_events, 'Achievements & XP', onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have unlocked 4/10 AI Companion Achievements! 🏆')));
            }),
            _buildListTile(context, Icons.memory, 'Memory Vault', onTap: () => context.push('/memory-vault')),
            _buildListTile(context, Icons.wallpaper, 'Holographic Gallery', onTap: () => context.push('/gallery')),
            _buildListTile(context, Icons.phone_in_talk, 'Neural Voice Calls', onTap: () => context.push('/calls')),
            _buildListTile(context, Icons.storefront, 'Community AI Marketplace', onTap: () => context.push('/marketplace')),
            _buildListTile(context, Icons.privacy_tip_outlined, 'Privacy Policy & Terms', onTap: () => context.push('/privacy')),
            _buildListTile(context, Icons.info_outline, 'About Nova AI (v1.0.0 Play Store)', onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Nova AI Companions',
                applicationVersion: '1.0.0 (Production Release)',
                applicationIcon: const Icon(Icons.auto_awesome, color: Colors.purple, size: 40),
                children: const [
                  Text('Built for immersive AI companionship on Android Play Store and Web platforms.'),
                ],
              );
            }),
            
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
              title: Text('Sign Out', style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w600)),
              onTap: () => context.go('/login'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.white38),
              title: const Text('Delete Account & Data', style: TextStyle(color: Colors.white38)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deletion request initiated.')));
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIcon(BuildContext context, String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mood logged: $label! Nova will adapt to your energy 🌟')));
      },
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap ?? () {},
      ),
    );
  }

}

