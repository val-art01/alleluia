import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alleluia_tome_1/core/services/audio_player_service.dart';
 
/// Provider du service audio — instance unique dans toute l'app.
/// Riverpod gère le cycle de vie : dispose() est appelé automatiquement
/// quand le ProviderScope est détruit (fin de l'app).
final audioPlayerServiceProvider = Provider.autoDispose<AudioPlayerService>(
  (ref) {
    final service = AudioPlayerService();
    ref.onDispose(service.dispose);
    return service;
  },
  // keepAlive : le service audio doit rester en vie même si aucun
  // widget ne l'écoute momentanément (ex: entre deux pages).
  dependencies: [],
);
 
// Pour garder le service en vie toute la durée de l'app :
final audioPlayerServiceKeepAliveProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
});
 