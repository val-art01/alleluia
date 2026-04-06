import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/routes/app_router.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/providers/hymns_provider.dart';
import 'package:alleluia_tome_1/core/providers/favorites_provider.dart';
import 'package:alleluia_tome_1/features/presentation/widgets/custom_appbar.dart';

/// Page : liste alphabétique de tous les chants.
///
/// Changements vs l'ancienne version :
///  - FutureBuilder → ref.watch(hymnsSortedAlphaProvider)
///  - HymnDbScope.of(context) supprimé
///  - Navigator.push → context.push (go_router)
///  - Couleurs hardcodées → ColorScheme du thème
///  - Bouton favori sur chaque carte
class PlayList extends ConsumerWidget {
  const PlayList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final hymnsAsync = ref.watch(hymnsSortedAlphaProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const CustomAppBar(),
      body: hymnsAsync.when(
        // Chargement
        loading: () => const Center(child: CircularProgressIndicator()),

        // Erreur
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: cs.error),
              const SizedBox(height: 12),
              Text(
                'Impossible de charger les chants',
                style: TextStyle(color: cs.error),
              ),
            ],
          ),
        ),

        // Données─
        data: (hymns) {
          if (hymns.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_music_outlined,
                    size: 56,
                    color: cs.onSurfaceVariant.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun chant disponible',
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: hymns.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _HymnCard(
              hymn: hymns[index],
              onTap: () => context.push(
                AppRoutes.playDetailsPath(hymns[index].number),
              ),
            ),
          );
        },
      ),
    );
  }
}

//  CARTE D'UN CHANT
//  ConsumerWidget pour réagir aux favoris
//  indépendamment du reste de la liste.
class _HymnCard extends ConsumerWidget {
  const _HymnCard({
    required this.hymn,
    required this.onTap,
  });

  final Hymn hymn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final isFav = ref.watch(isFavoriteProvider(hymn.number));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: appColors.hymnsCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: appColors.hymnsCardBorder,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
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

              // Titre + auteur
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hymn.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                    if ((hymn.actor ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        hymn.actor!.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Favori
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: 20,
                  color: isFav
                      ? appColors.favoriteFill
                      : cs.onSurfaceVariant.withOpacity(0.4),
                ),
                tooltip: isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
                onPressed: () =>
                    ref.read(favoritesProvider.notifier).toggle(hymn.number),
              ),

              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant.withOpacity(0.5),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}