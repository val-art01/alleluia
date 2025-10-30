import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/play_details_page.dart';

/// Page: PlayList
///
/// Rôle:
/// - Affiche la liste des chants sous forme de tuiles, triées par titre (A→Z).
/// - Permet d’ouvrir et de lire les chants depuis la base Isar via HymnsRepository.
class PlayList extends StatefulWidget {
  const PlayList({super.key});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  late HymnsRepository _repo;
  late Future<List<Hymn>> _futureHymns;
  // late final List<Alleluia> _sortedChants;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Récupérer la DB depuis le scope le plus haut
    final db = HymnDbScope.of(context);
    _repo = HymnsRepository(db);

    // Charger les chants une seule fois
    _futureHymns = _loadAndSort();
  }

  Future<List<Hymn>> _loadAndSort() async {
    final list = await _repo.getAll();
    // tri alphabétique insensible à la casse sur le titre
    list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<Hymn>>(
        future: _futureHymns,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Chargement initial
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur de chargement",
                style: TextStyle(color: cs.error),
              ),
            );
          }

          final hymns = snapshot.data ?? [];
          if (hymns.isEmpty) {
            return const Center(child: Text("Aucun chant disponible."));
          }

          return ListView.separated(
            itemCount: hymns.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, thickness: 0.5),
            itemBuilder: (context, index) {
              final hymn = hymns[index];
              return _buildHymnTile(context, hymn);
            },
          );
        },
      ),
    );
  }

  /// Tuile de chant (carte cliquable → PlayDetails).
  Widget _buildHymnTile(BuildContext context, Hymn hymn) {
    final avatarColor = Theme.of(context).colorScheme.primary.withOpacity(0.15);
    final arrowColor = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        title: Text(
          hymn.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          hymn.actor ?? '',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        leading: CircleAvatar(
          backgroundColor: avatarColor,
          child: Text(
            hymn.number.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 20, color: arrowColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PlayDetails(hymn)),
          );
        },
      ),
    );
  }
}
