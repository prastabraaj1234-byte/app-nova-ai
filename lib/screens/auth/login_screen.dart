import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/primary_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue your journey with Nova.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),
              
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to forgot password
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Sign In',
                onPressed: () {
                  context.go('/home');
                },
              ),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: Theme.of(context).colorScheme.surface, thickness: 2)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  Expanded(child: Divider(color: Theme.of(context).colorScheme.surface, thickness: 2)),
                ],
              ),
              const SizedBox(height: 24),
              
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata, color: Colors.white), // Placeholder for Google Icon
                label: const Text('Continue with Google', style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: Theme.of(context).colorScheme.surface, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              
              OutlinedButton.icon(
                onPressed: () {
                  context.go('/home');
                },
                icon: const Icon(Icons.person, color: Colors.white),
                label: const Text('Continue as Guest', style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: Theme.of(context).colorScheme.surface, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?', style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () => context.go('/signup'),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
