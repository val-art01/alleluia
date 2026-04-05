// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hymn.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHymnCollection on Isar {
  IsarCollection<Hymn> get hymns => this.collection();
}

const HymnSchema = CollectionSchema(
  name: r'Hymn',
  id: 3094077890258702503,
  properties: {
    r'actor': PropertySchema(
      id: 0,
      name: r'actor',
      type: IsarType.string,
    ),
    r'audioPath': PropertySchema(
      id: 1,
      name: r'audioPath',
      type: IsarType.string,
    ),
    r'beats': PropertySchema(
      id: 2,
      name: r'beats',
      type: IsarType.stringList,
    ),
    r'displayTitle': PropertySchema(
      id: 3,
      name: r'displayTitle',
      type: IsarType.string,
    ),
    r'language': PropertySchema(
      id: 4,
      name: r'language',
      type: IsarType.string,
    ),
    r'liturgicalTimes': PropertySchema(
      id: 5,
      name: r'liturgicalTimes',
      type: IsarType.stringList,
    ),
    r'number': PropertySchema(
      id: 6,
      name: r'number',
      type: IsarType.long,
    ),
    r'periods': PropertySchema(
      id: 7,
      name: r'periods',
      type: IsarType.stringList,
    ),
    r'sections': PropertySchema(
      id: 8,
      name: r'sections',
      type: IsarType.objectList,
      target: r'Section',
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    ),
    r'titleNorm': PropertySchema(
      id: 10,
      name: r'titleNorm',
      type: IsarType.string,
    )
  },
  estimateSize: _hymnEstimateSize,
  serialize: _hymnSerialize,
  deserialize: _hymnDeserialize,
  deserializeProp: _hymnDeserializeProp,
  idName: r'id',
  indexes: {
    r'number': IndexSchema(
      id: 5012388430481709372,
      name: r'number',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'number',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'titleNorm': IndexSchema(
      id: 5660707125133518993,
      name: r'titleNorm',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'titleNorm',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'language': IndexSchema(
      id: -1161120539689460177,
      name: r'language',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'language',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'liturgicalTimes': IndexSchema(
      id: 3939421813255591574,
      name: r'liturgicalTimes',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'liturgicalTimes',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'periods': IndexSchema(
      id: 2116355595295030220,
      name: r'periods',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'periods',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'Section': SectionSchema, r'Line': LineSchema},
  getId: _hymnGetId,
  getLinks: _hymnGetLinks,
  attach: _hymnAttach,
  version: '3.1.0+1',
);

int _hymnEstimateSize(
  Hymn object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.actor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.audioPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.beats.length * 3;
  {
    for (var i = 0; i < object.beats.length; i++) {
      final value = object.beats[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.displayTitle.length * 3;
  {
    final value = object.language;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.liturgicalTimes.length * 3;
  {
    for (var i = 0; i < object.liturgicalTimes.length; i++) {
      final value = object.liturgicalTimes[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.periods.length * 3;
  {
    for (var i = 0; i < object.periods.length; i++) {
      final value = object.periods[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.sections.length * 3;
  {
    final offsets = allOffsets[Section]!;
    for (var i = 0; i < object.sections.length; i++) {
      final value = object.sections[i];
      bytesCount += SectionSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.titleNorm.length * 3;
  return bytesCount;
}

void _hymnSerialize(
  Hymn object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actor);
  writer.writeString(offsets[1], object.audioPath);
  writer.writeStringList(offsets[2], object.beats);
  writer.writeString(offsets[3], object.displayTitle);
  writer.writeString(offsets[4], object.language);
  writer.writeStringList(offsets[5], object.liturgicalTimes);
  writer.writeLong(offsets[6], object.number);
  writer.writeStringList(offsets[7], object.periods);
  writer.writeObjectList<Section>(
    offsets[8],
    allOffsets,
    SectionSchema.serialize,
    object.sections,
  );
  writer.writeString(offsets[9], object.title);
  writer.writeString(offsets[10], object.titleNorm);
}

Hymn _hymnDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Hymn(
    actor: reader.readStringOrNull(offsets[0]),
    audioPath: reader.readStringOrNull(offsets[1]),
    language: reader.readStringOrNull(offsets[4]),
    number: reader.readLong(offsets[6]),
    title: reader.readString(offsets[9]),
    titleNorm: reader.readString(offsets[10]),
  );
  object.beats = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.liturgicalTimes = reader.readStringList(offsets[5]) ?? [];
  object.periods = reader.readStringList(offsets[7]) ?? [];
  object.sections = reader.readObjectList<Section>(
        offsets[8],
        SectionSchema.deserialize,
        allOffsets,
        Section(),
      ) ??
      [];
  return object;
}

P _hymnDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readObjectList<Section>(
            offset,
            SectionSchema.deserialize,
            allOffsets,
            Section(),
          ) ??
          []) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hymnGetId(Hymn object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hymnGetLinks(Hymn object) {
  return [];
}

void _hymnAttach(IsarCollection<dynamic> col, Id id, Hymn object) {
  object.id = id;
}

extension HymnByIndex on IsarCollection<Hymn> {
  Future<Hymn?> getByNumber(int number) {
    return getByIndex(r'number', [number]);
  }

  Hymn? getByNumberSync(int number) {
    return getByIndexSync(r'number', [number]);
  }

  Future<bool> deleteByNumber(int number) {
    return deleteByIndex(r'number', [number]);
  }

  bool deleteByNumberSync(int number) {
    return deleteByIndexSync(r'number', [number]);
  }

  Future<List<Hymn?>> getAllByNumber(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return getAllByIndex(r'number', values);
  }

  List<Hymn?> getAllByNumberSync(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'number', values);
  }

  Future<int> deleteAllByNumber(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'number', values);
  }

  int deleteAllByNumberSync(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'number', values);
  }

  Future<Id> putByNumber(Hymn object) {
    return putByIndex(r'number', object);
  }

  Id putByNumberSync(Hymn object, {bool saveLinks = true}) {
    return putByIndexSync(r'number', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNumber(List<Hymn> objects) {
    return putAllByIndex(r'number', objects);
  }

  List<Id> putAllByNumberSync(List<Hymn> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'number', objects, saveLinks: saveLinks);
  }
}

extension HymnQueryWhereSort on QueryBuilder<Hymn, Hymn, QWhere> {
  QueryBuilder<Hymn, Hymn, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhere> anyNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'number'),
      );
    });
  }
}

extension HymnQueryWhere on QueryBuilder<Hymn, Hymn, QWhereClause> {
  QueryBuilder<Hymn, Hymn, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> numberEqualTo(int number) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'number',
        value: [number],
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> numberNotEqualTo(int number) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [],
              upper: [number],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [number],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [number],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [],
              upper: [number],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> numberGreaterThan(
    int number, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'number',
        lower: [number],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> numberLessThan(
    int number, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'number',
        lower: [],
        upper: [number],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> numberBetween(
    int lowerNumber,
    int upperNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'number',
        lower: [lowerNumber],
        includeLower: includeLower,
        upper: [upperNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> titleNormEqualTo(
      String titleNorm) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'titleNorm',
        value: [titleNorm],
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> titleNormNotEqualTo(
      String titleNorm) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'titleNorm',
              lower: [],
              upper: [titleNorm],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'titleNorm',
              lower: [titleNorm],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'titleNorm',
              lower: [titleNorm],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'titleNorm',
              lower: [],
              upper: [titleNorm],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> languageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'language',
        value: [null],
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> languageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'language',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> languageEqualTo(
      String? language) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'language',
        value: [language],
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> languageNotEqualTo(
      String? language) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'language',
              lower: [],
              upper: [language],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'language',
              lower: [language],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'language',
              lower: [language],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'language',
              lower: [],
              upper: [language],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> liturgicalTimesEqualTo(
      List<String> liturgicalTimes) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'liturgicalTimes',
        value: [liturgicalTimes],
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> liturgicalTimesNotEqualTo(
      List<String> liturgicalTimes) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'liturgicalTimes',
              lower: [],
              upper: [liturgicalTimes],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'liturgicalTimes',
              lower: [liturgicalTimes],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'liturgicalTimes',
              lower: [liturgicalTimes],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'liturgicalTimes',
              lower: [],
              upper: [liturgicalTimes],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> periodsEqualTo(
      List<String> periods) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'periods',
        value: [periods],
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterWhereClause> periodsNotEqualTo(
      List<String> periods) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periods',
              lower: [],
              upper: [periods],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periods',
              lower: [periods],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periods',
              lower: [periods],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periods',
              lower: [],
              upper: [periods],
              includeUpper: false,
            ));
      }
    });
  }
}

extension HymnQueryFilter on QueryBuilder<Hymn, Hymn, QFilterCondition> {
  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actor',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actor',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actor',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> actorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actor',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audioPath',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audioPath',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> audioPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beats',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'beats',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'beats',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'beats',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'beats',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'beats',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'beats',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'beats',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beats',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'beats',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beats',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beats',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beats',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beats',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beats',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> beatsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'beats',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> displayTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'language',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'language',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'language',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'language',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'language',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> languageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'language',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> liturgicalTimesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'liturgicalTimes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition>
      liturgicalTimesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'liturgicalTimes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition>
      liturgicalTimesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'liturgicalTimes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> liturgicalTimesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'liturgicalTimes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition>
      liturgicalTimesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'liturgicalTimes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition>
      liturgicalTimesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'liturgicalTimes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition>
      liturgicalTimesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'liturgicalTimes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> liturgicalTimesElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'liturgicalTimes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition>
      liturgicalTimesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'liturgicalTimes',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition>
      liturgicalTimesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'liturgicalTimes',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> liturgicalTimesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'liturgicalTimes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> liturgicalTimesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'liturgicalTimes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> liturgicalTimesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'liturgicalTimes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> liturgicalTimesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'liturgicalTimes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition>
      liturgicalTimesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'liturgicalTimes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> liturgicalTimesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'liturgicalTimes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> numberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> numberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> numberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> numberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'number',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periods',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'periods',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'periods',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'periods',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'periods',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'periods',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'periods',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'periods',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periods',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'periods',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'periods',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'periods',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'periods',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'periods',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'periods',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> periodsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'periods',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> sectionsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> sectionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> sectionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> sectionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> sectionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> sectionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sections',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleNorm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titleNorm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titleNorm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titleNorm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titleNorm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titleNorm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titleNorm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titleNorm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleNorm',
        value: '',
      ));
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> titleNormIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titleNorm',
        value: '',
      ));
    });
  }
}

extension HymnQueryObject on QueryBuilder<Hymn, Hymn, QFilterCondition> {
  QueryBuilder<Hymn, Hymn, QAfterFilterCondition> sectionsElement(
      FilterQuery<Section> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sections');
    });
  }
}

extension HymnQueryLinks on QueryBuilder<Hymn, Hymn, QFilterCondition> {}

extension HymnQuerySortBy on QueryBuilder<Hymn, Hymn, QSortBy> {
  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByActor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actor', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByActorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actor', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByAudioPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByAudioPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByDisplayTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayTitle', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByDisplayTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayTitle', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByTitleNorm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleNorm', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> sortByTitleNormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleNorm', Sort.desc);
    });
  }
}

extension HymnQuerySortThenBy on QueryBuilder<Hymn, Hymn, QSortThenBy> {
  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByActor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actor', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByActorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actor', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByAudioPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByAudioPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByDisplayTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayTitle', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByDisplayTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayTitle', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByTitleNorm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleNorm', Sort.asc);
    });
  }

  QueryBuilder<Hymn, Hymn, QAfterSortBy> thenByTitleNormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleNorm', Sort.desc);
    });
  }
}

extension HymnQueryWhereDistinct on QueryBuilder<Hymn, Hymn, QDistinct> {
  QueryBuilder<Hymn, Hymn, QDistinct> distinctByActor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hymn, Hymn, QDistinct> distinctByAudioPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hymn, Hymn, QDistinct> distinctByBeats() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beats');
    });
  }

  QueryBuilder<Hymn, Hymn, QDistinct> distinctByDisplayTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hymn, Hymn, QDistinct> distinctByLanguage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'language', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hymn, Hymn, QDistinct> distinctByLiturgicalTimes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'liturgicalTimes');
    });
  }

  QueryBuilder<Hymn, Hymn, QDistinct> distinctByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'number');
    });
  }

  QueryBuilder<Hymn, Hymn, QDistinct> distinctByPeriods() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periods');
    });
  }

  QueryBuilder<Hymn, Hymn, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hymn, Hymn, QDistinct> distinctByTitleNorm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleNorm', caseSensitive: caseSensitive);
    });
  }
}

extension HymnQueryProperty on QueryBuilder<Hymn, Hymn, QQueryProperty> {
  QueryBuilder<Hymn, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Hymn, String?, QQueryOperations> actorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actor');
    });
  }

  QueryBuilder<Hymn, String?, QQueryOperations> audioPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioPath');
    });
  }

  QueryBuilder<Hymn, List<String>, QQueryOperations> beatsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beats');
    });
  }

  QueryBuilder<Hymn, String, QQueryOperations> displayTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayTitle');
    });
  }

  QueryBuilder<Hymn, String?, QQueryOperations> languageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'language');
    });
  }

  QueryBuilder<Hymn, List<String>, QQueryOperations> liturgicalTimesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'liturgicalTimes');
    });
  }

  QueryBuilder<Hymn, int, QQueryOperations> numberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'number');
    });
  }

  QueryBuilder<Hymn, List<String>, QQueryOperations> periodsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periods');
    });
  }

  QueryBuilder<Hymn, List<Section>, QQueryOperations> sectionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sections');
    });
  }

  QueryBuilder<Hymn, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Hymn, String, QQueryOperations> titleNormProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleNorm');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LineSchema = Schema(
  name: r'Line',
  id: 6581538959273871026,
  properties: {
    r'orderLine': PropertySchema(
      id: 0,
      name: r'orderLine',
      type: IsarType.long,
    ),
    r'repeatCountLine': PropertySchema(
      id: 1,
      name: r'repeatCountLine',
      type: IsarType.long,
    ),
    r'textLine': PropertySchema(
      id: 2,
      name: r'textLine',
      type: IsarType.string,
    ),
    r'textNormLine': PropertySchema(
      id: 3,
      name: r'textNormLine',
      type: IsarType.string,
    )
  },
  estimateSize: _lineEstimateSize,
  serialize: _lineSerialize,
  deserialize: _lineDeserialize,
  deserializeProp: _lineDeserializeProp,
);

int _lineEstimateSize(
  Line object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.textLine.length * 3;
  bytesCount += 3 + object.textNormLine.length * 3;
  return bytesCount;
}

void _lineSerialize(
  Line object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.orderLine);
  writer.writeLong(offsets[1], object.repeatCountLine);
  writer.writeString(offsets[2], object.textLine);
  writer.writeString(offsets[3], object.textNormLine);
}

Line _lineDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Line(
    orderLine: reader.readLongOrNull(offsets[0]) ?? 0,
    repeatCountLine: reader.readLongOrNull(offsets[1]) ?? 1,
    textLine: reader.readStringOrNull(offsets[2]) ?? '',
    textNormLine: reader.readStringOrNull(offsets[3]) ?? '',
  );
  return object;
}

P _lineDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LineQueryFilter on QueryBuilder<Line, Line, QFilterCondition> {
  QueryBuilder<Line, Line, QAfterFilterCondition> orderLineEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderLine',
        value: value,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> orderLineGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderLine',
        value: value,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> orderLineLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderLine',
        value: value,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> orderLineBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderLine',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> repeatCountLineEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatCountLine',
        value: value,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> repeatCountLineGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeatCountLine',
        value: value,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> repeatCountLineLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeatCountLine',
        value: value,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> repeatCountLineBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeatCountLine',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textLine',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textLine',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textLine',
        value: '',
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textLineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textLine',
        value: '',
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textNormLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textNormLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textNormLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textNormLine',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textNormLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textNormLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textNormLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textNormLine',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textNormLine',
        value: '',
      ));
    });
  }

  QueryBuilder<Line, Line, QAfterFilterCondition> textNormLineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textNormLine',
        value: '',
      ));
    });
  }
}

extension LineQueryObject on QueryBuilder<Line, Line, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SectionSchema = Schema(
  name: r'Section',
  id: 7698308494449530003,
  properties: {
    r'lines': PropertySchema(
      id: 0,
      name: r'lines',
      type: IsarType.objectList,
      target: r'Line',
    ),
    r'orderSection': PropertySchema(
      id: 1,
      name: r'orderSection',
      type: IsarType.long,
    ),
    r'repeatCountSection': PropertySchema(
      id: 2,
      name: r'repeatCountSection',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 3,
      name: r'type',
      type: IsarType.byte,
      enumMap: _SectiontypeEnumValueMap,
    )
  },
  estimateSize: _sectionEstimateSize,
  serialize: _sectionSerialize,
  deserialize: _sectionDeserialize,
  deserializeProp: _sectionDeserializeProp,
);

int _sectionEstimateSize(
  Section object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lines.length * 3;
  {
    final offsets = allOffsets[Line]!;
    for (var i = 0; i < object.lines.length; i++) {
      final value = object.lines[i];
      bytesCount += LineSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _sectionSerialize(
  Section object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Line>(
    offsets[0],
    allOffsets,
    LineSchema.serialize,
    object.lines,
  );
  writer.writeLong(offsets[1], object.orderSection);
  writer.writeLong(offsets[2], object.repeatCountSection);
  writer.writeByte(offsets[3], object.type.index);
}

Section _sectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Section(
    orderSection: reader.readLongOrNull(offsets[1]) ?? 0,
    repeatCountSection: reader.readLongOrNull(offsets[2]) ?? 1,
    type: _SectiontypeValueEnumMap[reader.readByteOrNull(offsets[3])] ??
        SectionType.SoloAss,
  );
  object.lines = reader.readObjectList<Line>(
        offsets[0],
        LineSchema.deserialize,
        allOffsets,
        Line(),
      ) ??
      [];
  return object;
}

P _sectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Line>(
            offset,
            LineSchema.deserialize,
            allOffsets,
            Line(),
          ) ??
          []) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 3:
      return (_SectiontypeValueEnumMap[reader.readByteOrNull(offset)] ??
          SectionType.SoloAss) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SectiontypeEnumValueMap = {
  'Solo': 0,
  'Ass': 1,
  'Ref': 2,
  'SoloAss': 3,
  'nullable': 4,
};
const _SectiontypeValueEnumMap = {
  0: SectionType.Solo,
  1: SectionType.Ass,
  2: SectionType.Ref,
  3: SectionType.SoloAss,
  4: SectionType.nullable,
};

extension SectionQueryFilter
    on QueryBuilder<Section, Section, QFilterCondition> {
  QueryBuilder<Section, Section, QAfterFilterCondition> linesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lines',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> linesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lines',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> linesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lines',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> linesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lines',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> linesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lines',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> linesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lines',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> orderSectionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderSection',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> orderSectionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderSection',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> orderSectionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderSection',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> orderSectionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderSection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition>
      repeatCountSectionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatCountSection',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition>
      repeatCountSectionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeatCountSection',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition>
      repeatCountSectionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeatCountSection',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition>
      repeatCountSectionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeatCountSection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> typeEqualTo(
      SectionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> typeGreaterThan(
    SectionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> typeLessThan(
    SectionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Section, Section, QAfterFilterCondition> typeBetween(
    SectionType lower,
    SectionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SectionQueryObject
    on QueryBuilder<Section, Section, QFilterCondition> {
  QueryBuilder<Section, Section, QAfterFilterCondition> linesElement(
      FilterQuery<Line> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'lines');
    });
  }
}
