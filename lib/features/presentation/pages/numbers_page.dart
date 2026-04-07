import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/routes/app_router.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/providers/hymns_provider.dart';
import 'package:alleluia_tome_1/features/presentation/widgets/custom_appbar.dart';

/// Page : grille de tous les chants par numéro.
///
/// Changements vs l'ancienne version :
///  - StatefulWidget + FutureBuilder → ConsumerWidget + hymnsProvider
///  - HymnDbScope.of(context) supprimé
///  - Navigator.push → context.push (go_router)
///  - Couleurs hardcodées → ColorScheme + AppColors
///  - Tuile redessinée : numéro + indicateur audio
class Numbers extends ConsumerWidget {
  const Numbers({super.key});

  /// Grille responsive selon la largeur d'écran
  static int _crossAxisCount(double width) {
    if (width >= 1200) return 8;
    if (width >= 900) return 7;
    if (width >= 700) return 6;
    if (width >= 500) return 5;
    return 4;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final hymnsAsync = ref.watch(hymnsProvider); // triés par numéro

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
              Icon(Icons.error_outline_rounded, size: 48, color: cs.error),
              const SizedBox(height: 12),
              Text(
                'Impossible de charger les chants',
                style: TextStyle(color: cs.error),
              ),
            ],
          ),
        ),

        // Données
        data: (hymns) {
          if (hymns.isEmpty) {
            return Center(
              child: Text(
                'Aucun chant disponible',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final count = _crossAxisCount(constraints.maxWidth);

              return CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                      child: Row(
                        children: [
                          Text(
                            'Tous les chants',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Badge compteur
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              '${hymns.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: cs.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Grille 
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: count,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _NumberTile(
                          hymn: hymns[i],
                          onTap: () => context.push(
                            AppRoutes.playDetailsPath(hymns[i].number),
                          ),
                        ),
                        childCount: hymns.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

//  TUILE NUMÉRO
class _NumberTile extends StatelessWidget {
  const _NumberTile({
    required this.hymn,
    required this.onTap,
  });

  final Hymn hymn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    // Mise en avant des chants avec audio disponible
    final hasAudio =
        (hymn.audioPath ?? '').trim().isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: appColors.numberTileBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: appColors.hymnsCardBorder,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Numéro centré
              Center(
                child: Text(
                  hymn.number.toString(),
                  semanticsLabel: 'Chant numéro ${hymn.number}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: appColors.numberTileText,
                    height: 1,
                  ),
                ),
              ),

              // Indicateur audio (point jaune) 
              if (hasAudio)
                Positioned(
                  top: 6,
                  right: 7,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: appColors.playerProgress, // jaune
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}