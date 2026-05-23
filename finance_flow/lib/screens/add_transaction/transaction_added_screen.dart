import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../models/transaction_model.dart';

class TransactionAddedScreen extends StatelessWidget {
  final double amount;
  final String category;
  final DateTime date;

  const TransactionAddedScreen({
    super.key,
    required this.amount,
    required this.category,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final cat = TransactionCategory.findById(category);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.income.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: AppColors.income, size: 60),
            ),
            const SizedBox(height: 32),
            Text('Transaction Added', style: AppTextStyles.headlineLg),
            const SizedBox(height: 12),
            Text(
              'Your transaction has been securely\nrecorded in your ledger.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
            ),
            const SizedBox(height: 48),
            GlassCard(
              child: Column(
                children: [
                  _buildSummaryRow('Amount', currencyFormat.format(amount), isAmount: true),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: AppColors.cardBorder, height: 1),
                  ),
                  _buildSummaryRow('Category', cat?.label ?? 'Other', icon: _getIcon(cat?.icon)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: AppColors.cardBorder, height: 1),
                  ),
                  _buildSummaryRow('Date', DateFormat('MMM dd, yyyy • HH:mm').format(date)),
                ],
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Go to Dashboard', style: AppTextStyles.headlineMd.copyWith(color: AppColors.background)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add Another'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.onSurface,
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 48),
            _buildQuoteBanner(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isAmount = false, IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.outline)),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.tertiary, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              value,
              style: AppTextStyles.bodyLg.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isAmount ? 20 : 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuoteBanner() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1512428559087-560fa5ceab42?q=80&w=2000&auto=format&fit=crop'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      alignment: Alignment.center,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          '“Prosperity is not just about wealth, it’s about having a peace of mind.”',
          textAlign: TextAlign.center,
          style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.outline),
        ),
      ),
    );
  }

  IconData _getIcon(String? name) {
    switch (name) {
      case 'restaurant': return Icons.restaurant;
      case 'directions_car': return Icons.directions_car;
      case 'home': return Icons.home;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'favorite': return Icons.favorite;
      case 'movie': return Icons.movie;
      case 'work': return Icons.work;
      case 'laptop': return Icons.laptop;
      default: return Icons.more_horiz;
    }
  }
}
