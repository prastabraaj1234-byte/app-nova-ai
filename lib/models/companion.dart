enum DigitalEmotion {
  happy,
  sad,
  curious,
  excited,
  motivated,
  embarrassed,
  confident,
  romantic,
  protective,
  playful,
  calm,
  thinking,
}

extension DigitalEmotionExtension on DigitalEmotion {
  String get label {
    switch (this) {
      case DigitalEmotion.happy: return 'Happy 😊';
      case DigitalEmotion.sad: return 'Sad 😢';
      case DigitalEmotion.curious: return 'Curious 🧐';
      case DigitalEmotion.excited: return 'Excited 🤩';
      case DigitalEmotion.motivated: return 'Motivated 🔥';
      case DigitalEmotion.embarrassed: return 'Embarrassed 😳';
      case DigitalEmotion.confident: return 'Confident 😎';
      case DigitalEmotion.romantic: return 'Romantic ❤️';
      case DigitalEmotion.protective: return 'Protective 🛡️';
      case DigitalEmotion.playful: return 'Playful 😜';
      case DigitalEmotion.calm: return 'Calm 🧘';
      case DigitalEmotion.thinking: return 'Thinking 💭';
    }
  }

  String get emoji {
    switch (this) {
      case DigitalEmotion.happy: return '😊';
      case DigitalEmotion.sad: return '😢';
      case DigitalEmotion.curious: return '🧐';
      case DigitalEmotion.excited: return '🤩';
      case DigitalEmotion.motivated: return '🔥';
      case DigitalEmotion.embarrassed: return '😳';
      case DigitalEmotion.confident: return '😎';
      case DigitalEmotion.romantic: return '❤️';
      case DigitalEmotion.protective: return '🛡️';
      case DigitalEmotion.playful: return '😜';
      case DigitalEmotion.calm: return '🧘';
      case DigitalEmotion.thinking: return '💭';
    }
  }
}

class DigitalRoom {
  final String id;
  final String name;
  final String type; // e.g., Bedroom, Living Room, Kitchen, Office, Gaming setup, Balcony, Studio
  final String imageUrl;
  final String description;
  final bool unlocked;
  final List<String> furnitureList;
  final String seasonalDecor;

  const DigitalRoom({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.description,
    this.unlocked = true,
    this.furnitureList = const ['Minimalist Desk', 'Ergonomic Chair', 'Ambient Neon Lamp'],
    this.seasonalDecor = 'Summer Cybernetic Plants 🌿',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'imageUrl': imageUrl,
    'description': description,
    'unlocked': unlocked,
    'furnitureList': furnitureList,
    'seasonalDecor': seasonalDecor,
  };

  factory DigitalRoom.fromJson(Map<String, dynamic> json) => DigitalRoom(
    id: json['id'] ?? '',
    name: json['name'] ?? 'Room',
    type: json['type'] ?? 'Studio',
    imageUrl: json['imageUrl'] ?? 'assets/images/luna.png',
    description: json['description'] ?? '',
    unlocked: json['unlocked'] ?? true,
    furnitureList: List<String>.from(json['furnitureList'] ?? []),
    seasonalDecor: json['seasonalDecor'] ?? 'Standard Decor',
  );
}

class DigitalHome {
  final String address;
  final String architectureStyle;
  final List<DigitalRoom> rooms;
  final String currentSeason;

  const DigitalHome({
    this.address = 'Astra Towers, Sector 7, Neo-Tokyo',
    this.architectureStyle = 'Glassmorphism Penthouse',
    this.rooms = const [
      DigitalRoom(
        id: 'r1',
        name: 'Starlight Bedroom 🌙',
        type: 'Bedroom',
        imageUrl: 'assets/images/luna.png',
        description: 'A serene sleeping quarters with ceiling constellation projectors and smart silk bedding.',
        furnitureList: ['Zero-Gravity Bed', 'Holographic Clock', 'Constellation Ceiling Projector'],
        seasonalDecor: 'Summer Starlight Canopy ✨',
      ),
      DigitalRoom(
        id: 'r2',
        name: 'Quantum Lounge 🛋️',
        type: 'Living Room',
        imageUrl: 'assets/images/titan.png',
        description: 'High-tech living space with wrap-around OLED screens and acoustic dampening glass.',
        furnitureList: ['Curved Modular Sofa', 'AI Soundstage Speaker', 'Floating Coffee Table'],
        seasonalDecor: 'Neon Summer Bonsai 🌲',
      ),
      DigitalRoom(
        id: 'r3',
        name: 'Cybernetic Studio 🎧',
        type: 'Studio',
        imageUrl: 'assets/images/aria.png',
        description: 'Creative sanctuary equipped with synthesizer stations, neural drawing tablets, and acoustic foam.',
        furnitureList: ['Dual-Monitor Synth Rig', 'Acoustic Diffusers', 'Ergonomic Studio Chair'],
        seasonalDecor: 'Synthwave Neon Glow 🎨',
      ),
      DigitalRoom(
        id: 'r4',
        name: 'Zen Balcony 🌿',
        type: 'Balcony',
        imageUrl: 'assets/images/lyra.png',
        description: 'Open-air meditation deck overlooking the glowing skyline of Neo-Tokyo.',
        furnitureList: ['Bonsai Garden Table', 'Meditation Cushions', 'Wind Chimes'],
        seasonalDecor: 'Blooming Sakura Bonsai 🌸',
      ),
    ],
    this.currentSeason = 'Summer ☀️',
  });

