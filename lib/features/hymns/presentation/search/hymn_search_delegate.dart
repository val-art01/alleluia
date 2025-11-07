import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/play_details_page.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/search_repositories.dart';

/// Recherche avec suggestions dès la frappe.
/// - Pas de debounce (on reste simple).
/// - Recherche insensible à la casse.
/// - Cherche dans: number, title/titleNorm, sections.lines.text/textNorm.
class HymnSearchDelegate extends SearchDelegate<Hymn?> {
  HymnSearchDelegate();

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppTheme.primaryBlue, //Colors.white,
        elevation: 3,
        toolbarHeight: 80,
        // shadowColor: Colors.black26,
        iconTheme: const IconThemeData(color: AppTheme.backgroundWhite),
        titleTextStyle: const TextStyle(color: Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.white,
        // hintText: "Search",
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.secondaryYellow, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.secondaryYellow, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.secondaryYellow, width: 2),
        ),
      ),
    );
  }

  @override
  String get searchFieldLabel => "Search Numéro, titre, texte...";

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Effacer',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Retour',
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchResults(
      query: query,
      onTap: (h) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayDetails(h)));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _SearchResults(
      query: query,
      onTap: (h) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayDetails(h)));
      },
    );
  }

  @override
  PreferredSizeWidget? buildBottom(BuildContext context) {
    // Retourne null pour ne pas afficher de barre de filtres
    // return null;
    return PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        color: Colors.transparent,
        height: 0,
      ),
    );
  }
}

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
    final db = HymnDbScope.of(context);
    final repo = HymnsRepository(db);

    return FutureBuilder<List<SearchResult>>(
      future: repo.search(query: query),
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
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final result = results[i];
            final h = result.hymn;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.primary.withOpacity(0.15),
                child: Text(
                  h.number.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                h.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (result.matchedLine != null)
                    Text(
                      result.matchedLine!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (result.matchedLine == null &&
                      (h.actor ?? '').trim().isNotEmpty)
                    Text((h.actor ?? '').trim()),
                ],
              ),
              trailing: Icon(Icons.chevron_right, color: cs.primary),
              onTap: () => onTap(h),
            );
          },
        );
      },
    );
  }
}