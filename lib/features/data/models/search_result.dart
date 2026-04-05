import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';

/// Résultat d'une recherche dans les chants.
///
/// - [hymn]  : le chant trouvé
/// - [score] : score de pertinence (plus élevé = plus pertinent)
///           1000 = match numérique exact
///           200  = titre commence par la recherche
///           150  = titre contient la recherche
///           120  = titleNorm contient la recherche
///           50   = texte d'une ligne contient la recherche
///           40   = ligne normalisée contient la recherche
/// - [matchedLine] : la ligne où le mot a été trouvé (pour l'aperçu UI)

@immutable
class SearchResult {
  const SearchResult({
    required this.hymn,
    required this.score,
    this.matchedLine,
  });

  final Hymn hymn;
  final int score;
  final String? matchedLine;
}