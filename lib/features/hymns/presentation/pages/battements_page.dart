import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/hymn_mini_card.dart';
import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';

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
  HymnsRepository? _repo;
  Future<Map<String, List<Hymn>>>? _future;

  /// Ordre canonique des beats (priorité de classement)
  static const List<String> _beatOrder = [
    '1 temps',
    '2 temps',
    '3 temps lent',
    '3 temps rapide',
    '4 temps rapide',
    '1+3 temps',
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
              child: Text(
                'Erreur de chargement',
                style: TextStyle(color: cs.error),
              ),
            );
          }

          final groups = snap.data ?? const <String, List<Hymn>>{};
          if (groups.isEmpty) {
            return const Center(child: Text('Aucun chant classé par battement.'));
          }

          // Cards accordéon, style moderne
          final tiles = <Widget>[];
          for (final label in _beatOrder) {
            final list = groups[label] ?? const <Hymn>[];
            if (list.isEmpty) continue;

            tiles.add(
              _BeatAccordionCard(
                title: label,
                hymns: list,
              ),
            );
          }

          if (tiles.isEmpty) {
            return const Center(child: Text('Aucun chant classé par battement.'));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: tiles,
          );
        },
      ),
    );
  }

  Future<Map<String, List<Hymn>>> _loadAndGroup() async {
    final list = await _repo!.getAll();
    list.sort((a, b) => a.number.compareTo(b.number));

    final Map<String, List<Hymn>> groups = {
      for (final label in _beatOrder) label: <Hymn>[],
    };

    String norm(String s) => s.trim().toLowerCase();

    for (final h in list) {
      final beats = h.beats
          .map(norm)               // normalise vraiment
          .where((b) => b.isNotEmpty)
          .toSet();                // évite doublons

      if (beats.isEmpty) continue;

      // Un chant peut apparaître dans plusieurs battements
      for (final canonical in _beatOrder) {
        if (beats.contains(norm(canonical))) {
          groups[canonical]!.add(h);
        }
      }
    }

    for (final e in groups.entries) {
      e.value.sort((a, b) => a.number.compareTo(b.number));
    }

    return groups;
  }
}


class _BeatAccordionCard extends StatelessWidget {
  const _BeatAccordionCard({
    required this.title,
    required this.hymns,
  });

  final String title;
  final List<Hymn> hymns;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
          collapsedIconColor: cs.onSurfaceVariant,
          iconColor: cs.primary,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "${hymns.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryBlue,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          children: hymns.map((h) => HymnMiniCard(hymn: h)).toList(),
        ),
      ),
    );
  }
}
