import 'package:expense_app/helpers/helper_functions.dart';
import 'package:expense_app/utils/constants.dart';
import 'package:expense_app/utils/my_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  const MyBarGraph({
    super.key,
    required this.monthlySummary,
    required this.startMonth,
  });

  final List<Map<String, dynamic>> monthlySummary;
  final int startMonth;

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  final String incomesKey = 'incomes';
  final String expensesKey = 'expenses';
  List<Map<String, dynamic>> barData = [];

  late final ScrollController _scrollController;

  void _initializeBarData() {
    barData = List.generate(
      widget.monthlySummary.length,
      (index) {
        final monthlySummaryMap = widget.monthlySummary[index];

        return {
          'month': (widget.startMonth + index) - 1,
          'summary': [
            monthlySummaryMap[incomesKey] ?? 0.0,
            monthlySummaryMap[expensesKey] ?? 0.0,
          ],
        };
      },
    );
  }

  double _calculateMax() {
    const double max_ = 500;
    double max = max_;

    List<double> amounts = [];

    for (final map in widget.monthlySummary) {
      amounts.addAll(
        [
          map[incomesKey],
          map[expensesKey],
        ],
      );
    }

    amounts.sort();

    max = amounts.last * 1.5;

    if (max < max_) return max_;

    return max;
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    Future.delayed(Duration.zero, () => _scrollToEnd());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initialize upon build
    _initializeBarData();

    const double barWidth = 20;
    const double spaceBetweenBars = 75;

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constants.defaultMargin),
        child: SizedBox(
          width: barWidth * barData.length + spaceBetweenBars * (barData.length - 1),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: _calculateMax(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      String text = getMonthByNumber(value);

                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          text,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Constants.defaultFontSize,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      );
                    },
                    reservedSize: 26,
                  ),
                ),
              ),
              barGroups: barData.map(
                (data) {
                  return BarChartGroupData(
                    x: data['month'],
                    barRods: data['summary'].asMap().entries.map<BarChartRodData>(
                      (entry) {
                        final bool isIncome = entry.key == 0;
                        final double value = entry.value;

                        return BarChartRodData(
                          toY: value,
                          width: barWidth,
                          borderRadius: BorderRadius.circular(Constants.borderRadius),
                          color: isIncome ? MyColors.success : Theme.of(context).colorScheme.errorContainer,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: _calculateMax(),
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              ).toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: spaceBetweenBars,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Theme.of(context).colorScheme.secondaryContainer,
                  tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY}',
                      TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
