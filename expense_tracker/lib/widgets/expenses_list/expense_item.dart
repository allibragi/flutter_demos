import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class Expenseitem extends StatelessWidget {
  const Expenseitem(this._expense, {super.key});

  final Expense _expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('\$${_expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(cateogryIcons[_expense.category]),
                    const SizedBox(width: 8),
                    Text(_expense.formattedDate),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
