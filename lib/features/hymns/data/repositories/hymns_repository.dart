import 'package:alleluia_tome_1/core/services/hymn_db_service.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:isar/isar.dart';


/// HymnsRepository
///
/// Rôle:
/// - Fournit un accès "propre" aux chants stockés en base Isar.
/// - Sert d'API de lecture/écriture pour l'UI.
/// - Centralise les requêtes courantes (tous les chants, suivant/précédent,
///   regroupements par catégories et par battement).
///
/// IMPORTANT:
/// On ne met AUCUNE logique d'UI ici.
/// Ce fichier ne dépend que de la DB + du modèle.
class HymnsRepository {
  HymnsRepository(this._db);
  final HymnDbService _db;

  /// Récupérer tous les chants triés par numéro croissant.
  Future<List<Hymn>> getAll() async {
    // Isar génère un accessoire `hymns` basé sur le nom du modèle Hymn
    // et des helpers de requêtes à partir du schéma.
    return _db.isar.hymns.where().sortByNumber().findAll();
  }

  /// Retrouver un chant par son numéro (ex: 45).
  Future<Hymn?> findByNumber(int number) async {
    return _db.isar.hymns.filter().numberEqualTo(number).findFirst();
  }

  /// Donner le chant suivant par numéro.
  Future<Hymn?> nextOf(int number) async {
    final list = await getAll();
    final i = list.indexWhere((h) => h.number == number);
    if (i >= 0 && i < list.length - 1) return list[i + 1];
    return null;
  }

  /// Donner le chant précédent par numéro.
  Future<Hymn?> previousOf(int number) async {
    final list = await getAll();
    final i = list.indexWhere((h) => h.number == number);
    if (i > 0) return list[i - 1];
    return null;
  }

  /// Regroupe les chants par catégorie liturgique.
  ///
  /// Renvoie une map du style:
  /// {
  ///   "Adoration": [Hymn, Hymn, ...],
  ///   "Louange": [Hymn, ...],
  /// }
  Future<Map<String, List<Hymn>>> groupByCategory() async {
    final list = await getAll();
    final map = <String, List<Hymn>>{};
    for (final h in list) {
      for (final cat in h.categories) {
        map.putIfAbsent(cat, () => <Hymn>[]).add(h);
      }
    }
    // Optionnel: trier les listes dans chaque catégorie
    for (final entry in map.entries) {
      entry.value.sort((a, b) => a.number.compareTo(b.number));
    }
    return map;
  }

  /// Regroupe les chants par battement / rythme.
  ///
  /// Renvoie une map du style:
  /// {
  ///   "1 temps": [...],
  ///   "3 temps rapide/BOBO": [...],
  ///   "4 temps rapide": [...],
  ///   "Autres": [...],
  /// }
  Future<Map<String, List<Hymn>>> groupByBeat() async {
    final list = await getAll();
    final map = <String, List<Hymn>>{};

    String normalizeBeat(List<String> beats) {
      if (beats.isEmpty) return 'Autres';
      // On prend le premier beat comme "beat principal"
      // (tu pourras raffiner ici plus tard)
      return beats.first;
    }

    for (final h in list) {
      final key = normalizeBeat(h.beats);
      map.putIfAbsent(key, () => <Hymn>[]).add(h);
    }

    // Tri par numéro à l'intérieur de chaque groupe
    for (final entry in map.entries) {
      entry.value.sort((a, b) => a.number.compareTo(b.number));
    }

    return map;
  }

  /// Seed initial de la base.
  /// On insère une liste complète de chants si la DB est vide.
  ///
  /// Utilisé au démarrage dans main.dart.
  Future<void> seedIfEmpty(List<Hymn> initialData) async {
    final existingCount = await _db.isar.hymns.count();
    if (existingCount > 0) return;

    if (initialData.isEmpty) return;

    await _db.isar.writeTxn(() async {
      await _db.isar.hymns.putAll(initialData);
    });
  }
}
