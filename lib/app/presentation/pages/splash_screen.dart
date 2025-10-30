import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/home_page.dart';

/// Écran de démarrage affiché brièvement avant d’entrer dans l’app.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _kSplashDuration = Duration(seconds: 2);
  static const String _kSplashImage = 'assets/images/screen.png';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  /// Lance un timer court puis remplace le Splash par la Home.
  void _startTimer() {
    _timer = Timer(_kSplashDuration, () {
      if (!mounted) return;
      // Version Navigator (Phase A)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Home()),
      );

      // Quand on passera à go_router (Phase B), remplace par :
      // context.go('/home');
    });
  }

  @override
  void dispose() {
    // Bonne pratique : annuler le timer pour éviter toute fuite.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _FullScreenImage(assetPath: _kSplashImage),
    );
  }
}

/// Widget interne pour afficher une image plein écran en cover.
class _FullScreenImage extends StatelessWidget {
  const _FullScreenImage({required this.assetPath});
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    );
  }
}
