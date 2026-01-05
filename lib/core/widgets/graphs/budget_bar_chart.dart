import 'package:eyvo_v3/api/response_models/budget_bar_chart_dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BudgetBarChart extends StatelessWidget {
  final BudgetData data;

  const BudgetBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.95,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          toggleSeriesVisibility: true,
          overflowMode: LegendItemOverflowMode.wrap,
          alignment: ChartAlignment.center,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: '₹ point.y',
        ),
        primaryXAxis: CategoryAxis(
          majorTickLines: const MajorTickLines(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 1),
          labelsExtent: 0,
          title: AxisTitle(
            text: 'This Financial Year',
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 1),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          title: AxisTitle(
            text: 'Amount',
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        series: <CartesianSeries>[
          ColumnSeries<_ChartData, String>(
            name: 'Total Budget',
            dataSource: [_ChartData('FY', data.totalBudget)],
            xValueMapper: (_ChartData d, _) => d.label,
            yValueMapper: (_ChartData d, _) => d.value,
            color: Colors.blue,
            width: 0.8,
            spacing: 0.2,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
          ColumnSeries<_ChartData, String>(
            name: 'Spent So Far',
            dataSource: [_ChartData('FY', data.spentSoFar)],
            xValueMapper: (_ChartData d, _) => d.label,
            yValueMapper: (_ChartData d, _) => d.value,
            color: Colors.red,
            width: 0.8,
            spacing: 0.2,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
          ColumnSeries<_ChartData, String>(
            name: 'Before Approval',
            dataSource: [_ChartData('FY', data.beforeApproval)],
            xValueMapper: (_ChartData d, _) => d.label,
            yValueMapper: (_ChartData d, _) => d.value,
            color: Colors.orange,
            width: 0.8,
            spacing: 0.2,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
          ColumnSeries<_ChartData, String>(
            name: 'After Approval',
            dataSource: [_ChartData('FY', data.afterApproval)],
            xValueMapper: (_ChartData d, _) => d.label,
            yValueMapper: (_ChartData d, _) => d.value,
            color: Colors.green,
            width: 0.8,
            spacing: 0.2,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  final String label;
  final double value;

  _ChartData(this.label, this.value);
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
