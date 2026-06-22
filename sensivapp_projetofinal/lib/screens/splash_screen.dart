import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeLogo;
  late Animation<Offset> _slideLogo;
  double _loadingOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeLogo = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn));

    _slideLogo = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _loadingOpacity = 0.0);
      await Future.delayed(const Duration(milliseconds: 600));
      _controller.forward();
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pink = AppTheme.sensivPink;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            FadeTransition(
              opacity: _fadeLogo,
              child: SlideTransition(
                position: _slideLogo,
                child: const Icon(Icons.local_hospital, size: 130, color: pink),
              ),
            ),
            Positioned(
              bottom: 100,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _loadingOpacity,
                child: const SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(pink),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
