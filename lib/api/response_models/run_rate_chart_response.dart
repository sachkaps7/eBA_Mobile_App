import 'dart:convert';

RunRateChartModel runRateChartModelFromJson(String str) =>
    RunRateChartModel.fromJson(json.decode(str));

String runRateChartModelToJson(RunRateChartModel data) =>
    json.encode(data.toJson());

class RunRateChartModel {
  int? code;
  List<String>? message;
  List<RunRateDatum>? data;
  int? totalrecords;

  RunRateChartModel({
    this.code,
    this.message,
    this.data,
    this.totalrecords,
  });

  factory RunRateChartModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RunRateChartModel();

    return RunRateChartModel(
      code: json["code"] ?? 0,
      message:
          (json["message"] as List?)?.map((e) => e.toString()).toList() ?? [],
      data: (json["data"] as List?)
              ?.map((e) => RunRateDatum.fromJson(e))
              .toList() ??
          [],
      totalrecords: json["totalrecords"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code ?? 0,
        "message": message ?? [],
        "data": data?.map((e) => e.toJson()).toList() ?? [],
        "totalrecords": totalrecords ?? 0,
      };
}

class RunRateDatum {
  RunRateData? data;

  RunRateDatum({this.data});

  factory RunRateDatum.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RunRateDatum();

    return RunRateDatum(
      data: RunRateData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data?.toJson() ?? {},
      };
}

class RunRateData {
  int? recNum;
  int? mid;
  String? mname;
  int? yearvalue;
  int? codeId;
  String? codeName;
  String? codeDescription;
  double? budget;
  double? monthlyBudget;
  double? spent;
  double? totalSpent;
  String? startDate;
  String? endDate;
  double? expectedRunRate;
  double? actualRunRate;
  double? avgTotalSpent;
  double? avgRunRate;
  String? ccyCode;
  RunRateData(
      {this.recNum,
      this.mid,
      this.mname,
      this.yearvalue,
      this.codeId,
      this.codeName,
      this.codeDescription,
      this.budget,
      this.monthlyBudget,
      this.spent,
      this.totalSpent,
      this.startDate,
      this.endDate,
      this.expectedRunRate,
      this.actualRunRate,
      this.avgTotalSpent,
      this.avgRunRate,
      this.ccyCode});

  factory RunRateData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RunRateData();

    return RunRateData(
      recNum: json["RecNum"] ?? 0,
      mid: json["Mid"] ?? 0,
      mname: json["Mname"] ?? "",
      yearvalue: json["Yearvalue"] ?? 0,
      codeId: json["CodeID"] ?? 0,
      codeName: json["CodeName"] ?? "",
      codeDescription: json["CodeDescription"] ?? "",
      budget: (json["Budget"] as num?)?.toDouble() ?? 0.0,
      monthlyBudget: (json["MonthlyBudget"] as num?)?.toDouble() ?? 0.0,
      spent: json["Spent"] ?? 0,
      totalSpent: json["TotalSpent"] ?? 0,
      startDate: json["StartDate"] ?? "",
      endDate: json["EndDate"] ?? "",
      expectedRunRate: (json["ExpectedRunRate"] as num?)?.toDouble() ?? 0.0,
      actualRunRate: json["ActualRunRate"] ?? 0,
      avgTotalSpent: json["AvgTotalSpent"] ?? 0,
      avgRunRate: json["AvgRunRate"] ?? 0,
      ccyCode: json["ccyCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "RecNum": recNum ?? 0,
        "Mid": mid ?? 0,
        "Mname": mname ?? "",
        "Yearvalue": yearvalue ?? 0,
        "CodeID": codeId ?? 0,
        "CodeName": codeName ?? "",
        "CodeDescription": codeDescription ?? "",
        "Budget": budget ?? 0.0,
        "MonthlyBudget": monthlyBudget ?? 0.0,
        "Spent": spent ?? 0,
        "TotalSpent": totalSpent ?? 0,
        "StartDate": startDate ?? "",
        "EndDate": endDate ?? "",
        "ExpectedRunRate": expectedRunRate ?? 0.0,
        "ActualRunRate": actualRunRate ?? 0,
        "AvgTotalSpent": avgTotalSpent ?? 0,
        "AvgRunRate": avgRunRate ?? 0,
        "ccyCode": ccyCode ?? "",
      };
}

class RunRateChartPoint {
  final String month;
  final double budgetedRunRate;
  final double monthlyBudget;
  final double actualSpend;
  final double avgRunRate;

  RunRateChartPoint({
    required this.month,
    required this.budgetedRunRate,
    required this.monthlyBudget,
    required this.actualSpend,
    required this.avgRunRate,
  });
}
