import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import '../db/database_helper.dart';
import 'package:uuid/uuid.dart';

class GoalProvider with ChangeNotifier {
  List<GoalModel> _goals = [];
  bool _isLoading = false;

  List<GoalModel> get goals => _goals;
  bool get isLoading => _isLoading;

  double get totalSaved {
    return _goals.fold(0, (sum, goal) => sum + goal.savedAmount);
  }

  Future<void> fetchGoals() async {
    _isLoading = true;
    notifyListeners();
    _goals = await DatabaseHelper.instance.getAllGoals();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addGoal({
    required String name,
    String subtitle = '',
    required double targetAmount,
    required double savedAmount,
    String iconId = 'savings',
    int colorValue = 0xFF98DA27,
  }) async {
    final newGoal = GoalModel(
      id: const Uuid().v4(),
      name: name,
      subtitle: subtitle,
      targetAmount: targetAmount,
      savedAmount: savedAmount,
      iconId: iconId,
      colorValue: colorValue,
    );
    await DatabaseHelper.instance.insertGoal(newGoal);
    await fetchGoals();
  }

  Future<void> addFunds(String goalId, double amount) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final updatedGoal = _goals[index].copyWith(
        savedAmount: _goals[index].savedAmount + amount,
      );
      await DatabaseHelper.instance.updateGoal(updatedGoal);
      await fetchGoals();
    }
  }

  Future<void> deleteGoal(String id) async {
    await DatabaseHelper.instance.deleteGoal(id);
    await fetchGoals();
  }
}
