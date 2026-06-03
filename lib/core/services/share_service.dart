import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:alleluia_tome_1/features/data/models/hymn.dart';

//  SERVICE DE PARTAGE
//
//  Centralise toute la logique de partage.
//  Pas de provider nécessaire — ce sont des
//  actions ponctuelles sans état à observer.
//
//  Utilisation :
//    ShareService.shareApp(context);
//    ShareService.shareHymn(context, hymn);

abstract final class ShareService {
  /// Lien Play Store de l'application.
  static const _kPlayStoreUrl = 'https://play.google.com/apps/testing/com.eec.alleluia_tome_1';

  //  PARTAGE DE L'APPLICATION
  static Future<void> shareApp(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(
      ShareParams(
        subject: 'Alleluia Tome 1 — Chants pour Culte d\'Enfants',
        text:
            'Découvrez l\'application Alleluia Tome 1 !\n\n'
            '220 chants du Culte d\'Enfants de l\'Église\n'
            'Évangélique du Cameroun.\n\n'
            '$_kPlayStoreUrl',
        sharePositionOrigin: box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : null,
      ),
    );
  }

  //  PARTAGE DES PAROLES D'UN CHANT
  static Future<void> shareHymn(BuildContext context, Hymn hymn) async {
    final box = context.findRenderObject() as RenderBox?;
    final text = _buildHymnText(hymn);

    await SharePlus.instance.share(
      ShareParams(
        subject: '${hymn.number} — ${hymn.title}',
        text: text,
        sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      ),
    );
  }

  static String _buildHymnText(Hymn hymn) {
    final buf = StringBuffer();

    // En-tête
    final separator = '═' * 30;
    buf.writeln(separator);
    buf.writeln('${hymn.number} — ${hymn.title}');
    buf.writeln(separator);

    // Auteur si disponible
    if ((hymn.actor ?? '').trim().isNotEmpty) {
      buf.writeln('Auteur : ${hymn.actor!.trim()}');
    }
    buf.writeln();

    // Sections
    for (final section in hymn.sections) {
      final lines = section.lines
          .where((l) => l.textLine.trim().isNotEmpty)
          .toList();
      if (lines.isEmpty) continue;

      // Label de section
      final label = _sectionLabel(section);
      if (label.isNotEmpty) {
        buf.writeln('[$label]');
      }

      // Lignes
      for (final line in lines) {
        final text = line.textLine.trim();
        if (line.repeatCountLine > 1) {
          buf.writeln('$text  (×${line.repeatCountLine})');
        } else {
          buf.writeln(text);
        }
      }

      // Répétition de section
      if (section.repeatCountSection > 1) {
        buf.writeln('(×${section.repeatCountSection})');
      }

      buf.writeln();
    }

    // Pied de page
    buf.writeln('— Partagé depuis Alleluia Tome 1');
    buf.writeln('   Culte d\'Enfants — Église Évangélique du Cameroun');

    return buf.toString().trimRight();
  }

  static String _sectionLabel(Section s) {
    final base = switch (s.type) {
      SectionType.Ref      => 'Ref',
      SectionType.Solo     => 'Solo',
      SectionType.Ass      => 'Ass',
      SectionType.SoloAss  => 'Solo+Ass',
      SectionType.nullable => '',
    };
    return base;
  }
}