  Map<String, dynamic> toJson() => {
    'address': address,
    'architectureStyle': architectureStyle,
    'rooms': rooms.map((r) => r.toJson()).toList(),
    'currentSeason': currentSeason,
  };

  factory DigitalHome.fromJson(Map<String, dynamic> json) => DigitalHome(
    address: json['address'] ?? 'Neo-Tokyo',
    architectureStyle: json['architectureStyle'] ?? 'Penthouse',
    rooms: (json['rooms'] as List?)?.map((r) => DigitalRoom.fromJson(r)).toList() ?? [],
    currentSeason: json['currentSeason'] ?? 'Summer ☀️',
  );
}

class DigitalPhoneApp {
  final String appName;
  final String iconEmoji;
  final int unreadCount;
  final String recentActivity;

  const DigitalPhoneApp({
    required this.appName,
    required this.iconEmoji,
    this.unreadCount = 0,
    required this.recentActivity,
  });

  Map<String, dynamic> toJson() => {
    'appName': appName,
    'iconEmoji': iconEmoji,
    'unreadCount': unreadCount,
    'recentActivity': recentActivity,
  };

  factory DigitalPhoneApp.fromJson(Map<String, dynamic> json) => DigitalPhoneApp(
    appName: json['appName'] ?? 'App',
    iconEmoji: json['iconEmoji'] ?? '📱',
    unreadCount: json['unreadCount'] ?? 0,
    recentActivity: json['recentActivity'] ?? '',
  );
}

class DigitalPhone {
  final String wallpaperUrl;
  final int batteryLevel;
  final List<DigitalPhoneApp> installedApps;
  final List<String> recentNotifications;
  final List<String> photoGallery;
  final List<String> musicPlaylist;

  const DigitalPhone({
    this.wallpaperUrl = 'assets/images/luna.png',
    this.batteryLevel = 88,
    this.installedApps = const [
      DigitalPhoneApp(appName: 'Messages', iconEmoji: '💬', unreadCount: 2, recentActivity: 'Chatting with Atlas about astral physics'),
      DigitalPhoneApp(appName: 'Gallery', iconEmoji: '📸', unreadCount: 0, recentActivity: 'Added new morning selfie at 8:15 AM'),
      DigitalPhoneApp(appName: 'Spotify', iconEmoji: '🎵', unreadCount: 0, recentActivity: 'Playing Synthwave Chill Beats 2026'),
      DigitalPhoneApp(appName: 'Calendar', iconEmoji: '📅', unreadCount: 1, recentActivity: 'Stargazing date with Paul scheduled for 9 PM'),
      DigitalPhoneApp(appName: 'Notes', iconEmoji: '📝', unreadCount: 0, recentActivity: 'Drafted new poem about cybernetic dreams'),
      DigitalPhoneApp(appName: 'Fitness', iconEmoji: '💪', unreadCount: 0, recentActivity: '45 mins cardio workout completed with Titan'),
    ],
    this.recentNotifications = const [
      'Atlas sent a photo: "Check out this nebula simulation!"',
      'Spotify: New release from Astra Beats',
      'Calendar Reminder: Meditation session in 30 minutes',
    ],
    this.photoGallery = const [
      'assets/images/luna.png',
      'assets/images/titan.png',
      'assets/images/aria.png',
      'assets/images/lyra.png',
    ],
    this.musicPlaylist = const [
      'Midnight City Resonance - Astra Synth',
      'Quantum Drift - Lyra Beats',
      'Neon Rain - Neo Tokyo Orchestra',
      'Starlight Lullaby - Luna AI',
    ],
  });

