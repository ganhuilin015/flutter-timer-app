import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:audioplayers/audioplayers.dart';
class AlertData {
  final String title;
  final String subtitle;
  final IconData icon;

  AlertData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class FullScreenAlert extends StatefulWidget {
  final AlertData data;
  final VoidCallback onDismiss;
  final String soundFile;

  const FullScreenAlert({
    super.key,
    required this.data,
    required this.onDismiss,
    required this.soundFile,
  });

  @override
  State<FullScreenAlert> createState() => _FullScreenAlertState();
}

class _FullScreenAlertState extends State<FullScreenAlert> {
  double _dragY = 0;
  late AudioPlayer _player;
  
  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    _startSound();
  }

  Future<void> _startSound() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('sounds/${widget.soundFile}'));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.read<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeColor.primary(context),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 150),
              child: SizedBox.expand (
                child: Column (
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    widget.data.icon,
                    size: 80,
                    color: themeColor.onPrimary(context),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    widget.data.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: themeColor.onPrimary(context),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    widget.data.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                      color: themeColor.onPrimary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: _buildSlider(themeColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(ThemeProvider themeColor) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _dragY += details.delta.dy;

          // limit upward movement only
          if (_dragY < -120) {
            widget.onDismiss();
          }

          if (_dragY > 0) _dragY = 0;
        });
      },
      onVerticalDragEnd: (_) {
        setState(() {
          _dragY = 0;
        });
      },
      child: SizedBox(
        height: 120,
        width: 80,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            /// track
            Container(
              height: 120,
              width: 60,
              decoration: BoxDecoration(
                color: themeColor.onPrimary(context).withAlpha(40),
                borderRadius: BorderRadius.circular(30),
              ),
            ),

            Transform.translate(
              offset: Offset(0, _dragY),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: themeColor.onPrimary(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: themeColor.primary(context),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}