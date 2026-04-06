import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/data/models/favorite.dart';

/// Service bas niveau responsable de la gestion de la base Isar.
/// 
/// - Ouvre la base au démarrage de l'application.
/// - Permet d'accéder à la collection Hymn et Favorite.
/// - Se conserve dans un InheritedWidget (`HymnDbScope`) pour être disponible partout.
class HymnDbService {
  HymnDbService._();
  late final Isar _isar;
  Isar get isar => _isar;

  /// Ouvre la base (ou la crée si elle n’existe pas encore).
  static Future<HymnDbService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final service = HymnDbService._();
    
    service._isar = await Isar.open(
      [
        HymnSchema,
        FavoriteSchema
      ],
      directory: dir.path,
      inspector: false, // mettre true si on veut debugger avec Isar Inspector
    );

    return service;
  }

  /// Ferme la base proprement.
  Future<void> close() async {
    await _isar.close();
  }
}
