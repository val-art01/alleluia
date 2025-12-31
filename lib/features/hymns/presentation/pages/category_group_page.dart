import 'package:alleluia_tome_1/features/hymns/presentation/widgets/hymn_mini_card.dart';
import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';

/// Page qui affiche un groupe de catégories (ex: Ordre liturgique OU Périodes)
/// sous forme d'accordéon :
/// - Sous-catégorie
/// - Déroule -> liste des chants de cette sous-catégorie
class CategoryGroupPage extends StatelessWidget {
  const CategoryGroupPage({
    super.key,
    required this.title,
    required this.groups,
    required this.order,
  });

  /// Titre affiché en haut (AppBar).
  final String title;

  /// Map : sous-catégorie -> liste des chants
  final Map<String, List<Hymn>> groups;

  /// Ordre officiel d’affichage des sous-catégories
  final List<String> order;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // On suit l'ordre officiel, et on enlève les catégories vides
    final keys = order.where((k) => (groups[k]?.isNotEmpty ?? false)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.backgroundWhite,
        elevation: 6,
      ),
      backgroundColor: cs.background,
      body: keys.isEmpty
          ? const Center(child: Text("Aucune sous-catégorie disponible."))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                final hymns = groups[key]!;
                return _AccordionCategoryCard(
                  title: _displayKey(key),
                  count: hymns.length,
                  hymns: hymns,
                );
              },
            ),
    );
  }

  /// Transforme la clé normalisée en libellé affichable.
  static String _displayKey(String k) {
    if (k.isEmpty) return k;
    return k[0].toUpperCase() + k.substring(1);
  }
}

class _AccordionCategoryCard extends StatelessWidget {
  const _AccordionCategoryCard({
    required this.title,
    required this.count,
    required this.hymns,
  });

  final String title;
  final int count;
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
                  "$count",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryBlue,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          children: hymns.map((h) => HymnMiniCard(hymn: h)).toList(growable: false),
        ),
      ),
    );
  }
}