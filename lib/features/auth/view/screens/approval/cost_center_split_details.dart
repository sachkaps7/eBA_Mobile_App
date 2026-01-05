import 'package:eyvo_v3/api/response_models/budget_bar_chart_dummy_data.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/widgets/graphs/budget_bar_chart.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/graphs/run_rate_line_chart.dart';
import 'package:flutter/material.dart';

class BudgetGraphPage extends StatelessWidget {
  BudgetGraphPage({super.key});

  final BudgetData dummyBudget = BudgetData(
    totalBudget: 100000,
    spentSoFar: 60000,
    beforeApproval: 40000,
    afterApproval: 30000,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: buildCommonAppBar(
          context: context,
          title: "Cost Center Code",
        ),
        body: Column(
          children: [
            ///  Tabs
            TabBar(
              labelColor: ColorManager.blue,
              unselectedLabelColor: ColorManager.grey,
              indicatorColor: ColorManager.blue,
              //   automaticIndicatorColorAdjustment: true,
              tabs: const [
                Tab(text: "Expense Chart"),
                Tab(text: "Run Rate Chart"),
              ],
            ),

            ///  Tab Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TabBarView(
                  children: [
                    /// Expense Chart
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Expense Chart',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        BudgetBarChart(data: dummyBudget),
                      ],
                    ),

                    /// Run Rate Chart
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Run Rate Chart',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        //   RunRateLineChart(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