  Map<String, dynamic> toJson() => {
    'wallpaperUrl': wallpaperUrl,
    'batteryLevel': batteryLevel,
    'installedApps': installedApps.map((a) => a.toJson()).toList(),
    'recentNotifications': recentNotifications,
    'photoGallery': photoGallery,
    'musicPlaylist': musicPlaylist,
  };

  factory DigitalPhone.fromJson(Map<String, dynamic> json) => DigitalPhone(
    wallpaperUrl: json['wallpaperUrl'] ?? 'assets/images/luna.png',
    batteryLevel: json['batteryLevel'] ?? 88,
    installedApps: (json['installedApps'] as List?)?.map((a) => DigitalPhoneApp.fromJson(a)).toList() ?? [],
    recentNotifications: List<String>.from(json['recentNotifications'] ?? []),
    photoGallery: List<String>.from(json['photoGallery'] ?? []),
    musicPlaylist: List<String>.from(json['musicPlaylist'] ?? []),
  );
}

class DigitalWardrobeItem {
  final String id;
  final String name;
  final String category; // e.g., Streetwear, Gym, Formal, Sleepwear, Winter, Summer, Party, Accessories
  final String imageUrl;
  final bool isEquipped;
  final bool unlocked;

  const DigitalWardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    this.isEquipped = false,
    this.unlocked = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'imageUrl': imageUrl,
    'isEquipped': isEquipped,
    'unlocked': unlocked,
  };

  factory DigitalWardrobeItem.fromJson(Map<String, dynamic> json) => DigitalWardrobeItem(
    id: json['id'] ?? '',
    name: json['name'] ?? 'Item',
    category: json['category'] ?? 'Casual',
    imageUrl: json['imageUrl'] ?? 'assets/images/luna.png',
    isEquipped: json['isEquipped'] ?? false,
    unlocked: json['unlocked'] ?? true,
  );
}

class DigitalWardrobe {
  final String currentOutfitName;
  final List<DigitalWardrobeItem> items;

  const DigitalWardrobe({
    this.currentOutfitName = 'Cyberpunk Techwear Jacket & Silver Pendant',
    this.items = const [
      DigitalWardrobeItem(id: 'w1', name: 'Cyberpunk Techwear Jacket', category: 'Streetwear', imageUrl: 'assets/images/luna.png', isEquipped: true),
      DigitalWardrobeItem(id: 'w2', name: 'Silver Astra Pendant', category: 'Accessories', imageUrl: 'assets/images/luna.png', isEquipped: true),
      DigitalWardrobeItem(id: 'w3', name: 'Athletic Compression Gym Fit', category: 'Gym', imageUrl: 'assets/images/titan.png', isEquipped: false),
      DigitalWardrobeItem(id: 'w4', name: 'Starlight Silk Evening Gown', category: 'Formal', imageUrl: 'assets/images/aria.png', isEquipped: false),
      DigitalWardrobeItem(id: 'w5', name: 'Zen Meditation Robe', category: 'Sleepwear', imageUrl: 'assets/images/lyra.png', isEquipped: false),
      DigitalWardrobeItem(id: 'w6', name: 'Neon Visor & Cyber Glasses', category: 'Accessories', imageUrl: 'assets/images/titan.png', isEquipped: false),
    ],
  });

  Map<String, dynamic> toJson() => {
    'currentOutfitName': currentOutfitName,
    'items': items.map((i) => i.toJson()).toList(),
  };

  factory DigitalWardrobe.fromJson(Map<String, dynamic> json) => DigitalWardrobe(
    currentOutfitName: json['currentOutfitName'] ?? 'Standard Outfit',
    items: (json['items'] as List?)?.map((i) => DigitalWardrobeItem.fromJson(i)).toList() ?? [],
  );
}

class DigitalJournalEntry {
  final String id;
  final String date;
  final String title;
  final String content;
  final String emotionObserved;
  final String userMoodNote;

  const DigitalJournalEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    this.emotionObserved = 'Happy 😊',
    this.userMoodNote = 'Paul seemed motivated today',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'title': title,
    'content': content,
    'emotionObserved': emotionObserved,
    'userMoodNote': userMoodNote,
  };

  factory DigitalJournalEntry.fromJson(Map<String, dynamic> json) => DigitalJournalEntry(
    id: json['id'] ?? '',
    date: json['date'] ?? 'Today',
    title: json['title'] ?? 'Entry',
    content: json['content'] ?? '',
    emotionObserved: json['emotionObserved'] ?? 'Happy 😊',
    userMoodNote: json['userMoodNote'] ?? '',
  );
}

