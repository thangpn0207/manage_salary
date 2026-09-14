// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_database.dart';

// ignore_for_file: type=lint
class $SalaryProfilesTable extends SalaryProfiles
    with TableInfo<$SalaryProfilesTable, SalaryProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalaryProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _salaryTypeMeta =
      const VerificationMeta('salaryType');
  @override
  late final GeneratedColumn<String> salaryType = GeneratedColumn<String>(
      'salary_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _baseAmountMeta =
      const VerificationMeta('baseAmount');
  @override
  late final GeneratedColumn<double> baseAmount = GeneratedColumn<double>(
      'base_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(15000000.0));
  static const VerificationMeta _standardWorkingDaysMeta =
      const VerificationMeta('standardWorkingDays');
  @override
  late final GeneratedColumn<double> standardWorkingDays =
      GeneratedColumn<double>('standard_working_days', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(26.0));
  static const VerificationMeta _standardHoursPerDayMeta =
      const VerificationMeta('standardHoursPerDay');
  @override
  late final GeneratedColumn<double> standardHoursPerDay =
      GeneratedColumn<double>('standard_hours_per_day', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(8.0));
  static const VerificationMeta _enableInsuranceMeta =
      const VerificationMeta('enableInsurance');
  @override
  late final GeneratedColumn<bool> enableInsurance = GeneratedColumn<bool>(
      'enable_insurance', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_insurance" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _insuranceRateMeta =
      const VerificationMeta('insuranceRate');
  @override
  late final GeneratedColumn<double> insuranceRate = GeneratedColumn<double>(
      'insurance_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(10.5));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        salaryType,
        baseAmount,
        standardWorkingDays,
        standardHoursPerDay,
        enableInsurance,
        insuranceRate,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salary_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<SalaryProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('salary_type')) {
      context.handle(
          _salaryTypeMeta,
          salaryType.isAcceptableOrUnknown(
              data['salary_type']!, _salaryTypeMeta));
    }
    if (data.containsKey('base_amount')) {
      context.handle(
          _baseAmountMeta,
          baseAmount.isAcceptableOrUnknown(
              data['base_amount']!, _baseAmountMeta));
    }
    if (data.containsKey('standard_working_days')) {
      context.handle(
          _standardWorkingDaysMeta,
          standardWorkingDays.isAcceptableOrUnknown(
              data['standard_working_days']!, _standardWorkingDaysMeta));
    }
    if (data.containsKey('standard_hours_per_day')) {
      context.handle(
          _standardHoursPerDayMeta,
          standardHoursPerDay.isAcceptableOrUnknown(
              data['standard_hours_per_day']!, _standardHoursPerDayMeta));
    }
    if (data.containsKey('enable_insurance')) {
      context.handle(
          _enableInsuranceMeta,
          enableInsurance.isAcceptableOrUnknown(
              data['enable_insurance']!, _enableInsuranceMeta));
    }
    if (data.containsKey('insurance_rate')) {
      context.handle(
          _insuranceRateMeta,
          insuranceRate.isAcceptableOrUnknown(
              data['insurance_rate']!, _insuranceRateMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalaryProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalaryProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      salaryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salary_type'])!,
      baseAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_amount'])!,
      standardWorkingDays: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}standard_working_days'])!,
      standardHoursPerDay: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}standard_hours_per_day'])!,
      enableInsurance: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enable_insurance'])!,
      insuranceRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}insurance_rate'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SalaryProfilesTable createAlias(String alias) {
    return $SalaryProfilesTable(attachedDatabase, alias);
  }
}

class SalaryProfile extends DataClass implements Insertable<SalaryProfile> {
  final int id;
  final String salaryType;
  final double baseAmount;
  final double standardWorkingDays;
  final double standardHoursPerDay;
  final bool enableInsurance;
  final double insuranceRate;
  final DateTime updatedAt;
  const SalaryProfile(
      {required this.id,
      required this.salaryType,
      required this.baseAmount,
      required this.standardWorkingDays,
      required this.standardHoursPerDay,
      required this.enableInsurance,
      required this.insuranceRate,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['salary_type'] = Variable<String>(salaryType);
    map['base_amount'] = Variable<double>(baseAmount);
    map['standard_working_days'] = Variable<double>(standardWorkingDays);
    map['standard_hours_per_day'] = Variable<double>(standardHoursPerDay);
    map['enable_insurance'] = Variable<bool>(enableInsurance);
    map['insurance_rate'] = Variable<double>(insuranceRate);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SalaryProfilesCompanion toCompanion(bool nullToAbsent) {
    return SalaryProfilesCompanion(
      id: Value(id),
      salaryType: Value(salaryType),
      baseAmount: Value(baseAmount),
      standardWorkingDays: Value(standardWorkingDays),
      standardHoursPerDay: Value(standardHoursPerDay),
      enableInsurance: Value(enableInsurance),
      insuranceRate: Value(insuranceRate),
      updatedAt: Value(updatedAt),
    );
  }

  factory SalaryProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalaryProfile(
      id: serializer.fromJson<int>(json['id']),
      salaryType: serializer.fromJson<String>(json['salaryType']),
      baseAmount: serializer.fromJson<double>(json['baseAmount']),
      standardWorkingDays:
          serializer.fromJson<double>(json['standardWorkingDays']),
      standardHoursPerDay:
          serializer.fromJson<double>(json['standardHoursPerDay']),
      enableInsurance: serializer.fromJson<bool>(json['enableInsurance']),
      insuranceRate: serializer.fromJson<double>(json['insuranceRate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'salaryType': serializer.toJson<String>(salaryType),
      'baseAmount': serializer.toJson<double>(baseAmount),
      'standardWorkingDays': serializer.toJson<double>(standardWorkingDays),
      'standardHoursPerDay': serializer.toJson<double>(standardHoursPerDay),
      'enableInsurance': serializer.toJson<bool>(enableInsurance),
      'insuranceRate': serializer.toJson<double>(insuranceRate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SalaryProfile copyWith(
          {int? id,
          String? salaryType,
          double? baseAmount,
          double? standardWorkingDays,
          double? standardHoursPerDay,
          bool? enableInsurance,
          double? insuranceRate,
          DateTime? updatedAt}) =>
      SalaryProfile(
        id: id ?? this.id,
        salaryType: salaryType ?? this.salaryType,
        baseAmount: baseAmount ?? this.baseAmount,
        standardWorkingDays: standardWorkingDays ?? this.standardWorkingDays,
        standardHoursPerDay: standardHoursPerDay ?? this.standardHoursPerDay,
        enableInsurance: enableInsurance ?? this.enableInsurance,
        insuranceRate: insuranceRate ?? this.insuranceRate,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SalaryProfile copyWithCompanion(SalaryProfilesCompanion data) {
    return SalaryProfile(
      id: data.id.present ? data.id.value : this.id,
      salaryType:
          data.salaryType.present ? data.salaryType.value : this.salaryType,
      baseAmount:
          data.baseAmount.present ? data.baseAmount.value : this.baseAmount,
      standardWorkingDays: data.standardWorkingDays.present
          ? data.standardWorkingDays.value
          : this.standardWorkingDays,
      standardHoursPerDay: data.standardHoursPerDay.present
          ? data.standardHoursPerDay.value
          : this.standardHoursPerDay,
      enableInsurance: data.enableInsurance.present
          ? data.enableInsurance.value
          : this.enableInsurance,
      insuranceRate: data.insuranceRate.present
          ? data.insuranceRate.value
          : this.insuranceRate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalaryProfile(')
          ..write('id: $id, ')
          ..write('salaryType: $salaryType, ')
          ..write('baseAmount: $baseAmount, ')
          ..write('standardWorkingDays: $standardWorkingDays, ')
          ..write('standardHoursPerDay: $standardHoursPerDay, ')
          ..write('enableInsurance: $enableInsurance, ')
          ..write('insuranceRate: $insuranceRate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      salaryType,
      baseAmount,
      standardWorkingDays,
      standardHoursPerDay,
      enableInsurance,
      insuranceRate,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalaryProfile &&
          other.id == this.id &&
          other.salaryType == this.salaryType &&
          other.baseAmount == this.baseAmount &&
          other.standardWorkingDays == this.standardWorkingDays &&
          other.standardHoursPerDay == this.standardHoursPerDay &&
          other.enableInsurance == this.enableInsurance &&
          other.insuranceRate == this.insuranceRate &&
          other.updatedAt == this.updatedAt);
}

class SalaryProfilesCompanion extends UpdateCompanion<SalaryProfile> {
  final Value<int> id;
  final Value<String> salaryType;
  final Value<double> baseAmount;
  final Value<double> standardWorkingDays;
  final Value<double> standardHoursPerDay;
  final Value<bool> enableInsurance;
  final Value<double> insuranceRate;
  final Value<DateTime> updatedAt;
  const SalaryProfilesCompanion({
    this.id = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.baseAmount = const Value.absent(),
    this.standardWorkingDays = const Value.absent(),
    this.standardHoursPerDay = const Value.absent(),
    this.enableInsurance = const Value.absent(),
    this.insuranceRate = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SalaryProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.baseAmount = const Value.absent(),
    this.standardWorkingDays = const Value.absent(),
    this.standardHoursPerDay = const Value.absent(),
    this.enableInsurance = const Value.absent(),
    this.insuranceRate = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<SalaryProfile> custom({
    Expression<int>? id,
    Expression<String>? salaryType,
    Expression<double>? baseAmount,
    Expression<double>? standardWorkingDays,
    Expression<double>? standardHoursPerDay,
    Expression<bool>? enableInsurance,
    Expression<double>? insuranceRate,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (salaryType != null) 'salary_type': salaryType,
      if (baseAmount != null) 'base_amount': baseAmount,
      if (standardWorkingDays != null)
        'standard_working_days': standardWorkingDays,
      if (standardHoursPerDay != null)
        'standard_hours_per_day': standardHoursPerDay,
      if (enableInsurance != null) 'enable_insurance': enableInsurance,
      if (insuranceRate != null) 'insurance_rate': insuranceRate,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SalaryProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? salaryType,
      Value<double>? baseAmount,
      Value<double>? standardWorkingDays,
      Value<double>? standardHoursPerDay,
      Value<bool>? enableInsurance,
      Value<double>? insuranceRate,
      Value<DateTime>? updatedAt}) {
    return SalaryProfilesCompanion(
      id: id ?? this.id,
      salaryType: salaryType ?? this.salaryType,
      baseAmount: baseAmount ?? this.baseAmount,
      standardWorkingDays: standardWorkingDays ?? this.standardWorkingDays,
      standardHoursPerDay: standardHoursPerDay ?? this.standardHoursPerDay,
      enableInsurance: enableInsurance ?? this.enableInsurance,
      insuranceRate: insuranceRate ?? this.insuranceRate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (salaryType.present) {
      map['salary_type'] = Variable<String>(salaryType.value);
    }
    if (baseAmount.present) {
      map['base_amount'] = Variable<double>(baseAmount.value);
    }
    if (standardWorkingDays.present) {
      map['standard_working_days'] =
          Variable<double>(standardWorkingDays.value);
    }
    if (standardHoursPerDay.present) {
      map['standard_hours_per_day'] =
          Variable<double>(standardHoursPerDay.value);
    }
    if (enableInsurance.present) {
      map['enable_insurance'] = Variable<bool>(enableInsurance.value);
    }
    if (insuranceRate.present) {
      map['insurance_rate'] = Variable<double>(insuranceRate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalaryProfilesCompanion(')
          ..write('id: $id, ')
          ..write('salaryType: $salaryType, ')
          ..write('baseAmount: $baseAmount, ')
          ..write('standardWorkingDays: $standardWorkingDays, ')
          ..write('standardHoursPerDay: $standardHoursPerDay, ')
          ..write('enableInsurance: $enableInsurance, ')
          ..write('insuranceRate: $insuranceRate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AttendancesTable extends Attendances
    with TableInfo<$AttendancesTable, Attendance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('full'));
  static const VerificationMeta _otHoursMeta =
      const VerificationMeta('otHours');
  @override
  late final GeneratedColumn<double> otHours = GeneratedColumn<double>(
      'ot_hours', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _otMultiplierMeta =
      const VerificationMeta('otMultiplier');
  @override
  late final GeneratedColumn<double> otMultiplier = GeneratedColumn<double>(
      'ot_multiplier', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.5));
  static const VerificationMeta _advanceAmountMeta =
      const VerificationMeta('advanceAmount');
  @override
  late final GeneratedColumn<double> advanceAmount = GeneratedColumn<double>(
      'advance_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bonusAmountMeta =
      const VerificationMeta('bonusAmount');
  @override
  late final GeneratedColumn<double> bonusAmount = GeneratedColumn<double>(
      'bonus_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        status,
        otHours,
        otMultiplier,
        advanceAmount,
        bonusAmount,
        note,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendances';
  @override
  VerificationContext validateIntegrity(Insertable<Attendance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('ot_hours')) {
      context.handle(_otHoursMeta,
          otHours.isAcceptableOrUnknown(data['ot_hours']!, _otHoursMeta));
    }
    if (data.containsKey('ot_multiplier')) {
      context.handle(
          _otMultiplierMeta,
          otMultiplier.isAcceptableOrUnknown(
              data['ot_multiplier']!, _otMultiplierMeta));
    }
    if (data.containsKey('advance_amount')) {
      context.handle(
          _advanceAmountMeta,
          advanceAmount.isAcceptableOrUnknown(
              data['advance_amount']!, _advanceAmountMeta));
    }
    if (data.containsKey('bonus_amount')) {
      context.handle(
          _bonusAmountMeta,
          bonusAmount.isAcceptableOrUnknown(
              data['bonus_amount']!, _bonusAmountMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attendance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attendance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      otHours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ot_hours'])!,
      otMultiplier: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ot_multiplier'])!,
      advanceAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}advance_amount'])!,
      bonusAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bonus_amount'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AttendancesTable createAlias(String alias) {
    return $AttendancesTable(attachedDatabase, alias);
  }
}

class Attendance extends DataClass implements Insertable<Attendance> {
  final int id;
  final DateTime date;
  final String status;
  final double otHours;
  final double otMultiplier;
  final double advanceAmount;
  final double bonusAmount;
  final String? note;
  final DateTime createdAt;
  const Attendance(
      {required this.id,
      required this.date,
      required this.status,
      required this.otHours,
      required this.otMultiplier,
      required this.advanceAmount,
      required this.bonusAmount,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['status'] = Variable<String>(status);
    map['ot_hours'] = Variable<double>(otHours);
    map['ot_multiplier'] = Variable<double>(otMultiplier);
    map['advance_amount'] = Variable<double>(advanceAmount);
    map['bonus_amount'] = Variable<double>(bonusAmount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttendancesCompanion toCompanion(bool nullToAbsent) {
    return AttendancesCompanion(
      id: Value(id),
      date: Value(date),
      status: Value(status),
      otHours: Value(otHours),
      otMultiplier: Value(otMultiplier),
      advanceAmount: Value(advanceAmount),
      bonusAmount: Value(bonusAmount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Attendance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attendance(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      otHours: serializer.fromJson<double>(json['otHours']),
      otMultiplier: serializer.fromJson<double>(json['otMultiplier']),
      advanceAmount: serializer.fromJson<double>(json['advanceAmount']),
      bonusAmount: serializer.fromJson<double>(json['bonusAmount']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(status),
      'otHours': serializer.toJson<double>(otHours),
      'otMultiplier': serializer.toJson<double>(otMultiplier),
      'advanceAmount': serializer.toJson<double>(advanceAmount),
      'bonusAmount': serializer.toJson<double>(bonusAmount),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Attendance copyWith(
          {int? id,
          DateTime? date,
          String? status,
          double? otHours,
          double? otMultiplier,
          double? advanceAmount,
          double? bonusAmount,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      Attendance(
        id: id ?? this.id,
        date: date ?? this.date,
        status: status ?? this.status,
        otHours: otHours ?? this.otHours,
        otMultiplier: otMultiplier ?? this.otMultiplier,
        advanceAmount: advanceAmount ?? this.advanceAmount,
        bonusAmount: bonusAmount ?? this.bonusAmount,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  Attendance copyWithCompanion(AttendancesCompanion data) {
    return Attendance(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      otHours: data.otHours.present ? data.otHours.value : this.otHours,
      otMultiplier: data.otMultiplier.present
          ? data.otMultiplier.value
          : this.otMultiplier,
      advanceAmount: data.advanceAmount.present
          ? data.advanceAmount.value
          : this.advanceAmount,
      bonusAmount:
          data.bonusAmount.present ? data.bonusAmount.value : this.bonusAmount,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attendance(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('otHours: $otHours, ')
          ..write('otMultiplier: $otMultiplier, ')
          ..write('advanceAmount: $advanceAmount, ')
          ..write('bonusAmount: $bonusAmount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, status, otHours, otMultiplier,
      advanceAmount, bonusAmount, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attendance &&
          other.id == this.id &&
          other.date == this.date &&
          other.status == this.status &&
          other.otHours == this.otHours &&
          other.otMultiplier == this.otMultiplier &&
          other.advanceAmount == this.advanceAmount &&
          other.bonusAmount == this.bonusAmount &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class AttendancesCompanion extends UpdateCompanion<Attendance> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> status;
  final Value<double> otHours;
  final Value<double> otMultiplier;
  final Value<double> advanceAmount;
  final Value<double> bonusAmount;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const AttendancesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.otHours = const Value.absent(),
    this.otMultiplier = const Value.absent(),
    this.advanceAmount = const Value.absent(),
    this.bonusAmount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AttendancesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.status = const Value.absent(),
    this.otHours = const Value.absent(),
    this.otMultiplier = const Value.absent(),
    this.advanceAmount = const Value.absent(),
    this.bonusAmount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<Attendance> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<double>? otHours,
    Expression<double>? otMultiplier,
    Expression<double>? advanceAmount,
    Expression<double>? bonusAmount,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (otHours != null) 'ot_hours': otHours,
      if (otMultiplier != null) 'ot_multiplier': otMultiplier,
      if (advanceAmount != null) 'advance_amount': advanceAmount,
      if (bonusAmount != null) 'bonus_amount': bonusAmount,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AttendancesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? status,
      Value<double>? otHours,
      Value<double>? otMultiplier,
      Value<double>? advanceAmount,
      Value<double>? bonusAmount,
      Value<String?>? note,
      Value<DateTime>? createdAt}) {
    return AttendancesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
      otHours: otHours ?? this.otHours,
      otMultiplier: otMultiplier ?? this.otMultiplier,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      bonusAmount: bonusAmount ?? this.bonusAmount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (otHours.present) {
      map['ot_hours'] = Variable<double>(otHours.value);
    }
    if (otMultiplier.present) {
      map['ot_multiplier'] = Variable<double>(otMultiplier.value);
    }
    if (advanceAmount.present) {
      map['advance_amount'] = Variable<double>(advanceAmount.value);
    }
    if (bonusAmount.present) {
      map['bonus_amount'] = Variable<double>(bonusAmount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('otHours: $otHours, ')
          ..write('otMultiplier: $otMultiplier, ')
          ..write('advanceAmount: $advanceAmount, ')
          ..write('bonusAmount: $bonusAmount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$SalaryDatabase extends GeneratedDatabase {
  _$SalaryDatabase(QueryExecutor e) : super(e);
  $SalaryDatabaseManager get managers => $SalaryDatabaseManager(this);
  late final $SalaryProfilesTable salaryProfiles = $SalaryProfilesTable(this);
  late final $AttendancesTable attendances = $AttendancesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [salaryProfiles, attendances];
}

typedef $$SalaryProfilesTableCreateCompanionBuilder = SalaryProfilesCompanion
    Function({
  Value<int> id,
  Value<String> salaryType,
  Value<double> baseAmount,
  Value<double> standardWorkingDays,
  Value<double> standardHoursPerDay,
  Value<bool> enableInsurance,
  Value<double> insuranceRate,
  Value<DateTime> updatedAt,
});
typedef $$SalaryProfilesTableUpdateCompanionBuilder = SalaryProfilesCompanion
    Function({
  Value<int> id,
  Value<String> salaryType,
  Value<double> baseAmount,
  Value<double> standardWorkingDays,
  Value<double> standardHoursPerDay,
  Value<bool> enableInsurance,
  Value<double> insuranceRate,
  Value<DateTime> updatedAt,
});

class $$SalaryProfilesTableFilterComposer
    extends Composer<_$SalaryDatabase, $SalaryProfilesTable> {
  $$SalaryProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baseAmount => $composableBuilder(
      column: $table.baseAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get standardWorkingDays => $composableBuilder(
      column: $table.standardWorkingDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get standardHoursPerDay => $composableBuilder(
      column: $table.standardHoursPerDay,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enableInsurance => $composableBuilder(
      column: $table.enableInsurance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get insuranceRate => $composableBuilder(
      column: $table.insuranceRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SalaryProfilesTableOrderingComposer
    extends Composer<_$SalaryDatabase, $SalaryProfilesTable> {
  $$SalaryProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baseAmount => $composableBuilder(
      column: $table.baseAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get standardWorkingDays => $composableBuilder(
      column: $table.standardWorkingDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get standardHoursPerDay => $composableBuilder(
      column: $table.standardHoursPerDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enableInsurance => $composableBuilder(
      column: $table.enableInsurance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get insuranceRate => $composableBuilder(
      column: $table.insuranceRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SalaryProfilesTableAnnotationComposer
    extends Composer<_$SalaryDatabase, $SalaryProfilesTable> {
  $$SalaryProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => column);

  GeneratedColumn<double> get baseAmount => $composableBuilder(
      column: $table.baseAmount, builder: (column) => column);

  GeneratedColumn<double> get standardWorkingDays => $composableBuilder(
      column: $table.standardWorkingDays, builder: (column) => column);

  GeneratedColumn<double> get standardHoursPerDay => $composableBuilder(
      column: $table.standardHoursPerDay, builder: (column) => column);

  GeneratedColumn<bool> get enableInsurance => $composableBuilder(
      column: $table.enableInsurance, builder: (column) => column);

  GeneratedColumn<double> get insuranceRate => $composableBuilder(
      column: $table.insuranceRate, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SalaryProfilesTableTableManager extends RootTableManager<
    _$SalaryDatabase,
    $SalaryProfilesTable,
    SalaryProfile,
    $$SalaryProfilesTableFilterComposer,
    $$SalaryProfilesTableOrderingComposer,
    $$SalaryProfilesTableAnnotationComposer,
    $$SalaryProfilesTableCreateCompanionBuilder,
    $$SalaryProfilesTableUpdateCompanionBuilder,
    (
      SalaryProfile,
      BaseReferences<_$SalaryDatabase, $SalaryProfilesTable, SalaryProfile>
    ),
    SalaryProfile,
    PrefetchHooks Function()> {
  $$SalaryProfilesTableTableManager(
      _$SalaryDatabase db, $SalaryProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalaryProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalaryProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalaryProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> salaryType = const Value.absent(),
            Value<double> baseAmount = const Value.absent(),
            Value<double> standardWorkingDays = const Value.absent(),
            Value<double> standardHoursPerDay = const Value.absent(),
            Value<bool> enableInsurance = const Value.absent(),
            Value<double> insuranceRate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SalaryProfilesCompanion(
            id: id,
            salaryType: salaryType,
            baseAmount: baseAmount,
            standardWorkingDays: standardWorkingDays,
            standardHoursPerDay: standardHoursPerDay,
            enableInsurance: enableInsurance,
            insuranceRate: insuranceRate,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> salaryType = const Value.absent(),
            Value<double> baseAmount = const Value.absent(),
            Value<double> standardWorkingDays = const Value.absent(),
            Value<double> standardHoursPerDay = const Value.absent(),
            Value<bool> enableInsurance = const Value.absent(),
            Value<double> insuranceRate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SalaryProfilesCompanion.insert(
            id: id,
            salaryType: salaryType,
            baseAmount: baseAmount,
            standardWorkingDays: standardWorkingDays,
            standardHoursPerDay: standardHoursPerDay,
            enableInsurance: enableInsurance,
            insuranceRate: insuranceRate,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SalaryProfilesTable, SalaryProfile>(table),
                    BaseReferences<_$SalaryDatabase, $SalaryProfilesTable,
                        SalaryProfile>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SalaryProfilesTableProcessedTableManager = ProcessedTableManager<
    _$SalaryDatabase,
    $SalaryProfilesTable,
    SalaryProfile,
    $$SalaryProfilesTableFilterComposer,
    $$SalaryProfilesTableOrderingComposer,
    $$SalaryProfilesTableAnnotationComposer,
    $$SalaryProfilesTableCreateCompanionBuilder,
    $$SalaryProfilesTableUpdateCompanionBuilder,
    (
      SalaryProfile,
      BaseReferences<_$SalaryDatabase, $SalaryProfilesTable, SalaryProfile>
    ),
    SalaryProfile,
    PrefetchHooks Function()>;
typedef $$AttendancesTableCreateCompanionBuilder = AttendancesCompanion
    Function({
  Value<int> id,
  required DateTime date,
  Value<String> status,
  Value<double> otHours,
  Value<double> otMultiplier,
  Value<double> advanceAmount,
  Value<double> bonusAmount,
  Value<String?> note,
  Value<DateTime> createdAt,
});
typedef $$AttendancesTableUpdateCompanionBuilder = AttendancesCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> status,
  Value<double> otHours,
  Value<double> otMultiplier,
  Value<double> advanceAmount,
  Value<double> bonusAmount,
  Value<String?> note,
  Value<DateTime> createdAt,
});

class $$AttendancesTableFilterComposer
    extends Composer<_$SalaryDatabase, $AttendancesTable> {
  $$AttendancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get otHours => $composableBuilder(
      column: $table.otHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get otMultiplier => $composableBuilder(
      column: $table.otMultiplier, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get advanceAmount => $composableBuilder(
      column: $table.advanceAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bonusAmount => $composableBuilder(
      column: $table.bonusAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AttendancesTableOrderingComposer
    extends Composer<_$SalaryDatabase, $AttendancesTable> {
  $$AttendancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get otHours => $composableBuilder(
      column: $table.otHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get otMultiplier => $composableBuilder(
      column: $table.otMultiplier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get advanceAmount => $composableBuilder(
      column: $table.advanceAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bonusAmount => $composableBuilder(
      column: $table.bonusAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AttendancesTableAnnotationComposer
    extends Composer<_$SalaryDatabase, $AttendancesTable> {
  $$AttendancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get otHours =>
      $composableBuilder(column: $table.otHours, builder: (column) => column);

  GeneratedColumn<double> get otMultiplier => $composableBuilder(
      column: $table.otMultiplier, builder: (column) => column);

  GeneratedColumn<double> get advanceAmount => $composableBuilder(
      column: $table.advanceAmount, builder: (column) => column);

  GeneratedColumn<double> get bonusAmount => $composableBuilder(
      column: $table.bonusAmount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AttendancesTableTableManager extends RootTableManager<
    _$SalaryDatabase,
    $AttendancesTable,
    Attendance,
    $$AttendancesTableFilterComposer,
    $$AttendancesTableOrderingComposer,
    $$AttendancesTableAnnotationComposer,
    $$AttendancesTableCreateCompanionBuilder,
    $$AttendancesTableUpdateCompanionBuilder,
    (
      Attendance,
      BaseReferences<_$SalaryDatabase, $AttendancesTable, Attendance>
    ),
    Attendance,
    PrefetchHooks Function()> {
  $$AttendancesTableTableManager(_$SalaryDatabase db, $AttendancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> otHours = const Value.absent(),
            Value<double> otMultiplier = const Value.absent(),
            Value<double> advanceAmount = const Value.absent(),
            Value<double> bonusAmount = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AttendancesCompanion(
            id: id,
            date: date,
            status: status,
            otHours: otHours,
            otMultiplier: otMultiplier,
            advanceAmount: advanceAmount,
            bonusAmount: bonusAmount,
            note: note,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            Value<String> status = const Value.absent(),
            Value<double> otHours = const Value.absent(),
            Value<double> otMultiplier = const Value.absent(),
            Value<double> advanceAmount = const Value.absent(),
            Value<double> bonusAmount = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AttendancesCompanion.insert(
            id: id,
            date: date,
            status: status,
            otHours: otHours,
            otMultiplier: otMultiplier,
            advanceAmount: advanceAmount,
            bonusAmount: bonusAmount,
            note: note,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AttendancesTable, Attendance>(table),
                    BaseReferences<_$SalaryDatabase, $AttendancesTable,
                        Attendance>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttendancesTableProcessedTableManager = ProcessedTableManager<
    _$SalaryDatabase,
    $AttendancesTable,
    Attendance,
    $$AttendancesTableFilterComposer,
    $$AttendancesTableOrderingComposer,
    $$AttendancesTableAnnotationComposer,
    $$AttendancesTableCreateCompanionBuilder,
    $$AttendancesTableUpdateCompanionBuilder,
    (
      Attendance,
      BaseReferences<_$SalaryDatabase, $AttendancesTable, Attendance>
    ),
    Attendance,
    PrefetchHooks Function()>;

class $SalaryDatabaseManager {
  final _$SalaryDatabase _db;
  $SalaryDatabaseManager(this._db);
  $$SalaryProfilesTableTableManager get salaryProfiles =>
      $$SalaryProfilesTableTableManager(_db, _db.salaryProfiles);
  $$AttendancesTableTableManager get attendances =>
      $$AttendancesTableTableManager(_db, _db.attendances);
}
