import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import 'transaction_details_screen.dart';

class SelectTypeScreen extends StatelessWidget {
  const SelectTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Prosper', style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=financeflow'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Entry', style: AppTextStyles.displayLg.copyWith(fontSize: 40)),
            const SizedBox(height: 8),
            Text('Select the type of transaction you would like to record.', style: AppTextStyles.bodyMd.copyWith(color: AppColors.outline)),
            const SizedBox(height: 32),
            _buildTypeCard(
              context,
              'Expense',
              'Spending, bills, and purchases',
              Icons.trending_up,
              AppColors.expense,
              'expense',
            ),
            const SizedBox(height: 16),
            _buildTypeCard(
              context,
              'Income',
              'Salary, dividends, and gifts',
              Icons.account_balance_wallet,
              AppColors.income,
              'income',
            ),
            const SizedBox(height: 16),
            _buildTypeCard(
              context,
              'Transfer',
              'Between your own accounts',
              Icons.swap_horiz,
              AppColors.transfer,
              'transfer',
            ),
            const SizedBox(height: 32),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel and return to Ledger', style: AppTextStyles.labelMd),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(BuildContext context, String title, String subtitle, IconData icon, Color color, String type) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransactionDetailsScreen(transactionType: type)),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.headlineMd),
                  Text(subtitle, style: AppTextStyles.labelMd),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.outline, size: 16),
          ],
        ),
      ),
    );
  }
}
