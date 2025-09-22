import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/concurrent/concurrent_cubit.dart';
import '../../bloc/travel_note/travel_note_bloc.dart';
import '../../bloc/travel_note/travel_note_event.dart';
import '../../bloc/travel_note/travel_note_state.dart';
import '../../core/locale/generated/l10n.dart';
import '../../core/util/money_util.dart';
import '../../models/travel_note/action_model.dart';
import '../../models/travel_note/member.dart';
import '../../models/travel_note/travel_note.dart';
import 'add_edit_action_screen.dart';
import 'summary_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final int tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<TravelNoteBloc, TravelNoteState>(
            builder: (context, state) {
              if (state.selectedTrip != null) {
                return Text(state.selectedTrip!.title);
              }
              return Text(S.current.tripDetail);
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: S.current.member),
              Tab(icon: Icon(Icons.receipt_long), text: S.current.expenses),
              Tab(icon: Icon(Icons.note), text: S.current.notes),
              Tab(icon: Icon(Icons.summarize), text: S.current.summary),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MembersTab(tripId: tripId),
            _ExpensesTab(tripId: tripId),
            _NotesTab(tripId: tripId),
            SummaryScreen(tripId: tripId),
          ],
        ),
      ),
    );
  }
}

class _MembersTab extends StatelessWidget {
  final int tripId;

  const _MembersTab({required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelNoteBloc, TravelNoteState>(
      builder: (context, state) {
        if (!state.isLoading) {
          if (state.members.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    S.current.noMembersYet,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddMemberDialog(context),
                    icon: const Icon(Icons.add),
                    label: Text(S.current.addMember),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      S.current.tripMember(state.members.length),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddMemberDialog(context),
                      icon: const Icon(Icons.add),
                      label: Text(S.current.addMember),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.members.length,
                  itemBuilder: (context, index) {
                    final member = state.members[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getAvatarColor(index),
                          child: Text(
                            member.name.isNotEmpty
                                ? member.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(member.name),
                        subtitle:
                            member.email != null ? Text(member.email!) : null,
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(S.current.delete,
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'delete') {
                              _showDeleteMemberConfirmation(context, member);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal
    ];
    return colors[index % colors.length];
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddMemberDialog(
        tripId: tripId,
        onSave: (member) {
          context.read<TravelNoteBloc>().add(CreateMember(member));
        },
      ),
    );
  }

  void _showDeleteMemberConfirmation(BuildContext context, MemberModel member) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.current.confirmDeletion),
        content: Text(S.current.areYouSureDeleteMember(member.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(S.current.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<TravelNoteBloc>().add(DeleteMember(member.id!));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(S.current.delete),
          ),
        ],
      ),
    );
  }
}

class _AddMemberDialog extends StatefulWidget {
  final int tripId;
  final Function(MemberModel) onSave;

  const _AddMemberDialog({required this.tripId, required this.onSave});

  @override
  State<_AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<_AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.current.addMember),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: S.current.name,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: S.current.email,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.current.cancel),
        ),
        ElevatedButton(
          onPressed: _saveMember,
          child: Text(S.current.add),
        ),
      ],
    );
  }

  void _saveMember() {
    if (_formKey.currentState!.validate()) {
      final member = MemberModel(
        tripId: widget.tripId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        createdAt: DateTime.now(),
      );

      widget.onSave(member);
      Navigator.pop(context);
    }
  }
}

class _ExpensesTab extends StatelessWidget {
  final int tripId;

