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

/// Représente un bloc du chant (Solo, Ass, refrain...).
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
  List<Line> lines = <Line>[];

  Section({
    this.type = SectionType.SoloAss,
    this.orderSection = 0,
    this.repeatCountSection = 1,
    List<Line>? linesParam,
  }){
    if (linesParam != null) {
      lines = linesParam;
    }
  }
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
  /// id interne Isar (auto-incrémenté).
  Id id = Isar.autoIncrement;

  /// Numéro du chant
  @Index(unique: true, replace: true)
  late int number;

  /// Titre affiché du chant.
  late String title;

  /// Version normalisée du titre:
  /// - sans accents,
  /// - en minuscules,
  /// - sans ponctuation spéciale.
  /// Ça sert pour les recherches rapides.
  @Index(type: IndexType.hash, caseSensitive: false)
  late String titleNorm;

  /// Auteur / compositeur / source liturgique.
  String? actor;

  /// Chemin du fichier audio (asset local) lié à ce chant.
  String? audioPath;

  /// Code langue ("fr", "en", etc.).
  @Index(type: IndexType.hash, caseSensitive: false)
  String? language;

  /// Temps liturgiques :
  /// Exemple: ["Louanges", "Adorations", "Offrande", "Sortie"]
  @Index(type: IndexType.hash, caseSensitive: false)
  List<String> liturgicalTimes = <String>[];

  /// Périodes de l'année liturgique :
  /// Exemple: ["Ordinaire", "Avent", "Noël", "Pâques"]
  @Index(type: IndexType.hash, caseSensitive: false)
  List<String> periods = <String>[];

  /// Battements / rythme.
  /// Sert à construire la page "Battements".
  List<String> beats = <String>[];

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
    List<String>? liturgicalTimesParam,
    List<String>? periodsParam,
    List<String>? beatsParam,
    List<Section>? sectionsParam,
  }){
    if (liturgicalTimesParam != null) {
      liturgicalTimes = liturgicalTimesParam;
    }
    if (periodsParam != null) {
      periods = periodsParam;
    }
    if (beatsParam != null) {
      beats = beatsParam;
    }
    if (sectionsParam != null) {
      sections = sectionsParam;
    }
  }

  /// Petit helper pratique pour l'UI.
  String get displayTitle => '$number — $title';
}

// Compat temporaire pour le reste du code tant que tout n'est pas migré.
typedef AlleluiaDB = Hymn;


