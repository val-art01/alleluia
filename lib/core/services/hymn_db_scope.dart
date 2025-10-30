import 'package:flutter/widgets.dart';
import 'hymn_db_service.dart';

class HymnDbScope extends InheritedWidget {
  const HymnDbScope({
    super.key,
    required this.db,
    required super.child,
  });

  final HymnDbService db;

  static HymnDbService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<HymnDbScope>();
    assert(scope != null, 'HymnDbScope manquant dans l’arbre des widgets');
    return scope!.db;
  }

  @override
  bool updateShouldNotify(HymnDbScope oldWidget) => false;
}
