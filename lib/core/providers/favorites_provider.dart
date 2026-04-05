import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alleluia_tome_1/core/providers/hymn_db_service_provider.dart';
import 'package:alleluia_tome_1/core/providers/hymns_provider.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/data/repositories/favorites_repository.dart';

//  REPOSITORY PROVIDER
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final db = ref.watch(hymnDbServiceProvider);
  return FavoritesRepository(db);
});


//  NOTIFIER — gère l'état des favoris
//
//  State = Set<int> des numéros de chants favoris.
//  Un Set permet de vérifier isFavorite en O(1).
//
//  Utilisation dans un widget :
//    // Lire tous les numéros favoris :
//    final favNums = ref.watch(favoritesProvider);
//
//    // Vérifier si un chant est favori :
//    final isFav = ref.watch(isFavoriteProvider(hymnNumber));
//
//    // Toggler :
//    ref.read(favoritesProvider.notifier).toggle(hymnNumber);
class FavoritesNotifier extends AsyncNotifier<Set<int>> {
  FavoritesRepository get _repo =>
      ref.read(favoritesRepositoryProvider);

  @override
  Future<Set<int>> build() async {
    // Charge tous les numéros favoris au démarrage
    final numbers = await _repo.getAllFavoriteNumbers();
    return numbers.toSet();
  }

  /// Ajoute ou retire un chant des favoris.
  /// L'UI se met à jour automatiquement grâce à Riverpod.
  Future<void> toggle(int hymnNumber) async {
    await _repo.toggleFavorite(hymnNumber);

    // Mise à jour optimiste de l'état local
    state = state.whenData((favs) {
      final updated = {...favs};
      if (updated.contains(hymnNumber)) {
        updated.remove(hymnNumber);
      } else {
        updated.add(hymnNumber);
      }
      return updated;
    });
  }

  /// Vérifie si un chant est dans les favoris.
  bool isFavorite(int hymnNumber) {
    return state.valueOrNull?.contains(hymnNumber) ?? false;
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);


//  PROVIDER DÉRIVÉ : isFavorite pour un chant
//
//  Utilisation :
//    final isFav = ref.watch(isFavoriteProvider(hymn.number));
//
//  Ne rebuild que si CE chant change de statut,
//  pas quand n'importe quel autre favori change.
final isFavoriteProvider = Provider.family<bool, int>((ref, hymnNumber) {
  final favs = ref.watch(favoritesProvider).valueOrNull ?? {};
  return favs.contains(hymnNumber);
});

//  LISTE DES CHANTS FAVORIS (page Favoris)
//
//  Combine favoritesProvider + hymnsProvider
//  pour retourner les objets Hymn complets,
//  triés par date d'ajout (plus récent en premier).
final favoriteHymnsProvider = FutureProvider<List<Hymn>>((ref) async {
  // On écoute les deux providers — si l'un change, on recalcule
  final favNumbers =
      await ref.watch(favoritesProvider.future);
  final allHymns = await ref.watch(hymnsProvider.future);

  // Filtrer uniquement les chants favoris
  // On garde l'ordre de favNumbers (= ordre d'ajout, plus récent en premier)
  final favList = favNumbers
      .map((n) => allHymns.where((h) => h.number == n).firstOrNull)
      .whereType<Hymn>()
      .toList();

  return favList;
});