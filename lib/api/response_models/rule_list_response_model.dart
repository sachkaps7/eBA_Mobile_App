// To parse this JSON data:
//
// final response = getRuleResponseFromJson(jsonString);

import 'dart:convert';

GetRuleResponse getRuleResponseFromJson(String str) =>
    GetRuleResponse.fromJson(json.decode(str));

String getRuleResponseToJson(GetRuleResponse data) =>
    json.encode(data.toJson());

class GetRuleResponse {
  final int code;
  final List<String> message;
  final List<GetRuleResponseData> data;
  final int totalrecords;

  GetRuleResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory GetRuleResponse.fromJson(Map<String, dynamic> json) =>
      GetRuleResponse(
        code: json["code"] ?? 0,
        message: json["message"] != null
            ? List<String>.from(json["message"].map((x) => x ?? ""))
            : [],
        data: json["data"] != null
            ? List<GetRuleResponseData>.from(
                json["data"].map((x) => GetRuleResponseData.fromJson(x)),
              )
            : [],
        totalrecords: json["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalrecords": totalrecords,
      };
}

class GetRuleResponseData {
  int ruleId;
  String ruleName;
  String ruleDescription;
  bool ruleSelected;
  int ruleEntityId;

  GetRuleResponseData({
    required this.ruleId,
    required this.ruleName,
    required this.ruleDescription,
    required this.ruleSelected,
    required this.ruleEntityId,
  });

  factory GetRuleResponseData.fromJson(Map<String, dynamic> json) =>
      GetRuleResponseData(
        ruleId: json["Rule_ID"] ?? 0,
        ruleName: json["Rule_Name"] ?? "",
        ruleDescription: json["Rule_Description"] ?? "",
        ruleSelected: json["Rule_Selected"] ?? false,
        ruleEntityId: json["Rule_Entity_ID"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "Rule_ID": ruleId,
        "Rule_Name": ruleName,
        "Rule_Description": ruleDescription,
        "Rule_Selected": ruleSelected,
        "Rule_Entity_ID": ruleEntityId,
      };
}
