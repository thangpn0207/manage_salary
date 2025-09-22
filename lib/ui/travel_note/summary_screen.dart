import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../bloc/concurrent/concurrent_cubit.dart';
import '../../bloc/travel_note/travel_note_bloc.dart';
import '../../bloc/travel_note/travel_note_event.dart';
import '../../bloc/travel_note/travel_note_state.dart';
import '../../core/locale/generated/l10n.dart';
import '../../core/util/balance_calculator.dart';
import '../../core/util/formatter.dart';
import '../../core/util/money_util.dart';
import '../../core/util/spell_number.dart';
import '../../models/travel_note/deposit.dart';

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
        final memberBalances = summary['memberBalances'] as List<MemberBalance>;
        final settlements = summary['settlements'] as List<Settlement>;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Trip Cost Card
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
                        'Total Trip Cost',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
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
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Deposits Section
              Row(
                children: [
                  Text(
                    'Deposits',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () =>
                        _showAddDepositDialog(context, state.members),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Deposit'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (state.deposits.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('No deposits recorded'),
                    ),
                  ),
                )
              else
                ...state.deposits.map((deposit) {
                  final member =
                      state.members.firstWhere((m) => m.id == deposit.memberId);
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.savings, color: Colors.white),
                      ),
                      title: Text(member.name),
                      trailing: Text(
                        MoneyUtil.formatDefault(deposit.amount,
                            currency: context
                                .read<CurrencyCubit>()
                                .state
                                .languageCode),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              const SizedBox(height: 24),

              // Member Balances
              Text(
                'Member Balances',
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
                                    'Paid',
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
                                    'Owes',
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
                                    'Deposit',
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
              }).toList(),
              const SizedBox(height: 24),

              // Settlements
              if (settlements.isNotEmpty) ...[
                Text(
                  'Suggested Settlements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                ...settlements.map((settlement) {
                  return Card(
                    color: Colors.orange.withValues(alpha: 0.1),
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

  void _showAddDepositDialog(BuildContext context, List members) {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddDepositDialog(
        tripId: widget.tripId,
        members: members,
        onSave: (deposit) {
          context.read<TravelNoteBloc>().add(AddDeposit(deposit));
        },
      ),
    );
  }
}

class _AddDepositDialog extends StatefulWidget {
  final int tripId;
  final List members;
  final Function(DepositModel) onSave;

  const _AddDepositDialog({
    required this.tripId,
    required this.members,
    required this.onSave,
  });

  @override
  State<_AddDepositDialog> createState() => _AddDepositDialogState();
}

class _AddDepositDialogState extends State<_AddDepositDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _amountController = TextEditingController();
  int? _selectedMemberId;
  String spelledAmount = '';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Deposit'),
      content: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderDropdown<int>(
              initialValue: _selectedMemberId,
              decoration: const InputDecoration(
                labelText: 'Member',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              items: widget.members.map((member) {
                return DropdownMenuItem<int>(
                  value: member.id,
                  child: Text(member.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMemberId = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a member';
                }
                return null;
              },
              name: 'member',
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'amount',
              controller: _amountController,
              decoration: InputDecoration(
                helperText: spelledAmount,
                labelText: S.of(context).amountLabel,
                prefixText:
                    '${NumberFormat.simpleCurrency(locale: context.read<CurrencyCubit>().state.languageCode).currencySymbol} ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                MoneyInputFormatter(),
              ],
              onChanged: (value) => setState(() {
                if (value?.isEmpty ?? true) {
                  spelledAmount = '';
                  return;
                }
                final cleanAmount = value?.replaceAll(RegExp(r'[^\d]'), '');
                final amount = double.parse(
                    cleanAmount ?? '0'); // Convert back to actual amount
                context.read<CurrencyCubit>().state.languageCode == 'vi'
                    ? spelledAmount = SpellNumber().spellMoneyVND(amount)
                    : spelledAmount = SpellNumber().spellMoney(amount);
              }),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: S.of(context).fieldRequired),
                (value) {
                  if (value == null || value.isEmpty) return null;
                  final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
                  if (cleanValue.isEmpty || double.parse(cleanValue) <= 0) {
                    return S.of(context).amountMustBePositive;
                  }
                  return null;
                },
              ]),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveDeposit,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _saveDeposit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final deposit = DepositModel(
        tripId: widget.tripId,
        memberId: _selectedMemberId!,
        amount: double.parse(_amountController.text.trim().replaceAll('.', '')),
        createdAt: DateTime.now(),
      );

      widget.onSave(deposit);
      Navigator.pop(context);
    }
  }
}
