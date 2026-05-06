import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alleluia_tome_1/core/providers/hymns_provider.dart';
import 'package:alleluia_tome_1/features/data/models/search_result.dart';

//  QUERY PROVIDER — stocke le texte de recherche
//
//  La page appelle :
//    ref.read(searchQueryProvider.notifier).state = 'alleluia';
//
//  Et le résultat se met à jour automatiquement.
final searchQueryProvider = StateProvider<String>((ref) => '');


//  RÉSULTATS DE RECHERCHE
//
//  - Dérive depuis searchQueryProvider (le texte)
//    et hymnsRepositoryProvider (accès DB).
//  - Retourne [] si la query est vide ou < 1 char.
//  - Riverpod annule automatiquement le calcul
//    précédent si la query change avant la fin
//    (comportement "debounce naturel").
//
//  Utilisation dans un widget :
//    final results = ref.watch(searchResultsProvider);
//    results.when(
//      data: (list) => ...,
//      loading: () => ...,
//      error: (e, _) => ...,
//    );
final searchResultsProvider = FutureProvider<List<SearchResult>>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();

  // Pas de recherche si la query est trop courte
  if (query.isEmpty) return [];

  final repo = ref.watch(hymnsRepositoryProvider);

  // Petit délai pour éviter de lancer la recherche
  // à chaque frappe — effet debounce simple.
  // Riverpod annule ce Future si la query change
  // avant que le délai soit écoulé.
  await Future<void>.delayed(const Duration(milliseconds: 300));

  // Vérification après le délai : si la query a changé
  // entre temps, Riverpod a déjà annulé ce provider.
  return repo.search(query: query, limit: 30);
});

//  ÉTAT DE LA BARRE DE RECHERCHE
//  (ouverte / fermée)
//
//  Utilisation :
//    final isOpen = ref.watch(searchOpenProvider);
//    ref.read(searchOpenProvider.notifier).state = true;
final searchOpenProvider = StateProvider<bool>((ref) => false);