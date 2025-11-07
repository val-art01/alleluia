import 'package:isar/isar.dart';
part 'favorite.g.dart';

@collection
class Favorite {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int hymnNumber;          // numéro unique du chant favori
  DateTime? createdAt;      // pour trier par ajout récent

  Favorite({
    required this.hymnNumber,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}


