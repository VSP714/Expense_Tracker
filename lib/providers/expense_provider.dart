import 'package:flutter/foundation.dart';
import '../models/expenses.dart';

class ExpensesProvider with ChangeNotifier {
  final List<Expense> _expenses = [
    Expense(id: '1', title: 'Grocery Shopping', amount: 85.50, date: DateTime(2024, 5, 1)),
    Expense(id: '2', title: 'Electric Bill',    amount: 120.00, date: DateTime(2024, 5, 3)),
    Expense(id: '3', title: 'Netflix',          amount: 15.99, date: DateTime(2024, 5, 5)),
    Expense(id: '4', title: 'Gym Membership',   amount: 45.00, date: DateTime(2024, 5, 7)),
    Expense(id: '5', title: 'Bus Pass',         amount: 30.00, date: DateTime(2024, 5, 10)),
  ];

  // READ
  List<Expense> get expenses => List.unmodifiable(_expenses);
  double get totalAmount => _expenses.fold(0.0, (sum, e) => sum + e.amount);
  Expense? getById(String id) {
    try { return _expenses.firstWhere((e) => e.id == id); } catch (_) { return null; }
  }

  // WRITE
  void addExpense({required String title, required double amount, required DateTime date}) {
    _expenses.add(Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title, amount: amount, date: date,
    ));
    notifyListeners();
  }

  // EDIT
  void updateExpense({required String id, String? title, double? amount, DateTime? date}) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final e = _expenses[index];
    e.title  = title  ?? e.title;
    e.amount = amount ?? e.amount;
    e.date   = date   ?? e.date;
    notifyListeners();
  }

  // DELETE
  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}