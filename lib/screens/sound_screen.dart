import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:timer/providers/theme_provider.dart';
import '../providers/sound_provider.dart';

enum SoundType { alarm, timer }

class SoundPickerScreen extends StatefulWidget {
  final SoundType type;

  const SoundPickerScreen({super.key, required this.type});

  @override
  State<SoundPickerScreen> createState() => _SoundPickerScreenState();
}

class _SoundPickerScreenState extends State<SoundPickerScreen> {
  final AudioPlayer _player = AudioPlayer();

  Future<void> _play(String file) async {
    await _player.stop();
    await _player.play(AssetSource('sounds/$file'));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundProvider = context.watch<SoundProvider>();
    final themeColor = context.watch<ThemeProvider>();

    final currentFile = widget.type == SoundType.alarm
        ? soundProvider.alarmSound.file
        : soundProvider.timerSound.file;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == SoundType.alarm
            ? 'Alarm Sound'
            : 'Timer Sound'),
      ),
      body: ListView.builder(
        itemCount: soundProvider.sortedSounds.length,
        itemBuilder: (context, index) {
          final sound = soundProvider.sortedSounds[index];
          final isSelected = sound.file == currentFile;

          return ListTile(
            leading: Icon(
              Icons.music_note,
              size: 25,
              color: isSelected ? themeColor.primary(context) : themeColor.onSurface(context),  
            ),

            title: Text(
              sound.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? themeColor.primary(context)
                    : themeColor.onSurface(context),
              ),
            ),

            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: themeColor.primary(context),
                  )
                : null,

            onTap: () async {
              await _play(sound.file);

              if (widget.type == SoundType.alarm) {
                soundProvider.setAlarmSound(sound);
              } else {
                soundProvider.setTimerSound(sound);
              }

              setState(() {});
            },
          );
        },
      ),
    );
  }
}