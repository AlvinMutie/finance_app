import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/transaction_model.dart';
import '../../widgets/glass_card.dart';

class TransactionsLedgerScreen extends StatefulWidget {
  const TransactionsLedgerScreen({super.key});

  @override
  State<TransactionsLedgerScreen> createState() => _TransactionsLedgerScreenState();
}

class _TransactionsLedgerScreenState extends State<TransactionsLedgerScreen> {
  String _searchQuery = '';

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
    
    // Group transactions by date
    final Map<String, List<TransactionModel>> groupedTransactions = {};
    for (var tx in txProvider.transactions) {
      if (_searchQuery.isNotEmpty && 
          !tx.note.toLowerCase().contains(_searchQuery.toLowerCase()) && 
          !tx.category.toLowerCase().contains(_searchQuery.toLowerCase())) {
        continue;
      }
      final dateStr = DateFormat('MMMM d, y').format(tx.date);
      if (groupedTransactions[dateStr] == null) {
        groupedTransactions[dateStr] = [];
      }
      groupedTransactions[dateStr]!.add(tx);
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          if (txProvider.transactions.isEmpty)
            _buildEmptyState()
          else ...[
            _buildSummaryCard(txProvider, settings),
            ...groupedTransactions.entries.map((entry) {
              return _buildTransactionGroup(entry.key, entry.value, settings);
            }),
          ],
          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppColors.background.withOpacity(0.8),
      title: Text('Transaction Ledger', style: AppTextStyles.headlineMd),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search transactions...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.surfaceContainer,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(TransactionProvider provider, SettingsProvider settings) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                _buildSummaryItem('INCOME', settings.formatAmount(provider.monthlyIncome), AppColors.secondary),
                Container(width: 1, height: 40, color: AppColors.cardBorder),
                _buildSummaryItem('EXPENSES', settings.formatAmount(provider.monthlyExpense), AppColors.error),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: AppTextStyles.labelSm),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.bodyLg.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTransactionGroup(String date, List<TransactionModel> txs, SettingsProvider settings) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(date.toUpperCase(), style: AppTextStyles.labelMd.copyWith(letterSpacing: 1.5, color: AppColors.outline)),
          ),
          ...txs.map((tx) => _buildTransactionItem(tx, settings)),
        ]),
      ),
    );
  }

  Widget _buildTransactionItem(TransactionModel tx, SettingsProvider settings) {
    final isExpense = tx.type == 'expense';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key(tx.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.delete_outline, color: Colors.white),
        ),
        onDismissed: (direction) {
          context.read<TransactionProvider>().deleteTransaction(tx.id);
        },
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isExpense ? AppColors.error.withOpacity(0.1) : AppColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isExpense ? Icons.arrow_outward : Icons.arrow_downward,
                  color: isExpense ? AppColors.error : AppColors.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx.category, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold)),
                    Text(tx.note, style: AppTextStyles.labelMd, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Text(
                (isExpense ? '- ' : '+ ') + settings.formatAmount(tx.amount),
                style: AppTextStyles.bodyLg.copyWith(
                  color: isExpense ? AppColors.error : AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.outline.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text('No transactions yet', style: AppTextStyles.headlineMd),
            Text('Your ledger will appear here', style: AppTextStyles.labelMd),
          ],
        ),
      ),
    );
  }
}
