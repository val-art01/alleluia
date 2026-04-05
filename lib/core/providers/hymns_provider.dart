import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alleluia_tome_1/core/providers/hymn_db_service_provider.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/data/repositories/hymns_repository.dart';

//  REPOSITORY PROVIDER
//  Une seule instance de HymnsRepository dans
//  toute l'app. Les autres providers en dépendent.
final hymnsRepositoryProvider = Provider<HymnsRepository>((ref) {
  final db = ref.watch(hymnDbServiceProvider);
  return HymnsRepository(db);
});

//  LISTE COMPLÈTE DES CHANTS (triés par numéro)
//
//  Utilisation dans un widget :
//    final hymnsAsync = ref.watch(hymnsProvider);
//    hymnsAsync.when(
//      data: (hymns) => ...,
//      loading: () => CircularProgressIndicator(),
//      error: (e, _) => Text('Erreur : $e'),
//    );
final hymnsProvider = FutureProvider<List<Hymn>>((ref) {
  final repo = ref.watch(hymnsRepositoryProvider);
  return repo.getAll();
});


//  LISTE TRIÉE ALPHABÉTIQUEMENT (page Titre)
//
//  On dérive depuis hymnsProvider pour ne pas
//  refaire un appel DB — simple transformation
//  en mémoire.
final hymnsSortedAlphaProvider = FutureProvider<List<Hymn>>((ref) async {
  final hymns = await ref.watch(hymnsProvider.future);
  final sorted = [...hymns];
  sorted.sort(
    (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
  );
  return sorted;
});

//  UN CHANT PAR SON NUMÉRO (page PlayDetails)
//
//  Utilisation :
//    final hymnAsync = ref.watch(hymnByNumberProvider(42));
final hymnByNumberProvider =
    FutureProvider.family<Hymn?, int>((ref, number) {
  final repo = ref.watch(hymnsRepositoryProvider);
  return repo.getByNumber(number);
});

//  CHANTS GROUPÉS PAR CATÉGORIE (page Catégories)
//
//  Retourne une Map<String, List<Hymn>> triée
//  alphabétiquement par nom de catégorie.
final hymnsByCategoryProvider =
    FutureProvider<Map<String, List<Hymn>>>((ref) async {
  final hymns = await ref.watch(hymnsProvider.future);

  final map = <String, List<Hymn>>{};
  for (final hymn in hymns) {
    // liturgicalTimes = les catégories du chant
    final categories = hymn.liturgicalTimes.isEmpty
        ? ['Sans catégorie']
        : hymn.liturgicalTimes;

    for (final cat in categories) {
      map.putIfAbsent(cat, () => []).add(hymn);
    }
  }

  // Trier les catégories alphabétiquement
  return Map.fromEntries(
    map.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)),
  );
});

//  CHANTS GROUPÉS PAR BATTEMENT (page Battements)
final hymnsByBeatProvider =
    FutureProvider<Map<String, List<Hymn>>>((ref) async {
  final hymns = await ref.watch(hymnsProvider.future);

  final map = <String, List<Hymn>>{};
  for (final hymn in hymns) {
    final beats =
        hymn.beats.isEmpty ? ['Sans battement'] : hymn.beats;

    for (final beat in beats) {
      map.putIfAbsent(beat, () => []).add(hymn);
    }
  }

  return Map.fromEntries(
    map.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)),
  );
});