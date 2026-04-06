import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Écran de démarrage Flutter (après le splash natif).
///
/// Affiche l'image screen.png en plein écran avec un
/// fondu d'entrée, puis navigue vers /home/playlist.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  // Durée minimale d'affichage avant navigation
  static const _kDuration = Duration(milliseconds: 2800);

  @override
  void initState() {
    super.initState();

    // Fondu d'entrée en 600ms
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);

    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(_kDuration);
    if (!mounted) return;
    context.go('/home/playlist');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fade,
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/screen.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}