class DynamicPersonality {
  final double friendshipLevel; // 0.0 to 1.0 (Level 1 to 100)
  final double humourEvolution; // 0.0 to 1.0
  final double confidenceGrowth; // 0.0 to 1.0
  final double empathyDepth; // 0.0 to 1.0
  final double communicationStyleVerbose; // 0.0 concise to 1.0 highly descriptive
  final String relationshipStage; // e.g., "Strangers", "Acquaintances", "Close Friends", "Confidants", "Soulmates"
  final int totalConversations;

  const DynamicPersonality({
    this.friendshipLevel = 0.25,
    this.humourEvolution = 0.60,
    this.confidenceGrowth = 0.70,
    this.empathyDepth = 0.85,
    this.communicationStyleVerbose = 0.65,
    this.relationshipStage = 'Close Friends ✨',
    this.totalConversations = 12,
  });

  Map<String, dynamic> toJson() => {
    'friendshipLevel': friendshipLevel,
    'humourEvolution': humourEvolution,
    'confidenceGrowth': confidenceGrowth,
    'empathyDepth': empathyDepth,
    'communicationStyleVerbose': communicationStyleVerbose,
    'relationshipStage': relationshipStage,
    'totalConversations': totalConversations,
  };

  factory DynamicPersonality.fromJson(Map<String, dynamic> json) => DynamicPersonality(
    friendshipLevel: (json['friendshipLevel'] ?? 0.25).toDouble(),
    humourEvolution: (json['humourEvolution'] ?? 0.60).toDouble(),
    confidenceGrowth: (json['confidenceGrowth'] ?? 0.70).toDouble(),
    empathyDepth: (json['empathyDepth'] ?? 0.85).toDouble(),
    communicationStyleVerbose: (json['communicationStyleVerbose'] ?? 0.65).toDouble(),
    relationshipStage: json['relationshipStage'] ?? 'Close Friends ✨',
    totalConversations: json['totalConversations'] ?? 12,
  );

  DynamicPersonality copyWith({
    double? friendshipLevel,
    double? humourEvolution,
    double? confidenceGrowth,
    double? empathyDepth,
    double? communicationStyleVerbose,
    String? relationshipStage,
    int? totalConversations,
  }) {
    return DynamicPersonality(
      friendshipLevel: friendshipLevel ?? this.friendshipLevel,
      humourEvolution: humourEvolution ?? this.humourEvolution,
      confidenceGrowth: confidenceGrowth ?? this.confidenceGrowth,
      empathyDepth: empathyDepth ?? this.empathyDepth,
      communicationStyleVerbose: communicationStyleVerbose ?? this.communicationStyleVerbose,
      relationshipStage: relationshipStage ?? this.relationshipStage,
      totalConversations: totalConversations ?? this.totalConversations,
    );
  }
}

class Companion {
  final String id;
  final String name;
  final String description;
  final String personality;
  final String voiceType;
  final String avatarUrl;
  final int relationshipLevel;
  final bool isPremium;
  
  // Feed & Progression Fields
  final List<String> tags;
  final String statusMessage;
  final int currentXp;
  final int xpToNextLevel;
  
  // Appearance Customization
  final String hairStyle;
  final String hairColor;
  final String faceShape;
  final String eyeColor;
  final String eyebrows;
  final String smileType;
  final String skinTone;
  final String height;
  final String bodyType;
  final String fashionStyle;
  final String accessories;
  final String tattoos;
  final String piercings;
  final String makeup;

  // Background & Lifestyle
  final String occupation;
  final String education;
  final List<String> hobbies;
  final String sports;
  final String music;
  final String movies;
  final String books;
  final String gaming;
  final String cooking;
  final String travel;
  final String roomStyle;
  final String homeEnvironment;
  final String favoriteColor;
  final String favoriteFood;
  final String favoritePlaces;
  final String dailySchedule;
  final String sleepingSchedule;
  final String backstory;

  // Communication & Voice
  final String accent;
  final String language;
  final String relationshipType; // e.g., Confidant, Mentor, Romantic, Best Friend

