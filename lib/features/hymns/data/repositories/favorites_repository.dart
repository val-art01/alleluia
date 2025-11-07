import 'package:isar/isar.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_service.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/favorite.dart';

class FavoritesRepository {
  FavoritesRepository(this._db);

  final HymnDbService _db;

  Future<bool> isFavorite(int hymnNumber) async {
    final isar = _db.isar;
    final f = await isar.favorites.filter().hymnNumberEqualTo(hymnNumber).findFirst();
    return f != null;
  }

  Future<void> toggleFavorite(int hymnNumber) async {
    final isar = _db.isar;
    await isar.writeTxn(() async {
      final existing = await isar.favorites.filter().hymnNumberEqualTo(hymnNumber).findFirst();
      if (existing != null) {
        await isar.favorites.delete(existing.id);
      } else {
        await isar.favorites.put(Favorite(hymnNumber: hymnNumber));
      }
    });
  }

  /// Retourne la liste des numéros favoris, triés par date d’ajout desc
  Future<List<int>> getAllFavoriteNumbers() async {
    final isar = _db.isar;
    final list = await isar.favorites.where().sortByCreatedAtDesc().findAll();
    return list.map((f) => f.hymnNumber).toList();
  }
}
