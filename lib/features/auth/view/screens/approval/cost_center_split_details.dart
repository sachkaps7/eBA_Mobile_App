import 'package:dotted_border/dotted_border.dart';
import 'package:eyvo_v3/api/api_service/api_service.dart';
import 'package:eyvo_v3/api/response_models/expanse_chart_model.dart';
import 'package:eyvo_v3/api/response_models/note_details_response_model.dart';
import 'package:eyvo_v3/api/response_models/run_rate_chart_response.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/constants.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:eyvo_v3/core/resources/strings_manager.dart';
import 'package:eyvo_v3/core/resources/styles_manager.dart';
import 'package:eyvo_v3/core/widgets/graphs/budget_bar_chart.dart';
import 'package:eyvo_v3/core/widgets/common_app_bar.dart';
import 'package:eyvo_v3/core/widgets/graphs/run_rate_line_chart.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';

class BudgetGraphPage extends StatefulWidget {
  final String group;
  final int cCId;
  final int ordReqID;
  const BudgetGraphPage({
    super.key,
    required this.group,
    required this.ordReqID,
    required this.cCId,
  });

  @override
  State<BudgetGraphPage> createState() => _BudgetGraphPageState();
}

class _BudgetGraphPageState extends State<BudgetGraphPage>
    with SingleTickerProviderStateMixin {
  late BudgetData dummyBudget;

  late TextStyle labelStyle;
  late TextStyle valueStyle;
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  final ApiService apiService = ApiService();
  ExpanceData? expanceData;
  List<RunRateData> runRateDataList = [];
  RunRateData? runRateSummary;

  bool runRateApiCalled = false;
  bool isExpenseLoading = false;
  bool isRunRateLoading = false;

  late TabController _tabController;
  BudgetData? budgetFromApi;
  @override
  void initState() {
    super.initState();

    dummyBudget = BudgetData(
      totalBudget: 100000,
      spentSoFar: 60000,
      beforeApproval: 40000,
      afterApproval: 30000,
    );

    labelStyle = getSemiBoldStyle(
      fontSize: FontSize.s14,
      color: ColorManager.black,
    );

    valueStyle = getBoldStyle(
      fontSize: FontSize.s14,
      color: ColorManager.black,
    );
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 1 && !runRateApiCalled) {
        runRateApiCalled = true;
        fetchRunRateChartDetails();
      }
    });

    // fetchExpanseChartDetails();
  }

  Future<void> fetchExpanseChartDetails() async {
    setState(() {
      // isLoading = true;
      isError = false;
      isExpenseLoading = true;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.expenditureChart,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'ID': '',
        'OrdReqID': widget.ordReqID,
        'group': widget.group,
        'CostCodeID': widget.cCId,
        'Code': '7'
      },
    );

    if (jsonResponse != null) {
      final resp = ExpanceChartDataModel.fromJson(jsonResponse);

      if (resp.code == 200 && resp.data != null) {
        setState(() {
          expanceData = resp.data;

          budgetFromApi = BudgetData(
            totalBudget: resp.data!.codeBudget?.toDouble() ?? 0,
            spentSoFar: resp.data!.totalSpent?.toDouble() ?? 0,
            beforeApproval:
                resp.data!.budgetAvailableBeforeApproving?.toDouble() ?? 0,
            afterApproval:
                resp.data!.budgetAvailableAfterApproving?.toDouble() ?? 0,
          );

          //   isLoading = false;
          isExpenseLoading = false;
        });
        return;
      } else {
        errorText = resp.message?.join(', ') ?? 'Something went wrong';
      }
    }

    setState(() {
      isError = true;
      //  isLoading = false;
      isExpenseLoading = false;
    });
  }

  String getExpenseChartYear(ExpanceData? data) {
    if (data == null) return '';

    final startDate = data.startDate ?? '';
    final endDate = data.endDate ?? '';

    final startYearMatch = RegExp(r'\d{4}').firstMatch(startDate);
    final endYearMatch = RegExp(r'\d{4}').firstMatch(endDate);

    if (startYearMatch == null || endYearMatch == null) return '';

    final startYear = startYearMatch.group(0)!;
    final endYear = endYearMatch.group(0)!;

    return startYear == endYear ? startYear : '$startYear-$endYear';
  }

  String getFinancialYear(ExpanceData? data) {
    if (data?.startYear == null || data?.endYear == null) return '';

    final int startYear = data!.startYear!;
    final int endYear = data.endYear!;

    return startYear == endYear ? startYear.toString() : '$startYear-$endYear';
  }

  Future<void> fetchRunRateChartDetails() async {
    setState(() {
      // isLoading = true;
      isError = false;
      isRunRateLoading = true;
    });

    final jsonResponse = await apiService.postRequest(
      context,
      ApiService.RunRateChart,
      {
        'uid': SharedPrefs().uID,
        'apptype': AppConstants.apptype,
        'ExpId': '7',
        'OrdReqID': widget.ordReqID,
        'group': widget.group,
        'CostCodeID': widget.cCId,
        'Code': '7'
      },
    );

    if (jsonResponse != null) {
      final resp = RunRateChartModel.fromJson(jsonResponse);

      if (resp.code == 200 && resp.data != null) {
        final allData =
            resp.data!.map((e) => e.data).whereType<RunRateData>().toList();

        setState(() {
          runRateSummary = allData.firstWhere((d) => d.mname == "",
              orElse: () => allData.first);

          runRateDataList = allData.where((d) => d.mname != "").toList();

          isRunRateLoading = false;
        });
      } else {
        errorText = resp.message?.join(', ') ?? 'Something went wrong';
      }
    }

    setState(() {
      isError = true;
      // isLoading = false;
      isRunRateLoading = false;
    });
  }

  String getRunRateYear(List<RunRateData> list) {
    if (list.isEmpty) return '';

    final summary = list.firstWhere(
      (e) => e.mname == null || e.mname!.isEmpty,
      orElse: () => list.first,
    );

    final startDate = summary.startDate ?? '';
    final endDate = summary.endDate ?? '';

    final startYearMatch = RegExp(r'\d{4}').firstMatch(startDate);
    final endYearMatch = RegExp(r'\d{4}').firstMatch(endDate);

    if (startYearMatch == null || endYearMatch == null) return '';

    final startYear = startYearMatch.group(0)!;
    final endYear = endYearMatch.group(0)!;

    return startYear == endYear ? startYear : '$startYear-$endYear';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: buildCommonAppBar(
        context: context,
        title: "Cost Center Code",
      ),
      body: Column(
        children: [
          /// Tabs
          TabBar(
            controller: _tabController,
            labelColor: ColorManager.blue,
            unselectedLabelColor: ColorManager.grey,
            indicatorColor: ColorManager.blue,
            tabs: const [
              Tab(text: "Expense Chart"),
              Tab(text: "Run Rate Chart"),
            ],
          ),

          /// Tab Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TabBarView(
                controller: _tabController,
                children: [
                  /// Expense Chart
                  SingleChildScrollView(
                    child: isExpenseLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BudgetBarChart(
                                data: budgetFromApi ?? dummyBudget,
                                financialYear: getExpenseChartYear(expanceData),
                              ),
                              const SizedBox(height: 8),
                              if (widget.group == 'Order')
                                OrderExpenseCard(data: expanceData)
                              else
                                RequestExpenseCard(data: expanceData)
                            ],
                          ),
                  ),

                  // Run Rate Chart
                  isRunRateLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RunRateLineChart(
                              apiData: runRateDataList,
                              financialYear: getRunRateYear(runRateDataList),
                            ),
                            const SizedBox(height: 8),
                            RunRateCard(data: runRateSummary),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------ Expense Card ------------------

  static Widget buildLabelValueRow({
    required String label,
    required String value,
    double spacing = 10,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: getSemiBoldStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.black,
                ),
              ),
            ),
            Text(
              value,
              style: getBoldStyle(
                fontSize: FontSize.s14,
                color: ColorManager.black,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
      ],
    );
  }

  static Widget OrderExpenseCard({required ExpanceData? data}) {
    return Card(
      color: ColorManager.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildLabelValueRow(
              label: "Cost Center Code",
              value: "${data?.codeName} (${data?.codeDescription})",
            ),
            buildLabelValueRow(
              label: "This FY Budget",
              value: "${data?.codeBudget}",
            ),
            buildLabelValueRow(
                label: "Allocated split amount for this Order",
                value: "${data?.currentOrderSpent}"),
            Container(
              width: double.infinity,
              color: ColorManager.lightGrey.withOpacity(0.15),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: buildLabelValueRow(
                label: "Current FY Spent",
                value: "${data?.startDate?.trim()} - ${data?.endDate?.trim()}",
              ),
            ),
            buildLabelValueRow(
              label: "Budget spent so far this FY",
              value: "${data?.totalSpent}",
            ),
            buildLabelValueRow(
              label: "Budget available to spend before approving this Order",
              value: "${data?.budgetAvailableBeforeApproving}",
            ),
            buildLabelValueRow(
              label: "Budget available to spend after approving this Order",
              value: "${data?.budgetAvailableAfterApproving}",
            ),
            Divider(
              color: ColorManager.lightGrey.withOpacity(0.3),
              thickness: 1,
              height: 16,
            ),
            buildLabelValueRow(
              label: "",
              value: "Currency : ${data?.ccyCode}",
            ),
            Divider(
              color: ColorManager.lightGrey.withOpacity(0.3),
              thickness: 1,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  static Widget RequestExpenseCard({required ExpanceData? data}) {
    return Card(
      color: ColorManager.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildLabelValueRow(
              label: "Cost Center Code",
              value: "${data?.codeName} (${data?.codeDescription})",
            ),
            buildLabelValueRow(
              label: "This FY Budget",
              value: "${data?.codeBudget}",
            ),
            Container(
              width: double.infinity,
              color: ColorManager.lightGrey.withOpacity(0.15),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: buildLabelValueRow(
                label: "Current FY Spent",
                value: "${data?.startDate?.trim()} - ${data?.endDate?.trim()}",
              ),
            ),
            buildLabelValueRow(
              label: "Budget spent so far this FY",
              value: "${data?.totalSpent}",
            ),
            Divider(
              color: ColorManager.lightGrey.withOpacity(0.3),
              thickness: 1,
              height: 16,
            ),
            buildLabelValueRow(
              label: "",
             value: "Currency : ${data?.ccyCode}",
            ),
            Divider(
              color: ColorManager.lightGrey.withOpacity(0.3),
              thickness: 1,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  static Widget RunRateCard({required RunRateData? data}) {
    if (data == null) {
      return const SizedBox.shrink();
    }

    return Card(
      color: ColorManager.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildLabelValueRow(
              label: "Financial Date",
              value: "${data.startDate?.trim()} - ${data.endDate?.trim()}",
            ),
            buildLabelValueRow(
              label: "Code",
              value: "${data.codeName} (${data.codeDescription})",
            ),
            buildLabelValueRow(
              label: "Total Budget",
              value: data.budget?.toStringAsFixed(2) ?? "0",
            ),
            buildLabelValueRow(
              label: "Budget spent so far",
              value: data.totalSpent?.toStringAsFixed(2) ?? "0",
            ),
            Divider(
              color: ColorManager.lightGrey.withOpacity(0.3),
              thickness: 1,
              height: 16,
            ),
            buildLabelValueRow(
              label: "",
             value: "Currency : ${data?.ccyCode}",
            ),
            Divider(
              color: ColorManager.lightGrey.withOpacity(0.3),
              thickness: 1,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
