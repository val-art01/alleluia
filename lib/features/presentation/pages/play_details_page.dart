import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/providers/hymns_provider.dart';
import 'package:alleluia_tome_1/core/providers/audio_provider.dart';
import 'package:alleluia_tome_1/core/providers/favorites_provider.dart';
import 'package:alleluia_tome_1/core/services/audio_player_service.dart';


///  PAGE PLAY DETAILS
///
///  Architecture :
///  - Scaffold fixe : AppBar + BottomPlayer
///  - Body : AnimatedSwitcher avec slide gauche/droite
///    qui anime UNIQUEMENT les paroles quand on
///    change de chant (prev/next).
///  - L'AppBar et le player ne bougent jamais.

class PlayDetails extends ConsumerStatefulWidget {
  const PlayDetails({super.key, required this.hymnId});
  final int hymnId;

  @override
  ConsumerState<PlayDetails> createState() => _PlayDetailsState();
}

class _PlayDetailsState extends ConsumerState<PlayDetails> {
  AudioPlayerService? _audio;

  // Chant actuellement affiché
  Hymn? _hymn;

  // Direction de l'animation : true = vers la droite (prev), false = vers la gauche (next)
  bool _slideToRight = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initAudio());
  }

  Future<void> _initAudio() async {
    if (!mounted) return;
    final audio = ref.read(audioServiceProvider);
    _audio = audio;
    final hymn = await ref.read(hymnByNumberProvider(widget.hymnId).future);
    if (!mounted || hymn == null) return;
    setState(() => _hymn = hymn);
    audio.setCurrentHymn(hymn);
    await audio.stop();
  }

  @override
  void dispose() {
    _audio?.stop();
    super.dispose();
  }

  // ── Navigation avec animation 
  Future<void> _navigate({required bool previous}) async {
    final audio = ref.read(audioServiceProvider);
    final repo = ref.read(hymnsRepositoryProvider);

    await audio.stop();

    final target = previous
        ? await repo.previousOf(_hymn!.number)
        : await repo.nextOf(_hymn!.number);

    if (!mounted) return;

    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            previous ? 'Pas de chant précédent' : 'Pas de chant suivant',
          ),
        ),
      );
      return;
    }

    // Met à jour la direction AVANT de changer le chant
    setState(() {
      _slideToRight = previous;
      _hymn = target;
    });

    audio.setCurrentHymn(target);
    await audio.stop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hymn = _hymn;

    // Chargement initial
    if (hymn == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,

      // AppBar FIXE
      appBar: _buildAppBar(context, hymn),

      // Body : seules les paroles animent
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          // Slide horizontal : droite→gauche (next) ou gauche→droite (prev)
          final offsetIn = Tween<Offset>(
            begin: Offset(_slideToRight ? -1.0 : 1.0, 0),
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(
            position: offsetIn,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        // La clé force l'animation à chaque changement de chant
        child: _LyricsBody(key: ValueKey(hymn.number), hymn: hymn),
      ),

      // BottomPlayer FIXE
      bottomSheet: _BottomPlayer(
        hymn: hymn,
        onPrevious: () => _navigate(previous: true),
        onNext: () => _navigate(previous: false),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Hymn hymn) {
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 64,
      // Animate uniquement le titre quand le chant change
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Text(
          '${hymn.number} — ${hymn.title}',
          key: ValueKey(hymn.number),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: cs.onPrimary,
            height: 1.3,
          ),
        ),
      ),
      actions: [
        Consumer(
          builder: (context, ref, _) {
            final isFav = ref.watch(isFavoriteProvider(hymn.number));
            return IconButton(
              tooltip: isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  key: ValueKey(isFav),
                  color: isFav
                      ? Theme.of(context).extension<AppColors>()!.favoriteFill
                      : cs.onPrimary,
                ),
              ),
              onPressed: () => ref.read(favoritesProvider.notifier).toggle(hymn.number)
            );
          },
        ),
      ],
    );
  }
}

