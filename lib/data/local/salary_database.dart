import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'salary_database.g.dart';

class SalaryProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get salaryType => text().withDefault(const Constant('monthly'))(); // 'monthly', 'hourly', 'daily'
  RealColumn get baseAmount => real().withDefault(const Constant(15000000.0))();
  RealColumn get standardWorkingDays => real().withDefault(const Constant(26.0))();
  RealColumn get standardHoursPerDay => real().withDefault(const Constant(8.0))();
  BoolColumn get enableInsurance => boolean().withDefault(const Constant(false))();
  RealColumn get insuranceRate => real().withDefault(const Constant(10.5))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Attendances extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => text().withDefault(const Constant('full'))(); // 'full', 'half', 'leave_paid', 'leave_unpaid'
  RealColumn get otHours => real().withDefault(const Constant(0.0))();
  RealColumn get otMultiplier => real().withDefault(const Constant(1.5))();
  RealColumn get advanceAmount => real().withDefault(const Constant(0.0))();
  RealColumn get bonusAmount => real().withDefault(const Constant(0.0))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [SalaryProfiles, Attendances])
class SalaryDatabase extends _$SalaryDatabase {
  SalaryDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'salary_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
