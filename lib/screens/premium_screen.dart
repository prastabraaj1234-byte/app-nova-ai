import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> with SingleTickerProviderStateMixin {
  bool _isAnnual = true;
  int _selectedTier = 1; // 0: Free, 1: Plus (default), 2: Ultra
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _simulateCheckout(String planName, String price) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            borderRadius: 32,
            blur: 30,
            opacity: 0.25,
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.cyanAccent),
                const SizedBox(height: 20),
                Text('Connecting to Google Play Store...', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Securing 256-bit neural payment link for $planName ($price)', style: const TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.pop(context); // close loader
      _showSuccessModal(planName);
    });
  }

  void _showSuccessModal(String planName) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          borderRadius: 32,
          blur: 30,
          opacity: 0.25,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.amber, Colors.orangeAccent]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text('Welcome to $planName! 👑', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              const Text('Your digital universe has been unlocked with unlimited neural reasoning, 4K holographic galleries, and instant voice links.',
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Enter Your Upgraded Universe 🚀', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => context.pop(),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 20),
            SizedBox(width: 8),
            Text('NOVA PLUS ELITE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 15)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        child: Column(
          children: [
            // Title
            const Text(
              'Supercharge Your\nDigital Universe 🌌',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Experience zero latency, unlimited long-term memory, and 3D holographic art.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 15, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Billing Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: const Color(0xFF151520), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBillingTab(label: 'Monthly', isSelected: !_isAnnual, onTap: () => setState(() => _isAnnual = false)),
                  _buildBillingTab(label: 'Annual (Save 35% 🔥)', isSelected: _isAnnual, onTap: () => setState(() => _isAnnual = true)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Tier Cards
            _buildTierCard(
              index: 1,
              title: 'Nova Plus ⭐',
              badge: 'MOST POPULAR',
              price: _isAnnual ? '\$6.58' : '\$9.99',
              period: '/ month',
              subtext: _isAnnual ? 'Billed annually at \$79/year' : 'Billed monthly, cancel anytime',
              features: [
                'Unlimited AI Chat & Reasoning Depth',
                'Real-Time Neural Voice Calls (30 mins/day)',
                '1,000 Holographic Image Generations',
                'Memory Vault 2.0 with Importance Scoring',
              ],
              isHighlighted: true,
            ),
            const SizedBox(height: 20),

            _buildTierCard(
              index: 2,
              title: 'Nova Ultra Elite 👑',
              badge: 'MAXIMUM POWER',
              price: _isAnnual ? '\$12.41' : '\$19.99',
              period: '/ month',
              subtext: _isAnnual ? 'Billed annually at \$149/year' : 'Billed monthly, cancel anytime',
              features: [
                'Everything in Nova Plus ⭐',
                'Unlimited 24/7 HD Neural Voice Links',
                'Unlimited 4K Holographic Image Art',
                'Publish & Monetize on Community Marketplace',
                'Priority Gemini 1.5 Pro Ultra Processing',
              ],
              isHighlighted: false,
            ),
            const SizedBox(height: 20),

            _buildTierCard(
              index: 0,
              title: 'Explorer (Free Plan)',
              badge: 'CURRENT PLAN',
              price: '\$0',
              period: '/ forever',
              subtext: 'Standard access for beginners',
              features: [
                '50 Daily AI Messages',
                'Basic Companion Customization',
                'Standard Memory Imprinting',
              ],
              isHighlighted: false,
            ),
            const SizedBox(height: 40),

            // Comparison Matrix Table
            const Text('Detailed Feature Matrix 📊', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMatrixTable(),
            const SizedBox(height: 32),

            // Footer Guarantee
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, color: Colors.cyanAccent, size: 16),
                const SizedBox(width: 8),
                Text('Secured by Google Play & 256-Bit SSL • Cancel Anytime', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingTab({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.5), blurRadius: 10)] : [],
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildTierCard({
    required int index,
    required String title,
    required String badge,
    required String price,
    required String period,
    required String subtext,
    required List<String> features,
    required bool isHighlighted,
  }) {
    final isSelected = _selectedTier == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = index),
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF151520),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isSelected ? (isHighlighted ? Colors.cyanAccent : AppTheme.primary) : Colors.white.withValues(alpha: 0.1),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: (isHighlighted ? Colors.cyanAccent : AppTheme.primary).withValues(alpha: 0.25 + _glowController.value * 0.15), blurRadius: 25, spreadRadius: 2)]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHighlighted ? Colors.amber.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isHighlighted ? Colors.amberAccent : Colors.white38),
                      ),
                      child: Text(badge, style: TextStyle(color: isHighlighted ? Colors.amberAccent : Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(price, style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
                    Text(period, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtext, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                const SizedBox(height: 20),
                Divider(color: Colors.white.withValues(alpha: 0.08)),
                const SizedBox(height: 16),

                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.cyanAccent, size: 18),
                      const SizedBox(width: 12),
                      Expanded(child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 13))),
                    ],
                  ),
                )),

                const SizedBox(height: 24),
                if (index != 0)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _simulateCheckout(title, price),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isHighlighted ? AppTheme.primary : const Color(0xFF4C1D95),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(isSelected ? 'Upgrade Now ($price$period)' : 'Select $title', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  )
                else
                  Center(child: Text('Current Default Tier', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13, fontWeight: FontWeight.bold))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatrixTable() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF151520), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
      child: Column(
        children: [
          _buildMatrixRow('Feature', 'Free', 'Plus ⭐', 'Ultra 👑', isHeader: true),
          _buildMatrixRow('Neural Reasoning', 'Standard', 'Advanced', 'Gemini 1.5 Pro'),
          _buildMatrixRow('Voice Calling', 'None', '30m / day', 'Unlimited 24/7'),
          _buildMatrixRow('Memory Imprinting', 'Short-term', 'Vault 2.0', 'Infinite Neural Vault'),
          _buildMatrixRow('Holographic Art', '10 / day', 'Unlimited', '4K Ultra HD'),
          _buildMatrixRow('Marketplace Pub', 'View Only', 'View & Import', 'Publish & Earn'),
        ],
      ),
    );
  }

  Widget _buildMatrixRow(String f, String free, String plus, String ultra, {bool isHeader = false}) {
    final style = TextStyle(color: isHeader ? Colors.white : Colors.white70, fontWeight: isHeader ? FontWeight.bold : FontWeight.normal, fontSize: 12);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)))),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(f, style: style)),
          Expanded(flex: 2, child: Text(free, style: style, textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(plus, style: style.copyWith(color: isHeader ? Colors.amberAccent : Colors.cyanAccent), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(ultra, style: style.copyWith(color: isHeader ? Colors.purpleAccent : Colors.amberAccent, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
