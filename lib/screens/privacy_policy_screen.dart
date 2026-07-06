import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Privacy & Terms', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassContainer(
                borderRadius: 20,
                blur: 15,
                opacity: 0.1,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Theme.of(context).colorScheme.primary, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Data & Privacy',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Nova AI is built with transparency and user control as our highest priorities.',
                            style: TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                '1. Information We Collect',
                'Nova AI processes user chat messages and preferences to provide personalized AI companion experiences. When you enter an API Key, it is stored locally on your device using secure local preferences and is never transmitted to our external marketing servers.',
              ),
              _buildSection(
                context,
                '2. AI Processing & Google Gemini',
                'Your messages are sent directly to Google\'s Generative AI (Gemini API) services to generate conversational responses. Please avoid sharing sensitive financial, medical, or passwords with AI companions.',
              ),
              _buildSection(
                context,
                '3. Data Storage & Deletion',
                'Chat histories and custom companions are saved locally on your device or linked to your anonymous session. You can clear your chat data or reset your profile at any time from the Profile & Settings menu.',
              ),
              _buildSection(
                context,
                '4. Terms of Service',
                'By using Nova AI on Android or Web, you agree to treat AI companions respectfully and comply with Google\'s Generative AI Terms of Service. Nova AI is designed for entertainment, emotional support, and productivity coaching.',
              ),
              _buildSection(
                context,
                '5. Contact & Support',
                'For privacy inquiries or Play Store data deletion requests, contact our team at support@novaai-app.com.',
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Last Updated: July 2026 • Version 1.0.0 (Play Store Release)',
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
