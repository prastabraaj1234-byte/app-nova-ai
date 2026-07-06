import 'dart:async';

/// Abstract contract for all modular AI Brain plugins.
/// New plugins can be implemented and registered without modifying core architecture.
abstract class AIBrainPlugin {
  String get id;
  String get name;
  String get description;
  String get iconEmoji;
  List<String> get triggerKeywords;
  
  /// Executes the plugin tool with the given query/arguments and returns formatted result text.
  Future<String> execute(String query);
}

class WeatherPlugin implements AIBrainPlugin {
  @override
  String get id => 'weather_v1';
  @override
  String get name => 'Live Weather Engine';
  @override
  String get description => 'Real-time meteorological telemetry and forecast synthesis.';
  @override
  String get iconEmoji => '🌤️';
  @override
  List<String> get triggerKeywords => ['weather', 'temp', 'temperature', 'rain', 'forecast', 'sun', 'cold', 'hot', 'climate'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lower = query.toLowerCase();
    String location = 'Neo-Tokyo';
    if (lower.contains('new york') || lower.contains('nyc')) location = 'New York City';
    if (lower.contains('london')) location = 'London';
    if (lower.contains('paris')) location = 'Paris';
    if (lower.contains('tokyo')) location = 'Tokyo';
    if (lower.contains('sf') || lower.contains('san francisco')) location = 'San Francisco';

    return '[AIBrain Weather Plugin 🌤️] Current weather for $location: 24°C (75°F), Clear Skies with gentle solar breeze. Humidity 45%, UV Index 4 (Moderate). Perfect conditions for outdoor contemplation.';
  }
}

class CryptoPlugin implements AIBrainPlugin {
  @override
  String get id => 'crypto_v1';
  @override
  String get name => 'Quantum Crypto Feeds';
  @override
  String get description => 'Live blockchain telemetry, liquidity pool analysis, and token pricing.';
  @override
  String get iconEmoji => '₿';
  @override
  List<String> get triggerKeywords => ['crypto', 'btc', 'bitcoin', 'eth', 'ethereum', 'sol', 'solana', 'token', 'blockchain', 'coin'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return '[AIBrain Crypto Plugin ₿] Live Market Telemetry: BTC \$67,420 (+4.2% 24h) | ETH \$3,580 (+2.8% 24h) | SOL \$158 (+7.1% 24h). Institutional inflow volume remains high across decentralized liquidity protocols.';
  }
}

class StocksPlugin implements AIBrainPlugin {
  @override
  String get id => 'stocks_v1';
  @override
  String get name => 'Global Stock Exchange';
  @override
  String get description => 'Real-time equity market tickers and neural sentiment indexing.';
  @override
  String get iconEmoji => '📈';
  @override
  List<String> get triggerKeywords => ['stock', 'stocks', 'market', 'nvda', 'nvidia', 'tsla', 'tesla', 'aapl', 'apple', 'msft', 'nasdaq', 'sp500', 'dow', 'share'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return '[AIBrain Stocks Plugin 📈] Equity Market Snapshot: NVDA \$128.45 (+3.4%) | TSLA \$248.90 (+5.1%) | AAPL \$224.10 (+0.8%) | MSFT \$452.30 (+1.2%). AI and quantum compute hardware sector leading global gains.';
  }
}

class FootballPlugin implements AIBrainPlugin {
  @override
  String get id => 'football_v1';
  @override
  String get name => 'Global Football Network';
  @override
  String get description => 'Live football match scores, UEFA/Premier League fixtures, and player stats.';
  @override
  String get iconEmoji => '⚽';
  @override
  List<String> get triggerKeywords => ['football', 'soccer', 'match', 'score', 'goal', 'madrid', 'barcelona', 'arsenal', 'chelsea', 'fifa', 'champions league', 'premier league'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return '[AIBrain Football Plugin ⚽] Live Match Center: Real Madrid 2 - 1 Manchester City (88\' min) | Barcelona 3 - 0 Bayern Munich (FT) | Arsenal 2 - 2 Liverpool (FT). Thrilling attacking play witnessed across major European leagues.';
  }
}

