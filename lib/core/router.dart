import 'package:go_router/go_router.dart';
import 'package:nova_ai/screens/home_screen.dart';
import 'package:nova_ai/screens/splash_screen.dart';
import 'package:nova_ai/screens/auth/onboarding_screen.dart';
import 'package:nova_ai/screens/auth/login_screen.dart';
import 'package:nova_ai/screens/auth/signup_screen.dart';
import 'package:nova_ai/screens/chat_screen.dart';
import 'package:nova_ai/screens/profile_screen.dart';
import 'package:nova_ai/screens/premium_screen.dart';
import 'package:nova_ai/screens/memory_vault_screen.dart';
import 'package:nova_ai/screens/dream_journal_screen.dart';
import 'package:nova_ai/screens/character_creator_screen.dart';
import 'package:nova_ai/screens/privacy_policy_screen.dart';
import 'package:nova_ai/screens/gallery_screen.dart';
import 'package:nova_ai/screens/call_screen.dart';
import 'package:nova_ai/screens/marketplace_screen.dart';
import 'package:nova_ai/screens/digital_home_screen.dart';
import 'package:nova_ai/screens/digital_phone_screen.dart';
import 'package:nova_ai/screens/digital_wardrobe_screen.dart';
import 'package:nova_ai/screens/productivity_hub_screen.dart';
import 'package:nova_ai/widgets/responsive_scaffold.dart';
import 'package:nova_ai/models/companion.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const ResponsiveScaffold(
        currentIndex: 0,
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final companion = state.extra as Companion;
        return ChatScreen(companion: companion);
      },
    ),
    GoRoute(
      path: '/memory-vault',
      builder: (context, state) => const ResponsiveScaffold(
        currentIndex: 1,
        child: MemoryVaultScreen(),
      ),
    ),
    GoRoute(
      path: '/create-companion',
      builder: (context, state) => const ResponsiveScaffold(
        currentIndex: 2,
        child: CharacterCreatorScreen(),
      ),
    ),
    GoRoute(
      path: '/gallery',
      builder: (context, state) => const ResponsiveScaffold(
        currentIndex: 3,
        child: GalleryScreen(),
      ),
    ),
    GoRoute(
      path: '/calls',
      builder: (context, state) => const ResponsiveScaffold(
        currentIndex: 4,
        child: CallScreen(),
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ResponsiveScaffold(
        currentIndex: 5,
        child: ProfileScreen(),
      ),
    ),
    GoRoute(
      path: '/marketplace',
      builder: (context, state) => const MarketplaceScreen(),
    ),
    GoRoute(
      path: '/digital-home',
      builder: (context, state) {
        final companion = state.extra as Companion?;
        return DigitalHomeScreen(companion: companion);
      },
    ),
    GoRoute(
      path: '/phone',
      builder: (context, state) {
        final companion = state.extra as Companion;
        return DigitalPhoneScreen(companion: companion);
      },
    ),
    GoRoute(
      path: '/wardrobe',
      builder: (context, state) {
        final companion = state.extra as Companion?;
        return DigitalWardrobeScreen(companion: companion);
      },
    ),
    GoRoute(
      path: '/premium',
      builder: (context, state) => const PremiumScreen(),
    ),
    GoRoute(
      path: '/journal',
      builder: (context, state) {
        final companion = state.extra as Companion;
        return DreamJournalScreen(companion: companion);
      },
    ),
    GoRoute(
      path: '/productivity',
      builder: (context, state) {
        final companion = state.extra as Companion?;
        return ProductivityHubScreen(companion: companion);
      },
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
  ],
);

