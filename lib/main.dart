import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alleluia_tome_1/app/app.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_service.dart';
import 'package:alleluia_tome_1/core/providers/hymn_db_service_provider.dart';
import 'package:alleluia_tome_1/features/data/repositories/hymns_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de la base Isar
  final hymnDb = await HymnDbService.init();

  // Seed automatique si la DB est vide
  final hymnsRepo = HymnsRepository(hymnDb);
  await hymnsRepo.seedFromJsonIfNeeded();

  // Lancement avec ProviderScope
  // On passe hymnDb via un override pour que les providers
  // Riverpod y aient accès sans InheritedWidget manuel.
  runApp(
    ProviderScope(
      overrides: [
        hymnDbServiceProvider.overrideWithValue(hymnDb),
      ],
      child: const App(),
    ),
  );
}
