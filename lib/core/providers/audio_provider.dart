import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alleluia_tome_1/core/services/audio_player_service.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';

//  SERVICE AUDIO — instance unique dans l'app
//
//  On utilise Provider (pas autoDispose) car le
//  service audio doit rester en vie même quand
//  on quitte la page PlayDetails (pour continuer à jouer en arrière-plan si besoin futur).
//
//  Riverpod appelle dispose() automatiquement
//  à la fermeture de l'app (destruction du
//  ProviderScope dans main.dart).
//
//  Utilisation dans un widget :
//    final audio = ref.watch(audioServiceProvider);
//    audio.togglePlay();
final audioServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
});


//  ÉTAT IS PLAYING (bool)
//
//  Écoute le ValueNotifier du service et
//  expose un bool réactif à Riverpod.
//
//  Utilisation :
//    final isPlaying = ref.watch(isPlayingProvider);
final isPlayingProvider = StreamProvider<bool>((ref) {
  final audio = ref.watch(audioServiceProvider);

  // Convertit le ValueNotifier en Stream
  return Stream.fromIterable([audio.isPlaying.value]).asyncExpand((_) {
    return _valueNotifierStream(audio.isPlaying);
  });
});

//  POSITION ACTUELLE (Duration)
//
//  Utilisation :
//    final position = ref.watch(audioPositionProvider).valueOrNull
//                     ?? Duration.zero;
final audioPositionProvider = StreamProvider<Duration>((ref) {
  final audio = ref.watch(audioServiceProvider);
  return _valueNotifierStream(audio.position);
});

//  DURÉE TOTALE (Duration)
final audioDurationProvider = StreamProvider<Duration>((ref) {
  final audio = ref.watch(audioServiceProvider);
  return _valueNotifierStream(audio.duration);
});

//  CHANT EN COURS (Hymn?)
final currentHymnProvider = StreamProvider<Hymn?>((ref) {
  final audio = ref.watch(audioServiceProvider);
  return _valueNotifierStream(audio.currentHymn);
});

//  HELPER — convertit un ValueNotifier<T> en
//  Stream<T> compatible Riverpod.
//
//  Utilise addListener (pas de polling) :
//  émet uniquement quand la valeur change réellement.
Stream<T> _valueNotifierStream<T>(ValueNotifier<T> notifier) {
  late void Function() listener;

  final controller = StreamController<T>(
    onCancel: () => notifier.removeListener(listener),
  );

  listener = () {
    if (!controller.isClosed) controller.add(notifier.value);
  };

  controller.onListen = () {
    controller.add(notifier.value);
    notifier.addListener(listener);
  };

  return controller.stream;
}