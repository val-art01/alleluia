import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/routes/app_router.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/providers/hymns_provider.dart';
import 'package:alleluia_tome_1/features/presentation/widgets/custom_appbar.dart';

//  ORDRES OFFICIELS D'AFFICHAGE
const _kLiturgicOrder = [
  'louanges',
  'adoration',
  'prière de repentance',
  'paroles de grâce',
  'après la leçon',
  'confession de foi',
  'offrandes',
  'sortie',
];

const _kPeriodOrder = [
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

//  PROVIDER DÉDIÉ AUX CATÉGORIES
//  Dérive depuis hymnsProvider — pas de second
//  appel DB, calcul en mémoire uniquement.
final _categoryDataProvider = FutureProvider<_CategoryData>((ref) async {
  final hymns = await ref.watch(hymnsProvider.future);

  String norm(String s) => s.trim().toLowerCase();

  final liturgic = {for (final k in _kLiturgicOrder) k: <Hymn>[]};
  final period = {for (final k in _kPeriodOrder) k: <Hymn>[]};

  for (final h in hymns) {
    for (final c in h.liturgicalTimes.map(norm)) {
      if (liturgic.containsKey(c)) liturgic[c]!.add(h);
    }
    for (final p in h.periods.map(norm)) {
      if (period.containsKey(p)) period[p]!.add(h);
    }
  }

  // Tri interne par numéro
  for (final list in [...liturgic.values, ...period.values]) {
    list.sort((a, b) => a.number.compareTo(b.number));
  }

  return _CategoryData(liturgic: liturgic, period: period);
});

class _CategoryData {
  const _CategoryData({required this.liturgic, required this.period});
  final Map<String, List<Hymn>> liturgic;
  final Map<String, List<Hymn>> period;
}

///  PAGE CATÉGORIES
class Category extends ConsumerWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dataAsync = ref.watch(_categoryDataProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const CustomAppBar(),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Erreur', style: TextStyle(color: cs.error)),
        ),
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [

            // Titre de section
            _SectionLabel(label: 'Par temps liturgique'),
            const SizedBox(height: 10),

            _CategoryEntryCard(
              title: 'Ordre liturgique',
              subtitle: 'Louanges, adoration, repentance, offrandes, sortie…',
              icon: Icons.menu_book_rounded,
              groupCount: _kLiturgicOrder.length,
              hymnCount: data.liturgic.values
                  .fold(0, (s, e) => s + e.length),
              onTap: () => _openGroup(
                context,
                title: 'Ordre liturgique',
                groups: data.liturgic,
                order: _kLiturgicOrder,
              ),
            ),

            const SizedBox(height: 20),

            // Titre de section
            _SectionLabel(label: 'Par période liturgique'),
            const SizedBox(height: 10),

            _CategoryEntryCard(
              title: 'Périodes',
              subtitle: 'Avent, Noël, Pâques, Pentecôte, Ascension…',
              icon: Icons.calendar_month_rounded,
              groupCount: _kPeriodOrder.length,
              hymnCount: data.period.values
                  .fold(0, (s, e) => s + e.length),
              onTap: () => _openGroup(
                context,
                title: 'Périodes',
                groups: data.period,
                order: _kPeriodOrder,
              ),
            ),

            const SizedBox(height: 32),

            // Astuce
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12,
              ),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded,
                      size: 18, color: cs.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Utilise la loupe pour rechercher un chant rapidement.',
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGroup(
    BuildContext context, {
    required String title,
    required Map<String, List<Hymn>> groups,
    required List<String> order,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryGroupPage(
          title: title,
          groups: groups,
          order: order,
        ),
      ),
    );
  }
}

///  LABEL DE SECTION
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: cs.onSurfaceVariant.withOpacity(0.6),
      ),
    );
  }
}

///  CARTE D'ENTRÉE CATÉGORIE
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
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: appColors.hymnsCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: appColors.hymnsCardBorder),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: cs.onPrimaryContainer, size: 24),
              ),
              const SizedBox(width: 14),

              // Textes
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Pills
                    Wrap(
                      spacing: 8,
                      children: [
                        _Pill(label: '$groupCount catégories'),
                        _Pill(label: '$hymnCount chants'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant.withOpacity(0.5),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  PILL (badge info)
class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: cs.onPrimaryContainer,
          fontSize: 11,
        ),
      ),
    );
  }
}

//  PAGE GROUPE (accordéon sous-catégories)
class CategoryGroupPage extends StatelessWidget {
  const CategoryGroupPage({
    super.key,
    required this.title,
    required this.groups,
    required this.order,
  });

  final String title;
  final Map<String, List<Hymn>> groups;
  final List<String> order;

  static String _displayKey(String k) =>
      k.isEmpty ? k : k[0].toUpperCase() + k.substring(1);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final keys = order
        .where((k) => groups[k]?.isNotEmpty ?? false)
        .toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: keys.isEmpty
          ? Center(
              child: Text(
                'Aucune sous-catégorie disponible',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: keys.length,
              itemBuilder: (context, i) {
                final key = keys[i];
                final hymns = groups[key]!;
                return _AccordionCard(
                  title: _displayKey(key),
                  hymns: hymns,
                );
              },
            ),
    );
  }
}

///  ACCORDÉON D'UNE SOUS-CATÉGORIE
class _AccordionCard extends StatelessWidget {
  const _AccordionCard({
    required this.title,
    required this.hymns,
  });

  final String title;
  final List<Hymn> hymns;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: appColors.hymnsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.hymnsCardBorder),
      ),
      child: Theme(
        // Supprime la ligne de séparation native de ExpansionTile
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 4,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          collapsedIconColor: cs.onSurfaceVariant,
          iconColor: cs.primary,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
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