import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/alleluia.dart';
import 'package:alleluia_tome_1/features/hymns/presentation/widgets/custom_appbar.dart';

/// Page: Numbers
///
/// Rôle:
/// - Affiche les chants triés par numéro dans une grille responsive.
/// - Navigation vers la page de détails au clic.
class Numbers extends StatelessWidget {
  const Numbers({super.key});

  @override
  Widget build(BuildContext context) {
    // Tri par numéro croissant
    final List<Alleluia> sortedChants = List<Alleluia>.from(chants)
      ..sort((a, b) => a.numberChants.compareTo(b.numberChants));

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Grille responsive en fonction de la largeur
          final w = constraints.maxWidth;
          int crossAxisCount = 4;
          if (w >= 1200) {
            crossAxisCount = 6;
          } else if (w >= 900) {
            crossAxisCount = 5;
          } else if (w >= 700) {
            crossAxisCount = 4;
          } else if (w >= 500) {
            crossAxisCount = 3;
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
              itemCount: sortedChants.length,
              itemBuilder: (context, index) {
                final chant = sortedChants[index];
                return _NumberTile(chant: chant, cs: cs);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({required this.chant, required this.cs});

  final Alleluia chant;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (_) => PlayDetails(chant)),
        // );
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
          chant.numberChants.toString(),
          semanticsLabel: 'Chant numéro ${chant.numberChants}',
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


