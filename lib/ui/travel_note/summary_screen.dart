import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/concurrent/concurrent_cubit.dart';
import '../../bloc/travel_note/travel_note_bloc.dart';
import '../../bloc/travel_note/travel_note_event.dart';
import '../../bloc/travel_note/travel_note_state.dart';
import '../../core/locale/generated/l10n.dart';
import '../../core/util/balance_calculator.dart';
import '../../core/util/money_util.dart';

class SummaryScreen extends StatefulWidget {
  final int tripId;

  const SummaryScreen({super.key, required this.tripId});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TravelNoteBloc>().add(LoadSummary(widget.tripId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelNoteBloc, TravelNoteState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.members.isEmpty) {
          return const Center(
            child: Text('Add members first to see summary'),
          );
        }

        if (state.actions.isEmpty) {
          return const Center(
            child: Text('Add expenses first to see summary'),
          );
        }

        if (state.summary == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final summary = state.summary!;
        final totalTripCost = summary['totalTripCost'] as double;
        final remainingGroupDeposit =
            summary['remainingGroupDeposit'] as double;
        final totalGroupBudget = summary['totalGroupBudget'] as double;
        final memberBalances = summary['memberBalances'] as List<MemberBalance>;
        final settlements = summary['settlements'] as List<Settlement>;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Trip Cost Card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.wallet,
                              size: 48,
                              color: Theme.of(context).highlightColor,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              S.current.totalTripCost,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              MoneyUtil.formatDefault(totalTripCost,
                                  currency: context
                                      .read<CurrencyCubit>()
                                      .state
                                      .languageCode),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontSize: 14,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            size: 48,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            S.current.remainingGroupDeposit,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            MoneyUtil.formatDefault(remainingGroupDeposit,
                                currency: context
                                    .read<CurrencyCubit>()
                                    .state
                                    .languageCode),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Member Balances
              Text(
                S.current.memberBalances,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...memberBalances.map((balance) {
                final isPositive = balance.balance > 0.01;
                final isNegative = balance.balance < -0.01;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isPositive
                                  ? Colors.green
                                  : isNegative
                                      ? Colors.red
                                      : Colors.grey,
                              child: Text(
                                balance.member.name.isNotEmpty
                                    ? balance.member.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                balance.member.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Text(
                              isPositive
                                  ? '+${MoneyUtil.formatDefault(balance.balance, currency: context.read<CurrencyCubit>().state.languageCode)}'
                                  : isNegative
                                      ? '-${MoneyUtil.formatDefault(-balance.balance, currency: context.read<CurrencyCubit>().state.languageCode)}'
                                      : '0.00',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isPositive
                                    ? Colors.green
                                    : isNegative
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.current.paid,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                  Text(
                                    MoneyUtil.formatDefault(balance.totalPaid,
                                        currency: context
                                            .read<CurrencyCubit>()
                                            .state
                                            .languageCode),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.current.owes,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                  Text(
                                    MoneyUtil.formatDefault(balance.totalOwed,
                                        currency: context
                                            .read<CurrencyCubit>()
                                            .state
                                            .languageCode),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.current.deposit,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                  Text(
                                    MoneyUtil.formatDefault(balance.deposit,
                                        currency: context
                                            .read<CurrencyCubit>()
                                            .state
                                            .languageCode),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Settlements
              if (settlements.isNotEmpty) ...[
                Text(
                  S.current.suggestedSettlements,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...settlements.map((settlement) {
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.swap_horiz, color: Colors.white),
                      ),
                      title: Text(
                        '${settlement.from.name} → ${settlement.to.name}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        MoneyUtil.formatDefault(settlement.amount,
                            currency: context
                                .read<CurrencyCubit>()
                                .state
                                .languageCode),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ] else ...[
                Card(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 32),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'All settled up! 🎉',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
