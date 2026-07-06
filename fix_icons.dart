import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final replacements = {
    'LucideIcons.bot': 'Icons.smart_toy',
    'LucideIcons.arrowLeft': 'Icons.arrow_back',
    'LucideIcons.mail': 'Icons.email',
    'LucideIcons.lock': 'Icons.lock',
    'LucideIcons.eyeOff': 'Icons.visibility_off',
    'LucideIcons.eye': 'Icons.visibility',
    'LucideIcons.chrome': 'Icons.g_mobiledata',
    'LucideIcons.user': 'Icons.person',
    'LucideIcons.sparkles': 'Icons.auto_awesome',
    'LucideIcons.heart': 'Icons.favorite',
    'LucideIcons.phone': 'Icons.phone',
    'LucideIcons.moreVertical': 'Icons.more_vert',
    'LucideIcons.brainCircuit': 'Icons.memory',
    'LucideIcons.plus': 'Icons.add',
    'LucideIcons.mic': 'Icons.mic',
    'LucideIcons.send': 'Icons.send',
    'LucideIcons.crown': 'Icons.workspace_premium',
    'LucideIcons.messageSquare': 'Icons.chat_bubble_outline',
    'LucideIcons.image': 'Icons.image',
    'LucideIcons.settings': 'Icons.settings',
    'LucideIcons.award': 'Icons.emoji_events',
    'LucideIcons.palette': 'Icons.palette',
    'LucideIcons.bell': 'Icons.notifications',
    'LucideIcons.downloadCloud': 'Icons.cloud_download',
    'LucideIcons.logOut': 'Icons.logout',
    'LucideIcons.trash2': 'Icons.delete_outline',
    'LucideIcons.chevronRight': 'Icons.chevron_right',
  };

  for (final file in files) {
    String content = file.readAsStringSync();
    if (content.contains('lucide_icons')) {
      content = content.replaceAll("import 'package:lucide_icons/lucide_icons.dart';", '');
      replacements.forEach((key, value) {
        content = content.replaceAll(key, value);
      });
      // Fallback for any other LucideIcons
      content = content.replaceAll('LucideIcons.', 'Icons.');
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
}
