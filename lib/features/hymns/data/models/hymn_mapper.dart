import 'package:alleluia_tome_1/features/hymns/data/models/alleluia.dart' as legacy show Alleluia;
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:flutter/material.dart';
// import 'package:isar/isar.dart';

/// Normalise un texte pour la recherche:
/// - minuscules
/// - enlève accents simples de base
String _normalize(String input) {
  final lower = input.toLowerCase();

  // Remplacements basiques d'accents fréquents FR.
  // (on pourra améliorer plus tard si tu veux gérer toutes les langues)
  const accents = {
    'à': 'a',
    'â': 'a',
    'ä': 'a',
    'á': 'a',
    'ç': 'c',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'í': 'i',
    'ì': 'i',
    'ï': 'i',
    'î': 'i',
    'ô': 'o',
    'ö': 'o',
    'ò': 'o',
    'ó': 'o',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ú': 'u',
    'ñ': 'n',
  };

  final buffer = StringBuffer();
  for (final char in lower.characters) {
    buffer.write(accents[char] ?? char);
  }

  return buffer.toString();
}

/// Transforme un ancien chant (Alleluia) en un Hymn prêt à insérer dans Isar.
///
/// - On mappe les champs simples.
/// - On encapsule l'ancien `description` dans une seule Section par défaut,
///   avec une seule Line. Comme ça, l'écran PlayDetails peut déjà afficher
///   proprement le texte par section plus tard.
Hymn hymnFromLegacy(legacy.Alleluia old) {
  // On construit une section "paroles complètes" à partir de l'ancien champ description.
  final section = Section(
    type: SectionType.SoloAss,
    orderSection: 1,
    repeatCountSection: 1,
    lines: [
      Line(
        textLine: old.description,
        textNormLine: _normalize(old.description),
        orderLine: 1,
        repeatCountLine: 1,
      ),
    ],
  );

  return Hymn(
    number: old.numberChants,
    title: old.title,
    titleNorm: _normalize(old.title),
    actor: old.actor,
    audioPath: old.audio,
    language: 'fr', // tu pourras ajuster si certains chants ne sont pas en français
    categories: List<String>.from(old.categories),
    beats: List<String>.from(old.beats),
    sections: [section],
  );
}