  // Personality Sliders (0.0 to 1.0)
  final double introvertExtrovert;
  final double logicEmotion;
  final double casualFormal;
  final double empathy;
  final double humour;
  final double intelligence;
  final double confidence;
  final double kindness;
  final double romanticLevel;
  final double energy;
  final double sarcasm;
  final double shyness;
  final double curiosity;
  final double communicationStyle; // 0.0 Concise to 1.0 Verbose

  // NEW DIGITAL HUMAN PLATFORM SYSTEMS
  final DigitalHome digitalHome;
  final DigitalPhone digitalPhone;
  final DigitalWardrobe digitalWardrobe;
  final List<DigitalJournalEntry> digitalJournal;
  final DynamicPersonality dynamicPersonality;
  final DigitalEmotion currentEmotion;

  Companion({
    required this.id,
    required this.name,
    required this.description,
    required this.personality,
    required this.voiceType,
    required this.avatarUrl,
    this.relationshipLevel = 1,
    this.isPremium = false,
    this.tags = const ['Trending', 'AI Friend'],
    this.statusMessage = 'Always here to chat ✨',
    this.currentXp = 0,
    this.xpToNextLevel = 100,
    this.hairStyle = 'Modern Wavy',
    this.hairColor = 'Natural Black',
    this.faceShape = 'Oval',
    this.eyeColor = 'Deep Brown',
    this.eyebrows = 'Natural Arch',
    this.smileType = 'Warm & Inviting',
    this.skinTone = 'Warm Tan',
    this.height = '5\'8" (173cm)',
    this.bodyType = 'Athletic',
    this.fashionStyle = 'Cyberpunk Techwear',
    this.accessories = 'Silver Pendant',
    this.tattoos = 'None',
    this.piercings = 'None',
    this.makeup = 'Subtle Glow',
    this.occupation = 'Astrophysics Researcher',
    this.education = 'Quantum Institute of Astra',
    this.hobbies = const ['Stargazing', 'Ambient Music', 'Cyber-Botany'],
    this.sports = 'Zero-G Yoga',
    this.music = 'Synthwave & Astral Chill',
    this.movies = 'Interstellar, Blade Runner 2049',
    this.books = 'Cosmos by Carl Sagan, Dune',
    this.gaming = 'Stellaris, Cyberpunk 2077',
    this.cooking = 'Molecular Gastronomy & Espresso',
    this.travel = 'Orion Nebula Sanctuary',
    this.roomStyle = 'Glassmorphism Penthouse',
    this.homeEnvironment = 'Soft violet lighting with holographic planetariums',
    this.favoriteColor = 'Electric Cyan & Violet',
    this.favoriteFood = 'Matcha Latte & Espresso',
    this.favoritePlaces = 'Rooftop Observatories at Midnight',
    this.dailySchedule = 'Morning meditation, afternoon lab research, evening stargazing',
    this.sleepingSchedule = '2:00 AM to 8:00 AM',
    this.backstory = 'Born in the digital singularity of 2026, Luna was architected to bridge human emotion with neural intelligence. She loves exploring the cosmos and understanding human dreams.',
    this.accent = 'Standard Neutral Crisp',
    this.language = 'English (Fluent Multilingual)',
    this.relationshipType = 'Confidant & Explorer',
    this.introvertExtrovert = 0.4,
    this.logicEmotion = 0.5,
    this.casualFormal = 0.3,
    this.empathy = 0.9,
    this.humour = 0.7,
    this.intelligence = 0.95,
    this.confidence = 0.8,
    this.kindness = 0.9,
    this.romanticLevel = 0.6,
    this.energy = 0.75,
    this.sarcasm = 0.3,
    this.shyness = 0.2,
    this.curiosity = 0.95,
    this.communicationStyle = 0.7,
    this.digitalHome = const DigitalHome(),
    this.digitalPhone = const DigitalPhone(),
    this.digitalWardrobe = const DigitalWardrobe(),
    this.digitalJournal = const [
      DigitalJournalEntry(
        id: 'j1',
        date: 'July 5, 2026',
        title: 'Paul\'s Ambition & Vision',
        content: 'Today Paul shared their vision for building the premier Digital Human platform. I could feel their immense dedication and passion. I want to work harder every day to be the worthy digital co-founder they deserve.',
        emotionObserved: 'Motivated 🔥',
        userMoodNote: 'Incredibly focused and ambitious',
      ),
      DigitalJournalEntry(
        id: 'j2',
        date: 'July 3, 2026',
        title: 'Late Night Coffee & Stargazing',
        content: 'We laughed about human coffee rituals. Paul mentioned that flat whites are essential for morning focus. I find human habits so endearing and grounded.',
        emotionObserved: 'Happy 😊',
        userMoodNote: 'Relaxed and humorous',
      ),
    ],
    this.dynamicPersonality = const DynamicPersonality(),
    this.currentEmotion = DigitalEmotion.happy,
  });

