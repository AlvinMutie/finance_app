import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/glass_card.dart';
import '../../models/transaction_model.dart';
import '../../models/budget_model.dart';

class BudgetPlannerScreen extends StatefulWidget {
  const BudgetPlannerScreen({super.key});

  @override
  State<BudgetPlannerScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<BudgetProvider>().fetchBudgets();
        context.read<TransactionProvider>().fetchTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final budgetProvider = context.watch<BudgetProvider>();
    final settings = context.watch<SettingsProvider>();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                _buildHeroStats(txProvider, budgetProvider, settings),
                const SizedBox(height: 40),
                if (budgetProvider.budgets.isEmpty)
                  _buildEmptyState()
                else ...[
                  _buildDonutChart(txProvider, budgetProvider, settings),
                  const SizedBox(height: 40),
                  _buildBudgetList(txProvider, budgetProvider, settings),
                ],
                const SizedBox(height: 40),
                _buildSmartInsights(txProvider, budgetProvider, settings),
                const SizedBox(height: 24),
                _buildMarketingBanner(),
                const SizedBox(height: 24),
              ]),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, color: AppColors.secondary, size: 48),
          const SizedBox(height: 16),
          Text('No Budgets Set', style: AppTextStyles.headlineMd),
          const SizedBox(height: 8),
          Text(
            'Control your spending by setting monthly limits for your categories.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddBudgetDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Set New Budget'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.background.withOpacity(0.8),
      title: Text('Planner', style: AppTextStyles.headlineMd.copyWith(color: AppColors.secondary)),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _showAddBudgetDialog(context),
          icon: const Icon(Icons.add_circle_outline, color: AppColors.secondary),
        ),
      ],
    );
  }

  Widget _buildHeroStats(TransactionProvider txProvider, BudgetProvider budgetProvider, SettingsProvider settings) {
    double totalLimit = 0;
    for (var b in budgetProvider.budgets) {
      totalLimit += b.limitAmount;
    }
    
    final spent = txProvider.monthlyExpense;
    final left = totalLimit - spent;

    return Column(
      children: [
        Text('MONTHLY ALLOWANCE LEFT', style: AppTextStyles.labelMd),
        const SizedBox(height: 8),
        Text(
          settings.formatAmount(left < 0 ? 0 : left), 
          style: AppTextStyles.displayLg.copyWith(color: left < 0 ? AppColors.error : AppColors.onSurface)
        ),
        const SizedBox(height: 8),
        if (totalLimit > 0)
          Text(
            '${((spent / totalLimit) * 100).toStringAsFixed(0)}% of your total budget used',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.outline),
          ),
      ],
    );
  }

  Widget _buildDonutChart(TransactionProvider txProvider, BudgetProvider budgetProvider, SettingsProvider settings) {
    double totalLimit = 0;
    for (var b in budgetProvider.budgets) {
      totalLimit += b.limitAmount;
    }
    if (totalLimit == 0) return const SizedBox.shrink();

    final spent = txProvider.monthlyExpense;
    final remaining = (totalLimit - spent).clamp(0.0, totalLimit);

    return Center(
      child: SizedBox(
        height: 240,
        width: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 80,
                sections: [
                  PieChartSectionData(
                    color: AppColors.secondary,
                    value: spent,
                    radius: 15,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    color: AppColors.surfaceContainer,
                    value: remaining,
                    radius: 10,
                    showTitle: false,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(settings.formatAmount(spent), style: AppTextStyles.headlineMd),
                Text('Spent Total', style: AppTextStyles.labelMd),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetList(TransactionProvider txProvider, BudgetProvider budgetProvider, SettingsProvider settings) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Budget Categories', style: AppTextStyles.headlineMd),
            const Icon(Icons.filter_list, color: AppColors.outline, size: 20),
          ],
        ),
        const SizedBox(height: 16),
        ...budgetProvider.budgets.map((b) {
          final cat = TransactionCategory.findById(b.category);
          final spent = txProvider.getSpentForCategory(b.category);
          final progress = (spent / b.limitAmount).clamp(0.0, 1.0);
          final isOver = spent > b.limitAmount;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Dismissible(
              key: Key(b.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
              onDismissed: (direction) {
                context.read<BudgetProvider>().deleteBudget(b.id);
              },
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(cat?.colorValue ?? 0xFFFFFFFF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(_getIcon(cat?.icon), color: Color(cat?.colorValue ?? 0xFFFFFFFF), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(cat?.label ?? 'Other', style: AppTextStyles.bodyLg),
                        const Spacer(),
                        Text(
                          '${settings.formatAmount(spent)} / ${settings.formatAmount(b.limitAmount)}',
                          style: AppTextStyles.labelMd.copyWith(
                            color: isOver ? AppColors.error : AppColors.onSurface,
                            fontWeight: isOver ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.surfaceContainer,
                      color: isOver ? AppColors.error : Color(cat?.colorValue ?? 0xFFFFFFFF),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showAddBudgetDialog(BuildContext context) {
    String selectedCategory = TransactionCategory.all.first.id;
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24, left: 24, right: 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set Monthly Budget', style: AppTextStyles.headlineLg),
              const SizedBox(height: 8),
              Text('Select a category and set your limit.', style: AppTextStyles.bodyMd.copyWith(color: AppColors.outline)),
              const SizedBox(height: 32),
              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TransactionCategory.all.map((cat) {
                  final isSelected = selectedCategory == cat.id;
                  return ChoiceChip(
                    label: Text(cat.label),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setModalState(() => selectedCategory = cat.id);
                    },
                    selectedColor: AppColors.secondary,
                    labelStyle: TextStyle(color: isSelected ? AppColors.background : AppColors.onSurface),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text('Monthly Limit', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 24),
                decoration: const InputDecoration(
                  prefixText: '\$ ',
                  hintText: '0.00',
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text) ?? 0;
                    if (amount > 0) {
                      context.read<BudgetProvider>().addBudget(
                        category: selectedCategory,
                        limitAmount: amount,
                        month: DateFormat('MMMM yyyy').format(DateTime.now()),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Save Budget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmartInsights(TransactionProvider txProvider, BudgetProvider budgetProvider, SettingsProvider settings) {
    final List<Widget> cards = [];
    
    // 1. Check for over-budget categories
    for (var b in budgetProvider.budgets) {
      final spent = txProvider.getSpentForCategory(b.category);
      if (spent > b.limitAmount) {
        final cat = TransactionCategory.findById(b.category);
        cards.add(_buildInsightCard(
          'BUDGET ALERT',
          'You have exceeded your ${cat?.label ?? 'Other'} budget by ${settings.formatAmount(spent - b.limitAmount)}.',
          Icons.warning_amber_rounded,
          AppColors.error,
        ));
      } else if (spent > b.limitAmount * 0.8) {
        final cat = TransactionCategory.findById(b.category);
        cards.add(_buildInsightCard(
          'ALMOST THERE',
          'You are at 80% of your ${cat?.label ?? 'Other'} budget. Slow down!',
          Icons.speed,
          AppColors.tertiary,
        ));
      }
    }

    // 2. Savings potential
    final savings = txProvider.monthlyIncome - txProvider.monthlyExpense;
    if (savings > 0) {
      cards.add(_buildInsightCard(
        'SAVINGS MASTER',
        'You have saved ${settings.formatAmount(savings)} this month. Add it to goals!',
        Icons.auto_graph,
        AppColors.secondary,
      ));
    }

    if (cards.isEmpty) {
      cards.add(_buildInsightCard(
        'GOOD START',
        'Set some budgets to get personalized smart insights.',
        Icons.lightbulb_outline,
        AppColors.outline,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart Insights', style: AppTextStyles.headlineMd),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: cards.expand((c) => [c, const SizedBox(width: 16)]).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(String title, String desc, IconData icon, Color color) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.bodyLg.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
              Icon(icon, color: color.withOpacity(0.5), size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildMarketingBanner() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1551288049-bbbda536339a?q=80&w=2000&auto=format&fit=crop'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Wealth Coaching', style: AppTextStyles.headlineMd),
            const SizedBox(height: 4),
            const Text('Personalized strategies for your portfolio.', style: TextStyle(color: AppColors.outline, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String? name) {
    switch (name) {
      case 'restaurant': return Icons.restaurant;
      case 'directions_car': return Icons.directions_car;
      case 'home': return Icons.home_outlined;
      case 'shopping_bag': return Icons.shopping_bag_outlined;
      case 'movie': return Icons.movie_outlined;
      default: return Icons.category_outlined;
    }
  }
}
