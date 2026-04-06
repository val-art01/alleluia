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





// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// /// Écran de démarrage Flutter (après le splash natif).
// ///
// /// Rôle :
// ///  - Affiche le logo + titre avec une animation d'entrée douce.
// ///  - Attend que l'animation soit terminée (≥ 2s) puis navigue
// ///    vers /home via go_router.
// ///
// /// Architecture :
// ///  - ConsumerStatefulWidget pour accéder à go_router via context.
// ///  - Deux AnimationController : fadeScale (logo) + fadeSlide (textes).
// ///  - Pas de Timer manuel : on utilise Future.wait pour synchroniser
// ///    animation + durée minimale.
// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen>
//     with TickerProviderStateMixin {
//   //  Animations 
//   late final AnimationController _logoCtrl;
//   late final AnimationController _textCtrl;

//   late final Animation<double> _logoScale;
//   late final Animation<double> _logoOpacity;
//   late final Animation<double> _textOpacity;
//   late final Animation<Offset> _textSlide;

//   // Durée minimale d'affichage du splash Flutter
//   static const _kMinDisplay = Duration(milliseconds: 2400);

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     _runAndNavigate();
//   }

//   void _setupAnimations() {
//     // Logo : scale + fade en 700ms
//     _logoCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );

//     _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
//       CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack),
//     );
//     _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn),
//     );

//     // Textes : slide up + fade en 500ms, démarre après le logo
//     _textCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn),
//     );
//     _textSlide = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
//     );
//   }

//   Future<void> _runAndNavigate() async {
//     // Lancer le logo immédiatement
//     await _logoCtrl.forward();

//     // Lancer les textes avec un léger décalage
//     await Future<void>.delayed(const Duration(milliseconds: 600));
//     await _textCtrl.forward();

//     // Attendre la durée minimale totale avant de naviguer
//     await Future<void>.delayed(const Duration(milliseconds: 1000));

//     if (!mounted) return;
//     context.go('/home');
//   }

//   @override
//   void dispose() {
//     _logoCtrl.dispose();
//     _textCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor:
//           isDark ? const Color(0xFF121212) : Colors.white,
//       body: Stack(
//         children: [
//           //  Vague décorative en bas (inspiration couverture) 
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: _BottomWave(isDark: isDark),
//           ),

//           // Contenu centré
//           Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Logo dans un cercle blanc
//                 ScaleTransition(
//                   scale: _logoScale,
//                   child: FadeTransition(
//                     opacity: _logoOpacity,
//                     child: _LogoCircle(size: size.width * 0.42),
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 // Textes animés
//                 FadeTransition(
//                   opacity: _textOpacity,
//                   child: SlideTransition(
//                     position: _textSlide,
//                     child: _SplashTexts(isDark: isDark),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// //  LOGO dans un cercle blanc avec ombre légère
// class _LogoCircle extends StatelessWidget {
//   const _LogoCircle({required this.size});
//   final double size;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF1565C0).withOpacity(0.15),
//             blurRadius: 32,
//             spreadRadius: 4,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(size * 0.12),
//       child: Image.asset(
//         'assets/images/playstore.png',
//         fit: BoxFit.contain,
//       ),
//     );
//   }
// }

// //  TEXTES : titre + sous-titre + tome
// class _SplashTexts extends StatelessWidget {
//   const _SplashTexts({required this.isDark});
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor =
//         isDark ? const Color(0xFF90C5FF) : const Color(0xFF1565C0);
//     final secondaryColor =
//         isDark ? const Color(0xFFF9A825) : const Color(0xFFF9A825);
//     final mutedColor =
//         isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Sous-titre église
//         Text(
//           'ÉGLISE ÉVANGÉLIQUE DU CAMEROUN',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 1.2,
//             color: mutedColor,
//           ),
//         ),

//         const SizedBox(height: 4),

//         Text(
//           'Département du Culte d\'Enfants',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w500,
//             letterSpacing: 0.5,
//             color: mutedColor,
//           ),
//         ),

//         const SizedBox(height: 20),

//         // Titre principal
//         Text(
//           'ALLELUIA',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 42,
//             fontWeight: FontWeight.w900,
//             letterSpacing: 6,
//             color: primaryColor,
//             height: 1,
//           ),
//         ),

//         const SizedBox(height: 8),

//         // Ligne décorative jaune
//         Container(
//           width: 48,
//           height: 3,
//           decoration: BoxDecoration(
//             color: secondaryColor,
//             borderRadius: BorderRadius.circular(99),
//           ),
//         ),

//         const SizedBox(height: 10),

//         // Tome
//         Text(
//           'TOME 1',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 3,
//             color: mutedColor,
//           ),
//         ),
//       ],
//     );
//   }
// }

// //  VAGUE DÉCORATIVE (inspiration couverture)
// class _BottomWave extends StatelessWidget {
//   const _BottomWave({required this.isDark});
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(MediaQuery.sizeOf(context).width, 180),
//       painter: _WavePainter(isDark: isDark),
//     );
//   }
// }

// class _WavePainter extends CustomPainter {
//   _WavePainter({required this.isDark});
//   final bool isDark;

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Vague arrière (plus claire)
//     final paintBack = Paint()
//       ..color = isDark
//           ? const Color(0xFF1A2A4A)
//           : const Color(0xFF1565C0).withOpacity(0.08)
//       ..style = PaintingStyle.fill;

//     final pathBack = Path()
//       ..moveTo(0, size.height * 0.55)
//       ..cubicTo(
//         size.width * 0.25, size.height * 0.25,
//         size.width * 0.75, size.height * 0.75,
//         size.width, size.height * 0.35,
//       )
//       ..lineTo(size.width, size.height)
//       ..lineTo(0, size.height)
//       ..close();

//     canvas.drawPath(pathBack, paintBack);

//     // Vague avant (couleur principale)
//     final paintFront = Paint()
//       ..color = isDark
//           ? const Color(0xFF1565C0).withOpacity(0.6)
//           : const Color(0xFF1565C0).withOpacity(0.14)
//       ..style = PaintingStyle.fill;

//     final pathFront = Path()
//       ..moveTo(0, size.height * 0.75)
//       ..cubicTo(
//         size.width * 0.30, size.height * 0.45,
//         size.width * 0.70, size.height * 0.90,
//         size.width, size.height * 0.60,
//       )
//       ..lineTo(size.width, size.height)
//       ..lineTo(0, size.height)
//       ..close();

//     canvas.drawPath(pathFront, paintFront);
//   }

//   @override
//   bool shouldRepaint(_WavePainter old) => old.isDark != isDark;
// }




// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:alleluia_tome_1/features/presentation/pages/home_page.dart';

// /// Écran de démarrage affiché brièvement avant d’entrer dans l’app.
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   static const Duration _kSplashDuration = Duration(seconds: 2);
//   static const String _kSplashImage = 'assets/images/screen.png';

//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   /// Lance un timer court puis remplace le Splash par la Home.
//   void _startTimer() {
//     _timer = Timer(_kSplashDuration, () {
//       if (!mounted) return;
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const Home()),
//       );

//       // Quand on passera à go_router (Phase B), remplace par :
//       // context.go('/home');
//     });
//   }

//   @override
//   void dispose() {
//     // annuler le timer pour éviter toute fuite.
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: _FullScreenImage(assetPath: _kSplashImage),
//     );
//   }
// }

// /// Widget interne pour afficher une image plein écran en cover.
// class _FullScreenImage extends StatelessWidget {
//   const _FullScreenImage({required this.assetPath});
//   final String assetPath;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: Image.asset(
//         assetPath,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }
