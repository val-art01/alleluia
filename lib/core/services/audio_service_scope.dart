import 'audio_player_service.dart';
import 'package:flutter/widgets.dart';

/// InheritedWidget minimal pour fournir AudioPlayerService à tout le sous-arbre.
class AudioServiceScope extends InheritedWidget {
  const AudioServiceScope({
    super.key,
    required this.service,
    required super.child,
  });

  final AudioPlayerService service;

  static AudioPlayerService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AudioServiceScope>();
    assert(scope != null, 'AudioServiceScope manquant dans l’arbre des widgets');
    return scope!.service;
  }

  @override
  bool updateShouldNotify(covariant AudioServiceScope oldWidget) =>
      oldWidget.service != service;
}
