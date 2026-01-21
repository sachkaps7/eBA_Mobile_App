import 'dart:convert';

ExpanceChartDataModel expanceChartDataModelFromJson(String str) =>
    ExpanceChartDataModel.fromJson(json.decode(str));

String expanceChartDataModelToJson(ExpanceChartDataModel data) =>
    json.encode(data.toJson());

class ExpanceChartDataModel {
  int? code;
  List<String>? message;
  ExpanceData? data;
  int? totalrecords;

  ExpanceChartDataModel({
    this.code,
    this.message,
    this.data,
    this.totalrecords,
  });

  factory ExpanceChartDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExpanceChartDataModel();

    return ExpanceChartDataModel(
      code: json["code"] ?? 0,
      message:
          json['message'] != null ? List<String>.from(json['message']) : [],
      data: ExpanceData.fromJson(json["data"]),
      totalrecords: json["totalrecords"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code ?? 0,
        "message": message ?? [],
        "data": data?.toJson() ?? {},
        "totalrecords": totalrecords ?? 0,
      };
}

class ExpanceData {
  String? spentType;
  String? codeName;
  String? codeDescription;
  double? codeBudget;
  int? currentOrderSpent;
  int? totalSpent;
  double? budgetAvailableBeforeApproving;
  double? budgetAvailableAfterApproving;
  String? startDate;
  String? endDate;
  double? previousTotalSpent;
  double? previousBudgetAvailableBeforeApproving;
  double? previousBudgetAvailableAfterApproving;
  int? ccyRate;
  String? ccyCode;
  int? startYear;
  int? endYear;

  ExpanceData({
    this.spentType,
    this.codeName,
    this.codeDescription,
    this.codeBudget,
    this.currentOrderSpent,
    this.totalSpent,
    this.budgetAvailableBeforeApproving,
    this.budgetAvailableAfterApproving,
    this.startDate,
    this.endDate,
    this.previousTotalSpent,
    this.previousBudgetAvailableBeforeApproving,
    this.previousBudgetAvailableAfterApproving,
    this.ccyRate,
    this.ccyCode,
    this.startYear,
    this.endYear,
  });

  factory ExpanceData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExpanceData();

    return ExpanceData(
      spentType: json["spentType"] ?? "",
      codeName: json["codeName"] ?? "",
      codeDescription: json["codeDescription"] ?? "",
      codeBudget: (json["codeBudget"] as num?)?.toDouble() ?? 0.0,
      currentOrderSpent: json["currentOrderSpent"] ?? 0,
      totalSpent: json["totalSpent"] ?? 0,
      budgetAvailableBeforeApproving:
          (json["budgetAvailableBeforeApproving"] as num?)?.toDouble() ?? 0.0,
      budgetAvailableAfterApproving:
          (json["budgetAvailableAfterApproving"] as num?)?.toDouble() ?? 0.0,
      startDate: json["startDate"] ?? "",
      endDate: json["endDate"] ?? "",
      previousTotalSpent:
          (json["previousTotalSpent"] as num?)?.toDouble() ?? 0.0,
      previousBudgetAvailableBeforeApproving:
          (json["previousBudgetAvailableBeforeApproving"] as num?)
                  ?.toDouble() ??
              0.0,
      previousBudgetAvailableAfterApproving:
          (json["previousBudgetAvailableAfterApproving"] as num?)?.toDouble() ??
              0.0,
      ccyRate: json["ccyRate"] ?? 0,
      ccyCode: json["ccyCode"] ?? "",
      startYear: json["startYear"] ?? 0,
      endYear: json["endYear"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "spentType": spentType ?? "",
        "codeName": codeName ?? "",
        "codeDescription": codeDescription ?? "",
        "codeBudget": codeBudget ?? 0.0,
        "currentOrderSpent": currentOrderSpent ?? 0,
        "totalSpent": totalSpent ?? 0,
        "budgetAvailableBeforeApproving": budgetAvailableBeforeApproving ?? 0.0,
        "budgetAvailableAfterApproving": budgetAvailableAfterApproving ?? 0.0,
        "startDate": startDate ?? "",
        "endDate": endDate ?? "",
        "previousTotalSpent": previousTotalSpent ?? 0.0,
        "previousBudgetAvailableBeforeApproving":
            previousBudgetAvailableBeforeApproving ?? 0.0,
        "previousBudgetAvailableAfterApproving":
            previousBudgetAvailableAfterApproving ?? 0.0,
        "ccyRate": ccyRate ?? 0,
        "ccyCode": ccyCode ?? "",
        "startYear": startYear ?? 0,
        "endYear": endYear ?? 0,
      };
}

class BudgetData {
  final double totalBudget;
  final double spentSoFar;
  final double beforeApproval;
  final double afterApproval;

  BudgetData({
    required this.totalBudget,
    required this.spentSoFar,
    required this.beforeApproval,
    required this.afterApproval,
  });
}
