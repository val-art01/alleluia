import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/favorites_repository.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/hymn_mini_card.dart';

/// Page: Favoris
///
/// Rôle:
/// - Afficher la liste des chants favoris (via FavoritesRepository).
/// - Charger ensuite les Hymn complets via HymnsRepository.
/// - UI cohérente avec les autres pages (cards + spacing).
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late FavoritesRepository _favRepo;
  late HymnsRepository _hymnsRepo;

  bool _initialized = false;
  late Future<List<Hymn>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final db = HymnDbScope.of(context);
    _favRepo = FavoritesRepository(db);
    _hymnsRepo = HymnsRepository(db);
    _future = _load();

    _initialized = true;
  }

  /// Charge:
  /// 1) les numéros favoris
  /// 2) les hymnes correspondants
  /// 3) tri stable (par numéro)
  Future<List<Hymn>> _load() async {
    final nums = await _favRepo.getAllFavoriteNumbers();

    if (nums.isEmpty) return <Hymn>[];

    final hymns = await _hymnsRepo.getByNumbers(nums);
    hymns.sort((a, b) => a.number.compareTo(b.number));
    return hymns;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<Hymn>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return _InfoState(
              icon: Icons.error_outline_rounded,
              title: "Erreur de chargement",
              subtitle: "Impossible de charger les favoris.",
              color: cs.error,
            );
          }

          final list = snap.data ?? const <Hymn>[];
          if (list.isEmpty) {
            return const _InfoState(
              icon: Icons.favorite_border_rounded,
              title: "Aucun favori",
              subtitle: "Ajoute des chants en favoris pour les retrouver ici.",
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final h = list[i];
              // Widget commun réutilisé (maintenance ++)
              return HymnMiniCard(hymn: h);
            },
          );
        },
      ),
    );
  }
}

/// Petit état vide / erreur, style cohérent.
class _InfoState extends StatelessWidget {
  const _InfoState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: color ?? cs.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
