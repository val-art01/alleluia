import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/app/app.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_service.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/services/audio_player_service.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn_mapper.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/alleluia.dart' as legacy;
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Ouvrir la base Isar
  final hymnDb = await HymnDbService.init();

  // 2. Créer le repository qui manipule les Hymn dans Isar
  final hymnsRepo = HymnsRepository(hymnDb);

  // 3. Seed initial (insérer tous tes chants legacy ➜ DB) si la DB est encore vide
  final count = await hymnDb.isar.hymns.count();
  if (count == 0) {
    // convertir chaque Alleluia (ancien modèle) en Hymn (nouveau modèle DB)
    final initialData = legacy.chants.map(hymnFromLegacy).toList();

    await hymnsRepo.seedIfEmpty(initialData);
  }

  // 4. Créer le service audio (unique pour l'app)
  final audioService = AudioPlayerService();

  // 5. Lancer l'app en lui injectant hymnDb et audioService
  runApp(
    App(
      hymnDb: hymnDb,
      audioService: audioService,
    ),
  );
}
