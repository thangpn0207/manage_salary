import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../bloc/concurrent/concurrent_cubit.dart';
import '../../core/locale/generated/l10n.dart';
import '../../core/util/formatter.dart';
import '../../core/util/money_util.dart';
import '../../core/util/spell_number.dart';
import '../../models/travel_note/action_model.dart';
import '../../models/travel_note/member.dart';

class AddEditActionScreen extends StatefulWidget {
  final int tripId;
  final List<MemberModel> members;
  final ActionModel? action;
  final Function(ActionModel, Map<int, double>?) onSave;

  const AddEditActionScreen({
    super.key,
    required this.tripId,
    required this.members,
    this.action,
    required this.onSave,
  });

  @override
  State<AddEditActionScreen> createState() => _AddEditActionScreenState();
}

class _AddEditActionScreenState extends State<AddEditActionScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String spelledAmount = '';

  int? _selectedPayerId;
  SplitType _splitType = SplitType.equal;
  final Map<int, TextEditingController> _customAmountControllers = {};

  @override
  void initState() {
    super.initState();

    // Initialize custom amount controllers for each member
    for (final member in widget.members) {
      _customAmountControllers[member.id!] = TextEditingController();
    }

    if (widget.action != null) {
      _titleController.text = widget.action!.title;
      _descriptionController.text = widget.action!.description ?? '';
      _amountController.text = widget.action!.amount.toStringAsFixed(2);
      _selectedPayerId = widget.action!.payerId;
      _splitType = widget.action!.splitType;

      if (_splitType == SplitType.custom) {
        final equalAmount = widget.action!.amount / widget.members.length;
        for (final member in widget.members) {
          _customAmountControllers[member.id!]!.text =
              equalAmount.toStringAsFixed(2);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    for (final controller in _customAmountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.action != null;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(isEditing ? S.current.editExpense : S.current.addNewExpense),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: S.current.expenseTitle,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.receipt),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return S.current.pleaseEnterExpenseTitle;
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                name: 'title',
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: S.current.description,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2,
                name: 'description',
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
              const SizedBox(height: 16),
              FormBuilderDropdown<int>(
                initialValue: _selectedPayerId,
                decoration: InputDecoration(
                  labelText: S.current.paidBy("??"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: widget.members.map((member) {
                  return DropdownMenuItem(
                    value: member.id,
                    child: Text(member.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPayerId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select who paid for this expense';
                  }
                  return null;
                },
                name: 'paidBy',
              ),
              const SizedBox(height: 16),
              FormBuilderSwitch(
                initialValue: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.payment),
                ),
                onChanged: (value) {
                  setState(() {
                    // _selectedPayerId = value;
                  });
                },
                validator: (value) {
                  return null;
                },
                name: 'isGroupBudget',
                title: Text(
                  S.current.isUsingGroupBudget,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                S.current.splitType,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Card(
                child: RadioGroup<SplitType>(
                  groupValue: _splitType,
                  onChanged: (SplitType? value) {
                    setState(() {
                      _splitType = value!;
                      _updateEqualSplit();
                    });
                  },
                  child: Column(
                    children: [
                      RadioListTile<SplitType>(
                        title: Text(S.current.equalSplit),
                        subtitle: Text(S.current.equalSplitDes),
                        value: SplitType.equal,
                      ),
                      RadioListTile<SplitType>(
                        title: Text(S.current.customSplit),
                        subtitle: Text(S.current.customSplitDes),
                        value: SplitType.custom,
                      ),
                    ],
                  ),
                ),
              ),
              if (_splitType == SplitType.custom) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.customSplitAmount,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        ...widget.members.map((member) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    member.name,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: FormBuilderTextField(
                                    controller:
                                        _customAmountControllers[member.id!],
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
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      MoneyInputFormatter(),
                                    ],
                                    onChanged: (value) => setState(() {
                                      if (value?.isEmpty ?? true) {
                                        spelledAmount = '';
                                        return;
                                      }
                                      final cleanAmount =
                                          value?.replaceAll(RegExp(r'\D'), '');
                                      final amount = double.parse(cleanAmount ??
                                          '0'); // Convert back to actual amount
                                      context
                                                  .read<CurrencyCubit>()
                                                  .state
                                                  .languageCode ==
                                              'vi'
                                          ? spelledAmount = SpellNumber()
                                              .spellMoneyVND(amount)
                                          : spelledAmount =
                                              SpellNumber().spellMoney(amount);
                                    }),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText:
                                              S.of(context).fieldRequired),
                                      (value) {
                                        if (value == null || value.isEmpty) {
                                          return null;
                                        }
                                        final cleanValue = value.replaceAll(
                                            RegExp(r'[^\d]'), '');
                                        if (cleanValue.isEmpty ||
                                            double.parse(cleanValue) <= 0) {
                                          return S
                                              .of(context)
                                              .amountMustBePositive;
                                        }
                                        return null;
                                      },
                                    ]),
                                    name: 'amount+${member.id}',
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                S.current.totalBalance,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                MoneyUtil.formatDefault(_calculateCustomTotal(),
                                    currency: context
                                        .read<CurrencyCubit>()
                                        .state
                                        .languageCode),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isEditing ? S.current.update : S.current.add,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateEqualSplit() {
    final totalAmount =
        double.tryParse(_amountController.text.trim().replaceAll('.', '')) ??
            0.0;
    if (totalAmount > 0 && widget.members.isNotEmpty) {
      final equalAmount = totalAmount / widget.members.length;
      for (final member in widget.members) {
        _customAmountControllers[member.id!]!.text =
            equalAmount.toStringAsFixed(2);
      }
    }
  }

  double _calculateCustomTotal() {
    double total = 0.0;
    for (final controller in _customAmountControllers.values) {
      final amount = double.tryParse(controller.text) ?? 0.0;
      total += amount;
    }
    return total;
  }

  void _saveAction() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final totalAmount =
          double.parse(_amountController.text.trim().replaceAll('.', ''));
      final formData = _formKey.currentState?.value;

      // Validate custom split totals match
      if (_splitType == SplitType.custom) {
        final customTotal = _calculateCustomTotal();
        if ((customTotal - totalAmount).abs() > 0.01) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Custom split total (${MoneyUtil.formatDefault(customTotal, currency: context.read<CurrencyCubit>().state.languageCode)}) '
                'must equal the expense amount (${MoneyUtil.formatDefault(totalAmount, currency: context.read<CurrencyCubit>().state.languageCode)})',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      Map<int, double>? customShares;
      if (_splitType == SplitType.custom) {
        customShares = {};
        for (final member in widget.members) {
          final amount =
              double.parse(_customAmountControllers[member.id!]!.text);
          customShares[member.id!] = amount;
        }
      }

      final now = DateTime.now();
      final action = ActionModel(
        id: widget.action?.id,
        tripId: widget.tripId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        payerId: _selectedPayerId!,
        amount: totalAmount,
        splitType: _splitType,
        createdAt: widget.action?.createdAt ?? now,
        updatedAt: now,
        isGroupBudget: formData?['isGroupBudget'],
      );

      widget.onSave(action, customShares);
      Navigator.pop(context);
    }
  }
}
