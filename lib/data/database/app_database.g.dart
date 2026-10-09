// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, BookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [surahNumber, ayahNumber, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {surahNumber, ayahNumber};
  @override
  BookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkRow(
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class BookmarkRow extends DataClass implements Insertable<BookmarkRow> {
  final int surahNumber;
  final int ayahNumber;
  final DateTime createdAt;
  const BookmarkRow({
    required this.surahNumber,
    required this.ayahNumber,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      createdAt: Value(createdAt),
    );
  }

  factory BookmarkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkRow(
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BookmarkRow copyWith({
    int? surahNumber,
    int? ayahNumber,
    DateTime? createdAt,
  }) => BookmarkRow(
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    createdAt: createdAt ?? this.createdAt,
  );
  BookmarkRow copyWithCompanion(BookmarksCompanion data) {
    return BookmarkRow(
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRow(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(surahNumber, ayahNumber, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkRow &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<BookmarkRow> {
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required int surahNumber,
    required int ayahNumber,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       createdAt = Value(createdAt);
  static Insertable<BookmarkRow> custom({
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith({
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BookmarksCompanion(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingPositionsTable extends ReadingPositions
    with TableInfo<$ReadingPositionsTable, ReadingPositionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingPositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahNumber,
    ayahNumber,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_positions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingPositionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingPositionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingPositionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingPositionsTable createAlias(String alias) {
    return $ReadingPositionsTable(attachedDatabase, alias);
  }
}

class ReadingPositionRow extends DataClass
    implements Insertable<ReadingPositionRow> {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final DateTime updatedAt;
  const ReadingPositionRow({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReadingPositionsCompanion toCompanion(bool nullToAbsent) {
    return ReadingPositionsCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingPositionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingPositionRow(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReadingPositionRow copyWith({
    int? id,
    int? surahNumber,
    int? ayahNumber,
    DateTime? updatedAt,
  }) => ReadingPositionRow(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingPositionRow copyWithCompanion(ReadingPositionsCompanion data) {
    return ReadingPositionRow(
      id: data.id.present ? data.id.value : this.id,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingPositionRow(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahNumber, ayahNumber, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingPositionRow &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.updatedAt == this.updatedAt);
}

class ReadingPositionsCompanion extends UpdateCompanion<ReadingPositionRow> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<DateTime> updatedAt;
  const ReadingPositionsCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReadingPositionsCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int ayahNumber,
    required DateTime updatedAt,
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       updatedAt = Value(updatedAt);
  static Insertable<ReadingPositionRow> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReadingPositionsCompanion copyWith({
    Value<int>? id,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<DateTime>? updatedAt,
  }) {
    return ReadingPositionsCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingPositionsCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SurahsTable extends Surahs with TableInfo<$SurahsTable, SurahRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arabicNameMeta = const VerificationMeta(
    'arabicName',
  );
  @override
  late final GeneratedColumn<String> arabicName = GeneratedColumn<String>(
    'arabic_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latinNameMeta = const VerificationMeta(
    'latinName',
  );
  @override
  late final GeneratedColumn<String> latinName = GeneratedColumn<String>(
    'latin_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseCountMeta = const VerificationMeta(
    'verseCount',
  );
  @override
  late final GeneratedColumn<int> verseCount = GeneratedColumn<int>(
    'verse_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    number,
    arabicName,
    latinName,
    verseCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurahRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    }
    if (data.containsKey('arabic_name')) {
      context.handle(
        _arabicNameMeta,
        arabicName.isAcceptableOrUnknown(data['arabic_name']!, _arabicNameMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicNameMeta);
    }
    if (data.containsKey('latin_name')) {
      context.handle(
        _latinNameMeta,
        latinName.isAcceptableOrUnknown(data['latin_name']!, _latinNameMeta),
      );
    } else if (isInserting) {
      context.missing(_latinNameMeta);
    }
    if (data.containsKey('verse_count')) {
      context.handle(
        _verseCountMeta,
        verseCount.isAcceptableOrUnknown(data['verse_count']!, _verseCountMeta),
      );
    } else if (isInserting) {
      context.missing(_verseCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {number};
  @override
  SurahRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurahRow(
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      arabicName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_name'],
      )!,
      latinName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}latin_name'],
      )!,
      verseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_count'],
      )!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class SurahRow extends DataClass implements Insertable<SurahRow> {
  final int number;
  final String arabicName;
  final String latinName;
  final int verseCount;
  const SurahRow({
    required this.number,
    required this.arabicName,
    required this.latinName,
    required this.verseCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['number'] = Variable<int>(number);
    map['arabic_name'] = Variable<String>(arabicName);
    map['latin_name'] = Variable<String>(latinName);
    map['verse_count'] = Variable<int>(verseCount);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      number: Value(number),
      arabicName: Value(arabicName),
      latinName: Value(latinName),
      verseCount: Value(verseCount),
    );
  }

  factory SurahRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurahRow(
      number: serializer.fromJson<int>(json['number']),
      arabicName: serializer.fromJson<String>(json['arabicName']),
      latinName: serializer.fromJson<String>(json['latinName']),
      verseCount: serializer.fromJson<int>(json['verseCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'number': serializer.toJson<int>(number),
      'arabicName': serializer.toJson<String>(arabicName),
      'latinName': serializer.toJson<String>(latinName),
      'verseCount': serializer.toJson<int>(verseCount),
    };
  }

  SurahRow copyWith({
    int? number,
    String? arabicName,
    String? latinName,
    int? verseCount,
  }) => SurahRow(
    number: number ?? this.number,
    arabicName: arabicName ?? this.arabicName,
    latinName: latinName ?? this.latinName,
    verseCount: verseCount ?? this.verseCount,
  );
  SurahRow copyWithCompanion(SurahsCompanion data) {
    return SurahRow(
      number: data.number.present ? data.number.value : this.number,
      arabicName: data.arabicName.present
          ? data.arabicName.value
          : this.arabicName,
      latinName: data.latinName.present ? data.latinName.value : this.latinName,
      verseCount: data.verseCount.present
          ? data.verseCount.value
          : this.verseCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurahRow(')
          ..write('number: $number, ')
          ..write('arabicName: $arabicName, ')
          ..write('latinName: $latinName, ')
          ..write('verseCount: $verseCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(number, arabicName, latinName, verseCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurahRow &&
          other.number == this.number &&
          other.arabicName == this.arabicName &&
          other.latinName == this.latinName &&
          other.verseCount == this.verseCount);
}

class SurahsCompanion extends UpdateCompanion<SurahRow> {
  final Value<int> number;
  final Value<String> arabicName;
  final Value<String> latinName;
  final Value<int> verseCount;
  const SurahsCompanion({
    this.number = const Value.absent(),
    this.arabicName = const Value.absent(),
    this.latinName = const Value.absent(),
    this.verseCount = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.number = const Value.absent(),
    required String arabicName,
    required String latinName,
    required int verseCount,
  }) : arabicName = Value(arabicName),
       latinName = Value(latinName),
       verseCount = Value(verseCount);
  static Insertable<SurahRow> custom({
    Expression<int>? number,
    Expression<String>? arabicName,
    Expression<String>? latinName,
    Expression<int>? verseCount,
  }) {
    return RawValuesInsertable({
      if (number != null) 'number': number,
      if (arabicName != null) 'arabic_name': arabicName,
      if (latinName != null) 'latin_name': latinName,
      if (verseCount != null) 'verse_count': verseCount,
    });
  }

  SurahsCompanion copyWith({
    Value<int>? number,
    Value<String>? arabicName,
    Value<String>? latinName,
    Value<int>? verseCount,
  }) {
    return SurahsCompanion(
      number: number ?? this.number,
      arabicName: arabicName ?? this.arabicName,
      latinName: latinName ?? this.latinName,
      verseCount: verseCount ?? this.verseCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (arabicName.present) {
      map['arabic_name'] = Variable<String>(arabicName.value);
    }
    if (latinName.present) {
      map['latin_name'] = Variable<String>(latinName.value);
    }
    if (verseCount.present) {
      map['verse_count'] = Variable<int>(verseCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('number: $number, ')
          ..write('arabicName: $arabicName, ')
          ..write('latinName: $latinName, ')
          ..write('verseCount: $verseCount')
          ..write(')'))
        .toString();
  }
}

class $AyahsTable extends Ayahs with TableInfo<$AyahsTable, AyahRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arabicTextMeta = const VerificationMeta(
    'arabicText',
  );
  @override
  late final GeneratedColumn<String> arabicText = GeneratedColumn<String>(
    'arabic_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [surahNumber, ayahNumber, arabicText];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AyahRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('arabic_text')) {
      context.handle(
        _arabicTextMeta,
        arabicText.isAcceptableOrUnknown(data['arabic_text']!, _arabicTextMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {surahNumber, ayahNumber};
  @override
  AyahRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AyahRow(
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      arabicText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_text'],
      )!,
    );
  }

  @override
  $AyahsTable createAlias(String alias) {
    return $AyahsTable(attachedDatabase, alias);
  }
}

class AyahRow extends DataClass implements Insertable<AyahRow> {
  final int surahNumber;
  final int ayahNumber;
  final String arabicText;
  const AyahRow({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabicText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['arabic_text'] = Variable<String>(arabicText);
    return map;
  }

  AyahsCompanion toCompanion(bool nullToAbsent) {
    return AyahsCompanion(
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      arabicText: Value(arabicText),
    );
  }

  factory AyahRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AyahRow(
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      arabicText: serializer.fromJson<String>(json['arabicText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'arabicText': serializer.toJson<String>(arabicText),
    };
  }

  AyahRow copyWith({int? surahNumber, int? ayahNumber, String? arabicText}) =>
      AyahRow(
        surahNumber: surahNumber ?? this.surahNumber,
        ayahNumber: ayahNumber ?? this.ayahNumber,
        arabicText: arabicText ?? this.arabicText,
      );
  AyahRow copyWithCompanion(AyahsCompanion data) {
    return AyahRow(
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      arabicText: data.arabicText.present
          ? data.arabicText.value
          : this.arabicText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AyahRow(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('arabicText: $arabicText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(surahNumber, ayahNumber, arabicText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AyahRow &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.arabicText == this.arabicText);
}

class AyahsCompanion extends UpdateCompanion<AyahRow> {
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String> arabicText;
  final Value<int> rowid;
  const AyahsCompanion({
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.arabicText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AyahsCompanion.insert({
    required int surahNumber,
    required int ayahNumber,
    required String arabicText,
    this.rowid = const Value.absent(),
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       arabicText = Value(arabicText);
  static Insertable<AyahRow> custom({
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? arabicText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (arabicText != null) 'arabic_text': arabicText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AyahsCompanion copyWith({
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<String>? arabicText,
    Value<int>? rowid,
  }) {
    return AyahsCompanion(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      arabicText: arabicText ?? this.arabicText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (arabicText.present) {
      map['arabic_text'] = Variable<String>(arabicText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahsCompanion(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('arabicText: $arabicText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AyahTranslationsTable extends AyahTranslations
    with TableInfo<$AyahTranslationsTable, AyahTranslationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<String> editionId = GeneratedColumn<String>(
    'edition_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationTextMeta = const VerificationMeta(
    'translationText',
  );
  @override
  late final GeneratedColumn<String> translationText = GeneratedColumn<String>(
    'translation_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    surahNumber,
    ayahNumber,
    editionId,
    translationText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayah_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<AyahTranslationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_editionIdMeta);
    }
    if (data.containsKey('translation_text')) {
      context.handle(
        _translationTextMeta,
        translationText.isAcceptableOrUnknown(
          data['translation_text']!,
          _translationTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {surahNumber, ayahNumber, editionId};
  @override
  AyahTranslationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AyahTranslationRow(
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_id'],
      )!,
      translationText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_text'],
      )!,
    );
  }

  @override
  $AyahTranslationsTable createAlias(String alias) {
    return $AyahTranslationsTable(attachedDatabase, alias);
  }
}

class AyahTranslationRow extends DataClass
    implements Insertable<AyahTranslationRow> {
  final int surahNumber;
  final int ayahNumber;
  final String editionId;

  /// Named `translationText` (not `text`) so the getter does not shadow
  /// drift's `text()` column builder.
  final String translationText;
  const AyahTranslationRow({
    required this.surahNumber,
    required this.ayahNumber,
    required this.editionId,
    required this.translationText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['edition_id'] = Variable<String>(editionId);
    map['translation_text'] = Variable<String>(translationText);
    return map;
  }

  AyahTranslationsCompanion toCompanion(bool nullToAbsent) {
    return AyahTranslationsCompanion(
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      editionId: Value(editionId),
      translationText: Value(translationText),
    );
  }

  factory AyahTranslationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AyahTranslationRow(
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      editionId: serializer.fromJson<String>(json['editionId']),
      translationText: serializer.fromJson<String>(json['translationText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'editionId': serializer.toJson<String>(editionId),
      'translationText': serializer.toJson<String>(translationText),
    };
  }

  AyahTranslationRow copyWith({
    int? surahNumber,
    int? ayahNumber,
    String? editionId,
    String? translationText,
  }) => AyahTranslationRow(
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    editionId: editionId ?? this.editionId,
    translationText: translationText ?? this.translationText,
  );
  AyahTranslationRow copyWithCompanion(AyahTranslationsCompanion data) {
    return AyahTranslationRow(
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      translationText: data.translationText.present
          ? data.translationText.value
          : this.translationText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AyahTranslationRow(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('editionId: $editionId, ')
          ..write('translationText: $translationText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(surahNumber, ayahNumber, editionId, translationText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AyahTranslationRow &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.editionId == this.editionId &&
          other.translationText == this.translationText);
}

class AyahTranslationsCompanion extends UpdateCompanion<AyahTranslationRow> {
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String> editionId;
  final Value<String> translationText;
  final Value<int> rowid;
  const AyahTranslationsCompanion({
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.editionId = const Value.absent(),
    this.translationText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AyahTranslationsCompanion.insert({
    required int surahNumber,
    required int ayahNumber,
    required String editionId,
    required String translationText,
    this.rowid = const Value.absent(),
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       editionId = Value(editionId),
       translationText = Value(translationText);
  static Insertable<AyahTranslationRow> custom({
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? editionId,
    Expression<String>? translationText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (editionId != null) 'edition_id': editionId,
      if (translationText != null) 'translation_text': translationText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AyahTranslationsCompanion copyWith({
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<String>? editionId,
    Value<String>? translationText,
    Value<int>? rowid,
  }) {
    return AyahTranslationsCompanion(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      editionId: editionId ?? this.editionId,
      translationText: translationText ?? this.translationText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<String>(editionId.value);
    }
    if (translationText.present) {
      map['translation_text'] = Variable<String>(translationText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahTranslationsCompanion(')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('editionId: $editionId, ')
          ..write('translationText: $translationText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentMetaTable extends ContentMeta
    with TableInfo<$ContentMetaTable, ContentMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arabicSourceMeta = const VerificationMeta(
    'arabicSource',
  );
  @override
  late final GeneratedColumn<String> arabicSource = GeneratedColumn<String>(
    'arabic_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arabicEditionMeta = const VerificationMeta(
    'arabicEdition',
  );
  @override
  late final GeneratedColumn<String> arabicEdition = GeneratedColumn<String>(
    'arabic_edition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arabicSha256Meta = const VerificationMeta(
    'arabicSha256',
  );
  @override
  late final GeneratedColumn<String> arabicSha256 = GeneratedColumn<String>(
    'arabic_sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationEditionIdMeta =
      const VerificationMeta('translationEditionId');
  @override
  late final GeneratedColumn<String> translationEditionId =
      GeneratedColumn<String>(
        'translation_edition_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _translationVersionMeta =
      const VerificationMeta('translationVersion');
  @override
  late final GeneratedColumn<String> translationVersion =
      GeneratedColumn<String>(
        'translation_version',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _translationSha256Meta = const VerificationMeta(
    'translationSha256',
  );
  @override
  late final GeneratedColumn<String> translationSha256 =
      GeneratedColumn<String>(
        'translation_sha256',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _acquiredAtMeta = const VerificationMeta(
    'acquiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> acquiredAt = GeneratedColumn<DateTime>(
    'acquired_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validationReportRefMeta =
      const VerificationMeta('validationReportRef');
  @override
  late final GeneratedColumn<String> validationReportRef =
      GeneratedColumn<String>(
        'validation_report_ref',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    arabicSource,
    arabicEdition,
    arabicSha256,
    translationEditionId,
    translationVersion,
    translationSha256,
    acquiredAt,
    validationReportRef,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('arabic_source')) {
      context.handle(
        _arabicSourceMeta,
        arabicSource.isAcceptableOrUnknown(
          data['arabic_source']!,
          _arabicSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_arabicSourceMeta);
    }
    if (data.containsKey('arabic_edition')) {
      context.handle(
        _arabicEditionMeta,
        arabicEdition.isAcceptableOrUnknown(
          data['arabic_edition']!,
          _arabicEditionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_arabicEditionMeta);
    }
    if (data.containsKey('arabic_sha256')) {
      context.handle(
        _arabicSha256Meta,
        arabicSha256.isAcceptableOrUnknown(
          data['arabic_sha256']!,
          _arabicSha256Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_arabicSha256Meta);
    }
    if (data.containsKey('translation_edition_id')) {
      context.handle(
        _translationEditionIdMeta,
        translationEditionId.isAcceptableOrUnknown(
          data['translation_edition_id']!,
          _translationEditionIdMeta,
        ),
      );
    }
    if (data.containsKey('translation_version')) {
      context.handle(
        _translationVersionMeta,
        translationVersion.isAcceptableOrUnknown(
          data['translation_version']!,
          _translationVersionMeta,
        ),
      );
    }
    if (data.containsKey('translation_sha256')) {
      context.handle(
        _translationSha256Meta,
        translationSha256.isAcceptableOrUnknown(
          data['translation_sha256']!,
          _translationSha256Meta,
        ),
      );
    }
    if (data.containsKey('acquired_at')) {
      context.handle(
        _acquiredAtMeta,
        acquiredAt.isAcceptableOrUnknown(data['acquired_at']!, _acquiredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_acquiredAtMeta);
    }
    if (data.containsKey('validation_report_ref')) {
      context.handle(
        _validationReportRefMeta,
        validationReportRef.isAcceptableOrUnknown(
          data['validation_report_ref']!,
          _validationReportRefMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_validationReportRefMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentMetaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      arabicSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_source'],
      )!,
      arabicEdition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_edition'],
      )!,
      arabicSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_sha256'],
      )!,
      translationEditionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_edition_id'],
      ),
      translationVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_version'],
      ),
      translationSha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_sha256'],
      ),
      acquiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acquired_at'],
      )!,
      validationReportRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}validation_report_ref'],
      )!,
    );
  }

  @override
  $ContentMetaTable createAlias(String alias) {
    return $ContentMetaTable(attachedDatabase, alias);
  }
}

class ContentMetaData extends DataClass implements Insertable<ContentMetaData> {
  final int id;
  final String arabicSource;
  final String arabicEdition;
  final String arabicSha256;
  final String? translationEditionId;
  final String? translationVersion;
  final String? translationSha256;
  final DateTime acquiredAt;
  final String validationReportRef;
  const ContentMetaData({
    required this.id,
    required this.arabicSource,
    required this.arabicEdition,
    required this.arabicSha256,
    this.translationEditionId,
    this.translationVersion,
    this.translationSha256,
    required this.acquiredAt,
    required this.validationReportRef,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['arabic_source'] = Variable<String>(arabicSource);
    map['arabic_edition'] = Variable<String>(arabicEdition);
    map['arabic_sha256'] = Variable<String>(arabicSha256);
    if (!nullToAbsent || translationEditionId != null) {
      map['translation_edition_id'] = Variable<String>(translationEditionId);
    }
    if (!nullToAbsent || translationVersion != null) {
      map['translation_version'] = Variable<String>(translationVersion);
    }
    if (!nullToAbsent || translationSha256 != null) {
      map['translation_sha256'] = Variable<String>(translationSha256);
    }
    map['acquired_at'] = Variable<DateTime>(acquiredAt);
    map['validation_report_ref'] = Variable<String>(validationReportRef);
    return map;
  }

  ContentMetaCompanion toCompanion(bool nullToAbsent) {
    return ContentMetaCompanion(
      id: Value(id),
      arabicSource: Value(arabicSource),
      arabicEdition: Value(arabicEdition),
      arabicSha256: Value(arabicSha256),
      translationEditionId: translationEditionId == null && nullToAbsent
          ? const Value.absent()
          : Value(translationEditionId),
      translationVersion: translationVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(translationVersion),
      translationSha256: translationSha256 == null && nullToAbsent
          ? const Value.absent()
          : Value(translationSha256),
      acquiredAt: Value(acquiredAt),
      validationReportRef: Value(validationReportRef),
    );
  }

  factory ContentMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentMetaData(
      id: serializer.fromJson<int>(json['id']),
      arabicSource: serializer.fromJson<String>(json['arabicSource']),
      arabicEdition: serializer.fromJson<String>(json['arabicEdition']),
      arabicSha256: serializer.fromJson<String>(json['arabicSha256']),
      translationEditionId: serializer.fromJson<String?>(
        json['translationEditionId'],
      ),
      translationVersion: serializer.fromJson<String?>(
        json['translationVersion'],
      ),
      translationSha256: serializer.fromJson<String?>(
        json['translationSha256'],
      ),
      acquiredAt: serializer.fromJson<DateTime>(json['acquiredAt']),
      validationReportRef: serializer.fromJson<String>(
        json['validationReportRef'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'arabicSource': serializer.toJson<String>(arabicSource),
      'arabicEdition': serializer.toJson<String>(arabicEdition),
      'arabicSha256': serializer.toJson<String>(arabicSha256),
      'translationEditionId': serializer.toJson<String?>(translationEditionId),
      'translationVersion': serializer.toJson<String?>(translationVersion),
      'translationSha256': serializer.toJson<String?>(translationSha256),
      'acquiredAt': serializer.toJson<DateTime>(acquiredAt),
      'validationReportRef': serializer.toJson<String>(validationReportRef),
    };
  }

  ContentMetaData copyWith({
    int? id,
    String? arabicSource,
    String? arabicEdition,
    String? arabicSha256,
    Value<String?> translationEditionId = const Value.absent(),
    Value<String?> translationVersion = const Value.absent(),
    Value<String?> translationSha256 = const Value.absent(),
    DateTime? acquiredAt,
    String? validationReportRef,
  }) => ContentMetaData(
    id: id ?? this.id,
    arabicSource: arabicSource ?? this.arabicSource,
    arabicEdition: arabicEdition ?? this.arabicEdition,
    arabicSha256: arabicSha256 ?? this.arabicSha256,
    translationEditionId: translationEditionId.present
        ? translationEditionId.value
        : this.translationEditionId,
    translationVersion: translationVersion.present
        ? translationVersion.value
        : this.translationVersion,
    translationSha256: translationSha256.present
        ? translationSha256.value
        : this.translationSha256,
    acquiredAt: acquiredAt ?? this.acquiredAt,
    validationReportRef: validationReportRef ?? this.validationReportRef,
  );
  ContentMetaData copyWithCompanion(ContentMetaCompanion data) {
    return ContentMetaData(
      id: data.id.present ? data.id.value : this.id,
      arabicSource: data.arabicSource.present
          ? data.arabicSource.value
          : this.arabicSource,
      arabicEdition: data.arabicEdition.present
          ? data.arabicEdition.value
          : this.arabicEdition,
      arabicSha256: data.arabicSha256.present
          ? data.arabicSha256.value
          : this.arabicSha256,
      translationEditionId: data.translationEditionId.present
          ? data.translationEditionId.value
          : this.translationEditionId,
      translationVersion: data.translationVersion.present
          ? data.translationVersion.value
          : this.translationVersion,
      translationSha256: data.translationSha256.present
          ? data.translationSha256.value
          : this.translationSha256,
      acquiredAt: data.acquiredAt.present
          ? data.acquiredAt.value
          : this.acquiredAt,
      validationReportRef: data.validationReportRef.present
          ? data.validationReportRef.value
          : this.validationReportRef,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetaData(')
          ..write('id: $id, ')
          ..write('arabicSource: $arabicSource, ')
          ..write('arabicEdition: $arabicEdition, ')
          ..write('arabicSha256: $arabicSha256, ')
          ..write('translationEditionId: $translationEditionId, ')
          ..write('translationVersion: $translationVersion, ')
          ..write('translationSha256: $translationSha256, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('validationReportRef: $validationReportRef')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    arabicSource,
    arabicEdition,
    arabicSha256,
    translationEditionId,
    translationVersion,
    translationSha256,
    acquiredAt,
    validationReportRef,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentMetaData &&
          other.id == this.id &&
          other.arabicSource == this.arabicSource &&
          other.arabicEdition == this.arabicEdition &&
          other.arabicSha256 == this.arabicSha256 &&
          other.translationEditionId == this.translationEditionId &&
          other.translationVersion == this.translationVersion &&
          other.translationSha256 == this.translationSha256 &&
          other.acquiredAt == this.acquiredAt &&
          other.validationReportRef == this.validationReportRef);
}

class ContentMetaCompanion extends UpdateCompanion<ContentMetaData> {
  final Value<int> id;
  final Value<String> arabicSource;
  final Value<String> arabicEdition;
  final Value<String> arabicSha256;
  final Value<String?> translationEditionId;
  final Value<String?> translationVersion;
  final Value<String?> translationSha256;
  final Value<DateTime> acquiredAt;
  final Value<String> validationReportRef;
  const ContentMetaCompanion({
    this.id = const Value.absent(),
    this.arabicSource = const Value.absent(),
    this.arabicEdition = const Value.absent(),
    this.arabicSha256 = const Value.absent(),
    this.translationEditionId = const Value.absent(),
    this.translationVersion = const Value.absent(),
    this.translationSha256 = const Value.absent(),
    this.acquiredAt = const Value.absent(),
    this.validationReportRef = const Value.absent(),
  });
  ContentMetaCompanion.insert({
    this.id = const Value.absent(),
    required String arabicSource,
    required String arabicEdition,
    required String arabicSha256,
    this.translationEditionId = const Value.absent(),
    this.translationVersion = const Value.absent(),
    this.translationSha256 = const Value.absent(),
    required DateTime acquiredAt,
    required String validationReportRef,
  }) : arabicSource = Value(arabicSource),
       arabicEdition = Value(arabicEdition),
       arabicSha256 = Value(arabicSha256),
       acquiredAt = Value(acquiredAt),
       validationReportRef = Value(validationReportRef);
  static Insertable<ContentMetaData> custom({
    Expression<int>? id,
    Expression<String>? arabicSource,
    Expression<String>? arabicEdition,
    Expression<String>? arabicSha256,
    Expression<String>? translationEditionId,
    Expression<String>? translationVersion,
    Expression<String>? translationSha256,
    Expression<DateTime>? acquiredAt,
    Expression<String>? validationReportRef,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (arabicSource != null) 'arabic_source': arabicSource,
      if (arabicEdition != null) 'arabic_edition': arabicEdition,
      if (arabicSha256 != null) 'arabic_sha256': arabicSha256,
      if (translationEditionId != null)
        'translation_edition_id': translationEditionId,
      if (translationVersion != null) 'translation_version': translationVersion,
      if (translationSha256 != null) 'translation_sha256': translationSha256,
      if (acquiredAt != null) 'acquired_at': acquiredAt,
      if (validationReportRef != null)
        'validation_report_ref': validationReportRef,
    });
  }

  ContentMetaCompanion copyWith({
    Value<int>? id,
    Value<String>? arabicSource,
    Value<String>? arabicEdition,
    Value<String>? arabicSha256,
    Value<String?>? translationEditionId,
    Value<String?>? translationVersion,
    Value<String?>? translationSha256,
    Value<DateTime>? acquiredAt,
    Value<String>? validationReportRef,
  }) {
    return ContentMetaCompanion(
      id: id ?? this.id,
      arabicSource: arabicSource ?? this.arabicSource,
      arabicEdition: arabicEdition ?? this.arabicEdition,
      arabicSha256: arabicSha256 ?? this.arabicSha256,
      translationEditionId: translationEditionId ?? this.translationEditionId,
      translationVersion: translationVersion ?? this.translationVersion,
      translationSha256: translationSha256 ?? this.translationSha256,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      validationReportRef: validationReportRef ?? this.validationReportRef,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (arabicSource.present) {
      map['arabic_source'] = Variable<String>(arabicSource.value);
    }
    if (arabicEdition.present) {
      map['arabic_edition'] = Variable<String>(arabicEdition.value);
    }
    if (arabicSha256.present) {
      map['arabic_sha256'] = Variable<String>(arabicSha256.value);
    }
    if (translationEditionId.present) {
      map['translation_edition_id'] = Variable<String>(
        translationEditionId.value,
      );
    }
    if (translationVersion.present) {
      map['translation_version'] = Variable<String>(translationVersion.value);
    }
    if (translationSha256.present) {
      map['translation_sha256'] = Variable<String>(translationSha256.value);
    }
    if (acquiredAt.present) {
      map['acquired_at'] = Variable<DateTime>(acquiredAt.value);
    }
    if (validationReportRef.present) {
      map['validation_report_ref'] = Variable<String>(
        validationReportRef.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetaCompanion(')
          ..write('id: $id, ')
          ..write('arabicSource: $arabicSource, ')
          ..write('arabicEdition: $arabicEdition, ')
          ..write('arabicSha256: $arabicSha256, ')
          ..write('translationEditionId: $translationEditionId, ')
          ..write('translationVersion: $translationVersion, ')
          ..write('translationSha256: $translationSha256, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('validationReportRef: $validationReportRef')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $ReadingPositionsTable readingPositions = $ReadingPositionsTable(
    this,
  );
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $AyahsTable ayahs = $AyahsTable(this);
  late final $AyahTranslationsTable ayahTranslations = $AyahTranslationsTable(
    this,
  );
  late final $ContentMetaTable contentMeta = $ContentMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bookmarks,
    readingPositions,
    surahs,
    ayahs,
    ayahTranslations,
    contentMeta,
  ];
}

typedef $$BookmarksTableCreateCompanionBuilder =
    BookmarksCompanion Function({
      required int surahNumber,
      required int ayahNumber,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BookmarksTableUpdateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          BookmarkRow,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (
            BookmarkRow,
            BaseReferences<_$AppDatabase, $BookmarksTable, BookmarkRow>,
          ),
          BookmarkRow,
          PrefetchHooks Function()
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion(
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int surahNumber,
                required int ayahNumber,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion.insert(
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BookmarksTable, BookmarkRow>(table),
                  BaseReferences<_$AppDatabase, $BookmarksTable, BookmarkRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      BookmarkRow,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (
        BookmarkRow,
        BaseReferences<_$AppDatabase, $BookmarksTable, BookmarkRow>,
      ),
      BookmarkRow,
      PrefetchHooks Function()
    >;
typedef $$ReadingPositionsTableCreateCompanionBuilder =
    ReadingPositionsCompanion Function({
      Value<int> id,
      required int surahNumber,
      required int ayahNumber,
      required DateTime updatedAt,
    });
typedef $$ReadingPositionsTableUpdateCompanionBuilder =
    ReadingPositionsCompanion Function({
      Value<int> id,
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<DateTime> updatedAt,
    });

class $$ReadingPositionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingPositionsTable> {
  $$ReadingPositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingPositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingPositionsTable> {
  $$ReadingPositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingPositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingPositionsTable> {
  $$ReadingPositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReadingPositionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingPositionsTable,
          ReadingPositionRow,
          $$ReadingPositionsTableFilterComposer,
          $$ReadingPositionsTableOrderingComposer,
          $$ReadingPositionsTableAnnotationComposer,
          $$ReadingPositionsTableCreateCompanionBuilder,
          $$ReadingPositionsTableUpdateCompanionBuilder,
          (
            ReadingPositionRow,
            BaseReferences<
              _$AppDatabase,
              $ReadingPositionsTable,
              ReadingPositionRow
            >,
          ),
          ReadingPositionRow,
          PrefetchHooks Function()
        > {
  $$ReadingPositionsTableTableManager(
    _$AppDatabase db,
    $ReadingPositionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingPositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingPositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingPositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ReadingPositionsCompanion(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahNumber,
                required int ayahNumber,
                required DateTime updatedAt,
              }) => ReadingPositionsCompanion.insert(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingPositionsTable, ReadingPositionRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ReadingPositionsTable,
                    ReadingPositionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingPositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingPositionsTable,
      ReadingPositionRow,
      $$ReadingPositionsTableFilterComposer,
      $$ReadingPositionsTableOrderingComposer,
      $$ReadingPositionsTableAnnotationComposer,
      $$ReadingPositionsTableCreateCompanionBuilder,
      $$ReadingPositionsTableUpdateCompanionBuilder,
      (
        ReadingPositionRow,
        BaseReferences<
          _$AppDatabase,
          $ReadingPositionsTable,
          ReadingPositionRow
        >,
      ),
      ReadingPositionRow,
      PrefetchHooks Function()
    >;
typedef $$SurahsTableCreateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> number,
      required String arabicName,
      required String latinName,
      required int verseCount,
    });
typedef $$SurahsTableUpdateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> number,
      Value<String> arabicName,
      Value<String> latinName,
      Value<int> verseCount,
    });

class $$SurahsTableFilterComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicName => $composableBuilder(
    column: $table.arabicName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get latinName => $composableBuilder(
    column: $table.latinName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SurahsTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicName => $composableBuilder(
    column: $table.arabicName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get latinName => $composableBuilder(
    column: $table.latinName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get arabicName => $composableBuilder(
    column: $table.arabicName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get latinName =>
      $composableBuilder(column: $table.latinName, builder: (column) => column);

  GeneratedColumn<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => column,
  );
}

class $$SurahsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurahsTable,
          SurahRow,
          $$SurahsTableFilterComposer,
          $$SurahsTableOrderingComposer,
          $$SurahsTableAnnotationComposer,
          $$SurahsTableCreateCompanionBuilder,
          $$SurahsTableUpdateCompanionBuilder,
          (SurahRow, BaseReferences<_$AppDatabase, $SurahsTable, SurahRow>),
          SurahRow,
          PrefetchHooks Function()
        > {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> number = const Value.absent(),
                Value<String> arabicName = const Value.absent(),
                Value<String> latinName = const Value.absent(),
                Value<int> verseCount = const Value.absent(),
              }) => SurahsCompanion(
                number: number,
                arabicName: arabicName,
                latinName: latinName,
                verseCount: verseCount,
              ),
          createCompanionCallback:
              ({
                Value<int> number = const Value.absent(),
                required String arabicName,
                required String latinName,
                required int verseCount,
              }) => SurahsCompanion.insert(
                number: number,
                arabicName: arabicName,
                latinName: latinName,
                verseCount: verseCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SurahsTable, SurahRow>(table),
                  BaseReferences<_$AppDatabase, $SurahsTable, SurahRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SurahsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurahsTable,
      SurahRow,
      $$SurahsTableFilterComposer,
      $$SurahsTableOrderingComposer,
      $$SurahsTableAnnotationComposer,
      $$SurahsTableCreateCompanionBuilder,
      $$SurahsTableUpdateCompanionBuilder,
      (SurahRow, BaseReferences<_$AppDatabase, $SurahsTable, SurahRow>),
      SurahRow,
      PrefetchHooks Function()
    >;
typedef $$AyahsTableCreateCompanionBuilder =
    AyahsCompanion Function({
      required int surahNumber,
      required int ayahNumber,
      required String arabicText,
      Value<int> rowid,
    });
typedef $$AyahsTableUpdateCompanionBuilder =
    AyahsCompanion Function({
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<String> arabicText,
      Value<int> rowid,
    });

class $$AyahsTableFilterComposer extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AyahsTableOrderingComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AyahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => column,
  );
}

class $$AyahsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AyahsTable,
          AyahRow,
          $$AyahsTableFilterComposer,
          $$AyahsTableOrderingComposer,
          $$AyahsTableAnnotationComposer,
          $$AyahsTableCreateCompanionBuilder,
          $$AyahsTableUpdateCompanionBuilder,
          (AyahRow, BaseReferences<_$AppDatabase, $AyahsTable, AyahRow>),
          AyahRow,
          PrefetchHooks Function()
        > {
  $$AyahsTableTableManager(_$AppDatabase db, $AyahsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AyahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AyahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AyahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<String> arabicText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AyahsCompanion(
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                arabicText: arabicText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int surahNumber,
                required int ayahNumber,
                required String arabicText,
                Value<int> rowid = const Value.absent(),
              }) => AyahsCompanion.insert(
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                arabicText: arabicText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AyahsTable, AyahRow>(table),
                  BaseReferences<_$AppDatabase, $AyahsTable, AyahRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AyahsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AyahsTable,
      AyahRow,
      $$AyahsTableFilterComposer,
      $$AyahsTableOrderingComposer,
      $$AyahsTableAnnotationComposer,
      $$AyahsTableCreateCompanionBuilder,
      $$AyahsTableUpdateCompanionBuilder,
      (AyahRow, BaseReferences<_$AppDatabase, $AyahsTable, AyahRow>),
      AyahRow,
      PrefetchHooks Function()
    >;
typedef $$AyahTranslationsTableCreateCompanionBuilder =
    AyahTranslationsCompanion Function({
      required int surahNumber,
      required int ayahNumber,
      required String editionId,
      required String translationText,
      Value<int> rowid,
    });
typedef $$AyahTranslationsTableUpdateCompanionBuilder =
    AyahTranslationsCompanion Function({
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<String> editionId,
      Value<String> translationText,
      Value<int> rowid,
    });

class $$AyahTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $AyahTranslationsTable> {
  $$AyahTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationText => $composableBuilder(
    column: $table.translationText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AyahTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AyahTranslationsTable> {
  $$AyahTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionId => $composableBuilder(
    column: $table.editionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationText => $composableBuilder(
    column: $table.translationText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AyahTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AyahTranslationsTable> {
  $$AyahTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editionId =>
      $composableBuilder(column: $table.editionId, builder: (column) => column);

  GeneratedColumn<String> get translationText => $composableBuilder(
    column: $table.translationText,
    builder: (column) => column,
  );
}

class $$AyahTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AyahTranslationsTable,
          AyahTranslationRow,
          $$AyahTranslationsTableFilterComposer,
          $$AyahTranslationsTableOrderingComposer,
          $$AyahTranslationsTableAnnotationComposer,
          $$AyahTranslationsTableCreateCompanionBuilder,
          $$AyahTranslationsTableUpdateCompanionBuilder,
          (
            AyahTranslationRow,
            BaseReferences<
              _$AppDatabase,
              $AyahTranslationsTable,
              AyahTranslationRow
            >,
          ),
          AyahTranslationRow,
          PrefetchHooks Function()
        > {
  $$AyahTranslationsTableTableManager(
    _$AppDatabase db,
    $AyahTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AyahTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AyahTranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AyahTranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<String> editionId = const Value.absent(),
                Value<String> translationText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AyahTranslationsCompanion(
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                editionId: editionId,
                translationText: translationText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int surahNumber,
                required int ayahNumber,
                required String editionId,
                required String translationText,
                Value<int> rowid = const Value.absent(),
              }) => AyahTranslationsCompanion.insert(
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                editionId: editionId,
                translationText: translationText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AyahTranslationsTable, AyahTranslationRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $AyahTranslationsTable,
                    AyahTranslationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AyahTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AyahTranslationsTable,
      AyahTranslationRow,
      $$AyahTranslationsTableFilterComposer,
      $$AyahTranslationsTableOrderingComposer,
      $$AyahTranslationsTableAnnotationComposer,
      $$AyahTranslationsTableCreateCompanionBuilder,
      $$AyahTranslationsTableUpdateCompanionBuilder,
      (
        AyahTranslationRow,
        BaseReferences<
          _$AppDatabase,
          $AyahTranslationsTable,
          AyahTranslationRow
        >,
      ),
      AyahTranslationRow,
      PrefetchHooks Function()
    >;
typedef $$ContentMetaTableCreateCompanionBuilder =
    ContentMetaCompanion Function({
      Value<int> id,
      required String arabicSource,
      required String arabicEdition,
      required String arabicSha256,
      Value<String?> translationEditionId,
      Value<String?> translationVersion,
      Value<String?> translationSha256,
      required DateTime acquiredAt,
      required String validationReportRef,
    });
typedef $$ContentMetaTableUpdateCompanionBuilder =
    ContentMetaCompanion Function({
      Value<int> id,
      Value<String> arabicSource,
      Value<String> arabicEdition,
      Value<String> arabicSha256,
      Value<String?> translationEditionId,
      Value<String?> translationVersion,
      Value<String?> translationSha256,
      Value<DateTime> acquiredAt,
      Value<String> validationReportRef,
    });

class $$ContentMetaTableFilterComposer
    extends Composer<_$AppDatabase, $ContentMetaTable> {
  $$ContentMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicSource => $composableBuilder(
    column: $table.arabicSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicEdition => $composableBuilder(
    column: $table.arabicEdition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicSha256 => $composableBuilder(
    column: $table.arabicSha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationEditionId => $composableBuilder(
    column: $table.translationEditionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationVersion => $composableBuilder(
    column: $table.translationVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationSha256 => $composableBuilder(
    column: $table.translationSha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validationReportRef => $composableBuilder(
    column: $table.validationReportRef,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentMetaTable> {
  $$ContentMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicSource => $composableBuilder(
    column: $table.arabicSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicEdition => $composableBuilder(
    column: $table.arabicEdition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicSha256 => $composableBuilder(
    column: $table.arabicSha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationEditionId => $composableBuilder(
    column: $table.translationEditionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationVersion => $composableBuilder(
    column: $table.translationVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationSha256 => $composableBuilder(
    column: $table.translationSha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validationReportRef => $composableBuilder(
    column: $table.validationReportRef,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentMetaTable> {
  $$ContentMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get arabicSource => $composableBuilder(
    column: $table.arabicSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arabicEdition => $composableBuilder(
    column: $table.arabicEdition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arabicSha256 => $composableBuilder(
    column: $table.arabicSha256,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationEditionId => $composableBuilder(
    column: $table.translationEditionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationVersion => $composableBuilder(
    column: $table.translationVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationSha256 => $composableBuilder(
    column: $table.translationSha256,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validationReportRef => $composableBuilder(
    column: $table.validationReportRef,
    builder: (column) => column,
  );
}

class $$ContentMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentMetaTable,
          ContentMetaData,
          $$ContentMetaTableFilterComposer,
          $$ContentMetaTableOrderingComposer,
          $$ContentMetaTableAnnotationComposer,
          $$ContentMetaTableCreateCompanionBuilder,
          $$ContentMetaTableUpdateCompanionBuilder,
          (
            ContentMetaData,
            BaseReferences<_$AppDatabase, $ContentMetaTable, ContentMetaData>,
          ),
          ContentMetaData,
          PrefetchHooks Function()
        > {
  $$ContentMetaTableTableManager(_$AppDatabase db, $ContentMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> arabicSource = const Value.absent(),
                Value<String> arabicEdition = const Value.absent(),
                Value<String> arabicSha256 = const Value.absent(),
                Value<String?> translationEditionId = const Value.absent(),
                Value<String?> translationVersion = const Value.absent(),
                Value<String?> translationSha256 = const Value.absent(),
                Value<DateTime> acquiredAt = const Value.absent(),
                Value<String> validationReportRef = const Value.absent(),
              }) => ContentMetaCompanion(
                id: id,
                arabicSource: arabicSource,
                arabicEdition: arabicEdition,
                arabicSha256: arabicSha256,
                translationEditionId: translationEditionId,
                translationVersion: translationVersion,
                translationSha256: translationSha256,
                acquiredAt: acquiredAt,
                validationReportRef: validationReportRef,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String arabicSource,
                required String arabicEdition,
                required String arabicSha256,
                Value<String?> translationEditionId = const Value.absent(),
                Value<String?> translationVersion = const Value.absent(),
                Value<String?> translationSha256 = const Value.absent(),
                required DateTime acquiredAt,
                required String validationReportRef,
              }) => ContentMetaCompanion.insert(
                id: id,
                arabicSource: arabicSource,
                arabicEdition: arabicEdition,
                arabicSha256: arabicSha256,
                translationEditionId: translationEditionId,
                translationVersion: translationVersion,
                translationSha256: translationSha256,
                acquiredAt: acquiredAt,
                validationReportRef: validationReportRef,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentMetaTable, ContentMetaData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ContentMetaTable,
                    ContentMetaData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentMetaTable,
      ContentMetaData,
      $$ContentMetaTableFilterComposer,
      $$ContentMetaTableOrderingComposer,
      $$ContentMetaTableAnnotationComposer,
      $$ContentMetaTableCreateCompanionBuilder,
      $$ContentMetaTableUpdateCompanionBuilder,
      (
        ContentMetaData,
        BaseReferences<_$AppDatabase, $ContentMetaTable, ContentMetaData>,
      ),
      ContentMetaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$ReadingPositionsTableTableManager get readingPositions =>
      $$ReadingPositionsTableTableManager(_db, _db.readingPositions);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$AyahsTableTableManager get ayahs =>
      $$AyahsTableTableManager(_db, _db.ayahs);
  $$AyahTranslationsTableTableManager get ayahTranslations =>
      $$AyahTranslationsTableTableManager(_db, _db.ayahTranslations);
  $$ContentMetaTableTableManager get contentMeta =>
      $$ContentMetaTableTableManager(_db, _db.contentMeta);
}
