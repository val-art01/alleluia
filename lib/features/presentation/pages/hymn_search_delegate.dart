import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/core/routes/app_router.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/providers/search_provider.dart';
import 'package:alleluia_tome_1/features/data/models/search_result.dart';

/// Délégué de recherche globale des chants.
///
/// Changements vs l'ancienne version :
///  - Plus de HymnDbScope.of(context) → utilise [searchResultsProvider]
///  - Plus de FutureBuilder → ConsumerWidget interne
///  - Debounce géré par [searchResultsProvider] (300ms)
///  - Navigation via context.push() (go_router)
///  - Couleurs depuis le ColorScheme du thème
class HymnSearchDelegate extends SearchDelegate<void> {
  HymnSearchDelegate({required this.ref});

  /// WidgetRef passé depuis CustomAppBar pour accéder aux providers.
  final WidgetRef ref;

  @override
  String get searchFieldLabel => 'Numéro, titre, paroles…';

  // Thème de l'AppBar de recherche
  @override
  ThemeData appBarTheme(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = Theme.of(context);

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        toolbarHeight: 72,
        iconTheme: IconThemeData(color: cs.onPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        filled: true,
        fillColor: cs.onPrimary.withOpacity(0.15),
        hintStyle: TextStyle(
          color: cs.onPrimary.withOpacity(0.7),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.secondary, width: 2),
        ),
      ),
    );
  }

  // Bouton effacer
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Effacer',
          icon: const Icon(Icons.clear_rounded),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  // Bouton retour─
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Retour',
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, null),
    );
  }

  // Suggestions (temps réel)
  @override
  Widget buildSuggestions(BuildContext context) {
    // Met à jour le provider de recherche avec la query courante
    ref.read(searchQueryProvider.notifier).state = query;
    return _SearchResultsList(
      ref: ref,
      onTap: (hymn) => _navigateToHymn(context, hymn),
    );
  }

  // Résultats (après validation)
  @override
  Widget buildResults(BuildContext context) {
    ref.read(searchQueryProvider.notifier).state = query;
    return _SearchResultsList(
      ref: ref,
      onTap: (hymn) => _navigateToHymn(context, hymn),
    );
  }

  void _navigateToHymn(BuildContext context, Hymn hymn) {
    close(context, null);
    context.push(AppRoutes.playDetailsPath(hymn.number));
  }
}

//  LISTE DES RÉSULTATS
//  ConsumerWidget — écoute searchResultsProvider
class _SearchResultsList extends ConsumerWidget {
  const _SearchResultsList({required this.ref, required this.onTap});

  final WidgetRef ref;
  final void Function(Hymn) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final resultsAsync = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    // Rien à afficher si la query est vide
    if (query.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              size: 56,
              color: cs.onSurfaceVariant.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Tapez un numéro, un titre\nou des paroles…',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.onSurfaceVariant.withOpacity(0.6),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return resultsAsync.when(
      // Chargement
      loading: () => const Center(child: CircularProgressIndicator()),

      // Erreur
      error: (e, _) => Center(
        child: Text('Erreur : $e', style: TextStyle(color: cs.error)),
      ),

      // Résultats
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied_rounded,
                  size: 56,
                  color: cs.onSurfaceVariant.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun résultat pour\n"$query"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurfaceVariant.withOpacity(0.6),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) => _SearchResultCard(
            result: results[i],
            onTap: () => onTap(results[i].hymn),
          ),
        );
      },
    );
  }
}

//  CARTE D'UN RÉSULTAT
class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.result, required this.onTap});

  final SearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hymn = result.hymn;
    final matched = result.matchedLine?.trim() ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Badge numéro
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  hymn.number.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Titre + ligne matchée─
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hymn.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    if (matched.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        matched,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ] else if ((hymn.actor ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        hymn.actor!.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}