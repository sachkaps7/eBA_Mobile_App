// import 'package:eyvo_v3/core/resources/color_manager.dart';
// import 'package:eyvo_v3/core/resources/font_manager.dart';
// import 'package:eyvo_v3/core/resources/styles_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class RunRateLineChart extends StatelessWidget {
//   const RunRateLineChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<_RunRateData> data = [
//       _RunRateData('Jan', 1000, 10000, 7500, 7800),
//       _RunRateData('Feb', 2000, 10000, 7500, 7800),
//       _RunRateData('Mar', 6000, 10000, 7500, 7800),
//       _RunRateData('Apr', 8000, 10000, 7500, 7800),
//       _RunRateData('May', 16000, 20000, 14000, 15000),
//       _RunRateData('Jun', 24000, 30000, 26000, 25000),
//       _RunRateData('Jul', 32000, 40000, 35000, 33000),
//       _RunRateData('Aug', 40000, 50000, 42000, 41000),
//       _RunRateData('Sep', 40000, 60000, 55000, 53000),
//       _RunRateData('Oct', 48000, 62000, 53000, 53000),
//       _RunRateData('Nov', 42000, 60000, 55000, 53000),
//       _RunRateData('Dec', 46000, 61000, 57000, 53000),
//     ];
//     final double budgetedValue = data.last.budgetedRunRate;
//     final double monthlyBudgetValue = data.last.monthlyBudget;
//     final double actualSpendValue = data.last.actualSpend;
//     final double avgRunRateValue = data.last.avgRunRate;

