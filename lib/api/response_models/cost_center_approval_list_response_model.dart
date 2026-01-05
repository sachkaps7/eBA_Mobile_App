// To parse this JSON data:
//
// final res = costCenterApprovalResponseFromJson(jsonString);

import 'dart:convert';

CostCenterApprovalResponse costCenterApprovalResponseFromJson(String str) =>
    CostCenterApprovalResponse.fromJson(json.decode(str));

String costCenterApprovalResponseToJson(CostCenterApprovalResponse data) =>
    json.encode(data.toJson());

class CostCenterApprovalResponse {
  int code;
  List<String> message;
  CostCenterApprovalResponseData data;
  int totalrecords;

  CostCenterApprovalResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory CostCenterApprovalResponse.fromJson(Map<String, dynamic>? json) =>
      CostCenterApprovalResponse(
        code: json?["code"] ?? 0,
        message: List<String>.from((json?["message"] ?? []).map((x) => x ?? "")),
        data: CostCenterApprovalResponseData.fromJson(json?["data"] ?? {}),
        totalrecords: json?["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": data.toJson(),
        "totalrecords": totalrecords,
      };
}

class CostCenterApprovalResponseData {
  Permission permission;
  List<ListElement> list;

  CostCenterApprovalResponseData({
    required this.permission,
    required this.list,
  });

  factory CostCenterApprovalResponseData.fromJson(
          Map<String, dynamic>? json) =>
      CostCenterApprovalResponseData(
        permission: Permission.fromJson(json?["permission"] ?? {}),
        list: List<ListElement>.from(
            (json?["list"] ?? []).map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "permission": permission.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class ListElement {
  int recNum;
  int orderId;
  int uid;
  int rank;
  String approval;
  String userName;
  String telephone;
  String extension;
  String email;
  DateTime? approvalDate;
  String uidProxy;

  ListElement({
    required this.recNum,
    required this.orderId,
    required this.uid,
    required this.rank,
    required this.approval,
    required this.userName,
    required this.telephone,
    required this.extension,
    required this.email,
    required this.approvalDate,
    required this.uidProxy,
  });

  factory ListElement.fromJson(Map<String, dynamic>? json) => ListElement(
        recNum: json?["RecNum"] ?? 0,
        orderId: json?["Order_ID"] ?? 0,
        uid: json?["UID"] ?? 0,
        rank: json?["Rank"] ?? 0,
        approval: json?["Approval"] ?? "",
        userName: json?["UserName"] ?? "",
        telephone: json?["Telephone"] ?? "",
        extension: json?["Extension"] ?? "",
        email: json?["Email"] ?? "",
        approvalDate: _safeDate(json?["Approval_Date"]),
        uidProxy: json?["UID_Proxy"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "RecNum": recNum,
        "Order_ID": orderId,
        "UID": uid,
        "Rank": rank,
        "Approval": approval,
        "UserName": userName,
        "Telephone": telephone,
        "Extension": extension,
        "Email": email,
        "Approval_Date": approvalDate?.toIso8601String() ?? "",
        "UID_Proxy": uidProxy,
      };

  static DateTime? _safeDate(dynamic value) {
    if (value == null || value == "") return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
}

class Permission {
  String mode;

  Permission({
    required this.mode,
  });

  factory Permission.fromJson(Map<String, dynamic>? json) => Permission(
        mode: json?["mode"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "mode": mode,
      };
}
