import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../locale/generated/l10n.dart';

import '../../bloc/salary/salary_state.dart';
import '../../core/util/money_util.dart';
import '../../data/local/salary_database.dart';

class ReportExportService {
  /// Export attendance and salary report as CSV (Excel-compatible with UTF-8 BOM)
  static Future<void> exportToCsv(SalaryState state) async {
    final monthStr = DateFormat('MM/yyyy').format(state.selectedMonth);
    final fileMonth = DateFormat('MM_yyyy').format(state.selectedMonth);

    final List<List<dynamic>> rows = [];

    // Title & Header info
    rows.add(['BẢNG CHẤM CÔNG VÀ TÍNH LƯƠNG CÁ NHÂN (ATTENDANCE & SALARY REPORT)']);
    rows.add(['Tháng (Month):', monthStr]);
    rows.add(['Ngày xuất (Export Date):', DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())]);
    rows.add([]);

    // Profile summary
    if (state.profile != null) {
      final p = state.profile!;
      rows.add(['HỒ SƠ LƯƠNG (SALARY PROFILE)']);
      rows.add(['Loại lương (Type):', p.salaryType.toUpperCase()]);
      rows.add(['Lương cơ bản (Base Salary):', MoneyUtil.formatMoney(p.baseAmount)]);
      rows.add(['Ngày chuẩn (Standard Days):', '${p.standardWorkingDays} ${S.current.daysSuffix}']);
      rows.add([]);
    }

    // Financial summary
    rows.add(['TỔNG KẾT THU NHẬP & KHẤU TRỪ (SUMMARY)']);
    rows.add(['Tổng ngày công (Total Work Days):', state.totalWorkDays]);
    rows.add(['Tổng giờ tăng ca (Total OT Hours):', '${state.totalOtHours}h']);
    rows.add(['Tiền làm thêm giờ (OT Pay):', MoneyUtil.formatMoney(state.totalOtMoney)]);
    rows.add(['Tiền thưởng (Bonus):', MoneyUtil.formatMoney(state.totalBonus)]);
    rows.add(['Tạm ứng đã nhận (Advance Payment):', '-${MoneyUtil.formatMoney(state.totalAdvance)}']);
    if (state.insuranceDeduction > 0) {
      rows.add(['Trừ BHXH (10.5%):', '-${MoneyUtil.formatMoney(state.insuranceDeduction)}']);
    }
    rows.add(['THỰC LĨNH (NET ESTIMATED SALARY):', MoneyUtil.formatMoney(state.estimatedSalary)]);
    rows.add([]);

    // Detailed table header
    rows.add([
      'Ngày (Date)',
      'Thứ (Day)',
      'Trạng thái (Status)',
      'Giờ OT (OT Hours)',
      'Hệ số OT (Rate)',
      'Tạm ứng (Advance)',
      'Thưởng (Bonus)',
      'Ghi chú (Notes)',
    ]);

