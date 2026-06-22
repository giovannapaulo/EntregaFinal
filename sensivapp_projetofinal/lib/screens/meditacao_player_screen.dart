import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';

class MeditacaoPlayerScreen extends StatefulWidget {
  final String title;
  final int durationMinutes;

  const MeditacaoPlayerScreen({
    super.key,
    required this.title,
    required this.durationMinutes,
  });

  @override
  State<MeditacaoPlayerScreen> createState() => _MeditacaoPlayerScreenState();
}

class _MeditacaoPlayerScreenState extends State<MeditacaoPlayerScreen> {
  Timer? _timer;
  late int _secondsRemaining;
  late int _totalSeconds;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _totalSeconds =
        (widget.durationMinutes > 0 ? widget.durationMinutes : 1) * 60;
    _secondsRemaining = _totalSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _timer?.cancel();
      } else {
        _startTimer();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _handleCircleTap(TapDownDetails details, double size) {
    final xPosition = details.localPosition.dx;
    final halfSize = size / 2;

    setState(() {
      if (xPosition < halfSize) {
        _secondsRemaining = (_secondsRemaining + 15).clamp(0, _totalSeconds);
      } else {
        _secondsRemaining = (_secondsRemaining - 15).clamp(0, _totalSeconds);
      }
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark ? const Color(0xFF111E1C) : const Color(0xFFEDF7F5);
    final navContentColor = isDark ? Colors.white : const Color(0xFF236B5E);
    final backgroundColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF3FAF8);
    final primaryTeal = const Color(0xFF2EA38F);

    double progress = _secondsRemaining / _totalSeconds;
    const double circleSize = 240.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: navColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: navContentColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("SensivApp",
            style: TextStyle(
                color: navContentColor,
                fontSize: 20,
                fontWeight: FontWeight.w400)),
        actions: [
          const ThemeToggleButton(),
          IconButton(
              icon: Icon(Icons.person, color: navContentColor),
              onPressed: () {}),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text("Meditação Guiada",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF236B5E))),
              const SizedBox(height: 60),
              GestureDetector(
                onTapDown: (details) => _handleCircleTap(details, circleSize),
                behavior: HitTestBehavior.opaque,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: circleSize,
                      height: circleSize,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: primaryTeal.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(primaryTeal),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_formatTime(_secondsRemaining),
                            style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w300,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF236B5E))),
                        Text("restantes",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : const Color(0xFF51877E))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Text(widget.title,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF236B5E))),
              const SizedBox(height: 48),
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration:
                      BoxDecoration(color: primaryTeal, shape: BoxShape.circle),
                  child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white, size: 36),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
