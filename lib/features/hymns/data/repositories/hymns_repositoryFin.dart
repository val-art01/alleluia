import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:alleluia_tome_1/core/services/hymn_db_service.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/search_repositories.dart';
// import 'package:alleluia_tome_1/features/hymns/data/sources/hymn_json_mapper.dart';

/// HymnsRepository principal pour accéder aux chants.
///
/// - Lit/écrit dans Isar via HymnDbService.
/// - Peut remplir la base à partir du JSON `chants_alleluai.json`.
/// - Fournit des méthodes pour :
///   * tout lister,
///   * trouver un chant par numéro,
///   * précédent / suivant,
///   * recherche avec scoring (SearchResult).
/// IMPORTANT:
/// On ne met AUCUNE logique d'UI ici.
/// Ce fichier ne dépend que de la DB + du modèle.
///

class HymnsRepository {
  HymnsRepository(this._db);
  final HymnDbService _db;
  Isar get _isar => _db.isar;

  // ---------------------------------------------------------------------------
  // 1) SEED JSON -> ISAR
  // ---------------------------------------------------------------------------
  /// Importe le JSON dans Isar si la base est vide.
  ///
  /// À appeler au démarrage, dans main():
  ///  await HymnsRepository(db).seedFromJsonIfNeeded();
  Future<void> seedFromJsonIfNeeded({
    String assetPath = 'assets/data/chants_alleluai.json',
  }) async {
    final count = await _isar.hymns.count();
    if (count > 0) return;

    final hymns = await _loadHymnsFromJsonAsset(assetPath);
    if (hymns.isEmpty) return;

    await _isar.writeTxn(() async {
      await _isar.hymns.putAll(hymns);
    });
  }

  /// Charge les hymnes depuis un asset JSON et les convertit en objets Hymn.
  Future<List<Hymn>> _loadHymnsFromJsonAsset(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final List<dynamic> data = json.decode(raw) as List<dynamic>;

    return data.map((e) => _hymnFromJson(e as Map<String, dynamic>)).toList();
  }

  Hymn _hymnFromJson(Map<String, dynamic> m) {
    // Fonctions helpers internes
    String _s(String key) => (m[key] as String?)?.trim() ?? '';
    List<String> _ls(String key) => (m[key] as List?)?.map((e) => e.toString().trim()).toList() ?? <String>[];

    final sectionsJson = (m['sections'] as List?) ?? const [];
    final sections = sectionsJson.map((s) {
      final ms = s as Map<String, dynamic>;
      final linesJson = (ms['lines'] as List?) ?? const [];
      final lines = linesJson.map((l) {
        final ml = l as Map<String, dynamic>;
        return Line(
          textLine: (ml['textLine'] as String?)?.trim() ?? '',
          textNormLine: (ml['textNormLine'] as String?)!.trim(),
          orderLine: (ml['orderLine'] as num?)?.toInt() ?? 0,
          repeatCountLine: (ml['repeatCountLine'] as num?)?.toInt() ?? 1,
        );
      }).toList();

      return Section(
        type: _sectionTypeFromString(ms['type'] as String?),
        orderSection: (ms['orderSection'] as num?)?.toInt() ?? 0,
        repeatCountSection: (ms['repeatCountSection'] as num?)?.toInt() ?? 1,
        linesParam: lines,
      );
    }).toList();

    // --- Création du Hymn ---
    return Hymn(
      number: (m['number'] as num?)?.toInt() ?? 0,
      title: _s('title'),
      titleNorm: (m['titleNorm'] as String?)!.trim(),
      actor: (m['actor'] as String?)?.trim(),
      audioPath: (m['audioPath'] as String?)?.trim(),
      language: (m['language'] as String?)?.trim(),
      liturgicalTimesParam: _ls('liturgicalTimes'),
      periodsParam: _ls('periods'),
      beatsParam: _ls('beats'),
      sectionsParam: sections,
    );
  }

