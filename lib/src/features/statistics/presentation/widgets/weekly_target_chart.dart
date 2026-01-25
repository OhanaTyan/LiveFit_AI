import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class WeeklyTargetChart extends StatelessWidget {
  const WeeklyTargetChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.weeklyTarget,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Icon(
                Icons.bar_chart,
                color: AppColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.blueGrey,
                    tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                    tooltipMargin: -10,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String weekDay;
                      switch (group.x) {
                        case 0: weekDay = l10n.mon; break;
                        case 1: weekDay = l10n.tue; break;
                        case 2: weekDay = l10n.wed; break;
                        case 3: weekDay = l10n.thu; break;
                        case 4: weekDay = l10n.fri; break;
                        case 5: weekDay = l10n.sat; break;
                        case 6: weekDay = l10n.sun; break;
                        default: throw Error();
                      }
                      return BarTooltipItem(
                        '$weekDay\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: (rod.toY - 1).toString(),
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final style = TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        Widget text;
                        // For brevity, we use first letter. In Chinese '周' is common prefix, so maybe just 一, 二 etc or full name.
                        // Let's use simple logic: if english, first letter. If Chinese, last char (一, 二...)
                        String label = '';
                        switch (value.toInt()) {
                          case 0: label = l10n.mon; break;
                          case 1: label = l10n.tue; break;
                          case 2: label = l10n.wed; break;
                          case 3: label = l10n.thu; break;
                          case 4: label = l10n.fri; break;
                          case 5: label = l10n.sat; break;
                          case 6: label = l10n.sun; break;
                        }
                        
                        // Simple abbreviation logic
                        if (label.isNotEmpty) {
                           if (l10n.locale.languageCode == 'zh') {
                              // "周一" -> "一"
                              text = Text(label.length > 1 ? label.substring(1) : label, style: style);
                           } else {
                              // "Monday" -> "M"
                              text = Text(label.substring(0, 1), style: style);
                           }
                        } else {
                           text = Text('', style: style);
                        }

                        return SideTitleWidget(
                          meta: meta,
                          space: 16,
                          child: text,
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  makeGroupData(0, 5, isTouched: true),
                  makeGroupData(1, 6.5),
                  makeGroupData(2, 5),
                  makeGroupData(3, 7.5),
                  makeGroupData(4, 9),
                  makeGroupData(5, 11.5),
                  makeGroupData(6, 6.5),
                ],
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= AppColors.secondary;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? AppColors.primary : barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: AppColors.primary, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barColor.withValues(alpha: 0.1),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
