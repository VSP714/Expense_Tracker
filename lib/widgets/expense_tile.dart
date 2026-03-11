import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _icon(String category) {
    switch (category) {
      case 'Food':         return Icons.fastfood;
      case 'Utilities':   return Icons.flash_on;
      case 'Entertainment': return Icons.movie;
      case 'Health':      return Icons.favorite;
      case 'Transport':   return Icons.directions_bus;
      default:            return Icons.attach_money;
    }
  }

  Color _color(String category) {
    switch (category) {
      case 'Food':         return Colors.orange;
      case 'Utilities':   return Colors.blue;
      case 'Entertainment': return Colors.purple;
      case 'Health':      return Colors.red;
      case 'Transport':   return Colors.teal;
      default:            return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _color(expense.category).withValues(alpha: 0.15 ),
          child: Icon(_icon(expense.category), color: _color(expense.category)),
        ),
        title: Text(expense.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\u20B1${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color:  Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
              color: Colors.grey[600],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
              color: Colors.red[300],
            ),
          ],
        ),
      ),
    );
  }
}