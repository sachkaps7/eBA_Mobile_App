import 'dart:convert';

CostCenterListResponse costCenterListResponseFromJson(String str) =>
    CostCenterListResponse.fromJson(json.decode(str));

String costCenterListResponseToJson(CostCenterListResponse data) =>
    json.encode(data.toJson());

class CostCenterListResponse {
  int code;
  List<String> message;
  CostCenterListResponseData data;
  int totalrecords;

  CostCenterListResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory CostCenterListResponse.fromJson(Map<String, dynamic> json) =>
      CostCenterListResponse(
        code: json["code"],
        message: List<String>.from(json["message"].map((x) => x)),
        data: CostCenterListResponseData.fromJson(json["data"]),
        totalrecords: json["totalrecords"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": data.toJson(),
        "totalrecords": totalrecords,
      };
}

class CostCenterListResponseData {
  Permission permission;
  List<CostCenterItem> list;

  CostCenterListResponseData({
    required this.permission,
    required this.list,
  });

  factory CostCenterListResponseData.fromJson(Map<String, dynamic> json) =>
      CostCenterListResponseData(
        permission: Permission.fromJson(json["permission"]),
        list: List<CostCenterItem>.from(
            json["list"].map((x) => CostCenterItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "permission": permission.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class CostCenterItem {
  int recNum;
  int costCentreId;
  String costCode;
  String costDescription;
  double splitPercentage;
  double splitValue;
  double costBudget;
  bool active;
  bool isSelected;
  int isExists;
  int splitType;
  int userCount;
  int ruleEntityId;

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

  factory CostCenterItem.fromJson(Map<String, dynamic> json) => CostCenterItem(
        recNum: json["RecNum"],
        costCentreId: json["CostCentre_ID"],
        costCode: json["Cost_Code"],
        costDescription: json["Cost_Description"],
        splitPercentage: json["SplitPercentage"],
        splitValue: json["SplitValue"],
        costBudget: json["Cost_Budget"],
        active: json["Active"],
        isSelected: json["IsSelected"],
        isExists: json["IsExists"],
        splitType: json["Split_Type"],
        userCount: json["UserCount"],
        ruleEntityId: json["Rule_Entity_ID"],
      );

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
  String mode;

  Permission({
    required this.mode,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        mode: json["mode"],
      );

  Map<String, dynamic> toJson() => {
        "mode": mode,
      };
}
