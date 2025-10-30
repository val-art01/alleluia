import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';


/// Service bas niveau responsable de la gestion de la base Isar.
/// 
/// - Ouvre la base au démarrage de l'application.
/// - Permet d'accéder à la collection Hymn.
/// - Se conserve dans un InheritedWidget (`HymnDbScope`) pour être disponible partout.
class HymnDbService {
  late final Isar _isar;

  Isar get isar => _isar;

  /// Ouvre la base (ou la crée si elle n’existe pas encore).
  static Future<HymnDbService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final service = HymnDbService._();
    service._isar = await Isar.open(
      [HymnSchema],
      directory: dir.path,
      inspector: false, // tu peux mettre true si tu veux debugger avec Isar Inspector
    );
    return service;
  }

  HymnDbService._();

  /// Ferme la base proprement (optionnel, Isar la ferme automatiquement à la sortie).
  Future<void> close() async {
    await _isar.close();
  }
}
