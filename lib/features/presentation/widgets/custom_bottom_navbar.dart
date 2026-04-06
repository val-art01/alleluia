import 'package:flutter/material.dart';

/// Barre de navigation inférieure Material 3.
///
/// Utilisée par [HomePage] via le ShellRoute de go_router.
/// L'index sélectionné et le callback sont gérés par [HomePage].
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.library_music_outlined),
          selectedIcon: Icon(Icons.library_music_rounded),
          label: 'Titre',
        ),
        NavigationDestination(
          icon: Icon(Icons.tag_outlined),
          selectedIcon: Icon(Icons.tag_rounded),
          label: 'Numéro',
        ),
        NavigationDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category_rounded),
          label: 'Catégories',
        ),
        NavigationDestination(
          icon: Icon(Icons.music_note_outlined),
          selectedIcon: Icon(Icons.music_note_rounded),
          label: 'Battements',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_outlined),
          selectedIcon: Icon(Icons.menu_rounded),
          label: 'Menu',
        ),
      ],
    );
  }
}