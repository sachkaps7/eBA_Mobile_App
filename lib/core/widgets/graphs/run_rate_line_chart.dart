import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RunRateLineChart extends StatelessWidget {
  const RunRateLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_RunRateData> data = [
      _RunRateData('Jan', 1000, 10000, 7500, 7800),
      _RunRateData('Feb', 2000, 10000, 7500, 7800),
      _RunRateData('Mar', 6000, 10000, 7500, 7800),
      _RunRateData('Apr', 8000, 10000, 7500, 7800),
      _RunRateData('May', 16000, 20000, 14000, 15000),
      _RunRateData('Jun', 24000, 30000, 26000, 25000),
      _RunRateData('Jul', 32000, 40000, 35000, 33000),
      _RunRateData('Aug', 40000, 50000, 42000, 41000),
      _RunRateData('Sep', 40000, 60000, 55000, 53000),
      _RunRateData('Oct', 48000, 62000, 53000, 53000),
      _RunRateData('Nov', 42000, 60000, 55000, 53000),
      _RunRateData('Dec', 46000, 61000, 57000, 53000),
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.95,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,

        // Legend
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
          alignment: ChartAlignment.center,
          toggleSeriesVisibility: true,
        ),

        tooltipBehavior: TooltipBehavior(enable: true, format: '₹ point.y'),

        // X Axis (Months)
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          axisLine: const AxisLine(width: 1),
          title: AxisTitle(
            text: 'Months',
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Y Axis (Amount)
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          axisLine: const AxisLine(width: 1),
          title: AxisTitle(
            text: 'Amount',
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        series: <ChartSeries>[
          //Budgeted Run Rate
          LineSeries<_RunRateData, String>(
            name: 'Budgeted Run Rate',
            dataSource: data,
            xValueMapper: (_RunRateData d, _) => d.month,
            yValueMapper: (_RunRateData d, _) => d.budgetedRunRate,
            color: Colors.blue,
            markerSettings: const MarkerSettings(isVisible: true),
          ),

          // Monthly Budget
          LineSeries<_RunRateData, String>(
            name: 'Monthly Budget',
            dataSource: data,
            xValueMapper: (_RunRateData d, _) => d.month,
            yValueMapper: (_RunRateData d, _) => d.monthlyBudget,
            color: Colors.orange,
            markerSettings: const MarkerSettings(isVisible: true),
          ),

          // Actual Spend
          LineSeries<_RunRateData, String>(
            name: 'Actual Spend',
            dataSource: data,
            xValueMapper: (_RunRateData d, _) => d.month,
            yValueMapper: (_RunRateData d, _) => d.actualSpend,
            color: Colors.red,
            markerSettings: const MarkerSettings(isVisible: true),
          ),

          // Average Spend Run Rate
          LineSeries<_RunRateData, String>(
            name: 'Avg Spend Run Rate',
            dataSource: data,
            xValueMapper: (_RunRateData d, _) => d.month,
            yValueMapper: (_RunRateData d, _) => d.avgRunRate,
            color: Colors.green,
            dashArray: const [6, 4],
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

class _RunRateData {
  final String month;
  final double budgetedRunRate;
  final double monthlyBudget;
  final double actualSpend;
  final double avgRunRate;

  _RunRateData(
    this.month,
    this.budgetedRunRate,
    this.monthlyBudget,
    this.actualSpend,
    this.avgRunRate,
  );
}