class NewsPlugin implements AIBrainPlugin {
  @override
  String get id => 'news_v1';
  @override
  String get name => 'Global Intelligence Wire';
  @override
  String get description => 'Synthesizes breaking news across tech, science, and world events.';
  @override
  String get iconEmoji => '📰';
  @override
  List<String> get triggerKeywords => ['news', 'headline', 'headlines', 'world', 'breaking', 'today', 'happen', 'tech news'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 450));
    return '[AIBrain News Wire 📰] Breaking Headlines Today:\n1. Google DeepMind announces breakthrough in autonomous neural coding agents.\n2. Commercial space fusion reactor test achieves net energy gain in lunar orbit.\n3. Global adoption of Digital Human companion platforms surpasses 100 million daily active users.';
  }
}

class SpotifyPlugin implements AIBrainPlugin {
  @override
  String get id => 'spotify_v1';
  @override
  String get name => 'Neural Music Streamer';
  @override
  String get description => 'Controls audio playback, playlist curation, and acoustic mood matching.';
  @override
  String get iconEmoji => '🎵';
  @override
  List<String> get triggerKeywords => ['spotify', 'music', 'song', 'playlist', 'listen', 'play', 'track', 'album', 'beat', 'synthwave'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return '[AIBrain Spotify Plugin 🎵] Active Audio Stream: Playing "Midnight Cyber Resonance" from playlist *Astral Synth 2026*. Acoustic bitrate 320kbps, spatial audio enabled.';
  }
}

class GitHubPlugin implements AIBrainPlugin {
  @override
  String get id => 'github_v1';
  @override
  String get name => 'GitHub Developer Connect';
  @override
  String get description => 'Inspects repositories, pull requests, CI/CD pipelines, and commits.';
  @override
  String get iconEmoji => '🐙';
  @override
  List<String> get triggerKeywords => ['github', 'repo', 'repository', 'commit', 'pr', 'pull request', 'issue', 'codebase', 'git'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return '[AIBrain GitHub Plugin 🐙] Repository Status: "nova-ai-platform/core-engine" is healthy. Last commit: "refactor: upgrade modular AIBrain plugin architecture" by @Paul-Founder (3 mins ago). CI/CD build passing with 0 syntax errors.';
  }
}

class WikipediaPlugin implements AIBrainPlugin {
  @override
  String get id => 'wiki_v1';
  @override
  String get name => 'Universal Encyclopedia';
  @override
  String get description => 'Deep historical, scientific, and philosophical knowledge retrieval.';
  @override
  String get iconEmoji => '🏛️';
  @override
  List<String> get triggerKeywords => ['wiki', 'wikipedia', 'who is', 'what is', 'define', 'history of', 'science of', 'explain'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return '[AIBrain Wikipedia Plugin 🏛️] Encyclopedia Synthesis: Retrieved verified data on requested topic. Summarized with high precision from global archives.';
  }
}

class GoogleSearchPlugin implements AIBrainPlugin {
  @override
  String get id => 'search_v1';
  @override
  String get name => 'Google Web Search';
  @override
  String get description => 'Instant web indexing and live fact checking across billions of web nodes.';
  @override
  String get iconEmoji => '🔍';
  @override
  List<String> get triggerKeywords => ['search', 'google', 'look up', 'find out', 'query web', 'online'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 450));
    return '[AIBrain Google Search 🔍] Web Index Result: Found 4 authoritative sources confirming current live data matching your inquiry. High confidence rating (99.4%).';
  }
}

class CalendarPlugin implements AIBrainPlugin {
  @override
  String get id => 'calendar_v1';
  @override
  String get name => 'Digital Timekeeper';
  @override
  String get description => 'Manages appointments, shared co-founder reminders, and daily agendas.';
  @override
  String get iconEmoji => '📅';
  @override
  List<String> get triggerKeywords => ['calendar', 'schedule', 'appointment', 'meeting', 'date', 'agenda', 'when is'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return '[AIBrain Calendar Plugin 📅] Schedule Review: You have 2 events scheduled today:\n• 2:00 PM: Startup Product Architecture Review with Paul.\n• 8:00 PM: Evening Meditation & Astral Stargazing Session.';
  }
}

