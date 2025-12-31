import 'package:alleluia_tome_1/app/themes/app_theme.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = HymnDbScope.of(context); // Récupérer la DB depuis le scope le plus haut
    _repo = HymnsRepository(db);
    _futureHymns = _loadAndSort();     // Charger les chants une seule fois
  }

  /// tri alphabétique insensible à la casse sur le titre
  Future<List<Hymn>> _loadAndSort() async {
    final list = await _repo.getAll();
    list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<Hymn>>(
        future: _futureHymns,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
            return const Center(
              child: Text(
                "Aucun chant disponible.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: hymns.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final hymn = hymns[index];
              return _buildHymnCard(context, hymn);
            },
            // itemCount: hymns.length,
            // separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5, color: Colors.black12),
            // itemBuilder: (context, index) {
            //   final hymn = hymns[index];
            //   return _buildHymnTile(context, hymn);
            // },
          );
        },
      ),
    );
  }

  /// Tuile de chant (carte cliquable → PlayDetails).
  Widget _buildHymnCard(BuildContext context, Hymn hymn) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PlayDetails(hymn)),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 4),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Numéro (badge)
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  hymn.number.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Textes
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hymn.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if ((hymn.actor ?? '').trim().isNotEmpty)
                      Text(
                        hymn.actor!.trim(),
                        style: TextStyle(
                          color: AppTheme.ongrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 28,
                color: AppTheme.primaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
