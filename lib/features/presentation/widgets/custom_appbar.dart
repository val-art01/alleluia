import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/features/presentation/pages/hymn_search_delegate.dart';

/// AppBar partagée dans toutes les pages principales.
///
/// - Logo à gauche
/// - Titre centré sur deux lignes
/// - Bouton recherche à droite → ouvre [HymnSearchDelegate]
///
/// Utilise exclusivement le ColorScheme du thème —
/// aucune couleur hardcodée.

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = "Chants Pour Le\nCulte d'Enfants",
    this.withSearch = true, 
  });
 
  final String title;
  final bool withSearch;
 
  static const double _kHeight = 72;
 
  @override
  Size get preferredSize => const Size.fromHeight(_kHeight);
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
 
    return AppBar(
      toolbarHeight: _kHeight,
      centerTitle: true,
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
 
      // Logo
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            'assets/images/logoCE.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
 
      // Titre
      title: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          height: 1.3,
          color: cs.onPrimary,
          letterSpacing: 0.2,
        ),
      ),
 
      // Actions
      actions: [
        if (withSearch)
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Rechercher un chant',
            onPressed: () => _openSearch(context, ref),
          ),
      ],
    );
  }
 
  void _openSearch(BuildContext context, WidgetRef ref) {
    showSearch<void>(
      context: context,
      delegate: HymnSearchDelegate(ref: ref),
    );
  }
}