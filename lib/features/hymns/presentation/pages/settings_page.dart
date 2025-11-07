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
        children: [
          const _SectionHeader('Général'),
          ListTile(
            leading: const Icon(Icons.favorite_rounded),
            title: const Text('Favoris'),
            subtitle: const Text('Retrouvez vos chants préférés'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
               Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.new_releases_rounded),
            title: const Text('Quoi de neuf'),
            subtitle: const Text('Notes de version / changelog'),
            onTap: () => _showWhatsNew(context),
          ),
          const Divider(height: 24),

          const _SectionHeader('Communauté'),
          ListTile(
            leading: const Icon(Icons.share_rounded),
            title: const Text("Partager l'application"),
            onTap: () async {
              await Clipboard.setData(const ClipboardData(text: _appShareLink));
              // ignore: use_build_context_synchronously
              _toast(context, "Lien copié dans le presse-papiers");
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_rate_rounded),
            title: const Text('Donner un avis'),
            onTap: () {
              // ouvrir le store via url_launcher
              _toast(context, 'Lien vers le store — à venir');
            },
          ),
          ListTile(
            leading: const Icon(Icons.volunteer_activism_rounded),
            title: const Text('Faire un don'),
            onTap: () => _showDonateDialog(context, cs),
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
    final ts = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
