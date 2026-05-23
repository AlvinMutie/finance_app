import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:finance_flow/main.dart';
import 'package:finance_flow/providers/transaction_provider.dart';
import 'package:finance_flow/providers/budget_provider.dart';
import 'package:finance_flow/providers/goal_provider.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
          ChangeNotifierProvider(create: (_) => BudgetProvider()),
          ChangeNotifierProvider(create: (_) => GoalProvider()),
        ],
        child: const FinanceFlowApp(),
      ),
    );
    // Verify the app launches
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
