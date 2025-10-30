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
              child: Text('Erreur de chargement', style: TextStyle(color: cs.error)),
            );
          }

          final hymns = snap.data ?? const <Hymn>[];
          if (hymns.isEmpty) {
            return const Center(child: Text('Aucun chant disponible.'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              int crossAxisCount = 4;
              if (w >= 1200) {
                crossAxisCount = 7;
              } else if (w >= 900) {
                crossAxisCount = 6;
              } else if (w >= 700) {
                crossAxisCount = 5;
              } else if (w >= 500) {
                crossAxisCount = 5;
              } else {
                crossAxisCount = 4;
              }

              return Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: hymns.length,
                  itemBuilder: (context, i) {
                    final hymn = hymns[i];
                    return _NumberTile(hymn: hymn, cs: cs);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({required this.hymn, required this.cs});

  final Hymn hymn;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PlayDetails(hymn)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(1, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          hymn.number.toString(),
          semanticsLabel: 'Chant numéro ${hymn.number}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ),
    );
  }
}
