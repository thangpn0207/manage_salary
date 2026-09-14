// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi_VN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'vi_VN';

  static String m0(title) => "${title} đã xóa";

  static String m1(name) => "Đã xóa ${name}";

  static String m2(name) => "Đã thêm ${name} thành công.";

  static String m3(name) => "Bạn có chắc muốn xóa ${name} khỏi chuyến đi này?";

  static String m4(category) => "Đã xóa ngân sách ${category}";

  static String m5(name) => "Bạn có chắc muốn xóa ngân sách ${name}?";

  static String m6(month, amount) =>
      "Bạn có chắc chắn muốn chốt lương tháng ${month} với số tiền là ${amount} không?";

  static String m7(number) => "Chi phí ${number}";

  static String m8(monthStr) => "BẢNG CHẤM CÔNG & TÍNH LƯƠNG THÁNG ${monthStr}";

  static String m9(name) => "${name} đã trả";

  static String m10(name) => "Bạn có chắc muốn xóa ${name}?";

  static String m11(number) => "Thành viên chuyến đi (${number})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutApp": MessageLookupByLibrary.simpleMessage("Thông tin ứng dụng"),
    "activityDeleted": m0,
    "activityNatureExpense": MessageLookupByLibrary.simpleMessage("Chi tiêu"),
    "activityNatureIncome": MessageLookupByLibrary.simpleMessage("Thu nhập"),
    "activityNatureLabel": MessageLookupByLibrary.simpleMessage(
      "Tính chất hoạt động",
    ),
    "activityRemoved": m1,
    "activityTypeEducation": MessageLookupByLibrary.simpleMessage("Giáo dục"),
    "activityTypeEntertainment": MessageLookupByLibrary.simpleMessage(
      "Giải trí",
    ),
    "activityTypeExpenseOther": MessageLookupByLibrary.simpleMessage(
      "Chi tiêu khác",
    ),
    "activityTypeFoodAndDrinks": MessageLookupByLibrary.simpleMessage(
      "Ăn uống",
    ),
    "activityTypeFreelance": MessageLookupByLibrary.simpleMessage("Làm tự do"),
    "activityTypeGroceries": MessageLookupByLibrary.simpleMessage(
      "Hàng tạp hóa",
    ),
    "activityTypeHealthcare": MessageLookupByLibrary.simpleMessage("Y tế"),
    "activityTypeIncomeOther": MessageLookupByLibrary.simpleMessage(
      "Thu nhập khác",
    ),
    "activityTypeInvestment": MessageLookupByLibrary.simpleMessage("Đầu tư"),
    "activityTypeLabel": MessageLookupByLibrary.simpleMessage("Loại hoạt động"),
    "activityTypeOther": MessageLookupByLibrary.simpleMessage("Khác"),
    "activityTypeRent": MessageLookupByLibrary.simpleMessage("Tiền thuê"),
    "activityTypeSalary": MessageLookupByLibrary.simpleMessage("Lương"),
    "activityTypeSavings": MessageLookupByLibrary.simpleMessage("Tiết kiệm"),
    "activityTypeShopping": MessageLookupByLibrary.simpleMessage("Mua sắm"),
    "activityTypeTravel": MessageLookupByLibrary.simpleMessage("Du lịch"),
    "activityTypeUtilities": MessageLookupByLibrary.simpleMessage("Tiện ích"),
    "add": MessageLookupByLibrary.simpleMessage("Thêm"),
    "addActivity": MessageLookupByLibrary.simpleMessage("Thêm hoạt động"),
    "addActivityButton": MessageLookupByLibrary.simpleMessage("Thêm hoạt động"),
    "addActivitySuccess": m2,
    "addBudget": MessageLookupByLibrary.simpleMessage("Thêm ngân sách"),
    "addDeposit": MessageLookupByLibrary.simpleMessage("Bốc họ"),
    "addExpenses": MessageLookupByLibrary.simpleMessage("Thêm chi phí"),
    "addMember": MessageLookupByLibrary.simpleMessage("Thêm thành viên"),
    "addMemberFirstEx": MessageLookupByLibrary.simpleMessage(
      "Thêm thành viên trước khi tạo chi phí",
    ),
    "addMemberFirstNote": MessageLookupByLibrary.simpleMessage(
      "Thêm thành viên trước khi tạo ghi chú",
    ),
    "addNewActivitySheetTitle": MessageLookupByLibrary.simpleMessage(
      "Thêm hoạt động mới",
    ),
    "addNewExpense": MessageLookupByLibrary.simpleMessage("Thêm chi phí mới"),
    "addNewMember": MessageLookupByLibrary.simpleMessage("Thêm thành viên mới"),
    "addRecurring": MessageLookupByLibrary.simpleMessage("Thêm định kỳ"),
    "addRecurringDescription": MessageLookupByLibrary.simpleMessage(
      "Thêm các hoạt động định kỳ để tự động hóa thu nhập và chi tiêu thường xuyên của bạn",
    ),
    "added": MessageLookupByLibrary.simpleMessage("đã thêm"),
    "advanceAmount": MessageLookupByLibrary.simpleMessage("Ứng tiền"),
    "advanceSalary": MessageLookupByLibrary.simpleMessage("Tạm ứng"),
    "advanceStat": MessageLookupByLibrary.simpleMessage("Tạm ứng"),
    "amount": MessageLookupByLibrary.simpleMessage("Số tiền"),
    "amountLabel": MessageLookupByLibrary.simpleMessage("Số tiền"),
    "amountMustBePositive": MessageLookupByLibrary.simpleMessage(
      "Số tiền phải lớn hơn 0",
    ),
    "appVersion": MessageLookupByLibrary.simpleMessage("Phiên bản ứng dụng"),
    "areYouSureDeleteMember": m3,
    "attendanceSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Chấm công ngày",
    ),
    "autoCalculationPreview": MessageLookupByLibrary.simpleMessage(
      "Tự động quy đổi định mức:",
    ),
    "autoDailyRate": MessageLookupByLibrary.simpleMessage("Lương 1 ngày"),
    "autoDeductRules": MessageLookupByLibrary.simpleMessage(
      "8% BHXH + 1.5% BHYT + 1% BHTN",
    ),
    "autoHourlyRate": MessageLookupByLibrary.simpleMessage("Lương 1 giờ"),
    "baseSalaryAmount": MessageLookupByLibrary.simpleMessage(
      "Mức lương cơ bản",
    ),
    "bonusMoney": MessageLookupByLibrary.simpleMessage("Thưởng"),
    "budget": MessageLookupByLibrary.simpleMessage("Ngân sách"),
    "budgetAmount": MessageLookupByLibrary.simpleMessage("Số tiền ngân sách"),
    "budgetDetails": MessageLookupByLibrary.simpleMessage("Chi tiết ngân sách"),
    "budgetPeriodMonthly": MessageLookupByLibrary.simpleMessage("Hàng tháng"),
    "budgetPeriodWeekly": MessageLookupByLibrary.simpleMessage("Hàng tuần"),
    "budgetPeriodYearly": MessageLookupByLibrary.simpleMessage("Hàng năm"),
    "budgetRemoved": m4,
    "budgetSummary": MessageLookupByLibrary.simpleMessage(
      "Tổng quan ngân sách",
    ),
    "cacheClearError": MessageLookupByLibrary.simpleMessage(
      "Lỗi khi xóa bộ nhớ đệm.",
    ),
    "cacheClearedSuccess": MessageLookupByLibrary.simpleMessage(
      "Đã xóa bộ nhớ đệm thành công.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Hủy"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Hủy"),
    "category": MessageLookupByLibrary.simpleMessage("Danh mục"),
    "changeButton": MessageLookupByLibrary.simpleMessage("Thay đổi"),
    "checkInFull": MessageLookupByLibrary.simpleMessage("Cả ngày"),
    "checkInHalf": MessageLookupByLibrary.simpleMessage("Nửa ngày"),
    "checkedInToday": MessageLookupByLibrary.simpleMessage(
      "Đã chấm công hôm nay",
    ),
    "clearButton": MessageLookupByLibrary.simpleMessage("Xóa"),
    "clearCache": MessageLookupByLibrary.simpleMessage("Xóa bộ nhớ đệm"),
    "confirmBudgetDeletion": m5,
    "confirmClearCacheContent": MessageLookupByLibrary.simpleMessage(
      "Bạn có chắc không? Thao tác này sẽ xóa toàn bộ dữ liệu hoạt động đã lưu và có thể đặt lại một số tùy chọn.",
    ),
    "confirmClearCacheTitle": MessageLookupByLibrary.simpleMessage(
      "Xác nhận xóa bộ nhớ đệm",
    ),
    "confirmDeletion": MessageLookupByLibrary.simpleMessage("Xác nhận xóa"),
    "confirmFinalizeSalary": m6,
    "create": MessageLookupByLibrary.simpleMessage("Tạo"),
    "createFirstTrip": MessageLookupByLibrary.simpleMessage(
      "Tạo chuyến đi đầu tiên để bắt đầu",
    ),
    "createNewTrip": MessageLookupByLibrary.simpleMessage("Tạo chuyến đi mới"),
    "currency": MessageLookupByLibrary.simpleMessage("Tiền tệ"),
    "currentSpending": MessageLookupByLibrary.simpleMessage(
      "Chi tiêu hiện tại",
    ),
    "customSplit": MessageLookupByLibrary.simpleMessage("Tự chia"),
    "customSplitAmount": MessageLookupByLibrary.simpleMessage("Số tiền chia"),
    "customSplitDes": MessageLookupByLibrary.simpleMessage(
      "Tự nhập số tiền chia mỗi người trong nhóm",
    ),
    "dailyOtPay": MessageLookupByLibrary.simpleMessage("Lương OT"),
    "dailyReminder": MessageLookupByLibrary.simpleMessage("Nhắc nhở chấm công"),
    "dailyReminderDesc": MessageLookupByLibrary.simpleMessage(
      "Nhắc nhở mỗi ngày vào 20:00",
    ),
    "dailyReminderDisabledMsg": MessageLookupByLibrary.simpleMessage(
      "Đã tắt nhắc nhở chấm công",
    ),
    "dailyReminderEnabledMsg": MessageLookupByLibrary.simpleMessage(
      "Đã bật nhắc nhở chấm công hàng ngày",
    ),
    "dailyWage": MessageLookupByLibrary.simpleMessage("Lương ngày"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Chế độ tối"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Bảng điều khiển"),
    "dateLabelPrefix": MessageLookupByLibrary.simpleMessage("Ngày: "),
    "daysSuffix": MessageLookupByLibrary.simpleMessage("công"),
    "delete": MessageLookupByLibrary.simpleMessage("Xóa"),
    "deleteMember": MessageLookupByLibrary.simpleMessage("Xóa thành viên"),
    "deleteTrip": MessageLookupByLibrary.simpleMessage("Xóa chuyến đi"),
    "deposit": MessageLookupByLibrary.simpleMessage("Đóng họ"),
    "deposits": MessageLookupByLibrary.simpleMessage("Những bát họ"),
    "description": MessageLookupByLibrary.simpleMessage(
      "Mô tả (Không bắt buộc)",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Sửa"),
    "editBudget": MessageLookupByLibrary.simpleMessage("Sửa ngân sách"),
    "editExpense": MessageLookupByLibrary.simpleMessage("Sửa chi phí"),
    "editRecurring": MessageLookupByLibrary.simpleMessage("Sửa định kỳ"),
    "editTrip": MessageLookupByLibrary.simpleMessage("Sửa chuyến đi"),
    "email": MessageLookupByLibrary.simpleMessage(
      "SDT đòi nợ (Không bắt buộc)",
    ),
    "enableInsurance": MessageLookupByLibrary.simpleMessage(
      "Tự động trừ bảo hiểm (10.5%)",
    ),
    "endDate": MessageLookupByLibrary.simpleMessage("Ngày kết thúc"),
    "enterValidNumber": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập số hợp lệ",
    ),
    "equalSplit": MessageLookupByLibrary.simpleMessage("Chia đều hết"),
    "equalSplitDes": MessageLookupByLibrary.simpleMessage(
      "Chia đều cho mỗi người trong nhóm",
    ),
    "errorEmptyNote": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập ghi chú",
    ),
    "estimatedDailyIncome": MessageLookupByLibrary.simpleMessage(
      "Thu nhập dự tính hôm nay",
    ),
    "estimatedSalary": MessageLookupByLibrary.simpleMessage("Lương dự tính"),
    "expenseTitle": MessageLookupByLibrary.simpleMessage("Tiêu đề chi phí"),
    "expenses": MessageLookupByLibrary.simpleMessage("Chi phí"),
    "expensesLength": m7,
    "exportAdvanceColumn": MessageLookupByLibrary.simpleMessage("Tạm ứng"),
    "exportAdvancePayment": MessageLookupByLibrary.simpleMessage(
      "Tạm ứng đã nhận:",
    ),
    "exportAttendanceLog": MessageLookupByLibrary.simpleMessage(
      "NHẬT KÝ CHẤM CÔNG THEO NGÀY",
    ),
    "exportBaseSalary": MessageLookupByLibrary.simpleMessage("Lương cơ bản:"),
    "exportBonus": MessageLookupByLibrary.simpleMessage("Tiền thưởng:"),
    "exportBonusColumn": MessageLookupByLibrary.simpleMessage("Thưởng"),
    "exportDate": MessageLookupByLibrary.simpleMessage("Ngày xuất:"),
    "exportDateColumn": MessageLookupByLibrary.simpleMessage("Ngày"),
    "exportEmptyLog": MessageLookupByLibrary.simpleMessage(
      "Chưa có dữ liệu chấm công.",
    ),
    "exportExcel": MessageLookupByLibrary.simpleMessage("Xuất Excel"),
    "exportExcelDesc": MessageLookupByLibrary.simpleMessage("Xuất báo cáo"),
    "exportFooterDesc": MessageLookupByLibrary.simpleMessage(
      "Báo cáo tự động từ ứng dụng Manage Salary - Có trên Google Play Store",
    ),
    "exportFooterTitle": MessageLookupByLibrary.simpleMessage(
      "Báo cáo được tạo bởi ứng dụng Manage Salary - Quản lý chi tiêu & chấm công",
    ),
    "exportInsuranceDeduction": MessageLookupByLibrary.simpleMessage(
      "Trừ BHXH (10.5%):",
    ),
    "exportMonth": MessageLookupByLibrary.simpleMessage("Tháng:"),
    "exportNetSalary": MessageLookupByLibrary.simpleMessage("THỰC LĨNH:"),
    "exportNoteColumn": MessageLookupByLibrary.simpleMessage("Ghi chú"),
    "exportOtHoursColumn": MessageLookupByLibrary.simpleMessage("Giờ OT"),
    "exportOtPay": MessageLookupByLibrary.simpleMessage("Tiền làm thêm giờ:"),
    "exportPdf": MessageLookupByLibrary.simpleMessage("Xuất PDF"),
    "exportPdfDesc": MessageLookupByLibrary.simpleMessage(
      "Xuất báo cáo dạng PDF",
    ),
    "exportProfileSummary": MessageLookupByLibrary.simpleMessage("HỒ SƠ LƯƠNG"),
    "exportReport": MessageLookupByLibrary.simpleMessage("Xuất báo cáo"),
    "exportReportTitle": MessageLookupByLibrary.simpleMessage(
      "BẢNG CHẤM CÔNG VÀ TÍNH LƯƠNG CÁ NHÂN",
    ),
    "exportReportTitlePdf": m8,
    "exportSalaryType": MessageLookupByLibrary.simpleMessage("Loại lương:"),
    "exportStandardDays": MessageLookupByLibrary.simpleMessage("Ngày chuẩn:"),
    "exportStatusColumn": MessageLookupByLibrary.simpleMessage("Trạng thái"),
    "exportSummary": MessageLookupByLibrary.simpleMessage(
      "TỔNG KẾT THU NHẬP & KHẤU TRỪ",
    ),
    "exportTotalOtHours": MessageLookupByLibrary.simpleMessage(
      "Tổng giờ tăng ca:",
    ),
    "exportTotalWorkDays": MessageLookupByLibrary.simpleMessage(
      "Tổng ngày công:",
    ),
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "Trường này là bắt buộc",
    ),
    "finalizeSalary": MessageLookupByLibrary.simpleMessage("Chốt lương"),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Vui lòng điền đầy đủ và chính xác các trường.",
    ),
    "frequency": MessageLookupByLibrary.simpleMessage("Tần suất"),
    "frequencyBiWeekly": MessageLookupByLibrary.simpleMessage(
      "Hai tuần một lần",
    ),
    "frequencyDaily": MessageLookupByLibrary.simpleMessage("Hằng ngày"),
    "frequencyMonthly": MessageLookupByLibrary.simpleMessage("Hằng tháng"),
    "frequencyWeekly": MessageLookupByLibrary.simpleMessage("Hằng tuần"),
    "frequencyYearly": MessageLookupByLibrary.simpleMessage("Hằng năm"),
    "hoursSuffix": MessageLookupByLibrary.simpleMessage("giờ"),
    "income": MessageLookupByLibrary.simpleMessage("Thu nhập"),
    "insuranceStat": MessageLookupByLibrary.simpleMessage("Bảo hiểm"),
    "isUsingGroupBudget": MessageLookupByLibrary.simpleMessage("Dùng tiền quỹ"),
    "language": MessageLookupByLibrary.simpleMessage("Ngôn ngữ"),
    "leavePaid": MessageLookupByLibrary.simpleMessage("Nghỉ có lương"),
    "leaveUnpaid": MessageLookupByLibrary.simpleMessage("Nghỉ không lương"),
    "manageBudgets": MessageLookupByLibrary.simpleMessage("Quản lý ngân sách"),
    "manageRecurring": MessageLookupByLibrary.simpleMessage("Quản lý định kỳ"),
    "member": MessageLookupByLibrary.simpleMessage("Thành viên"),
    "memberBalances": MessageLookupByLibrary.simpleMessage(
      "Chi tiêu theo thành viên",
    ),
    "name": MessageLookupByLibrary.simpleMessage("Tên"),
    "noBudgetsSet": MessageLookupByLibrary.simpleMessage(
      "Chưa có ngân sách nào",
    ),
    "noChartData": MessageLookupByLibrary.simpleMessage(
      "Không có dữ liệu chi tiêu trong giai đoạn này để hiển thị biểu đồ.",
    ),
    "noDatesSet": MessageLookupByLibrary.simpleMessage("Chưa đặt ngày"),
    "noDepositsYet": MessageLookupByLibrary.simpleMessage(
      "Nhóm chưa đóng gì??",
    ),
    "noEndDate": MessageLookupByLibrary.simpleMessage("Không có ngày kết thúc"),
    "noExpenseActivities": MessageLookupByLibrary.simpleMessage(
      "Chưa có hoạt động chi tiêu nào.",
    ),
    "noExpenses": MessageLookupByLibrary.simpleMessage("Chưa có chi phí nào"),
    "noIncomeActivities": MessageLookupByLibrary.simpleMessage(
      "Chưa có hoạt động thu nhập nào.",
    ),
    "noMembersYet": MessageLookupByLibrary.simpleMessage(
      "Chưa có thành viên nào",
    ),
    "noNotesYet": MessageLookupByLibrary.simpleMessage("Chưa có ghi chú nào"),
    "noRecurringActivities": MessageLookupByLibrary.simpleMessage(
      "Chưa có hoạt động định kỳ",
    ),
    "noTripYet": MessageLookupByLibrary.simpleMessage("Chưa có chuyến đi nào"),
    "notCheckedInToday": MessageLookupByLibrary.simpleMessage(
      "Chưa chấm công hôm nay",
    ),
    "noteToday": MessageLookupByLibrary.simpleMessage(
      "Ghi chú công việc hôm nay (tùy chọn)",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("Ghi chú"),
    "notifications": MessageLookupByLibrary.simpleMessage("Thông báo"),
    "ofBudgetUsed": MessageLookupByLibrary.simpleMessage(
      "ngân sách đã sử dụng",
    ),
    "oneTapCheckIn": MessageLookupByLibrary.simpleMessage("Chấm công 1 chạm"),
    "otHoliday": MessageLookupByLibrary.simpleMessage("x3.0 Ngày lễ"),
    "otHourlyRateDesc": MessageLookupByLibrary.simpleMessage(
      "Quy đổi ra giờ làm thêm",
    ),
    "otHoursStat": MessageLookupByLibrary.simpleMessage("Giờ OT"),
    "otNormalDay": MessageLookupByLibrary.simpleMessage("x1.5 Ngày thường"),
    "otWeekend": MessageLookupByLibrary.simpleMessage("x2.0 Cuối tuần"),
    "otherCategory": MessageLookupByLibrary.simpleMessage("Khác"),
    "overtimeHours": MessageLookupByLibrary.simpleMessage("Giờ làm thêm (OT)"),
    "overtimeSection": MessageLookupByLibrary.simpleMessage("Làm thêm"),
    "owes": MessageLookupByLibrary.simpleMessage("Ăn mất"),
    "paid": MessageLookupByLibrary.simpleMessage("Thanh toán"),
    "paidBy": m9,
    "period": MessageLookupByLibrary.simpleMessage("Chu kỳ"),
    "pleaseEnterAmount": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập số tiền",
    ),
    "pleaseEnterExpenseTitle": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập tiêu đề chi phí",
    ),
    "pleaseEnterTripTitle": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập tiêu đề chuyến đi",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage(
      "Chính sách quyền riêng tư",
    ),
    "privacyPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Cách chúng tôi bảo vệ dữ liệu của bạn",
    ),
    "quickAttendanceSubtitle": MessageLookupByLibrary.simpleMessage(
      "Chạm để chấm công",
    ),
    "quickCheckIn": MessageLookupByLibrary.simpleMessage("Chấm công nhanh"),
    "remaining": MessageLookupByLibrary.simpleMessage("Còn lại"),
    "remainingGroupDeposit": MessageLookupByLibrary.simpleMessage(
      "Tiền đóng họ còn dư",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Xóa"),
    "salaryAndAttendance": MessageLookupByLibrary.simpleMessage(
      "Lương & Chấm công",
    ),
    "salaryDaily": MessageLookupByLibrary.simpleMessage("Lương ngày"),
    "salaryHourly": MessageLookupByLibrary.simpleMessage("Lương giờ"),
    "salaryMonthly": MessageLookupByLibrary.simpleMessage("Lương tháng"),
    "salaryProfile": MessageLookupByLibrary.simpleMessage("Hồ sơ lương"),
    "salarySettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Cài đặt lương",
    ),
    "salaryType": MessageLookupByLibrary.simpleMessage("Hình thức trả lương"),
    "saveAttendance": MessageLookupByLibrary.simpleMessage("Lưu chấm công"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Lưu thay đổi"),
    "selectDate": MessageLookupByLibrary.simpleMessage("Chọn ngày"),
    "settings": MessageLookupByLibrary.simpleMessage("Cài đặt"),
    "spent": MessageLookupByLibrary.simpleMessage("Đã chi"),
    "splitType": MessageLookupByLibrary.simpleMessage("Kiểu chia tiền"),
    "standardHoursPerDay": MessageLookupByLibrary.simpleMessage(
      "Số giờ chuẩn/ngày",
    ),
    "standardWorkingDays": MessageLookupByLibrary.simpleMessage(
      "Số ngày công chuẩn/tháng",
    ),
    "startDate": MessageLookupByLibrary.simpleMessage("Ngày bắt đầu"),
    "suggestedSettlements": MessageLookupByLibrary.simpleMessage(
      "Gợi ý thanh toán",
    ),
    "summary": MessageLookupByLibrary.simpleMessage("Tóm tắt"),
    "sureDeleteTrip": m10,
    "tapToAddBudget": MessageLookupByLibrary.simpleMessage(
      "Nhấn nút + phía trên để thêm ngân sách đầu tiên",
    ),
    "termsOfService": MessageLookupByLibrary.simpleMessage(
      "Điều khoản sử dụng",
    ),
    "title": MessageLookupByLibrary.simpleMessage("Tiêu đề"),
    "titleDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Tiêu đề / Mô tả",
    ),
    "totalBalance": MessageLookupByLibrary.simpleMessage("Tổng số dư"),
    "totalExpenses": MessageLookupByLibrary.simpleMessage("Tổng chi phí"),
    "totalTripCost": MessageLookupByLibrary.simpleMessage("Chuyến này mất"),
    "travelNotes": MessageLookupByLibrary.simpleMessage("Ghi chú chuyến đi"),
    "tripDetail": MessageLookupByLibrary.simpleMessage("Chi tiết chuyến đi"),
    "tripMember": m11,
    "tripTitle": MessageLookupByLibrary.simpleMessage("Tiêu đề chuyến đi"),
    "type": MessageLookupByLibrary.simpleMessage("Loại"),
    "update": MessageLookupByLibrary.simpleMessage("Cập nhật"),
    "updated": MessageLookupByLibrary.simpleMessage("đã cập nhật"),
    "workDate": MessageLookupByLibrary.simpleMessage("Ngày làm việc"),
    "workDay": MessageLookupByLibrary.simpleMessage("Cả ngày"),
    "workDaysStat": MessageLookupByLibrary.simpleMessage("Công chuẩn"),
    "workHalfDay": MessageLookupByLibrary.simpleMessage("Nửa ngày"),
    "workOff": MessageLookupByLibrary.simpleMessage("Nghỉ"),
    "workStatus": MessageLookupByLibrary.simpleMessage("Trạng thái"),
    "workType": MessageLookupByLibrary.simpleMessage("Loại công"),
  };
}
