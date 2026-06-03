import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


//  CLÉ DE STOCKAGE
const _kThemeKey = 'alleluia_theme_mode';


//  CONVERSION ThemeMode --> String
String _themeModeToString(ThemeMode mode) => switch (mode) {
  ThemeMode.light => 'light',
  ThemeMode.dark => 'dark',
  ThemeMode.system => 'system',
};

ThemeMode _stringToThemeMode(String? value) => switch (value) {
  'light' => ThemeMode.light,
  'dark' => ThemeMode.dark,
  'system' => ThemeMode.system,
  _ => ThemeMode.light, // défaut si rien sauvegardé
};

//  NOTIFIER
//
//  - build()  : lit le thème sauvegardé au démarrage (depuis SharedPrefs).
//  - setMode(): change le thème ET le persiste.
//
//  Utilisation dans un widget :
//    final mode = ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.light;
//    Changer (depuis Settings) : ref.read(themeModeProvider.notifier).setMode(ThemeMode.dark);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeKey);
    return _stringToThemeMode(saved);
  }

  /// Change le thème et le persiste immédiatement.
  Future<void> setMode(ThemeMode mode) async {
    state = AsyncData(mode);

    // Persistence en arrière-plan
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, _themeModeToString(mode));
  }
}

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);