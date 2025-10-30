import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/play_details_page.dart';

/// Page: Battements (Rythmes)
///
/// Regroupe les chants par rythme selon un ordre défini par le produit.
/// Si un chant possède plusieurs beats, on l'associe au premier qui matche l'ordre.
/// Ce qui ne matche pas est mis dans "Autres".
class Battements extends StatefulWidget {
  const Battements({super.key});

  @override
  State<Battements> createState() => _BattementsState();
}

class _BattementsState extends State<Battements> {
  late HymnsRepository _repo;
  late Future<Map<String, List<Hymn>>> _future;

  // Ordre imposé par le produit (clé affichée -> liste de mots-clés de matching)
  // On normalise tout en minuscules pour comparer proprement.
  static const List<_BeatBucket> _order = [
    _BeatBucket('1 temps', ['1 temps']),
    _BeatBucket('2 temps', ['2 temps']),
    _BeatBucket('3 temps lent', ['3 temps lent']),
    _BeatBucket('3 temps rapide / BOBO', ['3 temps rapide', 'bobo', '3 temps bobo']),
    _BeatBucket('4 temps rapide', ['4 temps rapide']),
    _BeatBucket('1 temps lent', ['1 temps lent']),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = HymnDbScope.of(context);
    _repo = HymnsRepository(db);
    _future = _loadAndGroup();
  }

  Future<Map<String, List<Hymn>>> _loadAndGroup() async {
    final list = await _repo.getAll();

    // Prépare les groupes dans l'ordre voulu + "Autres"
    final Map<String, List<Hymn>> groups = {
      for (final b in _order) b.label: <Hymn>[],
      'Autres': <Hymn>[],
    };

    String norm(String s) => s.trim().toLowerCase();

    for (final h in list) {
      // Normaliser tous les beats du chant
      final beats = h.beats.map(norm).toList();

      // Trouver le premier bucket correspondant
      String? matchedLabel;
      for (final bucket in _order) {
        final anyMatch = beats.any((b) =>
            bucket.keywords.any((kw) => b.contains(kw))); // "contains" = matching souple
        if (anyMatch) {
          matchedLabel = bucket.label;
          break;
        }
      }

      groups[matchedLabel ?? 'Autres']!.add(h);
    }

    // Trier les hymnes par numéro dans chaque groupe
    for (final e in groups.entries) {
      e.value.sort((a, b) => a.number.compareTo(b.number));
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<Map<String, List<Hymn>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text('Erreur de chargement', style: TextStyle(color: cs.error)),
            );
          }

          final groups = snap.data!;
          // Construire une liste ordonnée de sections suivant _order
          final orderedKeys = [
            ..._order.map((b) => b.label),
            'Autres',
          ];

          final tiles = <Widget>[];
          for (final key in orderedKeys) {
            final list = groups[key] ?? const <Hymn>[];
            if (list.isEmpty) continue; // n’affiche pas les sections vides

            tiles.add(
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    listTileTheme: ListTileThemeData(
                      iconColor: cs.primary,
                      textColor: cs.onSurface,
                    ),
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      key,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    children: list
                        .map((h) => _HymnRow(hymn: h))
                        .toList(),
                  ),
                ),
              ),
            );
          }

          if (tiles.isEmpty) {
            return const Center(child: Text('Aucun chant classé par battement.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: tiles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => tiles[i],
          );
        },
      ),
    );
  }
}

class _HymnRow extends StatelessWidget {
  const _HymnRow({required this.hymn});

  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      dense: true,
      title: Text('${hymn.number} — ${hymn.title.toLowerCase()}'),
      trailing: Icon(Icons.chevron_right, color: cs.primary, size: 20),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PlayDetails(hymn)),
        );
      },
    );
  }
}

/// Petit helper pour définir un "bucket" de battements
class _BeatBucket {
  const _BeatBucket(this.label, this.keywords);
  final String label;
  final List<String> keywords; // en minuscules
}
