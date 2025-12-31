import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/pages/play_details_page.dart';

/// Page: Numbers
///
/// Lit les chants depuis Isar, les trie par numéro, et les affiche en grille responsive.
/// Clic -> ouvre PlayDetails avec le Hymn sélectionné.

class Numbers extends StatefulWidget {
  const Numbers({super.key});

  @override
  State<Numbers> createState() => _NumbersState();
}

class _NumbersState extends State<Numbers> {
  late HymnsRepository _repo;
  late Future<List<Hymn>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = HymnDbScope.of(context);
    _repo = HymnsRepository(db);
    _future = _load();
  }

  Future<List<Hymn>> _load() async {
    final list = await _repo.getAll();
    list.sort((a, b) => a.number.compareTo(b.number));
    return list;
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
            return Center(
              child: Text(
                'Erreur de chargement',
                style: TextStyle(color: cs.error),
              ),
            );
          }

          final hymns = snap.data ?? const <Hymn>[];
          if (hymns.isEmpty) {
            return const Center(child: Text('Aucun chant disponible.'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;

              // Grille responsive (simple et efficace)
              int crossAxisCount = 4;
              if (w >= 1200) {
                crossAxisCount = 8;
              } else if (w >= 900) {
                crossAxisCount = 7;
              } else if (w >= 700) {
                crossAxisCount = 6;
              } else if (w >= 500) {
                crossAxisCount = 5;
              } else {
                crossAxisCount = 4;
              }

              return Column(
                children: [
                  // Petit header (optionnel mais joli)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        Text(
                          "Tous les chants",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            "${hymns.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        // plus “tuile” moderne
                        childAspectRatio: 1.28,
                      ),
                      itemCount: hymns.length,
                      itemBuilder: (context, i) {
                        final hymn = hymns[i];
                        return _NumberTileModern(hymn: hymn);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),

    );
  }
}

class _NumberTileModern extends StatelessWidget {
  const _NumberTileModern({required this.hymn});

  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PlayDetails(hymn)),
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.08),
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
        child: Center(
          child: Text(
            hymn.number.toString(),
            semanticsLabel: 'Chant numéro ${hymn.number}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
