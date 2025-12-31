import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/core/services/audio_service_scope.dart';
import 'package:alleluia_tome_1/core/services/audio_player_service.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/favorites_repository.dart';

/// Page phare: détail d’un chant + lecteur audio.
///
/// Objectifs UX:
/// - Lecture confortable des paroles (compact, sans “gros vides”)
/// - Contrôles audio accessibles en bas (prev/play/next + slider)
/// - Gestion favoris (coeur en haut)
///
/// Architecture:
/// - La page “orchestration” (init services + fav + repo)
/// - Widgets dédiés pour le rendu des paroles et des contrôles
class PlayDetails extends StatefulWidget {
  const PlayDetails(this.hymn, {super.key});
  final Hymn hymn;

  @override
  State<PlayDetails> createState() => _PlayDetailsState();
}

class _PlayDetailsState extends State<PlayDetails> {
  late final AudioPlayerService _audio;
  late final HymnsRepository _repo;
  late final FavoritesRepository _favRepo;
  final GlobalKey _playerKey = GlobalKey();
  double _playerHeight = 0;

  bool _isFav = false;
  bool _initDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initDone) return;

    // Services (Scopes) + repos (DB)
    _audio = AudioServiceScope.of(context);
    final db = HymnDbScope.of(context);
    _repo = HymnsRepository(db);
    _favRepo = FavoritesRepository(db);

    // On prépare le player pour ce chant, mais on ne lance pas automatiquement.
    _audio.setCurrentHymn(widget.hymn);
    _audio.stop();

    _loadFav();
    _initDone = true;
  }

  @override
  void dispose() {
    // Politique UX: on coupe le son si on quitte l’écran.
    _audio.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hymn = widget.hymn;
    final cs = Theme.of(context).colorScheme;
    _measurePlayerHeight();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.secondary,
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 72, // un peu plus compact que 80
        title: Text(
          '${hymn.number} — ${hymn.title}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: _isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
            icon: Icon(
              _isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleFav,
          ),
        ],
      ),

      /// Body compact:
      /// - pas de gros padding
      /// - pas de SizedBox inutiles
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              sliver: SliverToBoxAdapter(child: HymnLyricsView(hymn: hymn)),
            ),

            // Auteur collé au bas des paroles (sans gros vide)
            if ((hymn.actor ?? '').trim().isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  (_playerHeight == 0 ? 110 : _playerHeight) + 12,
                ),
                sliver: SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Auteur : ${hymn.actor!.trim()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              )
            else
              // Espace minimum pour éviter que le bottomSheet couvre le contenu
              SliverToBoxAdapter(
                child: SizedBox(
                  height: (_playerHeight == 0 ? 110 : _playerHeight) + 12,
                ),
              ),
            
          ],
        ),
      ),

      /// Lecteur en bas (fixe)
      bottomSheet: BottomPlayerControls(
        key: _playerKey,
        background: AppTheme.secondaryYellow,
        hymn: hymn,
        repo: _repo,
        audio: _audio,
      ),
    );
  }

  void _measurePlayerHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _playerKey.currentContext;
      if (ctx == null) return;

      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) return;

      final h = box.size.height;
      if (h > 0 && h != _playerHeight && mounted) {
        setState(() => _playerHeight = h);
      }
    });
  }

  /// Charge l’état favori du chant (async -> setState si mounted).
  Future<void> _loadFav() async {
    final f = await _favRepo.isFavorite(widget.hymn.number);
    if (mounted) setState(() => _isFav = f);
  }

  /// Toggle favori + refresh UI.
  Future<void> _toggleFav() async {
    await _favRepo.toggleFavorite(widget.hymn.number);
    await _loadFav();
  }
}

/// Rendu des paroles (sections + lignes) en mode compact.
/// - Pas de grands espaces
/// - Titres de section visibles
/// - Badge de répétition "×2" sur les lignes répétées
class HymnLyricsView extends StatelessWidget {
  const HymnLyricsView({super.key, required this.hymn});
  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sections = hymn.sections;

    if (sections.isEmpty) {
      return Text(
        '(Paroles indisponibles pour le moment)',
        style: TextStyle(fontSize: 16, color: cs.onSurface),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final section in sections) SectionBlock(section: section),
      ],
    );
  }
}

/// Bloc d’une section (Ref/Solo/Ass/Solo+Ass) + ses lignes.
/// Optimisé pour éviter les “vides”.
class SectionBlock extends StatelessWidget {
  const SectionBlock({super.key, required this.section});
  final Section section;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final nonEmptyLines = section.lines
        .where((l) => l.textLine.trim().isNotEmpty)
        .toList();

    if (nonEmptyLines.isEmpty) return const SizedBox.shrink();

    final label = _sectionLabel(section);

