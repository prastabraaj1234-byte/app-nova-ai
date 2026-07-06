import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart') && !f.path.contains('app_theme.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool modified = false;

    if (content.contains('AppTheme.primary')) {
      content = content.replaceAll('AppTheme.primary', 'Theme.of(context).colorScheme.primary');
      modified = true;
    }
    if (content.contains('AppTheme.background')) {
      content = content.replaceAll('AppTheme.background', 'Theme.of(context).scaffoldBackgroundColor');
      modified = true;
    }
    if (content.contains('AppTheme.surface')) {
      content = content.replaceAll('AppTheme.surface', 'Theme.of(context).colorScheme.surface');
      modified = true;
    }
    if (content.contains('AppTheme.secondary')) {
      content = content.replaceAll('AppTheme.secondary', 'Theme.of(context).colorScheme.secondary');
      modified = true;
    }
    if (content.contains('AppTheme.error')) {
      content = content.replaceAll('AppTheme.error', 'Theme.of(context).colorScheme.error');
      modified = true;
    }
    
    // Exception: In some places, context might not be available or it's a const array, so removing const where needed
    if (modified) {
      content = content.replaceAll('const LinearGradient(', 'LinearGradient(');
      content = content.replaceAll('const Divider(', 'Divider(');
      content = content.replaceAll('const BorderSide(', 'BorderSide(');
      content = content.replaceAll('const Icon(Icons.logout', 'Icon(Icons.logout');
      content = content.replaceAll('const TextStyle(color: Theme.of(context)', 'TextStyle(color: Theme.of(context)');
      content = content.replaceAll('const Icon(Icons.memory', 'Icon(Icons.memory');
      content = content.replaceAll('const Icon(Icons.favorite', 'Icon(Icons.favorite');
      content = content.replaceAll('const Icon(Icons.send', 'Icon(Icons.send');
      content = content.replaceAll('const Icon(Icons.workspace_premium', 'Icon(Icons.workspace_premium');
      
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
}
