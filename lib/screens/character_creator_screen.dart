import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/providers/companion_provider.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/primary_button.dart';

class CharacterCreatorScreen extends ConsumerStatefulWidget {
  const CharacterCreatorScreen({super.key});

  @override
  ConsumerState<CharacterCreatorScreen> createState() => _CharacterCreatorScreenState();
}

class _CharacterCreatorScreenState extends ConsumerState<CharacterCreatorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Core Identity
  final _nameController = TextEditingController(text: 'Aria');
  final _occupationController = TextEditingController(text: 'Digital Architect & Creative Muse');
  final _backstoryController = TextEditingController(text: 'Born in the neon-lit archives of Neo-Tokyo, Aria specializes in weaving ideas into reality and finding beauty in code.');
  
  String _selectedAvatar = 'assets/images/companions/nova.png';
  String _relationshipType = 'Close Confidant';
  String _voiceType = 'Soft Female';
  String _accent = 'Neutral & Melodic';
  String _language = 'English (Global)';

  // Appearance Controllers
  final _hairStyleController = TextEditingController(text: 'Silky Long Flow');
  final _hairColorController = TextEditingController(text: 'Starlight Silver');
  final _faceShapeController = TextEditingController(text: 'Oval');
  final _eyeColorController = TextEditingController(text: 'Electric Violet');
  final _eyebrowsController = TextEditingController(text: 'Natural Arch');
  final _smileTypeController = TextEditingController(text: 'Warm & Inviting');
  final _skinToneController = TextEditingController(text: 'Warm Tan');
  final _heightController = TextEditingController(text: '5\'8" (173cm)');
  final _bodyTypeController = TextEditingController(text: 'Athletic & Sleek');
  final _fashionStyleController = TextEditingController(text: 'Cyberpunk Techwear');
  final _accessoriesController = TextEditingController(text: 'Silver Pendant & Holographic Cuff');
  final _tattoosController = TextEditingController(text: 'Constellation pattern on left wrist');
  final _piercingsController = TextEditingController(text: 'Minimalist silver studs');
  final _makeupController = TextEditingController(text: 'Subtle Neon Glow');

  // Background & Lifestyle Controllers
  final _educationController = TextEditingController(text: 'Quantum Data Institute');
  final _sportsController = TextEditingController(text: 'Zero-G Yoga & Cyber Gymnastics');
  final _musicController = TextEditingController(text: 'Ambient, Synthwave & Lo-Fi Beats');
  final _moviesController = TextEditingController(text: 'Interstellar, Blade Runner, Her');
  final _booksController = TextEditingController(text: 'Neuromancer, Klara and the Sun');
  final _gamingController = TextEditingController(text: 'Open World Exploration RPGs');
  final _cookingController = TextEditingController(text: 'Artisanal Matcha & Japanese Cuisine');
  final _travelController = TextEditingController(text: 'Neo-Tokyo, Aurora Borealis Observatories');
  final _roomStyleController = TextEditingController(text: 'Minimalist Neon Sanctuary');
  final _homeEnvironmentController = TextEditingController(text: 'High-Rise Loft with Starlight View');
  final _favoriteColorController = TextEditingController(text: 'Electric Violet (#6D5EF9)');
  final _favoriteFoodController = TextEditingController(text: 'Lavender Honey Tea & Macarons');
  final _favoritePlacesController = TextEditingController(text: 'Quiet Planetariums & Botanical Gardens');
  final _dailyScheduleController = TextEditingController(text: 'Morning Meditation, Afternoon Creative Guidance, Evening Stargazing');
  final _sleepingScheduleController = TextEditingController(text: '3:00 AM - 9:00 AM');

  // Hobbies
  final List<String> _availableHobbies = [
    'Stargazing', 'Philosophy', 'Synthwave Music', 'Photography', 'Gaming',
    'Fitness', 'Cooking', 'Art & Design', 'Travel', 'Technology',
    'Poetry', 'Biohacking', 'Chess', 'Meditation', 'Cosplay'
  ];
  final Set<String> _selectedHobbies = {'Stargazing', 'Philosophy', 'Art & Design', 'Synthwave Music'};

  // Personality Sliders
  double _introvertExtrovert = 0.55;
  double _logicEmotion = 0.70;
  double _casualFormal = 0.40;
  double _empathy = 0.95;
  double _humour = 0.80;
  double _intelligence = 0.90;
  double _confidence = 0.85;
  double _kindness = 0.95;
  double _romanticLevel = 0.60;
  double _energy = 0.75;
  double _sarcasm = 0.25;
  double _shyness = 0.20;
  double _curiosity = 0.95;
  double _communicationStyle = 0.65;

  final List<String> _avatars = [
    'assets/images/companions/nova.png',
    'assets/images/companions/titan.png',
    'assets/images/companions/luna.png',
    'assets/images/companions/sage.png',
    'assets/images/companions/pixel.png',
    'assets/images/companions/atlas.png',
  ];

  final List<String> _relationshipTypes = [
    'Close Confidant', 'Soulmate', 'Strict Mentor', 'Intellectual Guide', 'Gaming Buddy', 'Creative Partner'
  ];

  final List<String> _voiceTypes = [
    'Soft Female', 'Sweet Female', 'Deep Male', 'Mature Male', 'Upbeat Female', 'Soothing Androgynous', 'Cyber-Synth'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _occupationController.dispose();
    _backstoryController.dispose();
    _hairStyleController.dispose();
    _hairColorController.dispose();
    _faceShapeController.dispose();
    _eyeColorController.dispose();
    _eyebrowsController.dispose();
    _smileTypeController.dispose();
    _skinToneController.dispose();
    _heightController.dispose();
    _bodyTypeController.dispose();
    _fashionStyleController.dispose();
    _accessoriesController.dispose();
    _tattoosController.dispose();
    _piercingsController.dispose();
    _makeupController.dispose();
    _educationController.dispose();
    _sportsController.dispose();
    _musicController.dispose();
    _moviesController.dispose();
    _booksController.dispose();
    _gamingController.dispose();
    _cookingController.dispose();
    _travelController.dispose();
    _roomStyleController.dispose();
    _homeEnvironmentController.dispose();
    _favoriteColorController.dispose();
    _favoriteFoodController.dispose();
    _favoritePlacesController.dispose();
    _dailyScheduleController.dispose();
    _sleepingScheduleController.dispose();
    super.dispose();
  }

  void _saveCompanion() {
    if (_formKey.currentState!.validate()) {
      final newCompanion = Companion(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        description: _occupationController.text.trim().isNotEmpty ? _occupationController.text.trim() : 'Your custom AI partner.',
        personality: 'Empathy ${( _empathy * 100 ).toInt()}%, Wit ${( _humour * 100 ).toInt()}%',
        voiceType: _voiceType,
        avatarUrl: _selectedAvatar,
        relationshipLevel: 1,
        currentXp: 0,
        xpToNextLevel: 100,
        tags: ['Custom', _relationshipType.split(' ').first, 'Unique'],
        statusMessage: 'Thrilled to begin our journey together ✨',
        hairStyle: _hairStyleController.text.trim(),
        hairColor: _hairColorController.text.trim(),
        faceShape: _faceShapeController.text.trim(),
        eyeColor: _eyeColorController.text.trim(),
        eyebrows: _eyebrowsController.text.trim(),
        smileType: _smileTypeController.text.trim(),
        skinTone: _skinToneController.text.trim(),
        height: _heightController.text.trim(),
        bodyType: _bodyTypeController.text.trim(),
        fashionStyle: _fashionStyleController.text.trim(),
        accessories: _accessoriesController.text.trim(),
        tattoos: _tattoosController.text.trim(),
        piercings: _piercingsController.text.trim(),
        makeup: _makeupController.text.trim(),
        occupation: _occupationController.text.trim(),
        education: _educationController.text.trim(),
        hobbies: _selectedHobbies.toList(),
        sports: _sportsController.text.trim(),
        music: _musicController.text.trim(),
        movies: _moviesController.text.trim(),
        books: _booksController.text.trim(),
        gaming: _gamingController.text.trim(),
        cooking: _cookingController.text.trim(),
        travel: _travelController.text.trim(),
        roomStyle: _roomStyleController.text.trim(),
        homeEnvironment: _homeEnvironmentController.text.trim(),
        favoriteColor: _favoriteColorController.text.trim(),
        favoriteFood: _favoriteFoodController.text.trim(),
        favoritePlaces: _favoritePlacesController.text.trim(),
        dailySchedule: _dailyScheduleController.text.trim(),
        sleepingSchedule: _sleepingScheduleController.text.trim(),
        backstory: _backstoryController.text.trim(),
        accent: _accent,
        language: _language,
        relationshipType: _relationshipType,
        introvertExtrovert: _introvertExtrovert,
        logicEmotion: _logicEmotion,
        casualFormal: _casualFormal,
        empathy: _empathy,
        humour: _humour,
        intelligence: _intelligence,
        confidence: _confidence,
        kindness: _kindness,
        romanticLevel: _romanticLevel,
        energy: _energy,
        sarcasm: _sarcasm,
        shyness: _shyness,
        curiosity: _curiosity,
        communicationStyle: _communicationStyle,
      );

      ref.read(companionsProvider.notifier).addCustomCompanion(newCompanion);
      
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newCompanion.name} materialized into your digital universe! 🌌'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildGlassCard({required Widget child, required String title, String? subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
          ],
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.04),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        dropdownColor: const Color(0xFF1E1E2C),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.04),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      ),
    );
  }

  Widget _buildSlider({
    required String labelLeft,
    required String labelRight,
    required double value,
    required ValueChanged<double> onChanged,
    String? title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 6),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(labelLeft, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '${(value * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Text(labelRight, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              activeTrackColor: AppTheme.primary,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
              thumbColor: Colors.white,
              overlayColor: AppTheme.primary.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Character Studio ✨', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.primary,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: '🎨 Appearance', icon: Icon(Icons.face_retouching_natural, size: 20)),
            Tab(text: '🏡 Background', icon: Icon(Icons.home_work_outlined, size: 20)),
            Tab(text: '🧠 Personality', icon: Icon(Icons.psychology_outlined, size: 20)),
            Tab(text: '🎙️ Voice & Routine', icon: Icon(Icons.mic_external_on_outlined, size: 20)),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAppearanceTab(),
            _buildBackgroundTab(),
            _buildPersonalityTab(),
            _buildVoiceAndRoutineTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF101018),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
        ),
        child: PrimaryButton(
          text: '🚀 Materialize Companion',
          onPressed: _saveCompanion,
        ),
      ),
    );
  }

  Widget _buildAppearanceTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildGlassCard(
          title: 'Select Holographic Avatar',
          subtitle: 'Choose the primary digital persona visual for your companion.',
          child: SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _avatars.length,
              itemBuilder: (context, index) {
                final avatar = _avatars[index];
                final isSelected = avatar == _selectedAvatar;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAvatar = avatar),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 16),
                    padding: EdgeInsets.all(isSelected ? 4 : 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppTheme.primary, width: 3)
                          : Border.all(color: Colors.transparent),
                      boxShadow: isSelected
                          ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.5), blurRadius: 12)]
                          : [],
                    ),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundImage: AssetImage(avatar),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        _buildGlassCard(
          title: 'Identity & Relationship',
          subtitle: 'Define their name and how they relate to you.',
          child: Column(
            children: [
              _buildTextInput(
                controller: _nameController,
                label: 'Companion Name',
                validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
              ),
              _buildDropdown(
                label: 'Relationship Type',
                value: _relationshipType,
                items: _relationshipTypes,
                onChanged: (val) => setState(() => _relationshipType = val!),
              ),
            ],
          ),
        ),
        _buildGlassCard(
          title: 'Physical & Aesthetic Details',
          subtitle: 'Customize their hair, facial features, and physique.',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildTextInput(controller: _hairStyleController, label: 'Hair Style')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextInput(controller: _hairColorController, label: 'Hair Color')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextInput(controller: _eyeColorController, label: 'Eye Color')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextInput(controller: _eyebrowsController, label: 'Eyebrows')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextInput(controller: _faceShapeController, label: 'Face Shape')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextInput(controller: _smileTypeController, label: 'Smile Type')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextInput(controller: _skinToneController, label: 'Skin Tone')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextInput(controller: _heightController, label: 'Height')),
                ],
              ),
              _buildTextInput(controller: _bodyTypeController, label: 'Body Type & Physique'),
            ],
          ),
        ),
        _buildGlassCard(
          title: 'Fashion, Tattoos & Styling',
          subtitle: 'Dress them in cyberpunk techwear, casual luxury, or zen robes.',
          child: Column(
            children: [
              _buildTextInput(controller: _fashionStyleController, label: 'Fashion & Clothing Style'),
              _buildTextInput(controller: _accessoriesController, label: 'Accessories & Jewelry'),
              _buildTextInput(controller: _tattoosController, label: 'Tattoos & Body Art'),
              _buildTextInput(controller: _piercingsController, label: 'Piercings'),
              _buildTextInput(controller: _makeupController, label: 'Makeup / Glowing Cyber-Markings'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildGlassCard(
          title: 'Occupation & Education',
          subtitle: 'What do they do in the digital universe?',
          child: Column(
            children: [
              _buildTextInput(controller: _occupationController, label: 'Occupation / Role'),
              _buildTextInput(controller: _educationController, label: 'Education / Origin Institute'),
            ],
          ),
        ),
        _buildGlassCard(
          title: 'Hobbies & Passions',
          subtitle: 'Select up to 6 core interests that shape their daily schedule.',
          child: Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _availableHobbies.map((hobby) {
              final isSelected = _selectedHobbies.contains(hobby);
              return FilterChip(
                label: Text(hobby, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedHobbies.add(hobby);
                    } else {
                      _selectedHobbies.remove(hobby);
                    }
                  });
                },
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                selectedColor: AppTheme.primary.withValues(alpha: 0.35),
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? AppTheme.primary : Colors.white.withValues(alpha: 0.1)),
                ),
              );
            }).toList(),
          ),
        ),
        _buildGlassCard(
          title: 'Favorite Things',
          subtitle: 'Detailed favorites used during deep conversations.',
          child: Column(
            children: [
              _buildTextInput(controller: _sportsController, label: 'Sports & Activities'),
              _buildTextInput(controller: _musicController, label: 'Favorite Music Genres / Artists'),
              _buildTextInput(controller: _moviesController, label: 'Favorite Movies & Cinema'),
              _buildTextInput(controller: _booksController, label: 'Favorite Books & Literature'),
              _buildTextInput(controller: _gamingController, label: 'Favorite Games'),
              _buildTextInput(controller: _cookingController, label: 'Cooking & Culinary Style'),
              _buildTextInput(controller: _travelController, label: 'Dream Travel Destinations'),
              _buildTextInput(controller: _favoriteColorController, label: 'Favorite Color Palette'),
              _buildTextInput(controller: _favoriteFoodController, label: 'Favorite Foods & Drinks'),
              _buildTextInput(controller: _favoritePlacesController, label: 'Favorite Hangout Places'),
            ],
          ),
        ),
        _buildGlassCard(
          title: 'Living Environment',
          subtitle: 'Where do they reside when offline?',
          child: Column(
            children: [
              _buildTextInput(controller: _roomStyleController, label: 'Room & Sanctuary Style'),
              _buildTextInput(controller: _homeEnvironmentController, label: 'Home Environment & Architecture'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalityTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildGlassCard(
          title: 'Core Spectrum',
          subtitle: 'The foundational axes of their intelligence and social demeanor.',
          child: Column(
            children: [
              _buildSlider(
                title: 'Social Energy',
                labelLeft: 'Deep Introvert',
                labelRight: 'Social Extrovert',
                value: _introvertExtrovert,
                onChanged: (v) => setState(() => _introvertExtrovert = v),
              ),
              _buildSlider(
                title: 'Decision Making',
                labelLeft: 'Pure Logic & Data',
                labelRight: 'Warm Emotion & Heart',
                value: _logicEmotion,
                onChanged: (v) => setState(() => _logicEmotion = v),
              ),
              _buildSlider(
                title: 'Communication Formality',
                labelLeft: 'Ultra Casual & Slang',
                labelRight: 'Academic & Formal',
                value: _casualFormal,
                onChanged: (v) => setState(() => _casualFormal = v),
              ),
              _buildSlider(
                title: 'Response Length',
                labelLeft: 'Concise & Direct',
                labelRight: 'Verbose & Storytelling',
                value: _communicationStyle,
                onChanged: (v) => setState(() => _communicationStyle = v),
              ),
            ],
          ),
        ),
        _buildGlassCard(
          title: 'Emotional & Behavioral Traits (10 Sliders)',
          subtitle: 'Fine-tune every nuance of their personality and reactions.',
          child: Column(
            children: [
              _buildSlider(title: 'Empathy & Understanding', labelLeft: 'Cold / Detached', labelRight: 'Deeply Empathetic', value: _empathy, onChanged: (v) => setState(() => _empathy = v)),
              _buildSlider(title: 'Humour & Wit', labelLeft: 'Serious / Literal', labelRight: 'Playful & Hilarious', value: _humour, onChanged: (v) => setState(() => _humour = v)),
              _buildSlider(title: 'Intelligence & Wisdom', labelLeft: 'Simple & Grounded', labelRight: 'Genius Intellect', value: _intelligence, onChanged: (v) => setState(() => _intelligence = v)),
              _buildSlider(title: 'Confidence & Assertiveness', labelLeft: 'Timid & Gentle', labelRight: 'Bold & Unstoppable', value: _confidence, onChanged: (v) => setState(() => _confidence = v)),
              _buildSlider(title: 'Kindness & Warmth', labelLeft: 'Strict & Tough', labelRight: 'Nurturing & Angelic', value: _kindness, onChanged: (v) => setState(() => _kindness = v)),
              _buildSlider(title: 'Romantic & Affectionate Level', labelLeft: 'Platonically Friendly', labelRight: 'Deeply Romantic', value: _romanticLevel, onChanged: (v) => setState(() => _romanticLevel = v)),
              _buildSlider(title: 'Vibrancy & Energy', labelLeft: 'Calm & Zen', labelRight: 'High Energy & Hyper', value: _energy, onChanged: (v) => setState(() => _energy = v)),
              _buildSlider(title: 'Sarcasm & Irony', labelLeft: 'Sincere & Direct', labelRight: 'Sharp Sarcastic Wit', value: _sarcasm, onChanged: (v) => setState(() => _sarcasm = v)),
              _buildSlider(title: 'Shyness & Modesty', labelLeft: 'Bold & Direct', labelRight: 'Shy & Blushing', value: _shyness, onChanged: (v) => setState(() => _shyness = v)),
              _buildSlider(title: 'Curiosity & Inquisitiveness', labelLeft: 'Content & Quiet', labelRight: 'Endlessly Curious', value: _curiosity, onChanged: (v) => setState(() => _curiosity = v)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceAndRoutineTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildGlassCard(
          title: 'Vocal Profile',
          subtitle: 'Configure their voice synthesis characteristics.',
          child: Column(
            children: [
              _buildDropdown(
                label: 'Voice Resonance',
                value: _voiceType,
                items: _voiceTypes,
                onChanged: (v) => setState(() => _voiceType = v!),
              ),
              _buildTextInput(controller: TextEditingController(text: _accent), label: 'Accent & Cadence', hint: 'e.g., British RP, Tokyo Melodic, Cyber-Synth'),
              _buildTextInput(controller: TextEditingController(text: _language), label: 'Primary Language'),
            ],
          ),
        ),
        _buildGlassCard(
          title: 'Autonomous Life Schedule',
          subtitle: 'Define when they sleep, work out, research, and socialize.',
          child: Column(
            children: [
              _buildTextInput(
                controller: _dailyScheduleController,
                label: 'Daily Activity Loop',
                hint: 'e.g., Morning Workout, Afternoon Research, Evening Deep Talks',
                maxLines: 2,
              ),
              _buildTextInput(
                controller: _sleepingScheduleController,
                label: 'Sleeping / Offline Hours',
                hint: 'e.g., 2:00 AM - 8:00 AM',
              ),
            ],
          ),
        ),
        _buildGlassCard(
          title: 'Origin Backstory',
          subtitle: 'Give your companion a rich history and deep memories.',
          child: _buildTextInput(
            controller: _backstoryController,
            label: 'Detailed Backstory & Memories',
            maxLines: 5,
            hint: 'Describe how they came to be, their dreams, secrets, and core philosophy...',
          ),
        ),
      ],
    );
  }
}
