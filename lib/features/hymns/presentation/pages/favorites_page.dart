import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/play_details_page.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/favorites_repository.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late FavoritesRepository _favRepo;
  late HymnsRepository _hymnsRepo;
  late Future<List<Hymn>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = HymnDbScope.of(context);
    _favRepo = FavoritesRepository(db);
    _hymnsRepo = HymnsRepository(db);
    _future = _load();
  }

  Future<List<Hymn>> _load() async {
    final nums = await _favRepo.getAllFavoriteNumbers();
    final hymns = await _hymnsRepo.getByNumbers(nums);
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
            return Center(child: Text('Erreur de chargement', style: TextStyle(color: cs.error)));
          }

          final list = snap.data ?? const <Hymn>[];
          if (list.isEmpty) {
            return const Center(child: Text('Aucun favori pour le moment.'));
          }

          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final h = list[i];
              return ListTile(
                leading: CircleAvatar(
                  // ignore: deprecated_member_use
                  backgroundColor: cs.primary.withOpacity(0.15),
                  child: Text(h.number.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                title: Text(h.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text((h.actor ?? '').trim()),
                trailing: Icon(Icons.chevron_right, color: cs.primary),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayDetails(h)));
                },
              );
            },
          );
        },
      ),
    );
  }
}
