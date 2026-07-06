import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/primary_button.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  int _selectedAvatarIndex = 0;
  
  final List<Color> _avatarColors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Join Nova and meet your AI companion.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              
              Text(
                'Choose your avatar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _avatarColors.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedAvatarIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatarIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3) : null,
                        ),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: _avatarColors[index].withOpacity(0.2),
                          child: Icon(Icons.person, size: 40, color: _avatarColors[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),

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
              
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Sign Up',
                onPressed: () {
                  context.go('/home');
                },
              ),
              
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?', style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
