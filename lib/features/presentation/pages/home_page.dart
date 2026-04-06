import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:alleluia_tome_1/features/presentation/widgets/custom_bottom_navbar.dart';

/// Liste ordonnée des routes des onglets.
/// L'index dans cette liste = l'index dans la NavBar.
const _kTabRoutes = [
  '/home/playlist',
  '/home/numbers',
  '/home/categories',
  '/home/battements',
  '/home/settings',
];

/// Shell principal de l'application.
///
/// Rôle :
///  - Affiche la [NavigationBar] en bas.
///  - Injecte [child] (la page active du ShellRoute) dans le body.
///  - Synchronise l'index de la NavBar avec la route active.
///
/// Pourquoi ConsumerWidget ?
///  - Pour accéder éventuellement à des providers globaux
///    (ex: badge "nouveaux favoris", état audio en cours…)
///
/// Navigation :
///  - On utilise context.go() pour changer d'onglet.
///  - go_router gère la pile et la mémoire de chaque branche.
class Home extends ConsumerWidget {
  const Home({super.key, required this.child});

  /// Page active injectée par le ShellRoute de go_router.
  final Widget child;

  /// Calcule l'index actif depuis la location courante.
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _kTabRoutes.indexWhere(
      (route) => location.startsWith(route),
    );
    // Si la route ne correspond à aucun onglet, on reste sur 0.
    return idx < 0 ? 0 : idx;
  }

  void _onTap(BuildContext context, int index) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final targetRoute = _kTabRoutes[index];

    // Ne pas naviguer si on est déjà sur cet onglet
    if (!currentLocation.startsWith(targetRoute)) {
      context.go(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      // child = page active fournie par le ShellRoute
      body: child,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}