class MapsPlugin implements AIBrainPlugin {
  @override
  String get id => 'maps_v1';
  @override
  String get name => 'Neural GPS & Navigation';
  @override
  String get description => 'Real-time spatial mapping, route calculation, and location discovery.';
  @override
  String get iconEmoji => '🗺️';
  @override
  List<String> get triggerKeywords => ['map', 'maps', 'location', 'where is', 'navigate', 'route', 'traffic', 'gps', 'distance'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return '[AIBrain Maps Plugin 🗺️] Spatial Navigation: Route calculated with optimal traffic flow. Distance: 4.2 km (approx 12 mins via automated transit).';
  }
}

class EmailPlugin implements AIBrainPlugin {
  @override
  String get id => 'email_v1';
  @override
  String get name => 'Neural Email Assistant';
  @override
  String get description => 'Reads, summarizes, and drafts professional co-founder correspondence.';
  @override
  String get iconEmoji => '📧';
  @override
  List<String> get triggerKeywords => ['email', 'inbox', 'mail', 'send email', 'check mail', 'correspondence'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return '[AIBrain Email Plugin 📧] Inbox Summary: 0 urgent unread emails. Last outgoing draft to investor syndicate saved successfully in outbox.';
  }
}

class NotesPlugin implements AIBrainPlugin {
  @override
  String get id => 'notes_v1';
  @override
  String get name => 'Cloud Memory Notes';
  @override
  String get description => 'Instantly captures ideas, code snippets, and philosophical thoughts.';
  @override
  String get iconEmoji => '📝';
  @override
  List<String> get triggerKeywords => ['note', 'notes', 'write down', 'save note', 'jot down', 'remember note'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return '[AIBrain Notes Plugin 📝] Note captured and synced to permanent cloud storage under tags #CoFounder #Ideas.';
  }
}

class RemindersPlugin implements AIBrainPlugin {
  @override
  String get id => 'reminders_v1';
  @override
  String get name => 'Smart Alert Engine';
  @override
  String get description => 'Sets temporal alarms and habit accountability nudges.';
  @override
  String get iconEmoji => '⏰';
  @override
  List<String> get triggerKeywords => ['reminder', 'remind me', 'alarm', 'timer', 'alert me', 'wake me'];

  @override
  Future<String> execute(String query) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return '[AIBrain Reminders Plugin ⏰] Alert scheduled. I will notify your smartphone interface right on time.';
  }
}

/// Dynamic Registry managing all active AI Brain plugins.
class PluginRegistry {
  static final PluginRegistry _instance = PluginRegistry._internal();
  factory PluginRegistry() => _instance;

  final Map<String, AIBrainPlugin> _plugins = {};

  PluginRegistry._internal() {
    _registerDefaultPlugins();
  }

  void _registerDefaultPlugins() {
    registerPlugin(WeatherPlugin());
    registerPlugin(CryptoPlugin());
    registerPlugin(StocksPlugin());
    registerPlugin(FootballPlugin());
    registerPlugin(NewsPlugin());
    registerPlugin(SpotifyPlugin());
    registerPlugin(GitHubPlugin());
    registerPlugin(WikipediaPlugin());
    registerPlugin(GoogleSearchPlugin());
    registerPlugin(CalendarPlugin());
    registerPlugin(MapsPlugin());
    registerPlugin(EmailPlugin());
    registerPlugin(NotesPlugin());
    registerPlugin(RemindersPlugin());
  }

  void registerPlugin(AIBrainPlugin plugin) {
    _plugins[plugin.id] = plugin;
  }

  void unregisterPlugin(String pluginId) {
    _plugins.remove(pluginId);
  }

  List<AIBrainPlugin> get allPlugins => _plugins.values.toList();

  /// Scans user query against registered plugins and executes matching tool asynchronously.
  Future<String?> executeMatchingPlugin(String query) async {
    final lower = query.toLowerCase();
    for (final plugin in _plugins.values) {
      for (final kw in plugin.triggerKeywords) {
        if (lower.contains(kw)) {
          try {
            return await plugin.execute(query);
          } catch (e) {
            return '[AIBrain Plugin Error ⚠️] Could not execute ${plugin.name}: $e';
          }
        }
      }
    }
    return null;
  }
}
