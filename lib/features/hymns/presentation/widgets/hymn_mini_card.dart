import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/play_details_page.dart';

/// Mini carte réutilisable pour afficher un chant dans une liste compacte.
///
/// Utilisée dans:
/// - CategoryGroupPage (catégories -> chants)
/// - Battements (rythmes -> chants)
///
/// UX:
/// - compacte (peu d'espace)
/// - cliquable (ripple InkWell)
/// - numéro + titre + chevron
class HymnMiniCard extends StatelessWidget {
  const HymnMiniCard({
    super.key,
    required this.hymn,
    this.onTap,
  });

  final Hymn hymn;

  /// Optionnel: permet au parent de gérer la navigation lui-même.
  /// Si null -> navigation par défaut vers PlayDetails.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ??
            () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PlayDetails(hymn)),
              );
            },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  hymn.number.toString(),
                  semanticsLabel: 'Chant numéro ${hymn.number}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryBlue,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hymn.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