  SectionType _sectionTypeFromString(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'Solo':
        return SectionType.Solo;
      case 'Ass':
        return SectionType.Ass;
      case 'Ref':
        return SectionType.Ref;
      default:
        return SectionType.SoloAss;
    }
  }

  // ---------------------------------------------------------------------------
  // 2) ACCÈS DE BASE
  // ---------------------------------------------------------------------------

  /// Tous les chants, triés par numéro.
  Future<List<Hymn>> getAll() async {
    return _isar.hymns.where().sortByNumber().findAll();
  }

  /// Un chant par son numéro.
  Future<Hymn?> getByNumber(int number) {
    return _isar.hymns.where().numberEqualTo(number).findFirst();
  }

  /// Chant précédent (par numéro).
  Future<Hymn?> previousOf(int number) {
    return _isar.hymns.where().numberLessThan(number, sort: Sort.desc).findFirst();
  }

  /// Chant suivant (par numéro).
  Future<Hymn?> nextOf(int number) {
    return _isar.hymns.where().numberGreaterThan(number, sort: Sort.asc).findFirst();
  }

  /// Chants pour une liste de numéros (utile pour les favoris).
  Future<List<Hymn>> getByNumbers(List<int> numbers) async {
    if (numbers.isEmpty) return [];
    final res = await _isar.hymns.filter()
      .anyOf(numbers, (q, n) => q.numberEqualTo(n))
      .findAll();
    res.sort((a, b) => a.number.compareTo(b.number));
    return res;
  }

  // ---------------------------------------------------------------------------
  // 3) RECHERCHE AVEC SCORING (ta version)
  // ---------------------------------------------------------------------------

  /// Recherche multi-critères en mémoire (numéro, titre, texte).
  ///
  /// - `query` : texte saisi par l'utilisateur (peut être un numéro).
  /// - Renvoie une liste de SearchResult (hymn + score + ligne trouvée).
  Future<List<SearchResult>> search({String? query}) async {
    if (query == null || query.trim().isEmpty) return [];

    final raw = query.trim();
    final n = int.tryParse(raw);
    final searchTerm = raw.toLowerCase();

    final allHymns = await getAll();
    final results = <SearchResult>[];

    for (final hymn in allHymns) {
      int score = 0;
      String? matchedLine;

      // 1) Si la recherche est numérique -> match direct sur number
      if (n != null) {
        if (hymn.number == n) {
          results.add(SearchResult(hymn: hymn, score: 1000));
        }
        continue;
      }

      // 2) Titre (priorité forte)
      final titleLower = hymn.title.toLowerCase();

      if (titleLower.startsWith(searchTerm)) {
        score = 200;
        matchedLine = hymn.title;
      } else if (titleLower.contains(searchTerm)) {
        score = 150;
        matchedLine = hymn.title;
      }

      // 3) Variante normalisée du titre
      if (score == 0 && (hymn.titleNorm?.toLowerCase().contains(searchTerm) ?? false)) {
        score = 120;
        matchedLine = hymn.title;
      }

      // 4) Texte (sections / lignes)
      if (score == 0) {
        final sections = hymn.sections ?? const <Section>[];
        bool found = false;
        for (final section in sections) {
          final lines = section.lines ?? const <Line>[];
          for (final line in lines) {
            final tl = line.textLine.toLowerCase();
            if (tl.contains(searchTerm)) {
              score = 50;
              matchedLine = line.textLine;
              found = true;
              break;
            }
            final tnl = line.textNormLine?.toLowerCase() ?? '';
            if (tnl.contains(searchTerm)) {
              score = 40;
              matchedLine = line.textLine.isNotEmpty
                  ? line.textLine
                  : (line.textNormLine ?? '');
              found = true;
              break;
            }
          }
          if (found) break;
        }
      }

      if (score > 0) {
        results.add(SearchResult(
          hymn: hymn,
          score: score,
          matchedLine: matchedLine,
        ));
      }
    }

    // Tri final : par score desc, puis par numéro
    results.sort((a, b) {
      if (a.score != b.score) return b.score.compareTo(a.score);
      return a.hymn.number.compareTo(b.hymn.number);
    });

    return results;
  }

}