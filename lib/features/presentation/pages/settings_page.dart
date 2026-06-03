
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:alleluia_tome_1/app/app.dart';
import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/routes/app_router.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/services/share_service.dart';
import 'package:alleluia_tome_1/core/providers/theme_provider.dart';
import 'package:alleluia_tome_1/core/providers/favorites_provider.dart';
import 'package:alleluia_tome_1/features/presentation/widgets/custom_appbar.dart';


/// Page: Settings / Menu de l'application
///
/// Entrées proposées:
/// - Favoris
/// - Quoi de neuf
/// - Partager l'application
/// - Donner un avis
/// - Faire un don

class Settings extends ConsumerWidget {
  const Settings({super.key});

  // static const _shareLink = 'https://example.com/alleluia';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    // final themeMode = ref.watch(themeModeProvider);
    final themeMode = ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.light;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const CustomAppBar(withSearch: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [

          // ── Section Général ─────────────────
          _SectionLabel(label: 'Général'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              // Favoris
              _SettingsTile(
                icon: Icons.favorite_rounded,
                iconColor: cs.error,
                title: 'Favoris',
                subtitle: 'Retrouvez vos chants préférés',
                onTap: () => _openFavorites(context),
              ),
              // Changelog
              _SettingsTile(
                icon: Icons.new_releases_rounded,
                iconColor: cs.primary,
                title: 'Quoi de neuf',
                subtitle: 'Notes de version',
                onTap: () => _showWhatsNew(context),
              ),
            ],
          ),

          const SizedBox(height: 20),

          //  Section Apparence
          _SectionLabel(label: 'Apparence'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _ThemeTile(current: themeMode),
            ],
          ),

          const SizedBox(height: 20),

          // Section Communauté
          _SectionLabel(label: 'Communauté'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              // _SettingsTile(
              //   icon: Icons.share_rounded,
              //   iconColor: cs.primary,
              //   title: "Partager l'application",
              //   subtitle: 'Copier le lien',
              //   onTap: () async {
              //     await Clipboard.setData(
              //       const ClipboardData(text: _shareLink),
              //     );
              //     if (!context.mounted) return;
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //         content: Text('Lien copié dans le presse-papiers'),
              //       ),
              //     );
              //   },
              // ),
              _SettingsTile(
                icon: Icons.share_rounded,
                iconColor: cs.primary,
                title: "Partager l'application",
                subtitle: 'Inviter quelqu\'un à utiliser Alleluia',
                onTap: () => ShareService.shareApp(context),
              ),

              _SettingsTile(
                icon: Icons.star_rate_rounded,
                iconColor: const Color(0xFFF9A825),
                title: 'Donner un avis',
                subtitle: "Noter l'application",
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lien store — à venir')),
                ),
              ),
              _SettingsTile(
                icon: Icons.volunteer_activism_rounded,
                iconColor: cs.error,
                title: 'Faire un don',
                subtitle: 'Soutenir le projet',
                onTap: () => _showDonateDialog(context),
                showChevron: false,
              ),
            ],
          ),

          const SizedBox(height: 24),

          //  Version
          Center(
            child: Text(
              'Alleluia • Tome 1 • v1.0.0\nÉglise Évangélique du Cameroun',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurfaceVariant.withOpacity(0.5),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFavorites(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _FavoritesPage()),
    );
  }

  void _showWhatsNew(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quoi de neuf'),
        content: const Text(
          'v1.0.0\n'
          '• Architecture Riverpod + go_router\n'
          '• Navigation fluide entre onglets\n'
          '• Recherche dans titres et paroles\n'
          '• Favoris persistants\n'
          '• Thème clair / sombre\n\n'
          'À venir :\n'
          '• Partage de chants\n'
          '• Mode hors-ligne amélioré',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showDonateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Faire un don'),
        content: const Text(
          'Merci pour votre soutien !\n\n'
          'Moyens disponibles (à venir) :\n'
          '• Mobile Money\n'
          '• PayPal\n'
          '• Virement bancaire',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

//  TUILE CHOIX DE THÈME
class _ThemeTile extends ConsumerWidget {
  const _ThemeTile({required this.current});
  final ThemeMode current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.palette_rounded,
                color: cs.onPrimaryContainer, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thème',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text('Apparence de l\'application',
                    style: TextStyle(
                        color: cs.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          // Sélecteur : clair / auto / sombre
          _ThemeSegment(current: current),
        ],
      ),
    );
  }
}

class _ThemeSegment extends ConsumerWidget {
  const _ThemeSegment({required this.current});
  final ThemeMode current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return SegmentedButton<ThemeMode>(
      style: SegmentedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        visualDensity: VisualDensity.compact,
        selectedBackgroundColor: cs.primaryContainer,
        selectedForegroundColor: cs.onPrimaryContainer,
      ),
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode_rounded, size: 18),
          tooltip: 'Clair',
        ),
        ButtonSegment(
          value: ThemeMode.system,
          icon: Icon(Icons.brightness_auto_rounded, size: 18),
          tooltip: 'Automatique',
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode_rounded, size: 18),
          tooltip: 'Sombre',
        ),
      ],
      selected: {current},
      onSelectionChanged: (modes) {
        // ref.read(themeModeProvider.notifier).state = modes.first;
        ref.read(themeModeProvider.notifier).setMode(modes.first);
      },
    );
  }
}

//  LABEL DE SECTION
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

//  CARTE SETTINGS (groupe de tuiles)
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final cs = Theme.of(context).colorScheme;

    final items = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i != children.length - 1) {
        items.add(Divider(
          height: 1,
          thickness: 0.5,
          indent: 70,
          color: cs.outlineVariant.withOpacity(0.5),
        ));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: appColors.hymnsCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.hymnsCardBorder),
      ),
      child: Column(children: items),
    );
  }
}

//  TUILE SETTINGS
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.showChevron = true,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14, vertical: 4,
      ),
      leading: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
      trailing: showChevron
          ? Icon(Icons.chevron_right_rounded,
              color: cs.onSurfaceVariant.withOpacity(0.4), size: 22)
          : null,
    );
  }
}

//  PAGE FAVORIS (poussée depuis Settings)
class _FavoritesPage extends ConsumerWidget {
  const _FavoritesPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    // final appColors = Theme.of(context).extension<AppColors>()!;
    final favHymnsAsync = ref.watch(favoriteHymnsProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Favoris'),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: favHymnsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Erreur', style: TextStyle(color: cs.error)),
        ),
        data: (hymns) {
          if (hymns.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 64,
                      color: cs.onSurfaceVariant.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun favori',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Appuie sur le ♡ d\'un chant\npour l\'ajouter ici.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: hymns.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _FavHymnCard(hymn: hymns[i]),
          );
        },
      ),
    );
  }
}

//  CARTE FAVORI
class _FavHymnCard extends ConsumerWidget {
  const _FavHymnCard({required this.hymn});
  final Hymn hymn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(AppRoutes.playDetailsPath(hymn.number)),
        child: Ink(
          decoration: BoxDecoration(
            color: appColors.hymnsCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: appColors.hymnsCardBorder),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              // Badge numéro
              Container(
                width: 46, height: 46,
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
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Bouton retirer des favoris
              IconButton(
                icon: Icon(
                  Icons.favorite_rounded,
                  size: 20,
                  color: appColors.favoriteFill,
                ),
                tooltip: 'Retirer des favoris',
                onPressed: () => ref.read(favoritesProvider.notifier).toggle(hymn.number),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant.withOpacity(0.4),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
