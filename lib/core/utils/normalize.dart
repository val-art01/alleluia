import 'package:diacritic/diacritic.dart';

/// Normalisation de texte pour la recherche et l'indexation.
///
/// Règles appliquées (dans l'ordre) :
///  - trim + toLowerCase
///  - suppression des accents  (é → e, ç → c…)
///  - normalisation des apostrophes typographiques → '
///  - normalisation des tirets longs → -
///  - suppression de la ponctuation inutile
///  - suppression des tirets/apostrophes multiples consécutifs
///  - suppression de tout caractère non alphanumérique sauf espace, ' et -
///  - collapse des espaces multiples
String normalizeText(String? input) {
  if (input == null || input.trim().isEmpty) return '';

  var t = input.trim().toLowerCase();

  // Suppression des accents
  t = removeDiacritics(t);

  // Apostrophes typographiques → apostrophe droite
  t = t
      .replaceAll('\u2019', "'") // '
      .replaceAll('\u2018', "'") // '
      .replaceAll('`', "'")
      .replaceAll('\u00B4', "'"); // ´

  // Tirets longs → tiret simple
  t = t.replaceAll('\u2013', '-').replaceAll('\u2014', '-').replaceAll('\u2212', '-'); 

  // Ponctuation inutile → espace
  t = t.replaceAll(RegExp(r'[.,;:!?()\[\]{}_/°*•]'), ' ');

  // Tirets / apostrophes multiples consécutifs
  t = t.replaceAll(RegExp(r'-{2,}'), '-');
  t = t.replaceAll(RegExp(r"'{2,}"), "'");

  // Tout caractère non alphanumérique sauf espace, apostrophe, tiret
  t = t.replaceAll(RegExp(r"[^a-z0-9' \-]"), ' ');

  // Collapse des espaces multiples
  t = t.replaceAll(RegExp(r'\s+'), ' ').trim();

  return t;
}

/// Normalise un identifiant numérique : garde uniquement les chiffres.
/// Exemple : " 12-3 " → "123"
String normalizeNumber(String? input) {
  if (input == null) return '';
  return input.replaceAll(RegExp(r'[^0-9]'), '').trim();
}

/// Normalise pour l'indexation Isar : lettres et chiffres uniquement.
/// Plus strict que normalizeText, pas d'apostrophe ni de tiret.
String normalizeForSearch(String? input) {
  final base = normalizeText(input);
  return base.replaceAll(RegExp(r"[^a-z0-9 ]"), '').trim();
}

/// Normalise une ligne de paroles (alias lisible).
String normalizeHymnLine(String line) => normalizeText(line);

/// Normalise un titre de chant (alias lisible).
String normalizeTitle(String title) => normalizeText(title);