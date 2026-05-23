import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../db/database_helper.dart';
import 'package:uuid/uuid.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  double get totalBalance {
    double total = 0;
    for (var tx in _transactions) {
      if (tx.type == 'income') {
        total += tx.amount;
      } else if (tx.type == 'expense') {
        total -= tx.amount;
      }
    }
    return total;
  }

  double get monthlyIncome {
    double total = 0;
    final now = DateTime.now();
    for (var tx in _transactions) {
      if (tx.type == 'income' && tx.date.month == now.month && tx.date.year == now.year) {
        total += tx.amount;
      }
    }
    return total;
  }

  double get monthlyExpense {
    double total = 0;
    final now = DateTime.now();
    for (var tx in _transactions) {
      if (tx.type == 'expense' && tx.date.month == now.month && tx.date.year == now.year) {
        total += tx.amount;
      }
    }
    return total;
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();
    _transactions = await DatabaseHelper.instance.getAllTransactions();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction({
    required String type,
    required double amount,
    required String category,
    String note = '',
    required DateTime date,
    String paymentMethod = '',
  }) async {
    final newTx = TransactionModel(
      id: const Uuid().v4(),
      type: type,
      amount: amount,
      category: category,
      note: note,
      date: date,
      paymentMethod: paymentMethod,
    );
    await DatabaseHelper.instance.insertTransaction(newTx);
    await fetchTransactions();
  }

  double getSpentForCategory(String categoryId) {
    double total = 0;
    final now = DateTime.now();
    for (var tx in _transactions) {
      if (tx.type == 'expense' && 
          tx.category == categoryId && 
          tx.date.month == now.month && 
          tx.date.year == now.year) {
        total += tx.amount;
      }
    }
    return total;
  }

  Map<String, double> get categorySpending {
    Map<String, double> spending = {};
    for (var tx in _transactions) {
      if (tx.type == 'expense') {
        spending[tx.category] = (spending[tx.category] ?? 0) + tx.amount;
      }
    }
    return spending;
  }

  Future<void> deleteTransaction(String id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await fetchTransactions();
  }
}
