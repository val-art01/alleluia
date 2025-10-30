import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/play_details_page.dart';

/// Page: Catégories
/// - Affiche deux grands groupes fixes:
///   1) Alléluia par ordre liturgique (8 sous-catégories)
///   2) Alléluia par période (10 sous-catégories)
/// - Regroupe les chants selon leurs catégories (case-insensitive).
/// - Les catégories non reconnues sont placées dans "Autres".
class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late HymnsRepository _repo;
  late Future<_GroupedData> _future;

  // Sous-catégories connues (normalisées en minuscules pour matching robuste)
  static const List<String> _liturgicList = [
    'louanges',
    'adorations',
    'prière de repentance',
    'paroles de grâce',
    'après la leçon',
    'confession de foi',
    'offrande',
    'sortie',
  ];

  static const List<String> _periodList = [
    'ordinaire',
    'réformation',
    'avent',
    'noël',
    'nouvel an',
    'rameaux',
    'vendredi saint',
    'pâques',
    'ascension',
    'pentecôte',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = HymnDbScope.of(context);
    _repo = HymnsRepository(db);
    _future = _loadAndGroup();
  }

  Future<_GroupedData> _loadAndGroup() async {
    final list = await _repo.getAll();

    // maps: sous-catégorie -> liste de chants
    final Map<String, List<Hymn>> liturgic = {
      for (final k in _liturgicList) k: <Hymn>[],
      'autres': <Hymn>[],
    };
    final Map<String, List<Hymn>> period = {
      for (final k in _periodList) k: <Hymn>[],
      'autres': <Hymn>[],
    };

    // Collecte des catégories "inconnues" pour éventuellement les afficher à part
    final Map<String, List<Hymn>> unknown = {};

    String _norm(String s) => s.trim().toLowerCase();

    for (final h in list) {
      final cats = h.categories.map(_norm).toSet();
      if (cats.isEmpty) {
        // Sans catégorie : on ne range nulle part (ou on pourrait choisir un défaut).
        continue;
      }

      // Flags pour savoir si au moins une cat a matché un bloc
      bool matchedLiturgic = false;
      bool matchedPeriod = false;

      for (final c in cats) {
        if (_liturgicList.contains(c)) {
          liturgic[c]!.add(h);
          matchedLiturgic = true;
        } else if (_periodList.contains(c)) {
          period[c]!.add(h);
          matchedPeriod = true;
        } else {
          // on collectera dans "divers"
          unknown.putIfAbsent(c, () => <Hymn>[]).add(h);
        }
      }

      // S'il avait des catégories mais aucune reconnue dans le groupe,
      // on pousse dans "autres" correspondant pour ne pas les perdre
      if (!matchedLiturgic && cats.any((c) => !_periodList.contains(c))) {
        liturgic['autres']!.add(h);
      }
      if (!matchedPeriod && cats.any((c) => !_liturgicList.contains(c))) {
        period['autres']!.add(h);
      }
    }

    // Tri par numéro dans chaque groupe
    void sortMapLists(Map<String, List<Hymn>> m) {
      for (final e in m.entries) {
        e.value.sort((a, b) => a.number.compareTo(b.number));
      }
    }

    sortMapLists(liturgic);
    sortMapLists(period);
    sortMapLists(unknown);

    return _GroupedData(
      liturgic: liturgic,
      period: period,
      unknown: unknown,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<_GroupedData>(
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

          final data = snap.data!;
          final blocks = <Widget>[
            _CategoryBlock(
              title: "Alléluia par ordre liturgique",
              subtitle: "Louanges, Adorations, Prière de repentance, Paroles de grâce, Après la leçon, Confession de foi, Offrande, Sortie",
              groups: data.liturgic,
            ),
            _CategoryBlock(
              title: "Alléluia par période",
              subtitle: "Ordinaire, Réformation, Avent, Noël, Nouvel an, Rameaux, Vendredi saint, Pâques, Ascension, Pentecôte",
              groups: data.period,
            ),
          ];

          // Si on a des catégories inconnues, on les montre dans un bloc "divers"
          if (data.unknown.isNotEmpty) {
            blocks.add(
              _CategoryBlock(
                title: "Catégories diverses",
                subtitle: "Catégories non classées dans les deux grands blocs",
                groups: data.unknown,
                // on trie les keys par ordre alpha
                sortKeysAlphabetically: true,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: blocks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => blocks[i],
          );
        },
      ),
    );
  }
}

/// Données regroupées passées à l'UI
class _GroupedData {
  _GroupedData({
    required this.liturgic,
    required this.period,
    required this.unknown,
  });

  final Map<String, List<Hymn>> liturgic;
  final Map<String, List<Hymn>> period;
  final Map<String, List<Hymn>> unknown;
}

/// Un bloc card + ExpansionTiles pour un groupe (ex: "par ordre liturgique")
class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.title,
    required this.subtitle,
    required this.groups,
    this.sortKeysAlphabetically = false,
  });

  final String title;
  final String subtitle;
  final Map<String, List<Hymn>> groups;
  final bool sortKeysAlphabetically;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // on prépare l'ordre d'affichage des sous-catégories
    final entries = groups.entries.toList();
    if (sortKeysAlphabetically) {
      entries.sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));
    } else {
      // sinon on garde l'ordre d'insertion (déjà dans la logique plus haut)
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête du bloc
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            const Divider(height: 1),

            // Sous-catégories
            ...entries.map((e) {
              final subtitle = e.key; // clé normalisée (lower case)
              final displayTitle = _displayKey(e.key); // version jolie en titre
              final list = e.value;

              // on n'affiche pas les sous-catégories vides
              if (list.isEmpty) return const SizedBox.shrink();

              return Theme(
                data: theme.copyWith(
                  dividerColor: Colors.transparent,
                  listTileTheme: ListTileThemeData(
                    iconColor: cs.primary,
                    textColor: cs.onSurface,
                  ),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    displayTitle,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  childrenPadding: const EdgeInsets.only(bottom: 8),
                  children: list
                      .map((h) => _HymnRow(hymn: h))
                      .toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Transforme la clé normalisée en libellé affichable (capitalisation simple).
  String _displayKey(String k) {
    if (k.isEmpty) return k;
    return k[0].toUpperCase() + k.substring(1);
  }
}

/// Ligne cliquable pour un Hymn
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
