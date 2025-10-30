import 'package:flutter/material.dart';
import 'package:alleluia_tome_1/core/services/hymn_db_scope.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';
import 'package:alleluia_tome_1/core/services/audio_service_scope.dart';
import 'package:alleluia_tome_1/core/services/audio_player_service.dart';
import 'package:alleluia_tome_1/features/hymns/data/repositories/hymns_repository.dart';
// import 'package:alleluia_tome_1/features/hymns/data/models/alleluia.dart';


/// Page: PlayDetails
///
/// Rôle:
/// - Affiche le détail d’un chant (titre, auteur, description).
/// - Contrôle la lecture audio (play/pause, seek, précédent/suivant).
/// - Navigation vers le chant précédent/suivant.
///
/// Notes:
/// - Gestion audio robuste : abonnement / désabonnement, clamp du slider,
///   affichage des durées, ReleaseMode.stop, passage au chant suivant si fin.
// class PlayDetails extends StatefulWidget {
//   const PlayDetails(this.chantsDetails, {super.key});
//   final Alleluia chantsDetails;


class PlayDetails extends StatefulWidget {
  const PlayDetails(this.hymn, {super.key});
  final Hymn hymn;

  @override
  State<PlayDetails> createState() => _PlayDetailsState();
}

class _PlayDetailsState extends State<PlayDetails> {
  static const Color _blue = Color(0xFF3B5998);

  late final AudioPlayerService _audio;
  late final HymnsRepository _repo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // On récupère les services injectés en haut de l'app
    _audio = AudioServiceScope.of(context);
    final db = HymnDbScope.of(context);
    _repo = HymnsRepository(db);

    // dire au service audio : "le chant courant, c'est celui-ci"
    _audio.setCurrentHymn(widget.hymn);

    // on s'assure que rien ne joue tant qu'on n'a pas appuyé sur play
    _audio.stop();
  }

  @override
  void dispose() {
    // Politique choisie : on stop la lecture en quittant l'écran
    _audio.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hymn = widget.hymn;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 80,
        title: Text(
          '${hymn.number} — ${hymn.title}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Ajouter aux favoris',
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              _toast('Favoris — à venir');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texte du chant
              _buildSections(hymn, cs),

              const SizedBox(height: 20),

              // Auteur
              if (hymn.actor != null && hymn.actor!.trim().isNotEmpty) ...[
                Text(
                  "Auteur : ${hymn.actor}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Catégories
              if (hymn.categories.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: hymn.categories
                      .map(
                        (c) => Chip(
                          label: Text(c),
                          backgroundColor: cs.primaryContainer,
                          labelStyle: TextStyle(color: cs.onPrimaryContainer),
                        ),
                      )
                      .toList(),
                ),

              const SizedBox(height: 8),

              // Battements (rythmes)
              if (hymn.beats.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: hymn.beats
                      .map(
                        (b) => Chip(
                          label: Text(b),
                          backgroundColor: cs.secondaryContainer,
                          labelStyle: TextStyle(color: cs.onSecondaryContainer),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
      bottomSheet: _BottomControls(
        blue: _blue,
        hymn: hymn,
        repo: _repo,
        audio: _audio,
      ),
    );
  }

  /// Affiche toutes les sections du chant (couplets, refrains, etc.).
  Widget _buildSections(Hymn hymn, ColorScheme cs) {
    // si tu n'as pas encore structuré en plusieurs sections,
    // on reconstruit un paragraphe texte simple
    if (hymn.sections.isEmpty) {
      return Text(
        "(Paroles indisponibles pour le moment)",
        style: TextStyle(fontSize: 16, color: cs.onSurface),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: hymn.sections
          .map((section) => _buildSectionBlock(section, cs))
          .toList(),
    );
  }

  Widget _buildSectionBlock(Section section, ColorScheme cs) {
    // Titre de section (ex: "Refrain", "Couplet 1", etc.)
    final sectionLabel = _sectionLabel(section);

    // Contenu texte = toutes les lignes
    final textLines = section.lines.map((l) => l.textLine.trim()).join('\n');

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sectionLabel != null && sectionLabel.isNotEmpty)
            Text(
              sectionLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: cs.primary,
              ),
            ),
          const SizedBox(height: 6),
          Text(
            textLines,
            style: TextStyle(
              fontSize: 18,
              height: 1.4,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  String? _sectionLabel(Section section) {
    switch (section.type) {
      case SectionType.Ref:
        return "Refrain";
      case SectionType.Solo:
        return "Solo";
      case SectionType.Ass:
        return "Assemblée";
      case SectionType.SoloAss:
        // pour SoloAss on peut afficher "Couplet X"
        final num = section.orderSection;
        if (num > 0) return "Couplet $num";
        return null;
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.blue,
    required this.hymn,
    required this.repo,
    required this.audio,
  });

  final Color blue;
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
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Material(
        color: blue,
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // boutons lecture / précédent / suivant
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Précédent',
                    icon: const Icon(
                      Icons.skip_previous,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      // stop audio avant de bouger
                      await audio.stop();

                      final prev = await repo.previousOf(hymn.number);
                      if (prev == null) {
                        _showSnack(context, "Pas de chant précédent");
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
                          playing
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 36,
                          color: Colors.white,
                        ),

                        onPressed: () async {
                          if (hymn.audioPath == null ||
                              hymn.audioPath!.trim().isEmpty) {
                            _showSnack(context, "Pas d'audio pour ce chant");
                            return;
                          }

                          // on informe le service "ce chant est le courant"
                          audio.setCurrentHymn(hymn);

                          // et on bascule Lecture/Pause
                          await audio.togglePlay();
                        },
                      );
                    },
                  ),

                  IconButton(
                    tooltip: 'Suivant',
                    icon: const Icon(
                      Icons.skip_next,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await audio.stop();

                      final next = await repo.nextOf(hymn.number);
                      if (next == null) {
                        _showSnack(context, "Pas de chant suivant");
                        return;
                      }
                      _goTo(context, next);
                    },
                  ),
                ],
              ),

              // slider + durées
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: ValueListenableBuilder<Duration>(
                      valueListenable: audio.position,
                      builder: (_, p, __) => Text(
                        _fmt(p),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white),
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
                            final currSecs = pos.inSeconds
                                .clamp(0, totalSecs > 0 ? totalSecs : 0);
                            return SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 7),
                                trackHeight: 3,
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 12),
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white70,
                                thumbColor: Colors.white,
                              ),
                              child: Slider(
                                value: totalSecs > 0
                                    ? currSecs.toDouble()
                                    : 0,
                                min: 0,
                                max: totalSecs > 0
                                    ? totalSecs.toDouble()
                                    : 1,
                                onChanged: totalSecs > 0
                                    ? (v) => audio.seek(
                                          Duration(seconds: v.toInt()),
                                        )
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
                        _fmt(d),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
