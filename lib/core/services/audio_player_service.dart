import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';

/// Service audio partagé dans toute l'app.
///
/// - Pas d'autoplay quand on arrive sur un chant.
/// - La page appelle `setCurrentHymn(hymn)` pour dire "le chant courant, c'est celui-là".
/// - L'utilisateur doit cliquer sur play manuellement (`togglePlay()`).
/// - Quand on quitte l'écran PlayDetails, on appelle `stop()`.
///
/// Le service expose des ValueNotifier pour que l'UI puisse réagir:
/// - isPlaying
/// - duration
/// - position
/// - currentHymn

class AudioPlayerService {

  AudioPlayerService() : _player = AudioPlayer() {
    _player.setReleaseMode(ReleaseMode.stop);
    _bindPlayerStreams();
  }

  final AudioPlayer _player;

  // État observable pour l’UI
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  final ValueNotifier<Duration> duration = ValueNotifier<Duration>(Duration.zero);
  final ValueNotifier<Duration> position = ValueNotifier<Duration>(Duration.zero);

  // Hymn en cours d'association avec le player
  final ValueNotifier<Hymn?> currentHymn = ValueNotifier<Hymn?>(null);

  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _durSub;
  StreamSubscription<Duration>? _posSub;

  void _bindPlayerStreams() {
    _stateSub = _player.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });

    _durSub = _player.onDurationChanged.listen((d) {
      duration.value = d;
    });

    _posSub = _player.onPositionChanged.listen((p) {
      position.value = p;
    });
  }

  /// Définit le chant courant SANS démarrer la lecture.
  ///
  /// On stocke juste la référence du chant dans currentHymn.
  /// On ne lance pas de son. On ne touche pas au player tant que l'utilisateur
  /// n'a pas explicitement demandé play.
  void setCurrentHymn(Hymn hymn) {
    // si on change de chant, on remet la position à zero logiquement
    final different =
        currentHymn.value == null || currentHymn.value!.number != hymn.number;

    currentHymn.value = hymn;

    if (different) {
      // On reset les infos temporelles visibles par l'UI.
      position.value = Duration.zero;
      // duration sera recalculée quand on fera play (audioplayers donne la durée une fois la source jouée)
    }
  }

  /// Lance ou reprend la lecture du chant courant.
  ///
  /// Si aucun chant courant n'a été défini -> ne fait rien.
  /// Si le chant courant n'a pas d'audioPath -> ne fait rien.
  Future<void> _playInternal() async {
    final hymn = currentHymn.value;
    if (hymn == null) return;
    final path = hymn.audioPath;
    if (path == null || path.trim().isEmpty) return;

    // On joue l'asset depuis son chemin
    await _player.play(AssetSource(path));
  }

  /// Met la lecture en pause.
  Future<void> pause() async {
    await _player.pause();
  }

  /// Stoppe complètement l'audio et remet la position à zéro.
  ///
  /// À appeler:
  /// - quand on quitte PlayDetails
  /// - avant de naviguer vers précédent/suivant
  Future<void> stop() async {
    await _player.stop();
    position.value = Duration.zero;
    // On ne clear pas currentHymn ici,
    // comme ça l'UI sait toujours "quel chant est affiché".
  }

  /// Bascule entre Play et Pause pour le chant courant.
  ///
  /// - si rien ne joue -> play
  /// - si ça joue -> pause
  Future<void> togglePlay() async {
    if (isPlaying.value) {
      await pause();
    } else {
      await _playInternal();
    }
  }

  /// Aller à une position précise dans l'audio.
  Future<void> seek(Duration target) async {
    final total = duration.value;
    if (total == Duration.zero) return;

    var newPos = target;
    if (newPos < Duration.zero) newPos = Duration.zero;
    if (newPos > total) newPos = total;

    await _player.seek(newPos);
  }

  /// Libère toutes les ressources (appelé quand l'app se ferme).
  void dispose() {
    _stateSub?.cancel();
    _durSub?.cancel();
    _posSub?.cancel();
    _player.dispose();
  }

}
