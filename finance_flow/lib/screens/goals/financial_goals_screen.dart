import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../theme/app_theme.dart';
import '../../providers/goal_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/goal_model.dart';
import '../../widgets/glass_card.dart';

class FinancialGoalsScreen extends StatefulWidget {
  const FinancialGoalsScreen({super.key});

  @override
  State<FinancialGoalsScreen> createState() => _FinancialGoalsScreenState();
}

class _FinancialGoalsScreenState extends State<FinancialGoalsScreen> {
  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();
    final settings = context.watch<SettingsProvider>();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildTotalSavedCard(goalProvider, settings),
                  const SizedBox(height: 40),
                  _buildSectionHeader('YOUR GOALS', goalProvider.goals.length.toString()),
                  const SizedBox(height: 16),
                  if (goalProvider.goals.isEmpty)
                    _buildEmptyGoals()
                  else
                    ...goalProvider.goals.map((goal) => _buildGoalCard(goal, settings)),
                  const SizedBox(height: 24),
                  _buildCreateGoalCard(),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: AppColors.background.withOpacity(0.8),
      title: Text('Financial Goals', style: AppTextStyles.headlineMd),
      centerTitle: true,
    );
  }

  Widget _buildTotalSavedCard(GoalProvider provider, SettingsProvider settings) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOTAL SAVED', style: AppTextStyles.labelMd.copyWith(color: AppColors.tertiary)),
              const SizedBox(height: 8),
              Text(settings.formatAmount(provider.totalSaved), style: AppTextStyles.headlineLg.copyWith(fontSize: 40)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.stars, color: AppColors.tertiary, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.labelMd.copyWith(letterSpacing: 2)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(count, style: AppTextStyles.labelSm),
        ),
      ],
    );
  }

  Widget _buildGoalCard(GoalModel goal, SettingsProvider settings) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(goal.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.delete_outline, color: Colors.white, size: 32),
        ),
        onDismissed: (direction) {
          context.read<GoalProvider>().deleteGoal(goal.id);
        },
        child: GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(goal.colorValue).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getIcon(goal.iconId), color: Color(goal.colorValue)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(goal.name, style: AppTextStyles.headlineMd),
                        Text(goal.subtitle.isEmpty ? 'Your Goal' : goal.subtitle, style: AppTextStyles.labelMd),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(settings.formatAmount(goal.savedAmount), style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold)),
                      Text('of ${settings.formatAmount(goal.targetAmount)}', style: AppTextStyles.labelSm),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: goal.progress,
                backgroundColor: AppColors.surfaceContainer,
                color: Color(goal.colorValue),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${goal.progressPercent}% Complete', style: AppTextStyles.labelSm.copyWith(color: Color(goal.colorValue))),
                  Text(settings.formatAmount(goal.remaining) + ' left', style: AppTextStyles.labelSm),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateGoalCard() {
    return GestureDetector(
      onTap: () => _showAddGoalDialog(context),
      child: DottedBorder(
        color: AppColors.primary.withOpacity(0.3),
        strokeWidth: 2,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 32),
              const SizedBox(height: 12),
              Text('Create New Goal', style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
              Text('Set a new milestone', style: AppTextStyles.labelMd),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyGoals() {
    return Column(
      children: [
        Icon(Icons.flag_outlined, size: 64, color: AppColors.outline.withOpacity(0.5)),
        const SizedBox(height: 16),
        Text('No goals set', style: AppTextStyles.headlineMd),
        Text('Start by creating your first goal', style: AppTextStyles.labelMd),
      ],
    );
  }

  IconData _getIcon(String id) {
    switch (id) {
      case 'ac_unit': return Icons.ac_unit;
      case 'umbrella': return Icons.umbrella_outlined;
      case 'savings': return Icons.savings_outlined;
      case 'flight': return Icons.flight;
      case 'home': return Icons.home;
      case 'directions_car': return Icons.directions_car;
      default: return Icons.flag;
    }
  }

  void _showAddGoalDialog(BuildContext context) {
    // Basic dialog implementation
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('New Goal', style: AppTextStyles.headlineMd),
            const SizedBox(height: 24),
            // Placeholder for form fields
            Text('Goal Creation Form Placeholder', style: AppTextStyles.bodyMd),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
