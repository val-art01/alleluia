import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/category_group_page.dart';
import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';

/// Page: Catégories
///
/// Affiche deux grands groupes fixes:
///  1) Alléluia par ordre liturgique (8 sous-catégories)
///  2) Alléluia par période (10 sous-catégories)
///
/// Les chants sont rangés à partir des champs:
///  - Hymn.liturgicalTimes
///  - Hymn.periods
///
/// Les sous-catégories sont récupérées directement
/// depuis les données (JSON → Isar), puis triées A→Z.
///
class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  HymnsRepository? _repo;
  Future<_GroupedData>? _future;

  // Ordre officiel d'affichage (en minuscules + accents corrects)
  static const List<String> _liturgicOrder = [
    'louanges',
    'adoration',
    'prière de repentance',
    'paroles de grâce',
    'après la leçon',
    'confession de foi',
    'offrandes',
    'sortie',
  ];
  static const List<String> _periodOrder = [
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
    if (_repo == null) {
      final db = HymnDbScope.of(context);
      _repo = HymnsRepository(db);
      _future = _loadAndGroup();
    }
  }

  Future<_GroupedData> _loadAndGroup() async {
    final list = await _repo!.getAll();

    // On prépare les maps avec les clés officielles
    final Map<String, List<Hymn>> liturgic = {
      for (final k in _liturgicOrder) k: <Hymn>[],
    };
    final Map<String, List<Hymn>> period = {
      for (final k in _periodOrder) k: <Hymn>[],
    };

    String norm(String s) => s.trim().toLowerCase();

    for (final h in list) {
      // Catégories liturgiques
      final lits = (h.liturgicalTimes).map(norm).where((e) => e.isNotEmpty).toSet();
      for (final c in lits) {
        if (_liturgicOrder.contains(c)) {
          liturgic[c]!.add(h);
        }
      }

      // Catégories par période
      final pers = (h.periods).map(norm).where((e) => e.isNotEmpty).toSet();
      for (final p in pers) {
        if (_periodOrder.contains(p)) {
          period[p]!.add(h);
        }
      }
    }

    // Tri interne par numéro
    void sortMap(Map<String, List<Hymn>> m) {
      for (final e in m.entries) {
        e.value.sort((a, b) => a.number.compareTo(b.number));
      }
    }

    sortMap(liturgic);
    sortMap(period);
    return _GroupedData(liturgic: liturgic, period: period);
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
              child: Text(
                'Erreur de chargement',
                style: TextStyle(color: cs.error),
              ),
            );
          }
          if (!snap.hasData) {
            return const Center(child: Text('Aucune donnée.'));
          }

          final data = snap.data!;
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                _CategoryEntryCard(
                  title: "Ordre liturgique",
                  subtitle: "Louanges, adoration, repentance, offrandes, sortie…",
                  icon: Icons.menu_book_rounded,
                  groupCount: _CategoryState._liturgicOrder.length,
                  hymnCount: data.liturgic.values.fold<int>(0, (s, e) => s + e.length),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CategoryGroupPage(
                          title: "Ordre liturgique",
                          groups: data.liturgic,
                          order: _CategoryState._liturgicOrder,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _CategoryEntryCard(
                  title: "Ordre périodique",
                  subtitle: "Avent, Noël, Pâques, Pentecôte, Ascension…",
                  icon: Icons.calendar_month_rounded,
                  groupCount: _CategoryState._periodOrder.length,
                  hymnCount: data.period.values.fold<int>(0, (s, e) => s + e.length),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CategoryGroupPage(
                          title: "Périodes",
                          groups: data.period,
                          order: _CategoryState._periodOrder,
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                Text(
                  "Astuce : utilise la loupe pour rechercher un chant rapidement.",
                  style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );

        },
      ),
    );
  }
}

/// Données regroupées passées à l'UI
class _GroupedData {
  const _GroupedData({required this.liturgic, required this.period});

  final Map<String, List<Hymn>> liturgic;
  final Map<String, List<Hymn>> period;
}

class _CategoryEntryCard extends StatelessWidget {
  const _CategoryEntryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.groupCount,
    required this.hymnCount,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final int groupCount;
  final int hymnCount;
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
              color: Color(0x12000000),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppTheme.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        _Pill(text: "$groupCount sous-catégories"),
                        _Pill(text: "$hymnCount chants"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: cs.primary, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppTheme.primaryBlue,
          fontSize: 12,
        ),
      ),
    );
  }
}