  const _ExpensesTab({required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelNoteBloc, TravelNoteState>(
      builder: (context, state) {
        if (!state.isLoading) {
          if (state.members.isEmpty) {
            return Center(
              child: Text(S.current.addMemberFirstEx),
            );
          }

          if (state.actions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    S.current.noExpenses,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _navigateToAddExpense(context, state.members),
                    icon: const Icon(Icons.add),
                    label: Text(S.current.addExpenses),
                  ),
                ],
              ),
            );
          }

          final totalExpenses = state.actions
              .fold<double>(0.0, (sum, action) => sum + action.amount);

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      S.current.totalExpenses,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      MoneyUtil.formatDefault(totalExpenses,
                          currency:
                              context.read<CurrencyCubit>().state.languageCode),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      S.current.expensesLength(state.actions.length),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _navigateToAddExpense(context, state.members),
                      icon: const Icon(Icons.add),
                      label: Text(
                        S.current.addExpenses,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.actions.length,
                  itemBuilder: (context, index) {
                    final action = state.actions[index];
                    final payer = state.members.firstWhere(
                      (member) => member.id == action.payerId,
                      orElse: () => MemberModel(
                        id: -1,
                        tripId: tripId,
                        name: 'Unknown',
                        email: null,
                        createdAt: DateTime.now(),
                      ),
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: action.splitType == SplitType.equal
                              ? Colors.blue
                              : Colors.orange,
                          child: Icon(
                            action.splitType == SplitType.equal
                                ? Icons.people
                                : Icons.tune,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          action.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (action.description != null)
                              Text(action.description!),
                            Text(S.current.paidBy(payer.name)),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              MoneyUtil.formatDefault(action.amount,
                                  currency: context
                                      .read<CurrencyCubit>()
                                      .state
                                      .languageCode),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _navigateToAddExpense(BuildContext context, List<MemberModel> members) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditActionScreen(
          tripId: tripId,
          members: members,
          onSave: (action, customShares) {
            context
                .read<TravelNoteBloc>()
                .add(AddAction(action, customShares: customShares));
          },
        ),
      ),
    );
  }
}

class _NotesTab extends StatelessWidget {
  final int tripId;

  const _NotesTab({required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelNoteBloc, TravelNoteState>(
      builder: (context, state) {
        if (!state.isLoading) {
          if (state.members.isEmpty) {
            return Center(
              child: Text(S.current.addMemberFirstNote),
            );
          }

          if (state.travelNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.note_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    S.current.noNotesYet,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddNoteDialog(context, state.members),
                    icon: const Icon(Icons.add),
                    label: Text('Add Note'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'Travel Notes (${state.travelNotes.length})',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _showAddNoteDialog(context, state.members),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Note'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.travelNotes.length,
                  itemBuilder: (context, index) {
                    final note = state.travelNotes[index];
                    final owner = state.members.firstWhere(
                      (member) => member.id == note.ownerId,
                      orElse: () => MemberModel(
                        id: -1,
                        tripId: tripId,
                        name: 'Unknown',
                        email: null,
                        createdAt: DateTime.now(),
                      ),
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    note.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Delete',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      context
                                          .read<TravelNoteBloc>()
                                          .add(DeleteTravelNote(note.id!));
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(note.content),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    owner.name.isNotEmpty
                                        ? owner.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'by ${owner.name}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                const Spacer(),
                                Text(
                                  _formatDateTime(note.createdAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showAddNoteDialog(BuildContext context, List<MemberModel> members) {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddNoteDialog(
        tripId: tripId,
        members: members,
        onSave: (note) {
          context.read<TravelNoteBloc>().add(CreateTravelNote(note));
        },
      ),
    );
  }
}

class _AddNoteDialog extends StatefulWidget {
  final int tripId;
  final List<MemberModel> members;
  final Function(TravelNoteModel) onSave;

  const _AddNoteDialog({
    required this.tripId,
    required this.members,
    required this.onSave,
  });

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int? _selectedOwnerId;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Travel Note'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _selectedOwnerId,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                items: widget.members.map((member) {
                  return DropdownMenuItem(
                    value: member.id,
                    child: Text(member.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOwnerId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an author';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveNote,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final note = TravelNoteModel(
        tripId: widget.tripId,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        ownerId: _selectedOwnerId!,
        createdAt: now,
        updatedAt: now,
      );

      widget.onSave(note);
      Navigator.pop(context);
    }
  }
}
