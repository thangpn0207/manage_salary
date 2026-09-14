import 'package:drift/drift.dart';
import '../local/salary_database.dart';

class SalaryRepository {
  final SalaryDatabase _db;

  SalaryRepository(this._db);

  /// Lấy cấu hình lương hiện tại, nếu chưa có thì khởi tạo mặc định
  Future<SalaryProfile> getSalaryProfile() async {
    final list = await _db.select(_db.salaryProfiles).get();
    if (list.isNotEmpty) {
      return list.first;
    }
    // Tạo cấu hình mặc định ban đầu: Lương tháng 15.000.000đ, 26 công chuẩn
    final id = await _db.into(_db.salaryProfiles).insert(
          SalaryProfilesCompanion.insert(
            salaryType: const Value('monthly'),
            baseAmount: const Value(15000000.0),
            standardWorkingDays: const Value(26.0),
            standardHoursPerDay: const Value(8.0),
            enableInsurance: const Value(false),
            insuranceRate: const Value(10.5),
          ),
        );
    return (await (_db.select(_db.salaryProfiles)..where((tbl) => tbl.id.equals(id))).getSingle());
  }

  /// Cập nhật cấu hình lương
  Future<void> updateSalaryProfile({
    required int id,
    required String salaryType,
    required double baseAmount,
    required double standardWorkingDays,
    required double standardHoursPerDay,
    required bool enableInsurance,
    required double insuranceRate,
  }) async {
    await (_db.update(_db.salaryProfiles)..where((tbl) => tbl.id.equals(id))).write(
      SalaryProfilesCompanion(
        salaryType: Value(salaryType),
        baseAmount: Value(baseAmount),
        standardWorkingDays: Value(standardWorkingDays),
        standardHoursPerDay: Value(standardHoursPerDay),
        enableInsurance: Value(enableInsurance),
        insuranceRate: Value(insuranceRate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Lấy danh sách chấm công trong một tháng cụ thể
  Future<List<Attendance>> getAttendancesForMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1).subtract(const Duration(milliseconds: 1));

    return (_db.select(_db.attendances)
          ..where((tbl) => tbl.date.isBiggerOrEqualValue(start) & tbl.date.isSmallerOrEqualValue(end))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.date)]))
        .get();
  }

  /// Lưu hoặc cập nhật chấm công của 1 ngày (chuẩn hóa yyyy-MM-dd)
  Future<void> setAttendance({
    required DateTime date,
    required String status,
    double otHours = 0.0,
    double otMultiplier = 1.5,
    double advanceAmount = 0.0,
    double bonusAmount = 0.0,
    String? note,
  }) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final existing = await (_db.select(_db.attendances)
          ..where((tbl) => tbl.date.equals(normalizedDate)))
        .get();

    if (existing.isNotEmpty) {
      await (_db.update(_db.attendances)..where((tbl) => tbl.id.equals(existing.first.id))).write(
        AttendancesCompanion(
          status: Value(status),
          otHours: Value(otHours),
          otMultiplier: Value(otMultiplier),
          advanceAmount: Value(advanceAmount),
          bonusAmount: Value(bonusAmount),
          note: Value(note),
        ),
      );
    } else {
      await _db.into(_db.attendances).insert(
            AttendancesCompanion.insert(
              date: normalizedDate,
              status: Value(status),
              otHours: Value(otHours),
              otMultiplier: Value(otMultiplier),
              advanceAmount: Value(advanceAmount),
              bonusAmount: Value(bonusAmount),
              note: Value(note),
            ),
          );
    }
  }

  /// Xóa bản ghi chấm công của 1 ngày
  Future<void> removeAttendance(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    await (_db.delete(_db.attendances)..where((tbl) => tbl.date.equals(normalizedDate))).go();
  }
}
