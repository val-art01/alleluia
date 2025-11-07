import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/hymn_search_delegate.dart';
import 'package:flutter/material.dart';

/// AppBar personnalisée partagée dans la feature Hymns.
/// Utilise les couleurs du thème pour rester cohérente clair/sombre.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  static const double _kHeight = 80;

  @override
  Size get preferredSize => const Size.fromHeight(_kHeight);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: AppTheme.primaryBlue, //cs.primary,
      foregroundColor: AppTheme.backgroundWhite,
      elevation: 5.0,
      toolbarHeight: _kHeight,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/logoCE.png'),
      ),
      title: const Text(
        "Chants Pour Le\nCulte d'Enfants",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Rechercher un chant',
          onPressed: () {
            showSearch(
              context: context,
              delegate: HymnSearchDelegate(),
            );
          },
        ),
      ],
    );
  }
}