    // Sort attendances chronologically
    final sortedAttendances = List<Attendance>.from(state.attendances)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final att in sortedAttendances) {
      final dateStr = DateFormat('dd/MM/yyyy').format(att.date);
      final dayOfWeek = DateFormat('E', 'vi_VN').format(att.date);
      String statusStr = 'Đi làm đủ';
      if (att.status == 'half') statusStr = 'Nửa ngày';
      if (att.status == 'leave_paid') statusStr = 'Nghỉ phép';
      if (att.status == 'leave_unpaid') statusStr = 'Nghỉ không lương';

      rows.add([
        dateStr,
        dayOfWeek,
        statusStr,
        att.otHours > 0 ? '${att.otHours}h' : '-',
        att.otHours > 0 ? 'x${att.otMultiplier}' : '-',
        att.advanceAmount > 0 ? MoneyUtil.formatMoney(att.advanceAmount) : '-',
        att.bonusAmount > 0 ? MoneyUtil.formatMoney(att.bonusAmount) : '-',
        att.note ?? '',
      ]);
    }

    rows.add([]);
    rows.add(['---']);
    rows.add(['Báo cáo được tạo bởi ứng dụng Manage Salary - Quản lý chi tiêu & chấm công']);
    rows.add(['Tải trên Google Play & App Store: https://play.google.com/store/apps/details?id=id.thangpn.manage_salary']);

    // Convert to CSV string with UTF-8 BOM (\uFEFF) so Excel displays Vietnamese correctly
    final csvString = excel.encode(rows);
    final bomCsv = '\uFEFF$csvString';

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/Bang_Cham_Cong_Thang_$fileMonth.csv');
    await file.writeAsString(bomCsv);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Bảng chấm công & tính lương tháng $monthStr',
        subject: 'Bang_Cham_Cong_Thang_$fileMonth.csv',
      ),
    );
  }

  /// Export attendance and salary report as a professional printable PDF
  static Future<void> exportToPdf(SalaryState state) async {
    final doc = pw.Document();
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final monthStr = DateFormat('MM/yyyy').format(state.selectedMonth);
    final exportDateStr = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    final sortedAttendances = List<Attendance>.from(state.attendances)
      ..sort((a, b) => a.date.compareTo(b.date));

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
        ),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'MANAGE SALARY',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 14,
                      color: PdfColors.blueGrey800,
                    ),
                  ),
                  pw.Text(
                    '${S.current.exportDate} $exportDateStr',
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  'BẢNG CHẤM CÔNG & TÍNH LƯƠNG THÁNG $monthStr',
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 16,
                    color: PdfColors.blue900,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(top: 12),
            child: pw.Column(
              children: [
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Báo cáo tự động từ ứng dụng Manage Salary - Có trên Google Play Store',
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) => [
          // Financial Summary Card
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.grey300),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'TỔNG KẾT LƯƠNG & NGÀY CÔNG',
                  style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.blueGrey800),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${S.current.exportTotalWorkDays} ${state.totalWorkDays} ${S.current.daysSuffix}', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('Tăng ca: ${state.totalOtHours}h (+${MoneyUtil.formatMoney(state.totalOtMoney)})', style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${S.current.exportBonus} +${MoneyUtil.formatMoney(state.totalBonus)}', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('${S.current.exportAdvancePayment} -${MoneyUtil.formatMoney(state.totalAdvance)}', style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
                if (state.insuranceDeduction > 0) ...[
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Khấu trừ BHXH (10.5%):', style: const pw.TextStyle(fontSize: 10)),
                      pw.Text('-${MoneyUtil.formatMoney(state.insuranceDeduction)}', style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
                pw.Divider(color: PdfColors.grey400, height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('THỰC LĨNH DỰ KIẾN (NET PAY):', style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.green800)),
                    pw.Text(MoneyUtil.formatMoney(state.estimatedSalary), style: pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.green800)),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Attendance Details Table
          pw.Text('CHI TIẾT CHẤM CÔNG THEO NGÀY', style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.blueGrey800)),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1.8),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(2),
              4: pw.FlexColumnWidth(2),
              5: pw.FlexColumnWidth(3),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blueGrey50),
                children: [
                  _tableCell('Ngày', font: fontBold),
                  _tableCell('Trạng thái', font: fontBold),
                  _tableCell('Tăng ca', font: fontBold),
                  _tableCell('Tạm ứng', font: fontBold),
                  _tableCell('Thưởng', font: fontBold),
                  _tableCell('Ghi chú', font: fontBold),
                ],
              ),
              ...sortedAttendances.map((att) {
                final dateStr = DateFormat('dd/MM/yyyy').format(att.date);
                String statusStr = 'Đi làm đủ';
                if (att.status == 'half') statusStr = 'Nửa ngày';
                if (att.status == 'leave_paid') statusStr = 'Nghỉ phép';
                if (att.status == 'leave_unpaid') statusStr = 'Nghỉ không lương';

                return pw.TableRow(
                  children: [
                    _tableCell(dateStr),
                    _tableCell(statusStr),
                    _tableCell(att.otHours > 0 ? '${att.otHours}h (x${att.otMultiplier})' : '-'),
                    _tableCell(att.advanceAmount > 0 ? MoneyUtil.formatMoney(att.advanceAmount) : '-'),
                    _tableCell(att.bonusAmount > 0 ? MoneyUtil.formatMoney(att.bonusAmount) : '-'),
                    _tableCell(att.note ?? '-'),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );

    final fileMonth = DateFormat('MM_yyyy').format(state.selectedMonth);
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'Bang_Cham_Cong_Thang_$fileMonth.pdf',
    );
  }

  static pw.Widget _tableCell(String text, {pw.Font? font}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 9),
      ),
    );
  }
}
