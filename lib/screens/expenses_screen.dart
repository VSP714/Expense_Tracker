import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expenses_tile.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: 'Amount (₱)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    title: title, amount: amount, date: DateTime.now());
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, expense) {
    final titleCtrl = TextEditingController(text: expense.title);
    final amountCtrl = TextEditingController(text: expense.amount.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: 'Amount (₱)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    id: expense.id, title: title, amount: amount);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<ExpensesProvider>(
        builder: (_, provider, __) {
          final expenses = provider.expenses;
          return Column(
            children: [
              // Total card in the body
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Expenses',
                        style: TextStyle(fontSize: 13, color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text(
                      '₱${provider.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Expense list
              Expanded(
                child: expenses.isEmpty
                    ? const Center(
                        child: Text(
                          'No expenses yet.\nTap + to add one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: expenses.length,
                        itemBuilder: (_, i) => ExpenseTile(
                          expense: expenses[i],
                          onEdit: () => _showEditDialog(context, expenses[i]),
                          onDelete: () => provider.deleteExpense(expenses[i].id),
                        ),
                      ),
              ),
            ],
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