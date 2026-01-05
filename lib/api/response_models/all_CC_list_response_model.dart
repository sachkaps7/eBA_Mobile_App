import 'dart:convert';

CostCenterResponse costCenterResponseFromJson(String str) =>
    CostCenterResponse.fromJson(json.decode(str));

String costCenterResponseToJson(CostCenterResponse data) =>
    json.encode(data.toJson());

class CostCenterResponse {
  final int code;
  final List<String> message;
  final CostCenterData data;
  final int totalRecords;

  CostCenterResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory CostCenterResponse.fromJson(Map<String, dynamic> json) {
    return CostCenterResponse(
      code: json["code"] ?? 0,
      message: json["message"] != null
          ? List<String>.from(json["message"].map((x) => x.toString()))
          : <String>[],
      data: CostCenterData.fromJson(json["data"] ?? {}),
      totalRecords: json["totalrecords"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message),
        "data": data.toJson(),
        "totalrecords": totalRecords,
      };
}

class CostCenterData {
  final Permission permission;
  final List<CostCenterItem> list;

  CostCenterData({
    required this.permission,
    required this.list,
  });

  factory CostCenterData.fromJson(Map<String, dynamic> json) {
    return CostCenterData(
      permission: Permission.fromJson(json["permission"] ?? {}),
      list: json["list"] != null
          ? List<CostCenterItem>.from(
              json["list"].map((x) => CostCenterItem.fromJson(x)),
            )
          : <CostCenterItem>[],
    );
  }

  Map<String, dynamic> toJson() => {
        "permission": permission.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class CostCenterItem {
  final int recNum;
  final int costCentreId;
  final String costCode;
  final String costDescription;
  final double splitPercentage;
  final double splitValue;
  final double costBudget;
  final bool active;
  final bool isSelected;
  final int isExists;
  final int splitType;
  final int userCount;
  final int ruleEntityId;

  CostCenterItem({
    required this.recNum,
    required this.costCentreId,
    required this.costCode,
    required this.costDescription,
    required this.splitPercentage,
    required this.splitValue,
    required this.costBudget,
    required this.active,
    required this.isSelected,
    required this.isExists,
    required this.splitType,
    required this.userCount,
    required this.ruleEntityId,
  });

  factory CostCenterItem.fromJson(Map<String, dynamic> json) {
    return CostCenterItem(
      recNum: json["RecNum"] ?? 0,
      costCentreId: json["CostCentre_ID"] ?? 0,
      costCode: json["Cost_Code"] ?? '',
      costDescription: json["Cost_Description"] ?? '',
      splitPercentage: (json["SplitPercentage"] ?? 0).toDouble(),
      splitValue: (json["SplitValue"] ?? 0).toDouble(),
      costBudget: (json["Cost_Budget"] ?? 0).toDouble(),
      active: json["Active"] ?? false,
      isSelected: json["IsSelected"] ?? false,
      isExists: json["IsExists"] ?? 0,
      splitType: json["Split_Type"] ?? 0,
      userCount: json["UserCount"] ?? 0,
      ruleEntityId: json["Rule_Entity_ID"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "RecNum": recNum,
        "CostCentre_ID": costCentreId,
        "Cost_Code": costCode,
        "Cost_Description": costDescription,
        "SplitPercentage": splitPercentage,
        "SplitValue": splitValue,
        "Cost_Budget": costBudget,
        "Active": active,
        "IsSelected": isSelected,
        "IsExists": isExists,
        "Split_Type": splitType,
        "UserCount": userCount,
        "Rule_Entity_ID": ruleEntityId,
      };
}

class Permission {
  final String mode;

  Permission({
    required this.mode,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      mode: json["mode"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "mode": mode,
      };
}
