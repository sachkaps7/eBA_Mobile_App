import 'dart:convert';

TermListResponse termListResponseFromJson(String str) =>
    TermListResponse.fromJson(json.decode(str));

String termListResponseToJson(TermListResponse data) =>
    json.encode(data.toJson());

class TermListResponse {
  final int code;
  final List<String> message;
  final TermListResponseData data;
  final int totalRecords;

  TermListResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory TermListResponse.fromJson(Map<String, dynamic> json) =>
      TermListResponse(
        code: json["code"] ?? 0,
        message: json["message"] != null
            ? List<String>.from(json["message"])
            : <String>[],
        data: json["data"] != null
            ? TermListResponseData.fromJson(json["data"])
            : TermListResponseData.empty(),
        totalRecords: json["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message),
        "data": data.toJson(),
        "totalrecords": totalRecords,
      };
}

class TermListResponseData {
  final Permission permission;
  final List<TermListItem> list;

  TermListResponseData({
    required this.permission,
    required this.list,
  });

  /// Safe empty fallback
  factory TermListResponseData.empty() => TermListResponseData(
        permission: Permission(mode: "NA"),
        list: [],
      );

  factory TermListResponseData.fromJson(Map<String, dynamic> json) =>
      TermListResponseData(
        permission: json["permission"] != null
            ? Permission.fromJson(json["permission"])
            : Permission(mode: "NA"),
        list: json["list"] != null
            ? List<TermListItem>.from(
                json["list"].map((x) => TermListItem.fromJson(x)),
              )
            : <TermListItem>[],
      );

  Map<String, dynamic> toJson() => {
        "permission": permission.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

/// EACH TERM ITEM
class TermListItem {
  final int recNum;
  final int itemIndex;
  final String textCode;
  final int textCodeId;
  final String textOutline;
  final String requestStamp;
  final String orderStamp;

  TermListItem({
    required this.recNum,
    required this.itemIndex,
    required this.textCode,
    required this.textCodeId,
    required this.textOutline,
    required this.requestStamp,
    required this.orderStamp,
  });

  factory TermListItem.fromJson(Map<String, dynamic> json) => TermListItem(
        recNum: json["RecNum"] ?? 0,
        itemIndex: json["ItemIndex"] ?? 0,
        textCode: json["TextCode"] ?? "",
        textCodeId: json["TextCodeID"] ?? 0,
        textOutline: json["TextOutline"] ?? "",
        requestStamp: json["Request_Stamp"] ?? "",
        orderStamp: json["Order_Stamp"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "RecNum": recNum,
        "ItemIndex": itemIndex,
        "TextCode": textCode,
        "TextCodeID": textCodeId,
        "TextOutline": textOutline,
        "Request_Stamp": requestStamp,
        "Order_Stamp": orderStamp,
      };
}

/// PERMISSION MODEL
class Permission {
  final String mode;

  Permission({required this.mode});

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        mode: json["mode"] ?? "NA",
      );

  Map<String, dynamic> toJson() => {
        "mode": mode,
      };
}
