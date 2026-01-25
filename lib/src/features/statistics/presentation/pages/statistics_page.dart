import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../widgets/summary_stat_card.dart';
import '../widgets/activity_trend_chart.dart';
import '../widgets/weekly_target_chart.dart';
import '../widgets/workout_type_pie_chart.dart';
import 'stats_share_page.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _selectedPeriodIndex = 0; // 0: Week, 1: Month, 2: Year

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.statistics),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StatsSharePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(l10n),
            const SizedBox(height: 24),
            _buildSummaryCards(l10n),
            const SizedBox(height: 24),
            const ActivityTrendChart(),
            const SizedBox(height: 24),
            const WeeklyTargetChart(),
            const SizedBox(height: 24),
            const WorkoutTypePieChart(),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.borderLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildPeriodButton(0, l10n.week),
          _buildPeriodButton(1, l10n.month),
          _buildPeriodButton(2, l10n.year),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(int index, String text) {
    final isSelected = _selectedPeriodIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriodIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.black
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: SummaryStatCard(
            title: l10n.time,
            value: '5h 20m',
            unit: l10n.unitHours,
            icon: Icons.access_time_filled,
            iconColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryStatCard(
            title: l10n.calories,
            value: '1,240',
            unit: l10n.unitKcal,
            icon: Icons.local_fire_department,
            iconColor: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryStatCard(
            title: l10n.workouts,
            value: '12',
            unit: l10n.unitCount,
            icon: Icons.fitness_center,
            iconColor: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
