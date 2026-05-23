import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import 'dart:io';
import '../../providers/transaction_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_card.dart';
import '../../models/transaction_model.dart';
import '../add_transaction/select_type_screen.dart';
import '../settings/profile_settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<TransactionProvider>().fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(settings),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildBalanceHero(txProvider, settings),
                  const SizedBox(height: 40),
                  if (txProvider.transactions.isEmpty)
                    _buildEmptyState()
                  else ...[
                    _buildStatisticsCard(txProvider, settings),
                    const SizedBox(height: 24),
                    _buildCategoryGrid(txProvider, settings),
                    const SizedBox(height: 40),
                    _buildRecentTransactions(txProvider, settings),
                  ],
                  const SizedBox(height: 24),
                  _buildPremiumBanner(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar(SettingsProvider settings) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: AppColors.background.withOpacity(0.8),
      title: Text('Prosper', style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSettingsScreen())),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: settings.primaryColor.withOpacity(0.3)),
            ),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceContainer,
              backgroundImage: settings.profileImagePath != null
                  ? FileImage(File(settings.profileImagePath!))
                  : const NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000') as ImageProvider,
            ),
          ),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(settings.selectedCurrency.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          onSelected: (code) => settings.setCurrency(code),
          itemBuilder: (context) => SettingsProvider.currencies.map((c) {
            return PopupMenuItem(
              value: c.code,
              child: Row(
                children: [
                  Text(c.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Text(c.name),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildEmptyState() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary, size: 48),
          ),
          const SizedBox(height: 24),
          Text('Welcome to FinanceFlow', style: AppTextStyles.headlineMd),
          const SizedBox(height: 8),
          Text(
            'Your financial journey starts here. Add your first transaction to see your wealth grow.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectTypeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceHero(TransactionProvider provider, SettingsProvider settings) {
    return Column(
      children: [
        Text('TOTAL BALANCE', style: AppTextStyles.labelMd),
        const SizedBox(height: 8),
        Text(settings.formatAmount(provider.totalBalance), style: AppTextStyles.displayLg),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              provider.totalBalance >= 0 ? Icons.trending_up : Icons.trending_down,
              color: provider.totalBalance >= 0 ? AppColors.tertiary : AppColors.error,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              '${provider.totalBalance >= 0 ? "+" : ""}Live tracking enabled',
              style: AppTextStyles.labelMd.copyWith(
                color: provider.totalBalance >= 0 ? AppColors.tertiary : AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsCard(TransactionProvider provider, SettingsProvider settings) {
    final spendingMap = provider.categorySpending;
    if (spendingMap.isEmpty) return const SizedBox.shrink();

    final List<PieChartSectionData> sections = [];
    final List<Widget> legendItems = [];
    int i = 0;

    final sortedEntries = spendingMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (var entry in sortedEntries) {
      final cat = TransactionCategory.findById(entry.key) ?? TransactionCategory.all.last;
      if (i < 6) {
        sections.add(PieChartSectionData(
          color: Color(cat.colorValue),
          value: entry.value,
          radius: 12,
          showTitle: false,
        ));
        legendItems.add(_buildLegendItem(cat.label, settings.formatAmount(entry.value), Color(cat.colorValue)));
      }
      i++;
    }

    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monthly Insights', style: AppTextStyles.headlineMd),
              const Icon(Icons.more_vert, color: AppColors.outline),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 70,
                    sections: sections,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(settings.formatAmount(provider.monthlyExpense), style: AppTextStyles.headlineMd.copyWith(fontSize: 24)),
                    Text('Spent this month', style: AppTextStyles.labelMd),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            children: legendItems,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.labelSm, overflow: TextOverflow.ellipsis),
          Text(value, style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(TransactionProvider provider, SettingsProvider settings) {
    final spendingMap = provider.categorySpending;
    final List<Widget> cards = [];

    int i = 0;
    spendingMap.forEach((catId, amount) {
      if (i < 4) {
        final cat = TransactionCategory.findById(catId) ?? TransactionCategory.all.last;
        final progress = amount / (provider.monthlyExpense > 0 ? provider.monthlyExpense : 1);
        cards.add(_buildMiniCard(
          _getIcon(cat.icon),
          cat.label,
          settings.formatAmount(amount),
          Color(cat.colorValue),
          progress,
        ));
      }
      i++;
    });

    if (cards.isEmpty) return const SizedBox.shrink();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: cards,
    );
  }

  Widget _buildMiniCard(IconData icon, String label, String amount, Color color, double progress) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(label, style: AppTextStyles.labelMd),
          Text(amount, style: AppTextStyles.headlineMd.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceContainer,
            color: color,
            minHeight: 4,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(TransactionProvider provider, SettingsProvider settings) {
    final recent = provider.transactions.take(5).toList();
    if (recent.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Activity', style: AppTextStyles.headlineMd),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.outline),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: recent.map((tx) {
              final cat = TransactionCategory.findById(tx.category);
              return Dismissible(
                key: Key('dash_${tx.id}'),
                direction: DismissDirection.horizontal,
                background: _buildDeleteBackground(true),
                secondaryBackground: _buildDeleteBackground(false),
                onDismissed: (direction) {
                  context.read<TransactionProvider>().deleteTransaction(tx.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Transaction deleted'), backgroundColor: AppColors.expense),
                  );
                },
                child: _buildTransactionItem(
                  tx.note.isNotEmpty ? tx.note : (cat?.label ?? 'Other'),
                  cat?.label ?? 'Other',
                  '${tx.isIncome ? "+" : "-"}${settings.formatAmount(tx.amount)}',
                  _formatDate(tx.date),
                  _getIcon(cat?.icon),
                  Color(cat?.colorValue ?? 0xFFFFFFFF),
                  isPositive: tx.isIncome,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteBackground(bool isStart) {
    return Container(
      alignment: isStart ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.expense.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: isStart ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: isStart 
          ? [const Icon(Icons.delete_sweep, color: Colors.white), const SizedBox(width: 8), const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]
          : [const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const SizedBox(width: 8), const Icon(Icons.delete_sweep, color: Colors.white)],
      ),
    );
  }

  Widget _buildTransactionItem(String name, String sub, String amount, String time, IconData icon, Color iconColor, {bool isPositive = false}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyLg, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(sub, style: AppTextStyles.labelMd),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: AppTextStyles.bodyLg.copyWith(color: isPositive ? AppColors.income : AppColors.onSurface, fontWeight: FontWeight.bold)),
              Text(time, style: AppTextStyles.labelSm),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return DateFormat('h:mm a').format(date);
    }
    return DateFormat('MMM d').format(date);
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

  Widget _buildPremiumBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1633156191775-2d4622dad698?auto=format&fit=crop&q=80&w=1000'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('UNLOCK PRO', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            Text('Smart Wealth Insights', style: AppTextStyles.headlineMd),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text('Upgrade Now'),
            ),
          ],
        ),
      ),
    );
  }
}