///  BODY : PAROLES + AUTEUR
///  Reçoit une ValueKey(hymn.number) pour que
///  AnimatedSwitcher détecte le changement.
class _LyricsBody extends StatelessWidget {
  const _LyricsBody({super.key, required this.hymn});
  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomScrollView(
      // Remet le scroll en haut à chaque nouveau chant
      key: PageStorageKey(hymn.number),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(
            child: HymnLyricsView(hymn: hymn),
          ),
        ),
        if ((hymn.actor ?? '').trim().isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            sliver: SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Auteur : ${hymn.actor!.trim()}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

///  PAROLES
class HymnLyricsView extends StatelessWidget {
  const HymnLyricsView({super.key, required this.hymn});
  final Hymn hymn;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (hymn.sections.isEmpty) {
      return Text(
        '(Paroles indisponibles pour le moment)',
        style: TextStyle(fontSize: 16, color: cs.onSurfaceVariant),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final s in hymn.sections) _SectionBlock(section: s),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.section});
  final Section section;

  static String _label(Section s) {
    final base = switch (s.type) {
      SectionType.Ref      => 'Ref',
      SectionType.Solo     => 'Solo',
      SectionType.Ass      => 'Ass',
      SectionType.SoloAss  => 'Solo+Ass',
      SectionType.nullable => '',
    };
    return s.repeatCountSection > 1 ? '$base ×${s.repeatCountSection}' : base;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lines = section.lines
        .where((l) => l.textLine.trim().isNotEmpty)
        .toList();
    if (lines.isEmpty) return const SizedBox.shrink();
    final label = _label(section);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          for (final line in lines)
            _LyricLine(text: line.textLine.trim(),repeatCount: line.repeatCountLine),
        ],
      ),
    );
  }
}

class _LyricLine extends StatelessWidget {
  const _LyricLine({required this.text, required this.repeatCount});
  final String text;
  final int repeatCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontSize: 17,
      height: 1.45,
      color: cs.onSurface,
      fontWeight: FontWeight.w500,
    );

    if (repeatCount <= 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text, style: style),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(text, style: style)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: cs.primaryContainer,
            ),
            child: Text(
              '×$repeatCount',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: cs.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///  LECTEUR EN BAS (FIXE)
class _BottomPlayer extends ConsumerWidget {
  const _BottomPlayer({ required this.hymn, required this.onPrevious, required this.onNext});

  final Hymn hymn;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  static String _fmt(Duration d) {
    if (d <= Duration.zero) return '00:00';
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: cs.primary,
          boxShadow: [
            BoxShadow(
              color: cs.primary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Container(
              width: 32, height: 3,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: cs.onPrimary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            _TransportRow(hymn: hymn, onPrevious: onPrevious, onNext: onNext),
            const SizedBox(height: 4),
            _SeekRow(fmt: _fmt),
          ],
        ),
      ),
    );
  }
}

///  TRANSPORT
class _TransportRow extends ConsumerWidget {
  const _TransportRow({required this.hymn, required this.onPrevious, required this.onNext});

  final Hymn hymn;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isPlaying = ref.watch(isPlayingProvider).valueOrNull ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Précédent
        IconButton(
          tooltip: 'Précédent',
          icon: Icon(Icons.skip_previous_rounded, size: 32, color: cs.onPrimary),
          onPressed: onPrevious,
        ),

        const SizedBox(width: 8),

        // Play / Pause
        GestureDetector(
          onTap: () => _togglePlay(context, ref),
          child: Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: cs.onPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 34,
              color: cs.primary,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Suivant
        IconButton(
          tooltip: 'Suivant',
          icon: Icon(Icons.skip_next_rounded, size: 32, color: cs.onPrimary),
          onPressed: onNext,
        ),
      ],
    );
  }

  Future<void> _togglePlay(BuildContext context, WidgetRef ref) async {
    final audio = ref.read(audioServiceProvider);
    final path = hymn.audioPath?.trim() ?? '';

    if (path.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pas d'audio pour ce chant")),
        );
      }
      return;
    }

    audio.setCurrentHymn(hymn);
    try {
      await audio.togglePlay();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pas d'audio pour ce chant")),
        );
      }
    }
  }
}

///  SEEK ROW
class _SeekRow extends ConsumerWidget {
  const _SeekRow({required this.fmt});
  final String Function(Duration) fmt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final position = ref.watch(audioPositionProvider).valueOrNull ?? Duration.zero;
    final duration = ref.watch(audioDurationProvider).valueOrNull ?? Duration.zero;

    final totalSecs = duration.inSeconds;
    final currSecs = position.inSeconds.clamp(0, totalSecs > 0 ? totalSecs : 0);

    final labelStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: cs.onPrimary.withOpacity(0.8),
    );

    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(fmt(position), textAlign: TextAlign.center, style: labelStyle),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: cs.onPrimary,
              inactiveTrackColor: cs.onPrimary.withOpacity(0.3),
              thumbColor: cs.onPrimary,
              overlayColor: cs.onPrimary.withOpacity(0.15),
            ),
            child: Slider(
              value: totalSecs > 0 ? currSecs.toDouble() : 0,
              min: 0,
              max: totalSecs > 0 ? totalSecs.toDouble() : 1,
              onChanged: totalSecs > 0
                  ? (v) => ref
                      .read(audioServiceProvider)
                      .seek(Duration(seconds: v.toInt()))
                  : null,
            ),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(fmt(duration), textAlign: TextAlign.center, style: labelStyle),
        ),
      ],
    );
  }
}