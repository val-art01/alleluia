import 'package:diacritic/diacritic.dart';

/// Normalisation avancée du texte :
/// - trim()
/// - toLowerCase()
/// - suppression des accents (diacritic)
/// - remplacement des apostrophes typographiques
/// - suppression ponctuation inutile
/// - collapse des espaces multiples
/// - retrait des caractères non alphanumériques sauf espace
String normalizeText(String? input) {
  if (input == null || input.trim().isEmpty) return "";

  var text = input.trim().toLowerCase();

  // Remove accents (é => e)
  text = removeDiacritics(text);

  // Normalize apostrophes
  text = text
      .replaceAll("’", "'")
      .replaceAll("`", "'")
      .replaceAll("´", "'");

  // Replace long dashes and weird hyphens
  text = text
      .replaceAll("–", "-")
      .replaceAll("—", "-")
      .replaceAll("−", "-");

  // Remove most punctuation except apostrophe and dash
  text = text.replaceAll(RegExp(r"[.,;:!?()\\[\\]{}_/°*•\]"), " ");;

  // Remove double/multiple hyphens
  text = text.replaceAll(RegExp(r"-{2,}"), "-");

  // Remove double apostrophes
  text = text.replaceAll(RegExp(r"'{2,}"), "'");

  // Remove all remaining symbols except alphanumeric + space + ' + -
  // ignore: valid_regexps
  text = text.replaceAll(RegExp(r"[^a-z0-9'\\- ]"), " ");

  // Collapse spaces
  text = text.replaceAll(RegExp(r"\\s+"), " ").trim();

  return text;
}

/// Normalise un numéro ou identifiant textuel.
/// Supprime tout sauf chiffres.
/// Exemple : \" 12-3 \" → \"123\"
String normalizeNumber(String? input) {
  if (input == null) return "";
  return input.replaceAll(RegExp(r"[^0-9]"), "").trim();
}

/// Version plus permissive pour la recherche.
/// Garde seulement lettres & chiffres (utile pour les index Isar)
String normalizeForSearch(String? input) {
  final base = normalizeText(input);
  return base.replaceAll(RegExp(r"[^a-z0-9 ]"), "").trim();
}

/// Pour normaliser des lignes de chants
String normalizeHymnLine(String line) {
  return normalizeText(line);
}

/// Pour normaliser les titres
String normalizeTitle(String title) {
  return normalizeText(title);
}
