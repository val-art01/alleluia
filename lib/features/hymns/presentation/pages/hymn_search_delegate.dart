import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/play_details_page.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/search_repositories.dart';

/// Recherche globale des chants via [SearchDelegate].
///
/// Fonctionnement :
/// - L'utilisateur tape dans le champ de recherche
/// - [buildSuggestions] est appelé à chaque frappe (suggestions en direct)
/// - Quand l'utilisateur valide (Enter), [buildResults] est utilisé
///
/// Ici, on affiche la même UI dans suggestions et results.
class HymnSearchDelegate extends SearchDelegate<Hymn?> {
  HymnSearchDelegate();

  /// Thème appliqué à l'AppBar spécifique de la recherche.
  ///
  /// Important :
  /// - On force un AppBar bleu (comme l'app)
  /// - Le champ de recherche est blanc pour la lisibilité
  /// - Bordure jaune uniquement quand focus (plus propre)
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.backgroundWhite,
        elevation: 6,
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: AppTheme.backgroundWhite),
        titleTextStyle: TextStyle(
          color: AppTheme.backgroundWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide:
              const BorderSide(color: AppTheme.secondaryYellow, width: 2),
        ),
      ),
    );
  }

  /// Texte du placeholder dans le champ de recherche.
  @override
  String get searchFieldLabel => "Search Numéro, titre, texte...";

  /// Boutons à droite du champ.
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Effacer',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            // Revenir en mode suggestions quand on efface.
            showSuggestions(context);
          },
        ),
    ];
  }

  /// Bouton à retour.
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Retour',
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  /// Suggestions en direct (appelé dès que [query] change).
  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchResults(
      query: query,
      onTap: (h) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayDetails(h))),
    );
  }

  /// Résultats "validés" (quand l'utilisateur lance la recherche).
  ///
  /// Ici, on affiche la même liste que dans [buildSuggestions].
  @override
  Widget buildResults(BuildContext context) {
    return _SearchResults(
      query: query,
      onTap: (h) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayDetails(h))),
    );
  }

  /// Bottom optionnel sous l'AppBar (chips/filtres).
  @override
  PreferredSizeWidget? buildBottom(BuildContext context) {
    return const PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: SizedBox.shrink(),
    );
  }
}

/// Widget qui affiche réellement la liste des résultats.
///
/// Responsabilités :
/// - appeler le repository pour chercher (via Future)
/// - gérer loading / erreur / vide
/// - afficher des cards harmonisées
class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.query,
    required this.onTap,
  });

  final String query;
  final void Function(Hymn) onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final db = HymnDbScope.of(context); // DB récupérée via scope .
    final repo = HymnsRepository(db);

    return FutureBuilder<List<SearchResult>>(
      future: repo.search(query: query), // La recherche doit pouvoir gérer query vide dans repo.
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snap.hasError) {
          return Center(
            child: Text(
              'Erreur: ${snap.error}',
              style: TextStyle(color: cs.error),
            ),
          );
        }

        final results = snap.data ?? const <SearchResult>[];
        if (results.isEmpty) {
          return const Center(child: Text('Aucun résultat'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final result = results[i];
            final hymn = result.hymn;

            return _SearchResultCard(
              hymn: hymn,
              matchedLine: result.matchedLine,
              onTap: () => onTap(hymn),
            );
          },
        );
      },
    );
  }
}

/// Card UI d'un résultat de recherche.
///
/// Points UI :
/// - Badge numéro (bleu doux)
/// - Titre en gras
/// - Sous-texte : ligne matchée (si dispo) sinon auteur
/// - Chevron à droite
class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.hymn,
    required this.matchedLine,
    required this.onTap,
  });

  final Hymn hymn;
  final String? matchedLine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 4),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Badge numéro
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  hymn.number.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hymn.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.5,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Ligne matchée en priorité
                    if (matchedLine != null && matchedLine!.trim().isNotEmpty)
                      Text(
                        matchedLine!.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      )
                    else if ((hymn.actor ?? '').trim().isNotEmpty)
                      Text(
                        hymn.actor!.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppTheme.ongrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      )
                    else
                      Text(
                        "—",
                        style: TextStyle(
                          color: AppTheme.ongrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 28,
                color: cs.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
