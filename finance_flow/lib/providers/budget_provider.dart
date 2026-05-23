import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import '../db/database_helper.dart';
import 'package:uuid/uuid.dart';

class BudgetProvider with ChangeNotifier {
  List<BudgetModel> _budgets = [];
  bool _isLoading = false;

  List<BudgetModel> get budgets => _budgets;
  bool get isLoading => _isLoading;

  Future<void> fetchBudgets() async {
    _isLoading = true;
    notifyListeners();
    _budgets = await DatabaseHelper.instance.getAllBudgets();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBudget({
    required String category,
    required double limitAmount,
    required String month,
  }) async {
    final newBudget = BudgetModel(
      id: const Uuid().v4(),
      category: category,
      limitAmount: limitAmount,
      month: month,
    );
    await DatabaseHelper.instance.insertBudget(newBudget);
    await fetchBudgets();
  }

  Future<void> deleteBudget(String id) async {
    await DatabaseHelper.instance.deleteBudget(id);
    await fetchBudgets();
  }
}