//     final double maxY = data
//         .map((e) => [
//               e.budgetedRunRate,
//               e.monthlyBudget,
//               e.actualSpend,
//               e.avgRunRate,
//             ])
//         .expand((e) => e)
//         .reduce((a, b) => a > b ? a : b);
//     return Card(
//       color: ColorManager.white,
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const SizedBox(
//                 width: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Text('Run Rate Chart',
//                     style: getBoldStyle(
//                         color: ColorManager.black, fontSize: FontSize.s14)),
//               ),
//               const Spacer(),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: ColorManager.highlightColor,
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   color: ColorManager.highlightColor,
//                 ),
//                 child: Text(
//                   'FY 2024-2025',
//                   style: getBoldStyle(
//                     color: ColorManager.grey,
//                     fontSize: FontSize.s12,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               )
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height * 0.35,
//               width: MediaQuery.of(context).size.width * 0.95,
//               child: SfCartesianChart(
//                 backgroundColor: ColorManager.white,
//                 plotAreaBorderWidth: 0,

//                 // Legend
//                 legend: Legend(
//                   isVisible: true,
//                   position: LegendPosition.bottom,
//                   overflowMode: LegendItemOverflowMode.wrap,
//                   alignment: ChartAlignment.far,
//                   itemPadding: 8,
//                   legendItemBuilder:
//                       (String name, dynamic series, dynamic point, int index) {
//                     return SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.4,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 10,
//                             height: 10,
//                             margin: const EdgeInsets.only(right: 8),
//                             decoration: BoxDecoration(
//                               color: series.color,
//                               shape: BoxShape.rectangle,
//                             ),
//                           ),
//                           Expanded(
//                             child: Text(
//                               name,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: getBoldStyle(
//                                 color: ColorManager.black,
//                                 fontSize: FontSize.s14,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),

//                 tooltipBehavior:
//                     TooltipBehavior(enable: true, format: '₹ point.y'),

//                 // X Axis (Months)
//                 primaryXAxis: CategoryAxis(
//                   majorGridLines: const MajorGridLines(width: 0),
//                   majorTickLines: const MajorTickLines(width: 0),
//                   axisLine: const AxisLine(width: 1),
//                   title: AxisTitle(
//                     text: 'Months',
//                     textStyle: getSemiBoldStyle(
//                       fontSize: FontSize.s12,
//                       color: ColorManager.grey,
//                     ),
//                   ),
//                 ),

//                 // Y Axis (Amount)
//                 primaryYAxis: NumericAxis(
//                   minimum: 0,
//                   maximum: maxY,
//                   interval: maxY / 2,
//                   numberFormat: NumberFormat.compact(),
//                   majorGridLines: MajorGridLines(
//                     width: 1,
//                     dashArray: const [6, 4],
//                     color: ColorManager.grey,
//                   ),
//                   majorTickLines: const MajorTickLines(width: 0),
//                   axisLine: const AxisLine(width: 1),
//                   title: AxisTitle(
//                     text: 'Amount (USD)',
//                     textStyle: getSemiBoldStyle(
//                       fontSize: FontSize.s12,
//                       color: ColorManager.grey,
//                     ),
//                   ),
//                 ),

//                 series: <ChartSeries>[
//                   //Budgeted Run Rate
//                   LineSeries<_RunRateData, String>(
//                     name: 'Budgeted Run Rate',
//                     dataSource: data,
//                     xValueMapper: (_RunRateData d, _) => d.month,
//                     yValueMapper: (_RunRateData d, _) => d.budgetedRunRate,
//                     color: ColorManager.lightBlue,
//                     markerSettings: const MarkerSettings(isVisible: true),
//                   ),

//                   // Monthly Budget
//                   LineSeries<_RunRateData, String>(
//                     name: 'Monthly Budget',
//                     dataSource: data,
//                     xValueMapper: (_RunRateData d, _) => d.month,
//                     yValueMapper: (_RunRateData d, _) => d.monthlyBudget,
//                     color: ColorManager.orange,
//                     markerSettings: const MarkerSettings(isVisible: true),
//                   ),

//                   // Actual Spend
//                   LineSeries<_RunRateData, String>(
//                     name: 'Actual Spend',
//                     dataSource: data,
//                     xValueMapper: (_RunRateData d, _) => d.month,
//                     yValueMapper: (_RunRateData d, _) => d.actualSpend,
//                     color: ColorManager.red,
//                     markerSettings: const MarkerSettings(isVisible: true),
//                   ),

//                   // Average Spend Run Rate
//                   LineSeries<_RunRateData, String>(
//                     name: 'Avg Spend Run Rate',
//                     dataSource: data,
//                     xValueMapper: (_RunRateData d, _) => d.month,
//                     yValueMapper: (_RunRateData d, _) => d.avgRunRate,
//                     color: ColorManager.green,
//                     dashArray: const [6, 4],
//                     markerSettings: const MarkerSettings(isVisible: true),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _RunRateData {
//   final String month;
//   final double budgetedRunRate;
//   final double monthlyBudget;
//   final double actualSpend;
//   final double avgRunRate;

//   _RunRateData(
//     this.month,
//     this.budgetedRunRate,
//     this.monthlyBudget,
//     this.actualSpend,
//     this.avgRunRate,
//   );
// }
import 'package:eyvo_v3/api/response_models/run_rate_chart_response.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RunRateLineChart extends StatefulWidget {
  final List<RunRateData> apiData;
  final String financialYear;

  const RunRateLineChart({
    super.key,
    required this.apiData,
    required this.financialYear,
  });

  @override
  State<RunRateLineChart> createState() => _RunRateLineChartState();
}

class _RunRateLineChartState extends State<RunRateLineChart> {
  late List<RunRateData> monthlyData;
  late List<double> cumulativeMonthlyBudget;
  late double maxY;

  final List<String> allMonths = const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  @override
  void didUpdateWidget(covariant RunRateLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.apiData != widget.apiData) {
      final apiMonthlyData =
          widget.apiData.where((d) => (d.mname?.isNotEmpty ?? false)).toList();

      final Map<String, RunRateData> dataMap = {
        for (final d in apiMonthlyData) d.mname!: d
      };

      monthlyData = allMonths.map((month) {
        return dataMap[month] ??
            RunRateData(
              mname: month,
              monthlyBudget: 0,
              totalSpent: 0,
              avgRunRate: 0,
              budget: 0,
            );
      }).toList();

      cumulativeMonthlyBudget = _getCumulativeMonthlyBudget();
      maxY = _getMaxY();

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    final apiMonthlyData =
        widget.apiData.where((d) => (d.mname?.isNotEmpty ?? false)).toList();

    final Map<String, RunRateData> dataMap = {
      for (final d in apiMonthlyData) d.mname!: d
    };

    monthlyData = allMonths.map((month) {
      return dataMap[month] ??
          RunRateData(
            mname: month,
            monthlyBudget: 0,
            totalSpent: 0,
            avgRunRate: 0,
            budget: 0,
          );
    }).toList();

    //  Calculate cumulative budget
    cumulativeMonthlyBudget = _getCumulativeMonthlyBudget();

    //  Calculate Y axis max
    maxY = _getMaxY();
  }

