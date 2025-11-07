import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';

class SearchResult {
  final Hymn hymn;
  final int score; // Pour la priorisation
  final String? matchedLine; // La ligne où le mot a été trouvé
  
  SearchResult({
    required this.hymn,
    required this.score,
    this.matchedLine,
  });
}