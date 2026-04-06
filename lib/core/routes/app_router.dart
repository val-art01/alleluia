import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/app/screens/splash_screen.dart';
import 'package:alleluia_tome_1/features/presentation/pages/home_page.dart';
import 'package:alleluia_tome_1/features/presentation/pages/playlist_page.dart';
import 'package:alleluia_tome_1/features/presentation/pages/numbers_page.dart';
import 'package:alleluia_tome_1/features/presentation/pages/category_page.dart';
import 'package:alleluia_tome_1/features/presentation/pages/battements_page.dart';
import 'package:alleluia_tome_1/features/presentation/pages/settings_page.dart';
import 'package:alleluia_tome_1/features/presentation/pages/play_details_page.dart';

///  NOMS DE ROUTES
abstract final class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const playlist  = '/home/playlist';
  static const numbers   = '/home/numbers';
  static const categories = '/home/categories';
  static const battements = '/home/battements';
  static const settings  = '/home/settings';

  // Construit le chemin vers un chant
  static String playDetailsPath(int hymnId) => '/play/$hymnId';
}

///  PROVIDER DU ROUTER
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    // debugLogDiagnostics: false,
    debugLogDiagnostics: true,
    routes: [
      // Splash 
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ShellRoute maintient la NavigationBar en mémoire lors des transitions entre onglets.
      ShellRoute(
        builder: (context, state, child) => Home(child: child),
        routes: [
          GoRoute(
            path: '/home/playlist',
            name: 'playlist',
            builder: (context, state) => const PlayList(),
          ),
          GoRoute(
            path: '/home/numbers',
            name: 'numbers',
            builder: (context, state) => const Numbers(),
          ),
          GoRoute(
            path: '/home/categories',
            name: 'categories',
            builder: (context, state) => const Category(),
          ),
          GoRoute(
            path: '/home/battements',
            name: 'battements',
            builder: (context, state) => const Battements(),
          ),
          GoRoute(
            path: '/home/settings',
            name: 'settings',
            builder: (context, state) => const Settings(),
          ),
        ],
      ),

      // Play Details (hors shell, plein écran)
      GoRoute(
        path: '/play/:id',
        name: 'playDetails',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PlayDetails(hymnId: id);
        },
      ),
    ],

    // Redirection : /home → /home/playlist
    redirect: (context, state) {
      if (state.matchedLocation == '/home') {
        return AppRoutes.playlist;
      }
      return null;
    },

    // Redirection d'erreur
    errorBuilder: (context, state) => const _NotFoundPage(),
  );
});



//  PAGE 404
class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Page introuvable',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}