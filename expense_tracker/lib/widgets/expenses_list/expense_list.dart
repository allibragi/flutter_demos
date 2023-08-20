import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required List<Expense> expenses,
    required this.onRemoveExpense,
  }) : _expenses = expenses;

  final List<Expense> _expenses;
  final void Function(Expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          //margin: Theme.of(context).cardTheme.margin,
          // up copies the entire margin, down only the horizontal, from the global theme
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        key: ValueKey(_expenses[index]),
        onDismissed: (direction) => onRemoveExpense(_expenses[index]),
        child: Expenseitem(
          _expenses[index],
        ),
      ),
    );
  }
}
