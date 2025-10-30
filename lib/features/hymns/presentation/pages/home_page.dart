import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/numbers_page.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/playlist_page.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/settings_page.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_bottom_navbar.dart';


/// Page: Home (navigation par onglets pour les hymnes)
///
/// Rôle:
/// - Fournir une navigation par onglets entre les vues principales
///   (playlist, recherche par numéro, catégories, battements).
///
/// Notes:
/// - `IndexedStack` conserve l'état de chaque page.
/// - `CustomBottomNavBar` gère la sélection d'onglet.
/// - Quand on passera à `go_router`, on pourra synchroniser l'onglet avec l'URL.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _screens = const [
    PlayList(),
    Numbers(),
    // Category(),
    // Battements(),
    Settings(),
  ];

  int _selectedIndex = 0;

  void _onTap(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
