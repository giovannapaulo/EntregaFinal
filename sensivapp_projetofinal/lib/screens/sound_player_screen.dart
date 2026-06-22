import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';

class SoundPlayerScreen extends StatefulWidget {
  final String title;
  final String imageUrl;

  const SoundPlayerScreen({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  State<SoundPlayerScreen> createState() => _SoundPlayerScreenState();
}

class _SoundPlayerScreenState extends State<SoundPlayerScreen> {
  double _currentValue = 0;
  double _maxValue = 180;
  bool _isPlaying = false;
  Timer? _timer;

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentValue < _maxValue) {
            _currentValue++;
          } else {
            _isPlaying = false;
            _timer?.cancel();
          }
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  String _formatTime(double seconds) {
    int mins = (seconds / 60).floor();
    int secs = (seconds % 60).toInt();
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF3F6FF);
    final textColor = isDark ? Colors.white : const Color(0xFF4A4261);
    final accentColor = const Color(0xFF7553F6);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: textColor, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("SensivApp",
            style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: ThemeToggleButton(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(_isPlaying ? 0.4 : 0.1),
                    blurRadius: _isPlaying ? 40 : 20,
                    offset: const Offset(0, 15),
                  )
                ],
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isPlaying ? 1.0 : 0.8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: _isPlaying
                        ? null
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.4)
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              "Dados em tempo real • SensivApp",
              style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 15),
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbColor: accentColor,
                    activeTrackColor: accentColor,
                    inactiveTrackColor: isDark ? Colors.white10 : Colors.white,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayColor: accentColor.withOpacity(0.1),
                  ),
                  child: Slider(
                    value: _currentValue,
                    max: _maxValue,
                    onChanged: (value) {
                      setState(() => _currentValue = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatTime(_currentValue),
                          style: TextStyle(
                              color: textColor.withOpacity(0.6),
                              fontWeight: FontWeight.w500)),
                      Text(_formatTime(_maxValue),
                          style: TextStyle(
                              color: textColor.withOpacity(0.6),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous_rounded,
                      size: 45, color: accentColor.withOpacity(0.8)),
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: _togglePlay,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 85,
                    width: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cardBg,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(isDark ? 0.4 : 0.2),
                          blurRadius: _isPlaying ? 20 : 10,
                          spreadRadius: _isPlaying ? 5 : 0,
                        )
                      ],
                    ),
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 55,
                      color: accentColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next_rounded,
                      size: 45, color: accentColor.withOpacity(0.8)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
