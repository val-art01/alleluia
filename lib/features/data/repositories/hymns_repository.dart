import 'dart:async';
import 'package:isar/isar.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_service.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/data/sources/json_hymn_data_source.dart';
import 'package:alleluia_tome_1/features/data/models/search_result.dart';

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
class HymnsRepository {
  HymnsRepository(this._db, {this.assetPath = 'assets/data/chants_alleluia.json'});
  final HymnDbService _db;
  final String assetPath;
  Isar get _isar => _db.isar;

  // ---- seed params (configurables si besoin) ----
  static const int _chunkSize = 500;
  static const int _minNumberForValid = 1;

  /// Seed la DB si vide (ou force si force=true).
  /// Retourne le nombre d'éléments insérés.
  /// onProgress(optional): callback (insertedSoFar, totalToInsert)
  Future<int> seedFromJsonIfNeeded({bool force = true, void Function(int inserted, int total)? onProgress}) async {
    final existing = await _isar.hymns.count();
    if (existing > 0 && !force) return 0;

    final rawHymns = await loadHymnsFromJsonAssetInIsolate(assetPath);
    if (rawHymns.isEmpty) return 0;

    // tri par number pour insertion stable
    rawHymns.sort((a, b) => a.number.compareTo(b.number));

    // validations + normalisations supplémentaires
    final List<Hymn> valid = <Hymn>[];
    final seenNumbers = <int>{};
    for (final h in rawHymns) {
      if (h.number < _minNumberForValid) continue;
      if (h.title.trim().isEmpty) continue;
      if (seenNumbers.contains(h.number)) {
        // si doublon sur number -> on ignore la seconde occurrence
        continue;
      }
      // assure titleNorm
      if (h.titleNorm.trim().isEmpty) {
        h.titleNorm = h.title.toLowerCase();
      }
      valid.add(h);
      seenNumbers.add(h.number);
    }

    final total = valid.length;
    int inserted = 0;

    // Insert par chunks dans des transactions séparées
    for (var i = 0; i < total; i += _chunkSize) {
      final end = (i + _chunkSize < total) ? i + _chunkSize : total;
      final chunk = valid.sublist(i, end);

      await _isar.writeTxn(() async {
        await _isar.hymns.putAll(chunk);
      });

      inserted += chunk.length;
      if (onProgress != null) onProgress(inserted, total);
    }

    return inserted;
  }

  // ---------------- Basic access APIs ----------------

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
    return _isar.hymns.filter().numberLessThan(number).sortByNumberDesc().findFirst();
  }

  /// Chant suivant (par numéro).
  Future<Hymn?> nextOf(int number) {
    return _isar.hymns.filter().numberGreaterThan(number).sortByNumber().findFirst();
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

  /// Recherche multi-critères en mémoire (numéro, titre, texte).
  ///
  /// - `query` : texte saisi par l'utilisateur (peut être un numéro).
  /// - Renvoie une liste de SearchResult (hymn + score + ligne trouvée).
  Future<List<SearchResult>> search({String? query, int limit = 20, int minChars = 1}) async {
    if (query == null || query.trim().length < minChars) return [];

    final raw = query.trim();
    final asNumber = int.tryParse(raw);
    final searchTerm = raw.toLowerCase();

    final results = <SearchResult>[];
    final hymns = await getAll(); // On charge tout une seule fois

    for (final hymn in hymns) {
      int score = 0;
      String? matchedLine;

      // Recherche numérique -> priorité maximale
      if (asNumber != null) {
        if (hymn.number == asNumber) {
          results.add(SearchResult(hymn: hymn, score: 1000,  matchedLine: hymn.title));
        }
        continue;
      }

      // Titre (priorité forte)
      final titleLower = hymn.title.toLowerCase();

      if (titleLower.startsWith(searchTerm)) {
        score = 200;
        matchedLine = hymn.title;
      } else if (titleLower.contains(searchTerm)) {
        score = 150;
        matchedLine = hymn.title;
      }

      // Variante normalisée du titre (null-safe)
      if (score == 0) {
        final titleNorm = hymn.titleNorm.toLowerCase();
        if (titleNorm.contains(searchTerm)) {
          score = 120;
          matchedLine = hymn.title;
        }
      }

      // 4) Recherche dans le texte des lignes (null-safe)
      if (score == 0) {
        final sections = hymn.sections;
        bool found = false;

        for (final section in sections) {
          final lines = section.lines;

          for (final line in lines) {
            final textLower = (line.textLine).toLowerCase();
            final normLower = (line.textNormLine).toLowerCase();

            if (textLower.contains(searchTerm)) {
              score = 50;
              matchedLine = line.textLine;
              found = true;
              break;
            }

            if (normLower.contains(searchTerm)) {
              score = 40;
              matchedLine = line.textLine.isNotEmpty == true ? line.textLine : line.textNormLine;
              found = true;
              break;
            }
          }

          if (found) break;
        }
      }

      // Si match, on ajoute
      if (score > 0) {
        results.add(SearchResult(hymn: hymn, score: score,  matchedLine: matchedLine));
      }
    }

    // Tri final
    results.sort((a, b) {
      if (a.score != b.score) {
        return b.score.compareTo(a.score); // score desc
      }
      return a.hymn.number.compareTo(b.hymn.number); // numéro asc
    });

    // Limitation du nombre de résultats
    return results.take(limit).toList();
  }


}
