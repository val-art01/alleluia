// import 'package:alleluia_tome_1/app/themes/app_theme.dart';
// import 'package:flutter/material.dart';

// /// Barre de navigation inférieure avec icônes harmonisées.
// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   final int currentIndex;
//   final void Function(int) onTap;

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: const [
//         BottomNavigationBarItem(
//           label: 'Titre',
//           icon: Icon(Icons.library_music_rounded, size: 26),
//         ),
//         BottomNavigationBarItem(
//           label: 'Numéro',
//           icon: Icon(Icons.confirmation_number_rounded, size: 26),
//         ),
//         BottomNavigationBarItem(
//           label: 'Catégories',
//           icon: Icon(Icons.category_rounded, size: 26),
//         ),
//         BottomNavigationBarItem(
//           label: 'Battements',
//           icon: Icon(Icons.graphic_eq_rounded, size: 26),
//         ),
//         BottomNavigationBarItem(
//           label: 'Menu',
//           icon: Icon(Icons.settings_rounded, size: 26),
//         ),
//       ],
//       currentIndex: currentIndex,
//       onTap: onTap,
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: AppTheme.primaryBlue,
//       selectedItemColor: AppTheme.secondaryYellow,
//       unselectedItemColor: Colors.white,
//       selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//       unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
//       showSelectedLabels: true,
//       showUnselectedLabels: true,
//     );
//   }
// }

import 'package:flutter/material.dart';
// import 'package:alleluia_tome_1/app/themes/app_theme.dart';

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
          icon: Icon(Icons.library_music_rounded),
          label: 'Titre',
        ),
        NavigationDestination(
          icon: Icon(Icons.confirmation_number_rounded),
          label: 'Numéro',
        ),
        NavigationDestination(
          icon: Icon(Icons.category_rounded),
          label: 'Catégories',
        ),
        NavigationDestination(
          icon: Icon(Icons.graphic_eq_rounded),
          label: 'Battements',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_rounded),
          label: 'Menu',
        ),
      ],
    );
  }
}


