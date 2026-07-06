import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/primary_button.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _glowController;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Meet Your Perfect AI Companion',
      'description': 'Experience the next generation of AI with deep emotional intelligence, voice adaptation, and long-term memory.',
      'icon': Icons.auto_awesome,
      'color': Color(0xFF6D5EF9),
    },
    {
      'title': 'Evolves & Grows With You',
      'description': 'Your companion remembers your goals, celebrates your XP level-ups, and adapts to your daily mood shifts.',
      'icon': Icons.auto_graph,
      'color': Color(0xFF00D1FF),
    },
    {
      'title': 'Play Store & Web Connected',
      'description': 'Whether you need a confidential listener, a fitness mentor, or a coding strategist, Nova AI is ready 24/7.',
      'icon': Icons.public,
      'color': Color(0xFF22C55E),
    },
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutQuart,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: primary, size: 20),
                      const SizedBox(width: 8),
                      const Text('NOVA AI', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 13)),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Skip', style: TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  final color = page['color'] as Color;

                  return Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _glowController,
                          builder: (context, child) {
                            return Container(
                              height: 280,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    color.withOpacity(0.25),
                                    Theme.of(context).colorScheme.surface,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.3 + (_glowController.value * 0.2)),
                                    blurRadius: 30,
                                    spreadRadius: 4,
                                  ),
                                ],
                                border: Border.all(color: color.withOpacity(0.4), width: 1.5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(page['icon'] as IconData, size: 72, color: color),
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white12),
                                    ),
                                    child: Text('STEP ${index + 1} OF 3', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page['title']!,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['description']!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? primary : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: PrimaryButton(
                      text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next →',
                      onPressed: _nextPage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