    return Padding(
      // Compact: 12 au lieu de 24
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: cs.primary,
                ),
              ),
            ),

          for (final line in nonEmptyLines)
            _LyricLine(
              text: line.textLine.trim(),
              repeatCount: line.repeatCountLine,
            ),
        ],
      ),
    );
  }

  /// Libellé humain pour le type de section + répétition de section.
  static String _sectionLabel(Section section) {
    String base;
    switch (section.type) {
      case SectionType.Ref:
        base = 'Ref';
        break;
      case SectionType.Solo:
        base = 'Solo';
        break;
      case SectionType.Ass:
        base = 'Ass';
        break;
      case SectionType.SoloAss:
        base = 'Solo+Ass';
        break;
    }

    final rep = section.repeatCountSection;
    return rep > 1 ? '$base ×$rep' : base;
  }
}

/// Une ligne de paroles.
/// - Texte
/// - Badge "×n" si répétition > 1
class _LyricLine extends StatelessWidget {
  const _LyricLine({required this.text, required this.repeatCount});

  final String text;
  final int repeatCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Spacing minimal: padding vertical léger
    if (repeatCount <= 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: TextStyle(fontSize: 17, height: 1.35, color: cs.onSurface),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 17, height: 1.35, color: cs.onSurface),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: cs.secondaryContainer,
            ),
            child: Text(
              '×$repeatCount',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: cs.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Contrôles audio en bas:
/// - Précédent / Play-Pause / Suivant
/// - Slider (seek) + durées
///
/// Notes:
/// - `ValueListenableBuilder` écoute le service audio
/// - Slider clampé pour éviter pos > duration
class BottomPlayerControls extends StatelessWidget {
  const BottomPlayerControls({
    super.key,
    required this.background,
    required this.hymn,
    required this.repo,
    required this.audio,
  });

  final Color background;
  final Hymn hymn;
  final HymnsRepository repo;
  final AudioPlayerService audio;

  String _fmt(Duration d) {
    if (d <= Duration.zero) return '00:00';
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Material(
        color: background,
        elevation: 12,
        child: Padding(
          // Compact: on réduit un peu
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TransportRow(hymn: hymn, repo: repo, audio: audio),
              const SizedBox(height: 2),
              _SeekRow(fmt: _fmt, audio: audio),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransportRow extends StatelessWidget {
  const _TransportRow({
    required this.hymn,
    required this.repo,
    required this.audio,
  });

  final Hymn hymn;
  final HymnsRepository repo;
  final AudioPlayerService audio;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'Précédent',
          icon: const Icon(
            Icons.skip_previous,
            size: 30,
            color: AppTheme.backgroundWhite,
          ),
          onPressed: () async {
            await audio.stop();
            final prev = await repo.previousOf(hymn.number);
            if (prev == null) {
              _showSnack(context, 'Pas de chant précédent');
              return;
            }
            _goTo(context, prev);
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: audio.isPlaying,
          builder: (_, playing, __) {
            return IconButton(
              tooltip: playing ? 'Pause' : 'Lecture',
              icon: Icon(
                playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
                size: 38,
                color: AppTheme.backgroundWhite,
              ),
              onPressed: () async {
                final path = hymn.audioPath?.trim();
                if (path == null || path.isEmpty) {
                  _showSnack(context, "Pas d'audio pour ce chant");
                  return;
                }

                audio.setCurrentHymn(hymn);
                try {
                  await audio.togglePlay();
                } catch (_) {
                  _showSnack(context, "Pas d'audio pour ce chant");
                }
              },
            );
          },
        ),
        IconButton(
          tooltip: 'Suivant',
          icon: const Icon(
            Icons.skip_next,
            size: 30,
            color: AppTheme.backgroundWhite,
          ),
          onPressed: () async {
            await audio.stop();
            final next = await repo.nextOf(hymn.number);
            if (next == null) {
              _showSnack(context, 'Pas de chant suivant');
              return;
            }
            _goTo(context, next);
          },
        ),
      ],
    );
  }

  void _goTo(BuildContext context, Hymn hymn) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, __, ___) => PlayDetails(hymn),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _SeekRow extends StatelessWidget {
  const _SeekRow({required this.fmt, required this.audio});

  final String Function(Duration) fmt;
  final AudioPlayerService audio;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: ValueListenableBuilder<Duration>(
            valueListenable: audio.position,
            builder: (_, p, __) => Text(
              fmt(p),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.backgroundWhite,
              ),
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<Duration>(
            valueListenable: audio.duration,
            builder: (_, total, __) {
              return ValueListenableBuilder<Duration>(
                valueListenable: audio.position,
                builder: (_, pos, __) {
                  final totalSecs = total.inSeconds;
                  final currSecs = pos.inSeconds.clamp(
                    0,
                    totalSecs > 0 ? totalSecs : 0,
                  );

                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                      ),
                      trackHeight: 3,
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12,
                      ),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white70,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: totalSecs > 0 ? currSecs.toDouble() : 0,
                      min: 0,
                      max: totalSecs > 0 ? totalSecs.toDouble() : 1,
                      onChanged: totalSecs > 0
                          ? (v) => audio.seek(Duration(seconds: v.toInt()))
                          : null,
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(
          width: 48,
          child: ValueListenableBuilder<Duration>(
            valueListenable: audio.duration,
            builder: (_, d, __) => Text(
              fmt(d),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.backgroundWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
