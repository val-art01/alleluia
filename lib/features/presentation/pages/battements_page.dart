import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/routes/app_router.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/providers/hymns_provider.dart';
import 'package:alleluia_tome_1/features/presentation/widgets/custom_appbar.dart';

//  ORDRE CANONIQUE DES BATTEMENTS
const _kBeatOrder = [
  '1 temps',
  '2 temps',
  '3 temps lent',
  '3 temps rapide',
  '4 temps rapide',
  '1+3 temps',
];

// Icônes associées à chaque battement
const _kBeatIcons = <String, IconData>{
  '1 temps':        Icons.looks_one_rounded,
  '2 temps':        Icons.looks_two_rounded,
  '3 temps lent':   Icons.music_note_rounded,
  '3 temps rapide': Icons.music_note_rounded,
  '4 temps rapide': Icons.queue_music_rounded,
  '1+3 temps':      Icons.graphic_eq_rounded,
};

///  PROVIDER DÉDIÉ AUX BATTEMENTS
///  Dérive depuis hymnsProvider — pas de second appel DB.
final _beatDataProvider =
    FutureProvider<Map<String, List<Hymn>>>((ref) async {
  final hymns = await ref.watch(hymnsProvider.future);

  String norm(String s) => s.trim().toLowerCase();

  final groups = {for (final b in _kBeatOrder) b: <Hymn>[]};

  for (final h in hymns) {
    final beats = h.beats
        .map(norm)
        .where((b) => b.isNotEmpty)
        .toSet();

    for (final canonical in _kBeatOrder) {
      if (beats.contains(norm(canonical))) {
        groups[canonical]!.add(h);
      }
    }
  }

  // Tri interne par numéro
  for (final list in groups.values) {
    list.sort((a, b) => a.number.compareTo(b.number));
  }

  return groups;
});

///  PAGE BATTEMENTS
class Battements extends ConsumerWidget {
  const Battements({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dataAsync = ref.watch(_beatDataProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const CustomAppBar(),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Erreur', style: TextStyle(color: cs.error)),
        ),
        data: (groups) {
          final keys = _kBeatOrder
              .where((k) => groups[k]?.isNotEmpty ?? false)
              .toList();

          if (keys.isEmpty) {
            return Center(
              child: Text(
                'Aucun chant classé par battement',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Text(
                    'RYTHMES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: cs.onSurfaceVariant.withOpacity(0.6),
                    ),
                  ),
                ),
              ),

              // Accordéons 
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _BeatAccordionCard(
                      beat: keys[i],
                      hymns: groups[keys[i]]!,
                    ),
                    childCount: keys.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

///  ACCORDÉON D'UN BATTEMENT
class _BeatAccordionCard extends StatelessWidget {
  const _BeatAccordionCard({
    required this.beat,
    required this.hymns,
  });

  final String beat;
  final List<Hymn> hymns;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final icon = _kBeatIcons[beat] ?? Icons.music_note_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: appColors.hymnsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.hymnsCardBorder),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 6,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          collapsedIconColor: cs.onSurfaceVariant,
          iconColor: cs.primary,
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: cs.onPrimaryContainer),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  beat,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // Badge compteur
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${hymns.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: cs.onPrimaryContainer,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          children: hymns
              .map((h) => _HymnMiniRow(hymn: h))
              .toList(growable: false),
        ),
      ),
    );
  }
}

///  MINI LIGNE CHANT (dans l'accordéon)
class _HymnMiniRow extends StatelessWidget {
  const _HymnMiniRow({required this.hymn});
  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => context.push(AppRoutes.playDetailsPath(hymn.number)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              // Badge numéro
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hymn.number.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hymn.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: cs.onSurfaceVariant.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}