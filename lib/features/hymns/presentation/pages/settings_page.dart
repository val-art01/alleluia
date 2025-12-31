import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/favorites_page.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';

/// Page: Settings / Menu de l'application
///
/// Entrées proposées:
/// - Favoris
/// - Quoi de neuf
/// - Partager l'application
/// - Donner un avis
/// - Faire un don
class Settings extends StatelessWidget {
  const Settings({super.key});

  static const _appShareLink = 'https://example.com/alleluia'; // lien

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const _SectionHeader('Général'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.favorite_rounded,
                title: 'Favoris',
                subtitle: 'Retrouvez vos chants préférés',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FavoritesPage()),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.new_releases_rounded,
                title: 'Quoi de neuf',
                subtitle: 'Notes de version / changelog',
                onTap: () => _showWhatsNew(context),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const _SectionHeader('Communauté'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.share_rounded,
                title: "Partager l'application",
                subtitle: "Copier le lien de l'application",
                onTap: () async {
                  await Clipboard.setData(const ClipboardData(text: _appShareLink));
                  // ignore: use_build_context_synchronously
                  _toast(context, "Lien copié dans le presse-papiers");
                },
              ),
              _SettingsTile(
                icon: Icons.star_rate_rounded,
                title: 'Donner un avis',
                subtitle: "Noter l'application sur le store",
                onTap: () => _toast(context, 'Lien vers le store — à venir'),
              ),
              _SettingsTile(
                icon: Icons.volunteer_activism_rounded,
                title: 'Faire un don',
                subtitle: "Soutenir le projet",
                onTap: () => _showDonateDialog(context, cs),
              ),
            ],
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showWhatsNew(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Quoi de neuf'),
        content: Text(
          'v1.0.0\n• Première version modernisée\n• Navigation améliorée\n• Pages Hymns, Numéros, Catégories, Battements\n\nÀ venir:\n• Favoris\n• Mode hors-ligne\n• Partage avancé',
        ),
      ),
    );
  }

  void _showDonateDialog(BuildContext context, ColorScheme cs) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Faire un don'),
        content: const Text(
          "Merci pour votre soutien !\n\nMoyens (à venir):\n• PayPal\n• Mobile Money\n• Virement bancaire",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fermer', style: TextStyle(color: cs.primary)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 14,
          color: cs.onSurface,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
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
      child: Column(
        children: _withDividers(children),
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    final out = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) {
        out.add(const Divider(height: 1, thickness: 0.5));
      }
    }
    return out;
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppTheme.primaryBlue),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
      trailing: Icon(Icons.chevron_right_rounded, color: cs.primary),
      onTap: onTap,
    );
  }
}


// class _SectionHeader extends StatelessWidget {
//   const _SectionHeader(this.title);
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     final ts = Theme.of(context).textTheme;
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//       child: Text(title, style: ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
//     );
//   }
// }
