import 'package:expense_app/barGraph/individual_bar.dart';
import 'package:expense_app/helper/helper_functions.dart';
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

  final List<double> monthlySummary;
  final int startMonth;

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  List<IndividualBar> barData = [];
  late final ScrollController _scrollController;

  void initializeBarData() {
    barData = List.generate(
      widget.monthlySummary.length,
      (index) => IndividualBar(
        x: (widget.startMonth + index) - 1,
        y: widget.monthlySummary[index],
      ),
    );
  }

  double calculateMax() {
    double max = 500;

    widget.monthlySummary.sort();

    max = widget.monthlySummary.last * 1.5;

    if (max < 500) {
      return 500;
    }

    return max;
  }

  void scrollToEnd() {
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

    Future.delayed(Duration.zero, () => scrollToEnd());
  }

  @override
  Widget build(BuildContext context) {
    // initialize upon build
    initializeBarData();

    double barWidth = 20;
    double spaceBetweenBars = 15;

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
              maxY: calculateMax(),
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
                            fontSize: Constants.defaultFontSize,
                            fontWeight: FontWeight.bold,
                            color: MyColors.base300,
                          ),
                        ),
                      );
                    },
                    reservedSize: 26,
                  ),
                ),
              ),
              barGroups: barData
                  .map(
                    (data) => BarChartGroupData(
                      x: data.x,
                      barRods: [
                        BarChartRodData(
                          toY: data.y,
                          width: barWidth,
                          borderRadius: BorderRadius.circular(5),
                          color: MyColors.base300Shade800,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: calculateMax(),
                            color: MyColors.base100,
                          ),
                        )
                      ],
                    ),
                  )
                  .toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: spaceBetweenBars,
            ),
          ),
        ),
      ),
    );
  }
}
