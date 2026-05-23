import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';
import '../../providers/settings_provider.dart';
import 'transaction_added_screen.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final String transactionType;

  const TransactionDetailsScreen({super.key, required this.transactionType});

  @override
  State<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'food';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Transaction'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountInput(),
            const SizedBox(height: 32),
            _buildCategorySelector(),
            const SizedBox(height: 32),
            _buildDatePicker(),
            const SizedBox(height: 32),
            _buildNoteInput(),
            const SizedBox(height: 32),
            _buildReceiptPlaceholder(),
            const SizedBox(height: 48),
            _buildSaveButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    final settings = context.watch<SettingsProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AMOUNT', style: AppTextStyles.labelMd),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(settings.selectedCurrency.symbol, style: AppTextStyles.displayLg.copyWith(color: AppColors.outline)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: AppTextStyles.displayLg,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0.00',
                  hintStyle: TextStyle(color: AppColors.surfaceContainerHigh),
                ),
              ),
            ),
            const Icon(Icons.unfold_more, color: AppColors.outline),
          ],
        ),
        Center(
          child: Container(
            width: 100,
            height: 2,
            color: AppColors.outlineVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.labelMd),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: TransactionCategory.all.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = TransactionCategory.all[index];
              final isSelected = _selectedCategory == cat.id;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat.id),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isSelected ? Color(cat.colorValue).withOpacity(0.2) : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected ? Border.all(color: Color(cat.colorValue), width: 2) : null,
                        boxShadow: isSelected ? [BoxShadow(color: Color(cat.colorValue).withOpacity(0.3), blurRadius: 10)] : null,
                      ),
                      child: Icon(_getIcon(cat.icon), color: isSelected ? Color(cat.colorValue) : AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    Text(cat.label, style: AppTextStyles.labelMd.copyWith(color: isSelected ? AppColors.onSurface : AppColors.outline)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date', style: AppTextStyles.labelMd),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) setState(() => _selectedDate = date);
          },
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Text(DateFormat('MM/dd/yyyy').format(_selectedDate), style: AppTextStyles.bodyMd),
                const Spacer(),
                const Icon(Icons.calendar_month, color: AppColors.outline, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Note (Optional)', style: AppTextStyles.labelMd),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              icon: const Icon(Icons.notes, color: AppColors.primary, size: 20),
              hintText: 'What was this for?',
              hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1554224155-672629188427?auto=format&fit=crop&q=80&w=1000'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Receipt Attached', style: TextStyle(fontSize: 12)),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: AppColors.surface.withOpacity(0.6),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: () async {
          final amount = double.tryParse(_amountController.text) ?? 0.0;
          if (amount <= 0) return;

          final provider = context.read<TransactionProvider>();
          await provider.addTransaction(
            type: widget.transactionType,
            amount: amount,
            category: _selectedCategory,
            note: _noteController.text,
            date: _selectedDate,
          );

          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => TransactionAddedScreen(
                  amount: amount,
                  category: _selectedCategory,
                  date: _selectedDate,
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text('SAVE TRANSACTION', style: AppTextStyles.headlineMd.copyWith(color: AppColors.background)),
      ),
    );
  }

  IconData _getIcon(String name) {
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
