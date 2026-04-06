import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alleluia_tome_1/app/themes/app_theme.dart';
import 'package:alleluia_tome_1/core/routes/app_router.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/providers/hymns_provider.dart';
import 'package:alleluia_tome_1/core/providers/audio_provider.dart';
import 'package:alleluia_tome_1/core/providers/favorites_provider.dart';
import 'package:alleluia_tome_1/core/services/audio_player_service.dart';

//  PAGE PLAY DETAILS
//  Reçoit un hymnId depuis go_router,
//  charge le chant via hymnByNumberProvider.
class PlayDetails extends ConsumerStatefulWidget {
  const PlayDetails({super.key, required this.hymnId});
  final int hymnId;
 
  @override
  ConsumerState<PlayDetails> createState() => _PlayDetailsState();
}
 
class _PlayDetailsState extends ConsumerState<PlayDetails> {
  // Stocké en variable pour éviter ref.read() dans dispose()
  AudioPlayerService? _audio;
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initAudio());
  }
 
  Future<void> _initAudio() async {
    if (!mounted) return;
    // Capturer le service AVANT tout await
    final audio = ref.read(audioServiceProvider);
    _audio = audio;
 
    final hymn = await ref.read(hymnByNumberProvider(widget.hymnId).future);
    if (!mounted) return;
 
    audio.setCurrentHymn(hymn!);
    await audio.stop();
  }
 
  @override
  void dispose() {
    // Variable locale — jamais ref.read() dans dispose()
    _audio?.stop();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final hymnAsync = ref.watch(hymnByNumberProvider(widget.hymnId));
 
    return hymnAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur : $e')),
      ),
      data: (hymn) {
        if (hymn == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Chant introuvable')),
          );
        }
        return _PlayDetailsContent(hymn: hymn);
      },
    );
  }
}

//  CONTENU PRINCIPAL
class _PlayDetailsContent extends ConsumerWidget {
  const _PlayDetailsContent({required this.hymn});
  final Hymn hymn;
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isFav = ref.watch(isFavoriteProvider(hymn.number));
 
    return Scaffold(
      backgroundColor: cs.surface,
 
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        title: Text(
          '${hymn.number} — ${hymn.title}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: cs.onPrimary,
            height: 1.3,
          ),
        ),
        actions: [
          IconButton(
            tooltip: isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
            icon: Icon(
              isFav
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFav
                  ? Theme.of(context).extension<AppColors>()!.favoriteFill
                  : cs.onPrimary,
            ),
            onPressed: () =>
                ref.read(favoritesProvider.notifier).toggle(hymn.number),
          ),
        ],
      ),
 
      body: CustomScrollView(
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
      ),
 
      bottomSheet: _BottomPlayer(hymn: hymn),
    );
  }
}

//  PAROLES DU CHANT
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

//  BLOC D'UNE SECTION
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
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
            _LyricLine(
              text: line.textLine.trim(),
              repeatCount: line.repeatCountLine,
            ),
        ],
      ),
    );
  }
}

//  UNE LIGNE DE PAROLES
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

//  LECTEUR AUDIO EN BAS
class _BottomPlayer extends ConsumerWidget {
  const _BottomPlayer({required this.hymn});
  final Hymn hymn;

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
            Container(
              width: 32, height: 3,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: cs.onPrimary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            _TransportRow(hymn: hymn),
            const SizedBox(height: 4),
            _SeekRow(fmt: _fmt),
          ],
        ),
      ),
    );
  }
}

//  TRANSPORT : PREV / PLAY / NEXT
class _TransportRow extends ConsumerWidget {
  const _TransportRow({required this.hymn});
  final Hymn hymn;

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
          icon: Icon(Icons.skip_previous_rounded,
              size: 32, color: cs.onPrimary),
          onPressed: () => _navigate(context, ref, previous: true),
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
          icon: Icon(Icons.skip_next_rounded,
              size: 32, color: cs.onPrimary),
          onPressed: () => _navigate(context, ref, previous: false),
        ),
      ],
    );
  }

  Future<void> _togglePlay(BuildContext context, WidgetRef ref) async {
    // Capturer tout AVANT les awaits
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

  Future<void> _navigate(
    BuildContext context,
    WidgetRef ref, {
    required bool previous,
  }) async {
    // Capturer tout AVANT les awaits
    final audio = ref.read(audioServiceProvider);
    final repo = ref.read(hymnsRepositoryProvider);

    await audio.stop();

    final target = previous
        ? await repo.previousOf(hymn.number)
        : await repo.nextOf(hymn.number);

    // Vérifier mounted APRÈS chaque await
    if (!context.mounted) return;

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

    context.pushReplacement(AppRoutes.playDetailsPath(target.number));
  }
}

//  SEEK ROW : SLIDER + DURÉES
class _SeekRow extends ConsumerWidget {
  const _SeekRow({required this.fmt});
  final String Function(Duration) fmt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final position = ref.watch(audioPositionProvider).valueOrNull
        ?? Duration.zero;
    final duration = ref.watch(audioDurationProvider).valueOrNull
        ?? Duration.zero;

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
          child: Text(fmt(position), textAlign: TextAlign.center,
              style: labelStyle),
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
          child: Text(fmt(duration), textAlign: TextAlign.center,
              style: labelStyle),
        ),
      ],
    );
  }
}