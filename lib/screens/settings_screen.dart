import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/sound_provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/screens/sound_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDark(context);
    final soundProvider = context.watch<SoundProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Appearance'),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: theme.secondary(context),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                  ),
                  title: Text(
                    isDark ? 'Dark Mode' : 'Light Mode',
                  ),
                  onTap: () {
                    theme.toggleTheme(!isDark);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _sectionTitle('Sounds'),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: theme.secondary(context),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.alarm),
                  title: const Text('Alarm Sound'),
                  subtitle: Text(soundProvider.alarmSound.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SoundPickerScreen(
                          type: SoundType.alarm,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: theme.secondary(context),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.timer),
                  title: const Text('Timer Sound'),
                  subtitle: Text(soundProvider.timerSound.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SoundPickerScreen(
                          type: SoundType.timer,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle('Permissions'),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: theme.secondary(context),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  subtitle: const Text('Manage notification permissions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: open app settings
                  },
                ),
              ],
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: theme.secondary(context),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.battery_saver),
                  title: const Text('Battery Optimization'),
                  subtitle: const Text('Allow background alarms'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle('Legal'),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: theme.secondary(context),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                  },
                ),
              ],
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            color: theme.secondary(context),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Colors.grey,
        ),
      ),
    );
  }
}