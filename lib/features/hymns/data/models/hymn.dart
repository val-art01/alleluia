import 'package:isar/isar.dart';
part 'hymn.g.dart';

/// Types de section du chant.
/// - Solo : chanté par un meneur
/// - Ass  : assemblée
/// - Ref  : refrain
/// - SoloAss : les deux (par défaut)
// ignore: constant_identifier_names
enum SectionType { Solo, Ass, Ref, SoloAss }

/// Représente une ligne individuelle dans un couplet/refrain.
///
/// Exemple:
/// - textLine: "Jésus est mon sauveur"
/// - textNormLine: "jesus est mon sauveur" (sans majuscules/accents pour la recherche)
/// - orderLine: ordre d'apparition dans la section
/// - repeatCountLine: nombre de répétitions ("x2", "bis", etc.)
@embedded
class Line {
  String textLine;
  String textNormLine;
  int orderLine;
  int repeatCountLine;

  Line({
    this.textLine = '',
    this.textNormLine = '',
    this.orderLine = 0,
    this.repeatCountLine = 1,
  });
}

/// Représente un bloc du chant (couplet, refrain, pont...).
///
/// - type: Solo / Ass / Ref / SoloAss
/// - orderSection: ordre dans le chant (1, 2, 3...)
/// - repeatCountSection: répéter ce bloc combien de fois
/// - lines: le texte détaillé du bloc
@embedded
class Section {
  @enumerated
  SectionType type;

  int orderSection;
  int repeatCountSection;
  List<Line> lines;

  Section({
    this.type = SectionType.SoloAss,
    this.orderSection = 0,
    this.repeatCountSection = 1,
    this.lines = const <Line>[],
  });
}

/// Modèle principal d'un chant stocké dans Isar.
///
/// Important:
/// - `number` = numéro officiel du chant (unique)
/// - `titleNorm` = titre sans accents / en minuscules -> utile pour la recherche
/// - `categories` = sert à construire la page "Catégories"
/// - `beats` = sert à construire la page "Battements"
@collection
class Hymn {
  /// id interne Isar (auto-incrémenté). Pas affiché à l'utilisateur.
  Id id = Isar.autoIncrement;

  /// Numéro du chant (ex: 45)
  /// On le considère unique dans le recueil.
  @Index(unique: true, replace: true)
  late int number;

  /// Titre affiché du chant.
  late String title;

  /// Version normalisée du titre:
  /// - sans accents,
  /// - en minuscules,
  /// - sans ponctuation spéciale.
  ///
  /// Ça sert pour les recherches rapides.
  @Index(type: IndexType.hash, caseSensitive: false)
  late String titleNorm;

  /// Auteur / compositeur / source liturgique.
  String? actor;

  /// Chemin du fichier audio (asset local) lié à ce chant.
  /// Exemple: "assets/sound/045.mp3"
  String? audioPath;

  /// Code langue ("fr", "en", etc.).
  @Index(type: IndexType.hash, caseSensitive: false)
  String? language;

  /// Catégories liturgiques.
  /// Exemple: ["Louange", "Adoration", "Offrande"]
  ///
  /// Sert à construire la page "Catégories".
  @Index(type: IndexType.hash, caseSensitive: false)
  List<String> categories;

  /// Battements / rythme.
  /// Exemple: ["3 temps rapide", "BOBO"]
  ///
  /// Sert à construire la page "Battements".
  List<String> beats;

  /// Structure détaillée du chant (couplets, refrains).
  /// Affichage texte, répétitions, etc.
  List<Section> sections = <Section>[];

  Hymn({
    required this.number,
    required this.title,
    required this.titleNorm,
    this.actor,
    this.audioPath,
    this.language,
    this.categories = const <String>[],
    this.beats = const <String>[],
    this.sections = const <Section>[],
  });

  /// Petit helper pratique pour l'UI.
  /// Exemple: "45 — Je louerai l'Éternel"
  String get displayTitle => '$number — $title';
}

// Compat temporaire pour le reste du code tant que tout n'est pas migré.
typedef AlleluiaDB = Hymn;
