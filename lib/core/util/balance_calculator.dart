import '../../data/repositories/travel_note_repository.dart';
import '../../models/travel_note/action_model.dart';
import '../../models/travel_note/deposit.dart';
import '../../models/travel_note/member.dart';

class MemberBalance {
  final MemberModel member;
  final double totalPaid;
  final double totalOwed;
  final double deposit;
  final double balance;

  MemberBalance({
    required this.member,
    required this.totalPaid,
    required this.totalOwed,
    required this.deposit,
  }) : balance = (totalPaid + deposit) - totalOwed;
}

class Settlement {
  final MemberModel from;
  final MemberModel to;
  final double amount;

  Settlement({
    required this.from,
    required this.to,
    required this.amount,
  });
}

class BalanceCalculator {
  static Future<Map<String, dynamic>> calculateSummary({
    required List<MemberModel> members,
    required List<ActionModel> actions,
    required List<DepositModel> deposits,
    required TravelNoteRepository repository,
  }) async {
    final memberBalances = <MemberBalance>[];
    final totalTripCost =
        actions.fold<double>(0.0, (sum, action) => sum + action.amount);

    for (final member in members) {
      final totalPaid = actions
          .where((action) => action.payerId == member.id)
          .fold<double>(0.0, (sum, action) => sum + action.amount);

      double totalOwed = 0.0;
      for (final action in actions) {
        final shares = await repository.getActionSharesByActionId(action.id!);
        final memberShare = shares.firstWhere(
          (share) => share.memberId == member.id,
          orElse: () => throw Exception(
              'Share not found for member ${member.id} in action ${action.id}'),
        );
        totalOwed += memberShare.amountOwed;
      }

      final deposit = deposits
          .where((d) => d.memberId == member.id)
          .fold<double>(0.0, (sum, d) => sum + d.amount);

      memberBalances.add(MemberBalance(
        member: member,
        totalPaid: totalPaid,
        totalOwed: totalOwed,
        deposit: deposit,
      ));
    }

    final settlements = _calculateSettlements(memberBalances);

    return {
      'totalTripCost': totalTripCost,
      'memberBalances': memberBalances,
      'settlements': settlements,
    };
  }

  static List<Settlement> _calculateSettlements(List<MemberBalance> balances) {
    final settlements = <Settlement>[];
    final creditors = balances.where((b) => b.balance > 0.01).toList();
    final debtors = balances.where((b) => b.balance < -0.01).toList();

    creditors.sort((a, b) => b.balance.compareTo(a.balance));
    debtors.sort((a, b) => a.balance.compareTo(b.balance));

    int creditorIndex = 0;
    int debtorIndex = 0;

    while (creditorIndex < creditors.length && debtorIndex < debtors.length) {
      final creditor = creditors[creditorIndex];
      final debtor = debtors[debtorIndex];

      final creditAmount = creditor.balance;
      final debtAmount = -debtor.balance;
      final settlementAmount =
          creditAmount < debtAmount ? creditAmount : debtAmount;

      if (settlementAmount > 0.01) {
        settlements.add(Settlement(
          from: debtor.member,
          to: creditor.member,
          amount: settlementAmount,
        ));
      }

      if (creditAmount <= debtAmount) {
        creditorIndex++;
      }
      if (debtAmount <= creditAmount) {
        debtorIndex++;
      }
    }

    return settlements;
  }
}
