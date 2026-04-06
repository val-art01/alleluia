import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//  TOKENS — valeurs de design réutilisables
abstract final class AppTokens {
  // Spacing
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Border radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  // Elevation (M3 tonal)
  static const double elevationNone = 0;
  static const double elevationLow = 1;
  static const double elevationMid = 3;
  static const double elevationHigh = 6;

  // Durées d'animation
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMid = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);

  // Courbes d'animation
  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveEmphasized = Curves.easeOutCubic;
  static const Curve curveSpring = Curves.elasticOut;
}

//  COULEURS SÉMANTIQUES (extension de thème)
//  Accès : Theme.of(context).extension<AppColors>()
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.hymnsCardBg,
    required this.hymnsCardBorder,
    required this.playerBg,
    required this.playerProgress,
    required this.favoriteFill,
    required this.categoryChipBg,
    required this.categoryChipLabel,
    required this.numberTileBg,
    required this.numberTileText,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color hymnsCardBg;
  final Color hymnsCardBorder;
  final Color playerBg;
  final Color playerProgress;
  final Color favoriteFill;
  final Color categoryChipBg;
  final Color categoryChipLabel;
  final Color numberTileBg;
  final Color numberTileText;
  final Color shimmerBase;
  final Color shimmerHighlight;

  @override
  AppColors copyWith({
    Color? hymnsCardBg,
    Color? hymnsCardBorder,
    Color? playerBg,
    Color? playerProgress,
    Color? favoriteFill,
    Color? categoryChipBg,
    Color? categoryChipLabel,
    Color? numberTileBg,
    Color? numberTileText,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppColors(
      hymnsCardBg: hymnsCardBg ?? this.hymnsCardBg,
      hymnsCardBorder: hymnsCardBorder ?? this.hymnsCardBorder,
      playerBg: playerBg ?? this.playerBg,
      playerProgress: playerProgress ?? this.playerProgress,
      favoriteFill: favoriteFill ?? this.favoriteFill,
      categoryChipBg: categoryChipBg ?? this.categoryChipBg,
      categoryChipLabel: categoryChipLabel ?? this.categoryChipLabel,
      numberTileBg: numberTileBg ?? this.numberTileBg,
      numberTileText: numberTileText ?? this.numberTileText,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      hymnsCardBg: Color.lerp(hymnsCardBg, other.hymnsCardBg, t)!,
      hymnsCardBorder: Color.lerp(hymnsCardBorder, other.hymnsCardBorder, t)!,
      playerBg: Color.lerp(playerBg, other.playerBg, t)!,
      playerProgress: Color.lerp(playerProgress, other.playerProgress, t)!,
      favoriteFill: Color.lerp(favoriteFill, other.favoriteFill, t)!,
      categoryChipBg: Color.lerp(categoryChipBg, other.categoryChipBg, t)!,
      categoryChipLabel:
          Color.lerp(categoryChipLabel, other.categoryChipLabel, t)!,
      numberTileBg: Color.lerp(numberTileBg, other.numberTileBg, t)!,
      numberTileText: Color.lerp(numberTileText, other.numberTileText, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }

  // Valeurs light
  static const AppColors light = AppColors(
    hymnsCardBg: Color(0xFFF5F8FF),
    hymnsCardBorder: Color(0xFFDDE5F8),
    playerBg: Color(0xFF1565C0),
    playerProgress: Color(0xFFF9A825),
    favoriteFill: Color(0xFFF9A825),
    categoryChipBg: Color(0xFFE3EEFF),
    categoryChipLabel: Color(0xFF1565C0),
    numberTileBg: Color(0xFFE3EEFF),
    numberTileText: Color(0xFF1565C0),
    shimmerBase: Color(0xFFE8EEF8),
    shimmerHighlight: Color(0xFFF5F8FF),
  );

  // Valeurs dark
  static const AppColors dark = AppColors(
    hymnsCardBg: Color(0xFF1A2035),
    hymnsCardBorder: Color(0xFF2A3550),
    playerBg: Color(0xFF0D1B3E),
    playerProgress: Color(0xFFF9A825),
    favoriteFill: Color(0xFFF9A825),
    categoryChipBg: Color(0xFF1A2A4A),
    categoryChipLabel: Color(0xFF90C5FF),
    numberTileBg: Color(0xFF1A2A4A),
    numberTileText: Color(0xFF90C5FF),
    shimmerBase: Color(0xFF1A2035),
    shimmerHighlight: Color(0xFF243050),
  );
}

//  APP THEME
abstract final class AppTheme {
  // Couleurs brutes 
  static const Color seedBlue = Color(0xFF1565C0);
  static const Color seedYellow = Color(0xFFF9A825);

  // Thème CLAIR
  static ThemeData get light {
    final cs = ColorScheme.fromSeed(
      seedColor: seedBlue,
      secondary: seedYellow,
      brightness: Brightness.light,
    );
    return _build(cs, Brightness.light);
  }

  // Thème SOMBRE 
  static ThemeData get dark {
    final cs = ColorScheme.fromSeed(
      seedColor: seedBlue,
      secondary: seedYellow,
      brightness: Brightness.dark,
    );
    return _build(cs, Brightness.dark);
  }

  // Constructeur commun
  static ThemeData _build(ColorScheme cs, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Overlay system UI
    SystemChrome.setSystemUIOverlayStyle(
      isDark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: cs.surface,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: cs.surface,
            ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      extensions: [isDark ? AppColors.dark : AppColors.light],

      // Scaffold
      scaffoldBackgroundColor: cs.surface,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: AppTokens.elevationNone,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: cs.onSurface,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      // NavigationBar (M3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppTokens.elevationNone,
        height: 64,
        indicatorColor: cs.primaryContainer,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppTokens.radiusMd),
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? cs.primary : cs.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
          );
        }),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: AppTokens.elevationNone,
        color: isDark ? const Color(0xFF1A2035) : const Color(0xFFF5F8FF),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppTokens.radiusLg),
          side: BorderSide(
            color: isDark
                ? const Color(0xFF2A3550)
                : const Color(0xFFDDE5F8),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.md,
          vertical: AppTokens.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        tileColor: Colors.transparent,
        selectedColor: cs.primary,
        selectedTileColor: cs.primaryContainer.withOpacity(0.5),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? const Color(0xFF1A2A4A)
            : const Color(0xFFE3EEFF),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFF90C5FF) : cs.primary,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.sm,
          vertical: AppTokens.xs,
        ),
        selectedColor: cs.primaryContainer,
      ),

      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          elevation: AppTokens.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.lg,
            vertical: AppTokens.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          side: BorderSide(color: cs.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: cs.onSurfaceVariant,
          highlightColor: cs.primaryContainer.withOpacity(0.4),
        ),
      ),

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: seedYellow,
        foregroundColor: Colors.black87,
        elevation: AppTokens.elevationMid,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        ),
      ),

      // Input / SearchBar
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? const Color(0xFF1A2035)
            : const Color(0xFFF0F4FF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.md,
          vertical: AppTokens.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        hintStyle: TextStyle(
          color: cs.onSurfaceVariant.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIconColor: cs.onSurfaceVariant,
      ),

      // SearchBar
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(
          isDark ? const Color(0xFF1A2035) : const Color(0xFFF0F4FF),
        ),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          ),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: isDark ? const Color(0xFF2A3550) : const Color(0xFFDDE5F8),
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(color: cs.onSurface, fontSize: 15),
        ),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(
            color: cs.onSurfaceVariant.withOpacity(0.6),
            fontSize: 15,
          ),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant.withOpacity(0.5),
        thickness: 1,
        space: 1,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF2A3550)
            : cs.inverseSurface,
        contentTextStyle: TextStyle(
          color: isDark ? Colors.white : cs.onInverseSurface,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // BottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTokens.radiusXl),
          ),
        ),
        dragHandleColor: cs.outlineVariant,
        dragHandleSize: const Size(40, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppTokens.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusXl),
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: cs.onSurfaceVariant,
          height: 1.5,
        ),
      ),

      // Slider (player audio)
      sliderTheme: SliderThemeData(
        activeTrackColor: seedYellow,
        inactiveTrackColor: cs.outlineVariant.withOpacity(0.4),
        thumbColor: seedYellow,
        overlayColor: seedYellow.withOpacity(0.2),
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),

      // Progress indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.outlineVariant.withOpacity(0.3),
        circularTrackColor: cs.outlineVariant.withOpacity(0.2),
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Accès rapide au ColorScheme
extension ColorSchemeX on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  TextTheme get tt => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