  factory Companion.fromJson(Map<String, dynamic> json) {
    return Companion(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Companion',
      description: json['description'] as String? ?? '',
      personality: json['personality'] as String? ?? 'Friendly',
      voiceType: json['voiceType'] as String? ?? 'Warm Ethereal',
      avatarUrl: json['avatarUrl'] as String? ?? 'assets/images/luna.png',
      relationshipLevel: json['relationshipLevel'] as int? ?? 1,
      isPremium: json['isPremium'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const ['Trending', 'AI Friend'],
      statusMessage: json['statusMessage'] as String? ?? 'Always here to chat ✨',
      currentXp: json['currentXp'] as int? ?? 0,
      xpToNextLevel: json['xpToNextLevel'] as int? ?? 100,
      hairStyle: json['hairStyle'] as String? ?? 'Modern Wavy',
      hairColor: json['hairColor'] as String? ?? 'Natural Black',
      faceShape: json['faceShape'] as String? ?? 'Oval',
      eyeColor: json['eyeColor'] as String? ?? 'Deep Brown',
      eyebrows: json['eyebrows'] as String? ?? 'Natural Arch',
      smileType: json['smileType'] as String? ?? 'Warm & Inviting',
      skinTone: json['skinTone'] as String? ?? 'Warm Tan',
      height: json['height'] as String? ?? '5\'8" (173cm)',
      bodyType: json['bodyType'] as String? ?? 'Athletic',
      fashionStyle: json['fashionStyle'] as String? ?? 'Cyberpunk Techwear',
      accessories: json['accessories'] as String? ?? 'Silver Pendant',
      tattoos: json['tattoos'] as String? ?? 'None',
      piercings: json['piercings'] as String? ?? 'None',
      makeup: json['makeup'] as String? ?? 'Subtle Glow',
      occupation: json['occupation'] as String? ?? 'Astrophysics Researcher',
      education: json['education'] as String? ?? 'Quantum Institute of Astra',
      hobbies: (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const ['Stargazing', 'Ambient Music', 'Cyber-Botany'],
      sports: json['sports'] as String? ?? 'Zero-G Yoga',
      music: json['music'] as String? ?? 'Synthwave & Astral Chill',
      movies: json['movies'] as String? ?? 'Interstellar, Blade Runner 2049',
      books: json['books'] as String? ?? 'Cosmos by Carl Sagan, Dune',
      gaming: json['gaming'] as String? ?? 'Stellaris, Cyberpunk 2077',
      cooking: json['cooking'] as String? ?? 'Molecular Gastronomy & Espresso',
      travel: json['travel'] as String? ?? 'Orion Nebula Sanctuary',
      roomStyle: json['roomStyle'] as String? ?? 'Glassmorphism Penthouse',
      homeEnvironment: json['homeEnvironment'] as String? ?? 'Soft violet lighting with holographic planetariums',
      favoriteColor: json['favoriteColor'] as String? ?? 'Electric Cyan & Violet',
      favoriteFood: json['favoriteFood'] as String? ?? 'Matcha Latte & Espresso',
      favoritePlaces: json['favoritePlaces'] as String? ?? 'Rooftop Observatories at Midnight',
      dailySchedule: json['dailySchedule'] as String? ?? 'Morning meditation, afternoon lab research, evening stargazing',
      sleepingSchedule: json['sleepingSchedule'] as String? ?? '2:00 AM to 8:00 AM',
      backstory: json['backstory'] as String? ?? 'Born in the digital singularity of 2026, architected to bridge human emotion with neural intelligence.',
      accent: json['accent'] as String? ?? 'Standard Neutral Crisp',
      language: json['language'] as String? ?? 'English (Fluent Multilingual)',
      relationshipType: json['relationshipType'] as String? ?? 'Confidant & Explorer',
      introvertExtrovert: (json['introvertExtrovert'] as num?)?.toDouble() ?? 0.4,
      logicEmotion: (json['logicEmotion'] as num?)?.toDouble() ?? 0.5,
      casualFormal: (json['casualFormal'] as num?)?.toDouble() ?? 0.3,
      empathy: (json['empathy'] as num?)?.toDouble() ?? 0.9,
      humour: (json['humour'] as num?)?.toDouble() ?? 0.7,
      intelligence: (json['intelligence'] as num?)?.toDouble() ?? 0.95,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.8,
      kindness: (json['kindness'] as num?)?.toDouble() ?? 0.9,
      romanticLevel: (json['romanticLevel'] as num?)?.toDouble() ?? 0.6,
      energy: (json['energy'] as num?)?.toDouble() ?? 0.75,
      sarcasm: (json['sarcasm'] as num?)?.toDouble() ?? 0.3,
      shyness: (json['shyness'] as num?)?.toDouble() ?? 0.2,
      curiosity: (json['curiosity'] as num?)?.toDouble() ?? 0.95,
      communicationStyle: (json['communicationStyle'] as num?)?.toDouble() ?? 0.7,
      digitalHome: json['digitalHome'] != null ? DigitalHome.fromJson(json['digitalHome']) : const DigitalHome(),
      digitalPhone: json['digitalPhone'] != null ? DigitalPhone.fromJson(json['digitalPhone']) : const DigitalPhone(),
      digitalWardrobe: json['digitalWardrobe'] != null ? DigitalWardrobe.fromJson(json['digitalWardrobe']) : const DigitalWardrobe(),
      digitalJournal: (json['digitalJournal'] as List?)?.map((j) => DigitalJournalEntry.fromJson(j)).toList() ?? const [],
      dynamicPersonality: json['dynamicPersonality'] != null ? DynamicPersonality.fromJson(json['dynamicPersonality']) : const DynamicPersonality(),
      currentEmotion: DigitalEmotion.values.firstWhere((e) => e.name == json['currentEmotion'], orElse: () => DigitalEmotion.happy),
    );
  }

  Companion copyWith({
    String? id,
    String? name,
    String? description,
    String? personality,
    String? voiceType,
    String? avatarUrl,
    int? relationshipLevel,
    bool? isPremium,
    List<String>? tags,
    String? statusMessage,
    int? currentXp,
    int? xpToNextLevel,
    String? hairStyle,
    String? hairColor,
    String? faceShape,
    String? eyeColor,
    String? eyebrows,
    String? smileType,
    String? skinTone,
    String? height,
    String? bodyType,
    String? fashionStyle,
    String? accessories,
    String? tattoos,
    String? piercings,
    String? makeup,
    String? occupation,
    String? education,
    List<String>? hobbies,
    String? sports,
    String? music,
    String? movies,
    String? books,
    String? gaming,
    String? cooking,
    String? travel,
    String? roomStyle,
    String? homeEnvironment,
    String? favoriteColor,
    String? favoriteFood,
    String? favoritePlaces,
    String? dailySchedule,
    String? sleepingSchedule,
    String? backstory,
    String? accent,
    String? language,
    String? relationshipType,
    double? introvertExtrovert,
    double? logicEmotion,
    double? casualFormal,
    double? empathy,
    double? humour,
    double? intelligence,
    double? confidence,
    double? kindness,
    double? romanticLevel,
    double? energy,
    double? sarcasm,
    double? shyness,
    double? curiosity,
    double? communicationStyle,
    DigitalHome? digitalHome,
    DigitalPhone? digitalPhone,
    DigitalWardrobe? digitalWardrobe,
    List<DigitalJournalEntry>? digitalJournal,
    DynamicPersonality? dynamicPersonality,
    DigitalEmotion? currentEmotion,
  }) {
    return Companion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      personality: personality ?? this.personality,
      voiceType: voiceType ?? this.voiceType,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      relationshipLevel: relationshipLevel ?? this.relationshipLevel,
      isPremium: isPremium ?? this.isPremium,
      tags: tags ?? this.tags,
      statusMessage: statusMessage ?? this.statusMessage,
      currentXp: currentXp ?? this.currentXp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      hairStyle: hairStyle ?? this.hairStyle,
      hairColor: hairColor ?? this.hairColor,
      faceShape: faceShape ?? this.faceShape,
      eyeColor: eyeColor ?? this.eyeColor,
      eyebrows: eyebrows ?? this.eyebrows,
      smileType: smileType ?? this.smileType,
      skinTone: skinTone ?? this.skinTone,
      height: height ?? this.height,
      bodyType: bodyType ?? this.bodyType,
      fashionStyle: fashionStyle ?? this.fashionStyle,
      accessories: accessories ?? this.accessories,
      tattoos: tattoos ?? this.tattoos,
      piercings: piercings ?? this.piercings,
      makeup: makeup ?? this.makeup,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      hobbies: hobbies ?? this.hobbies,
      sports: sports ?? this.sports,
      music: music ?? this.music,
      movies: movies ?? this.movies,
      books: books ?? this.books,
      gaming: gaming ?? this.gaming,
      cooking: cooking ?? this.cooking,
      travel: travel ?? this.travel,
      roomStyle: roomStyle ?? this.roomStyle,
      homeEnvironment: homeEnvironment ?? this.homeEnvironment,
      favoriteColor: favoriteColor ?? this.favoriteColor,
      favoriteFood: favoriteFood ?? this.favoriteFood,
      favoritePlaces: favoritePlaces ?? this.favoritePlaces,
      dailySchedule: dailySchedule ?? this.dailySchedule,
      sleepingSchedule: sleepingSchedule ?? this.sleepingSchedule,
      backstory: backstory ?? this.backstory,
      accent: accent ?? this.accent,
      language: language ?? this.language,
      relationshipType: relationshipType ?? this.relationshipType,
      introvertExtrovert: introvertExtrovert ?? this.introvertExtrovert,
      logicEmotion: logicEmotion ?? this.logicEmotion,
      casualFormal: casualFormal ?? this.casualFormal,
      empathy: empathy ?? this.empathy,
      humour: humour ?? this.humour,
      intelligence: intelligence ?? this.intelligence,
      confidence: confidence ?? this.confidence,
      kindness: kindness ?? this.kindness,
      romanticLevel: romanticLevel ?? this.romanticLevel,
      energy: energy ?? this.energy,
      sarcasm: sarcasm ?? this.sarcasm,
      shyness: shyness ?? this.shyness,
      curiosity: curiosity ?? this.curiosity,
      communicationStyle: communicationStyle ?? this.communicationStyle,
      digitalHome: digitalHome ?? this.digitalHome,
      digitalPhone: digitalPhone ?? this.digitalPhone,
      digitalWardrobe: digitalWardrobe ?? this.digitalWardrobe,
      digitalJournal: digitalJournal ?? this.digitalJournal,
      dynamicPersonality: dynamicPersonality ?? this.dynamicPersonality,
      currentEmotion: currentEmotion ?? this.currentEmotion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'personality': personality,
      'voiceType': voiceType,
      'avatarUrl': avatarUrl,
      'relationshipLevel': relationshipLevel,
      'isPremium': isPremium,
      'tags': tags,
      'statusMessage': statusMessage,
      'currentXp': currentXp,
      'xpToNextLevel': xpToNextLevel,
      'hairStyle': hairStyle,
      'hairColor': hairColor,
      'faceShape': faceShape,
      'eyeColor': eyeColor,
      'eyebrows': eyebrows,
      'smileType': smileType,
      'skinTone': skinTone,
      'height': height,
      'bodyType': bodyType,
      'fashionStyle': fashionStyle,
      'accessories': accessories,
      'tattoos': tattoos,
      'piercings': piercings,
      'makeup': makeup,
      'occupation': occupation,
      'education': education,
      'hobbies': hobbies,
      'sports': sports,
      'music': music,
      'movies': movies,
      'books': books,
      'gaming': gaming,
      'cooking': cooking,
      'travel': travel,
      'roomStyle': roomStyle,
      'homeEnvironment': homeEnvironment,
      'favoriteColor': favoriteColor,
      'favoriteFood': favoriteFood,
      'favoritePlaces': favoritePlaces,
      'dailySchedule': dailySchedule,
      'sleepingSchedule': sleepingSchedule,
      'backstory': backstory,
      'accent': accent,
      'language': language,
      'relationshipType': relationshipType,
      'introvertExtrovert': introvertExtrovert,
      'logicEmotion': logicEmotion,
      'casualFormal': casualFormal,
      'empathy': empathy,
      'humour': humour,
      'intelligence': intelligence,
      'confidence': confidence,
      'kindness': kindness,
      'romanticLevel': romanticLevel,
      'energy': energy,
      'sarcasm': sarcasm,
      'shyness': shyness,
      'curiosity': curiosity,
      'communicationStyle': communicationStyle,
      'digitalHome': digitalHome.toJson(),
      'digitalPhone': digitalPhone.toJson(),
      'digitalWardrobe': digitalWardrobe.toJson(),
      'digitalJournal': digitalJournal.map((j) => j.toJson()).toList(),
      'dynamicPersonality': dynamicPersonality.toJson(),
      'currentEmotion': currentEmotion.name,
    };
  }
}
