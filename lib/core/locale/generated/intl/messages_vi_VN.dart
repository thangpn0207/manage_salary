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

  static String m6(number) => "Chi phí ${number}";

  static String m7(name) => "${name} đã trả";

  static String m8(name) => "Bạn có chắc muốn xóa ${name}?";

  static String m9(number) => "Thành viên chuyến đi (${number})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
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
    "amount": MessageLookupByLibrary.simpleMessage("Số tiền"),
    "amountLabel": MessageLookupByLibrary.simpleMessage("Số tiền"),
    "amountMustBePositive": MessageLookupByLibrary.simpleMessage(
      "Số tiền phải lớn hơn 0",
    ),
    "areYouSureDeleteMember": m3,
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
    "darkMode": MessageLookupByLibrary.simpleMessage("Chế độ tối"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Bảng điều khiển"),
    "dateLabelPrefix": MessageLookupByLibrary.simpleMessage("Ngày: "),
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
    "endDate": MessageLookupByLibrary.simpleMessage("Ngày kết thúc"),
    "enterValidNumber": MessageLookupByLibrary.simpleMessage(
      "Vui lòng nhập số hợp lệ",
    ),
    "equalSplit": MessageLookupByLibrary.simpleMessage("Chia đều hết"),
    "equalSplitDes": MessageLookupByLibrary.simpleMessage(
      "Chia đều cho mỗi người trong nhóm",
    ),
    "expenseTitle": MessageLookupByLibrary.simpleMessage("Tiêu đề chi phí"),
    "expenses": MessageLookupByLibrary.simpleMessage("Chi phí"),
    "expensesLength": m6,
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "Trường này là bắt buộc",
    ),
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
    "income": MessageLookupByLibrary.simpleMessage("Thu nhập"),
    "isUsingGroupBudget": MessageLookupByLibrary.simpleMessage("Dùng tiền quỹ"),
    "language": MessageLookupByLibrary.simpleMessage("Ngôn ngữ"),
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
    "notes": MessageLookupByLibrary.simpleMessage("Ghi chú"),
    "ofBudgetUsed": MessageLookupByLibrary.simpleMessage(
      "ngân sách đã sử dụng",
    ),
    "otherCategory": MessageLookupByLibrary.simpleMessage("Khác"),
    "owes": MessageLookupByLibrary.simpleMessage("Ăn mất"),
    "paid": MessageLookupByLibrary.simpleMessage("Thanh toán"),
    "paidBy": m7,
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
    "remaining": MessageLookupByLibrary.simpleMessage("Còn lại"),
    "remainingGroupDeposit": MessageLookupByLibrary.simpleMessage(
      "Tiền đóng họ còn dư",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Xóa"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Lưu thay đổi"),
    "selectDate": MessageLookupByLibrary.simpleMessage("Chọn ngày"),
    "settings": MessageLookupByLibrary.simpleMessage("Cài đặt"),
    "spent": MessageLookupByLibrary.simpleMessage("Đã chi"),
    "splitType": MessageLookupByLibrary.simpleMessage("Kiểu chia tiền"),
    "startDate": MessageLookupByLibrary.simpleMessage("Ngày bắt đầu"),
    "suggestedSettlements": MessageLookupByLibrary.simpleMessage(
      "Gợi ý thanh toán",
    ),
    "summary": MessageLookupByLibrary.simpleMessage("Tóm tắt"),
    "sureDeleteTrip": m8,
    "tapToAddBudget": MessageLookupByLibrary.simpleMessage(
      "Nhấn nút + phía trên để thêm ngân sách đầu tiên",
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
    "tripMember": m9,
    "tripTitle": MessageLookupByLibrary.simpleMessage("Tiêu đề chuyến đi"),
    "type": MessageLookupByLibrary.simpleMessage("Loại"),
    "update": MessageLookupByLibrary.simpleMessage("Cập nhật"),
    "updated": MessageLookupByLibrary.simpleMessage("đã cập nhật"),
  };
}
