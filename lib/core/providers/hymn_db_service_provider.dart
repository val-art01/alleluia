import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_service.dart';
 
/// Provider de la base Isar.
/// Il est OVERRIDÉ dans main.dart avec l'instance déjà initialisée.
/// Ne jamais l'utiliser sans l'override → throwsUnsupportedError par sécurité.
final hymnDbServiceProvider = Provider<HymnDbService>((ref) {
  throw UnsupportedError(
    'hymnDbServiceProvider must be overridden in main.dart via ProviderScope.',
  );
});
 