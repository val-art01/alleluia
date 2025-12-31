import 'themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'presentation/pages/splash_screen.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_service.dart';
import 'package:alleluia_tome_1/core/services/audio_service_scope.dart';
import 'package:alleluia_tome_1/core/services/audio_player_service.dart';

/// App est maintenant stateful car elle doit disposer proprement le service audio.
class App extends StatefulWidget {
  const App({
    super.key,
    required this.hymnDb,
    required this.audioService,
  });

  final HymnDbService hymnDb;
  final AudioPlayerService audioService;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void dispose() {
    // Libère les ressources audio proprement quand l'app se ferme
    widget.audioService.dispose();

    // On pourrait fermer la DB ici avec widget.hymnDb.close();
    // mais ce n'est pas obligatoire sur mobile.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HymnDbScope(
      db: widget.hymnDb,
      child: AudioServiceScope(
        service: widget.audioService,
        child: MaterialApp(
          title: 'Alleluia',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          // darkTheme: AppTheme.dark,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

