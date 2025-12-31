import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:alleluia_tome_1/features/utils/normalize.dart';
import 'package:alleluia_tome_1/features/hymns/data/models/hymn.dart';

/// Top-level parser invoqué par compute : transforme la string JSON en List<Hymn>
List<Hymn> _parseHymnsFromJsonString(String jsonString) {
  final raw = jsonDecode(jsonString) as List<dynamic>;

  SectionType _sectionTypeFromString(String? raw) {
    final r = (raw ?? '').toLowerCase().trim();
    switch (r) {
      case 'solo':
        return SectionType.Solo;
      case 'ass':
        return SectionType.Ass;
      case 'ref':
        return SectionType.Ref;
      default:
        return SectionType.SoloAss;
    }
  }

  return raw.map<Hymn>((dynamic item) {
    final map = item as Map<String, dynamic>;

    final rawSections = map['sections'] as List<dynamic>? ?? <dynamic>[];
    final sections = rawSections.map<Section>((dynamic sec) {
      final secMap = sec as Map<String, dynamic>;
      final rawLines = secMap['lines'] as List<dynamic>? ?? <dynamic>[];

      final lines = rawLines.map<Line>((dynamic ln) {
        final lnMap = ln as Map<String, dynamic>;
        final rawText = (lnMap['textLine'] as String?) ?? '';
        final rawNorm = (lnMap['textNormLine'] as String?);
        return Line(
          textLine: rawText.trim(),
          textNormLine: (rawNorm?.trim().isNotEmpty == true)? rawNorm!.trim(): normalizeHymnLine(rawText),
          orderLine: (lnMap['orderLine'] as num?)?.toInt() ?? 0,
          repeatCountLine: (lnMap['repeatCountLine'] as num?)?.toInt() ?? 1,
        );
      }).toList();

      return Section(
        type: _sectionTypeFromString(secMap['type'] as String?),
        orderSection: (secMap['orderSection'] as num?)?.toInt() ?? 0,
        repeatCountSection: (secMap['repeatCountSection'] as num?)?.toInt() ?? 1,
        linesParam: lines,
      );
    }).toList();

    final title = (map['title'] as String?)?.trim() ?? '';
    final titleNormCandidate = (map['titleNorm'] as String?)?.trim();
    final titleNorm = (titleNormCandidate != null && titleNormCandidate.isNotEmpty)? titleNormCandidate: normalizeTitle(title);

    // --- Création du Hymn ---
    return Hymn(
      number: (map['number'] as num?)?.toInt() ?? 0,
      title: title,
      titleNorm: titleNorm,
      actor: (map['actor'] as String?)?.trim(),
      audioPath: (map['audioPath'] as String?)?.trim(),
      language: (map['language'] as String?)?.trim(),
      liturgicalTimesParam: (map['liturgicalTimes'] as List<dynamic>?)?.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList() ??<String>[],
      periodsParam: (map['periods'] as List<dynamic>?)?.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList() ??<String>[],
      beatsParam: (map['beats'] as List<dynamic>?)?.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList() ??<String>[],
      sectionsParam: sections,
    );
  }).toList();
}

/// Charge les hymnes depuis un asset JSON et les convertit en objets Hymn.
Future<List<Hymn>> loadHymnsFromJsonAssetInIsolate(String assetPath) async {
  final jsonString = await rootBundle.loadString(assetPath);
  final hymns = await compute(_parseHymnsFromJsonString, jsonString);
  return hymns;
}
