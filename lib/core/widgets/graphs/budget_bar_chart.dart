import 'package:eyvo_v3/api/response_models/expanse_chart_model.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BudgetBarChart extends StatefulWidget {
  final BudgetData data;
  final String financialYear;

  const BudgetBarChart(
      {super.key, required this.data, required this.financialYear});

  @override
  State<BudgetBarChart> createState() => _BudgetBarChartState();
}

class _BudgetBarChartState extends State<BudgetBarChart> {
  double _getMaxValueWithPadding() {
    final maxValue = [
      widget.data.totalBudget,
      widget.data.spentSoFar,
      widget.data.beforeApproval,
      widget.data.afterApproval,
    ].reduce((a, b) => a > b ? a : b);

    return maxValue * 1.2;
  }

  double _getYAxisInterval(double maxValue) {
    return maxValue / 4;
  }

  @override
  Widget build(BuildContext context) {
    final double yAxisMax = _getMaxValueWithPadding();
    return Card(
      color: ColorManager.white,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Expance Overview',
                      style: getBoldStyle(
                          color: ColorManager.black, fontSize: FontSize.s14)),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorManager.highlightColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: ColorManager.highlightColor,
                  ),
                  child: Text(
                    widget.financialYear.isEmpty
                        ? 'FY'
                        : 'FY ${widget.financialYear}',
                    style: getBoldStyle(
                      color: ColorManager.grey,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width * 0.98,
              child: SfCartesianChart(
                backgroundColor: ColorManager.white,
                plotAreaBorderWidth: 0,
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                  alignment: ChartAlignment.far,
                  itemPadding: 8,
                  legendItemBuilder:
                      (String name, dynamic series, dynamic point, int index) {
                    double value = 0;

                    switch (name) {
                      case 'Total Budget':
                        value = widget.data.totalBudget;
                        break;
                      case 'Spent So Far':
                        value = widget.data.spentSoFar;
                        break;
                      case 'Before Approval':
                        value = widget.data.beforeApproval;
                        break;
                      case 'After Approval':
                        value = widget.data.afterApproval;
                        break;
                    }

                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(top: 4, right: 8),
                            decoration: BoxDecoration(
                              color: series.color,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: getBoldStyle(
                                        color: ColorManager.lightGrey,
                                        fontSize: FontSize.s14)),
                                Text('₹${value.toStringAsFixed(0)}',
                                    style: getSemiBoldStyle(
                                        color: ColorManager.black,
                                        fontSize: FontSize.s12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                    text: 'THIS FINANCIAL YEAR',
                    textStyle: getSemiBoldStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.grey,
                    ),
                  ),
                ),
                // primaryYAxis: NumericAxis(
                //   axisLine: const AxisLine(width: 1),
                //   majorTickLines: const MajorTickLines(width: 0),
                //   majorGridLines: MajorGridLines(
                //     width: 1,
                //     dashArray: const [5, 5],
                //     color: ColorManager.lightGrey4,
                //   ),
                //   interval: (data.totalBudget / 2),
                //   minimum: 0,
                //   maximum: data.totalBudget,
                //   numberFormat: NumberFormat.compact(),
                //   title: AxisTitle(
                //     text: 'AMOUNT(USD)',
                //     textStyle: getSemiBoldStyle(
                //       fontSize: FontSize.s12,
                //       color: ColorManager.grey,
                //     ),
                //   ),
                // ),

                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 1),
                  majorTickLines: const MajorTickLines(width: 0),
                  majorGridLines: MajorGridLines(
                    width: 1,
                    dashArray: const [5, 5],
                    color: ColorManager.lightGrey4,
                  ),
                  minimum: 0,
                  maximum: yAxisMax,
                  interval: _getYAxisInterval(yAxisMax),
                  numberFormat: NumberFormat.compact(),
                  title: AxisTitle(
                    text: 'AMOUNT(USD)',
                    textStyle: getSemiBoldStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.grey,
                    ),
                  ),
                ),

                series: <CartesianSeries>[
                  ColumnSeries<_ChartData, String>(
                    name: 'Total Budget',
                    dataSource: [_ChartData('FY', widget.data.totalBudget)],
                    xValueMapper: (_ChartData d, _) => d.label,
                    yValueMapper: (_ChartData d, _) => d.value,
                    color: ColorManager.lightBlue,
                    width: 0.8,
                    spacing: 0.2,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                  ColumnSeries<_ChartData, String>(
                    name: 'Spent So Far',
                    dataSource: [_ChartData('FY', widget.data.spentSoFar)],
                    xValueMapper: (_ChartData d, _) => d.label,
                    yValueMapper: (_ChartData d, _) => d.value,
                    color: ColorManager.red,
                    width: 0.8,
                    spacing: 0.2,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                  ColumnSeries<_ChartData, String>(
                    name: 'Before Approval',
                    dataSource: [_ChartData('FY', widget.data.beforeApproval)],
                    xValueMapper: (_ChartData d, _) => d.label,
                    yValueMapper: (_ChartData d, _) => d.value,
                    color: ColorManager.orange,
                    width: 0.8,
                    spacing: 0.2,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                  ColumnSeries<_ChartData, String>(
                    name: 'After Approval',
                    dataSource: [_ChartData('FY', widget.data.afterApproval)],
                    xValueMapper: (_ChartData d, _) => d.label,
                    yValueMapper: (_ChartData d, _) => d.value,
                    color: ColorManager.green,
                    width: 0.8,
                    spacing: 0.2,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                ],
              ),
            ),
          ],
        ),
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
