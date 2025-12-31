import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/app/app.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_service.dart';
import 'package:alleluia_tome_1/core/services/audio_player_service.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ouvrir la base Isar
  final hymnDb = await HymnDbService.init();

  // Créer le repository qui manipule les Hymn dans Isar
  final hymnsRepo = HymnsRepository(hymnDb);

  // Seed depuis le fichier JSON si la DB est vide
  await hymnsRepo.seedFromJsonIfNeeded();

  // Créer le service audio (unique pour l'app)
  final audioService = AudioPlayerService();

  // Lancer l'app en lui injectant hymnDb et audioService
  runApp(
    App(
      hymnDb: hymnDb,
      audioService: audioService,
    ),
  );
}