  List<double> _getCumulativeMonthlyBudget() {
    double runningTotal = 0;
    return monthlyData.map((d) {
      runningTotal += d.monthlyBudget ?? 0;
      return runningTotal;
    }).toList();
  }

  double _getMaxY() {
    final values = <double>[];

    for (int i = 0; i < monthlyData.length; i++) {
      final d = monthlyData[i];
      values.addAll([
        cumulativeMonthlyBudget[i],
        d.monthlyBudget ?? 0,
        d.totalSpent ?? 0,
        d.avgRunRate ?? 0,
      ]);
    }

    if (values.isEmpty) return 0;

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue == 0 ? 10 : maxValue * 1.2; // fallback height
  }

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Card(
      color: ColorManager.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ---------------- HEADER ----------------
          Row(
            children: [
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Run Rate Chart',
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.highlightColor),
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
              const SizedBox(width: 10),
            ],
          ),

          // ---------------- CHART ----------------
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 15, 10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 0.95,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                backgroundColor: ColorManager.white,

                // Legend
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                  alignment: ChartAlignment.far,
                  itemPadding: 8,
                  legendItemBuilder:
                      (String name, dynamic series, dynamic point, int index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: series.color,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                tooltipBehavior:
                    TooltipBehavior(enable: true, format: ' point.y'),

                // -------- X Axis --------
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 1),
                  title: AxisTitle(
                    text: 'Months',
                    textStyle: getSemiBoldStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.grey,
                    ),
                  ),
                  interval: 1,
                  labelPlacement: LabelPlacement.onTicks,
                ),

                // -------- Y Axis --------
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: maxY,
                  interval: maxY / 4,
                  numberFormat: NumberFormat.compact(),
                  majorGridLines: MajorGridLines(
                    dashArray: const [6, 4],
                    color: ColorManager.grey,
                  ),
                  axisLine: const AxisLine(width: 1),
                  title: AxisTitle(
                    text: 'Amount (USD)',
                    textStyle: getSemiBoldStyle(
                      fontSize: FontSize.s12,
                      color: ColorManager.grey,
                    ),
                  ),
                ),

                // -------- SERIES --------
                series: <ChartSeries>[
                  LineSeries<RunRateData, String>(
                    name: 'Monthly Budget',
                    dataSource: monthlyData,
                    xValueMapper: (d, _) => d.mname ?? '',
                    yValueMapper: (d, _) => d.monthlyBudget ?? 0,
                    color: ColorManager.green,
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
                  LineSeries<RunRateData, String>(
                    name: 'Actual Spend',
                    dataSource: monthlyData,
                    xValueMapper: (d, _) => d.mname ?? '',
                    yValueMapper: (d, _) => d.totalSpent ?? 0,
                    color: ColorManager.darkBlue,
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
                  LineSeries<RunRateData, String>(
                    name: 'Avg Run Rate',
                    dataSource: monthlyData,
                    xValueMapper: (d, _) => d.mname ?? '',
                    yValueMapper: (d, _) => d.avgRunRate ?? 0,
                    color: ColorManager.orange,
                    dashArray: const [6, 4],
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
                  LineSeries<RunRateData, String>(
                    name: 'Budgeted Run rate',
                    dataSource: monthlyData,
                    xValueMapper: (d, index) => d.mname ?? '',
                    yValueMapper: (d, index) => cumulativeMonthlyBudget[index!],
                    color: ColorManager.lightBlue,
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
