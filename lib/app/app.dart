import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/routes/app_router.dart';

/// Point d'entrée de l'application.
/// ConsumerWidget permet d'accéder aux providers Riverpod
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Alleluia',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // Navigation
      routerConfig: router,
    );
  }
}

//  Permet à l'utilisateur de choisir son thème.
final themeModeProvider = StateProvider<ThemeMode>(
  (ref) => ThemeMode.light,
);

