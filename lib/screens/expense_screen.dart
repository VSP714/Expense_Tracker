import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_tile.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String selected = 'Food';
    final categories = ['Food', 'Utilities', 'Entertainment', 'Health', 'Transport', 'Other'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title')),
              TextField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: 'Amount (\u20B1)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selected,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => selected = v!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final title = titleCtrl.text.trim();
                final amount = double.tryParse(amountCtrl.text.trim());
                if (title.isEmpty || amount == null) return;
                context.read<ExpensesProvider>().addExpense(
                  title: title, amount: amount,
                  category: selected, date: DateTime.now(),
                );
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, expense) {
    final titleCtrl = TextEditingController(text: expense.title);
    final amountCtrl = TextEditingController(text: expense.amount.toString());
    String selected = expense.category;
    final categories = ['Food', 'Utilities', 'Entertainment', 'Health', 'Transport', 'Other'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title')),
              TextField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: 'Amount (\u20B1)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selected,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => selected = v!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final title = titleCtrl.text.trim();
                final amount = double.tryParse(amountCtrl.text.trim());
                if (title.isEmpty || amount == null) return;
                context.read<ExpensesProvider>().updateExpense(
                  id: expense.id, title: title,
                  amount: amount, category: selected,
                );
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<ExpensesProvider>(
            builder: (_, provider, _) => Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  'Total: \$${provider.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ExpensesProvider>(
        builder: (_, provider, _) {
          final expenses = provider.expenses;
          if (expenses.isEmpty) {
            return const Center(
              child: Text('No expenses yet.\nTap + to add one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: expenses.length,
            itemBuilder: (_, i) => ExpenseTile(
              expense: expenses[i],
              onEdit: () => _showEditDialog(context, expenses[i]),
              onDelete: () =>
                  context.read<ExpensesProvider>().deleteExpense(expenses[i].id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}