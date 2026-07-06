import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nova_ai/models/companion.dart';
import 'package:nova_ai/theme/app_theme.dart';
import 'package:nova_ai/widgets/glass_container.dart';

class DigitalPhoneScreen extends StatefulWidget {
  final Companion companion;
  const DigitalPhoneScreen({super.key, required this.companion});

  @override
  State<DigitalPhoneScreen> createState() => _DigitalPhoneScreenState();
}

class _DigitalPhoneScreenState extends State<DigitalPhoneScreen> {
  int _selectedAppIndex = -1; // -1 shows home screen launcher

  void _openApp(int index) {
    setState(() => _selectedAppIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final phone = widget.companion.digitalPhone;

    return Scaffold(
      backgroundColor: const Color(0xFF06060A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_selectedAppIndex != -1) {
              setState(() => _selectedAppIndex = -1);
            } else {
              context.pop();
            }
          },
        ),
        title: Text(_selectedAppIndex == -1 ? '${widget.companion.name}\'s Smartphone 📱' : phone.installedApps[_selectedAppIndex].appName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 360,
          height: 700,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF101018),
            borderRadius: BorderRadius.circular(44),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 3),
            boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 40, spreadRadius: 5)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Stack(
              children: [
                // Wallpaper Background
                Positioned.fill(
                  child: Image.asset(phone.wallpaperUrl, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.4), Colors.black.withValues(alpha: 0.75)]),
                    ),
                  ),
                ),

                // Smartphone Notch / Status Bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('09:41 AM', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        Container(
                          width: 80,
                          height: 18,
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          child: const Center(child: Icon(Icons.lens, color: Colors.white24, size: 8)),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.wifi, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            const Text('5G', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 4),
                            Text('${phone.batteryLevel}% 🔋', style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Phone Content
                Positioned.fill(
                  top: 50,
                  bottom: 20,
                  child: _selectedAppIndex == -1 ? _buildLauncherGrid(phone) : _buildAppContent(phone, _selectedAppIndex),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLauncherGrid(DigitalPhone phone) {
    return Column(
      children: [
        // Live Clock Widget
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: Column(
            children: [
              const Text('09:41', style: TextStyle(color: Colors.white, fontSize: 54, fontWeight: FontWeight.w200, letterSpacing: -2)),
              Text('Tuesday, July 6 • Neo-Tokyo', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),

        // App Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 24, childAspectRatio: 0.85),
            itemCount: phone.installedApps.length,
            itemBuilder: (context, index) {
              final app = phone.installedApps[index];
              return GestureDetector(
                onTap: () => _openApp(index),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10)],
                          ),
                          child: Center(child: Text(app.iconEmoji, style: const TextStyle(fontSize: 30))),
                        ),
                        if (app.unreadCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                              child: Text('${app.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(app.appName, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          ),
        ),

        // Notification Drawer
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Notifications 🔔', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('${phone.recentNotifications.length} new', style: const TextStyle(color: Colors.cyanAccent, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 8),
              ...phone.recentNotifications.take(2).map((notif) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.cyanAccent, size: 6),
                    const SizedBox(width: 8),
                    Expanded(child: Text(notif, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppContent(DigitalPhone phone, int index) {
    final app = phone.installedApps[index];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 24,
        blur: 20,
        opacity: 0.3,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(app.iconEmoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.appName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Active Session', style: TextStyle(color: Colors.cyanAccent.withValues(alpha: 0.8), fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          const Text('Recent Activity Telemetry 🛰️', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
            child: Text(app.recentActivity, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
          ),
          const SizedBox(height: 24),

          if (app.appName == 'Spotify') ...[
            const Text('Active Starlight Playlist 🎵', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...phone.musicPlaylist.map((song) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.music_note, color: Colors.cyanAccent),
              title: Text(song, style: const TextStyle(color: Colors.white, fontSize: 12)),
              trailing: const Icon(Icons.play_circle_fill, color: Colors.white54),
            )),
          ] else if (app.appName == 'Gallery') ...[
            const Text('Personal Camera Roll 📸', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: phone.photoGallery.length,
                itemBuilder: (context, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(phone.photoGallery[i], fit: BoxFit.cover),
                ),
              ),
            ),
          ] else ...[
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _selectedAppIndex = -1),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: const Icon(Icons.home, color: Colors.white),
                label: const Text('Return to Launcher', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ],
      ),
    ));
  }
}
