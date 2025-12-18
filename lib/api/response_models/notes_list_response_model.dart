import 'dart:convert';

NotesListResponse notesListResponseFromJson(String str) =>
    NotesListResponse.fromJson(json.decode(str));

String notesListResponseToJson(NotesListResponse data) =>
    json.encode(data.toJson());

class NotesListResponse {
  int code;
  List<String> message;
  NotesData data;
  int totalrecords;

  NotesListResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory NotesListResponse.fromJson(Map<String, dynamic>? json) =>
      NotesListResponse(
        code: json?["code"] ?? 0,
        message: json?["message"] == null
            ? []
            : List<String>.from(
                (json!["message"] as List).map((x) => x?.toString() ?? "")),
        data: json?["data"] == null
            ? NotesData.empty()
            : NotesData.fromJson(json!["data"]),
        totalrecords: json?["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": data.toJson(),
        "totalrecords": totalrecords,
      };
}

class NotesData {
  Permission permission;
  List<NotesItem> list;

  NotesData({
    required this.permission,
    required this.list,
  });

  factory NotesData.fromJson(Map<String, dynamic>? json) => NotesData(
        permission: json?["permission"] == null
            ? Permission.empty()
            : Permission.fromJson(json!["permission"]),
        list: json?["list"] == null
            ? []
            : List<NotesItem>.from(
                (json!["list"] as List)
                    .map((x) => NotesItem.fromJson(x))),
      );

  factory NotesData.empty() =>
      NotesData(permission: Permission.empty(), list: []);

  Map<String, dynamic> toJson() => {
        "permission": permission.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class NotesItem {
  int notesId;
  String notes;
  String enteredBy;
  String entryDate;
  int intId;
  int requestId;
  int orderId;
  int rfqId;
  int uid;
  int regionId;
  dynamic groupName;
  int notePrivacy;
  String notePrivacyText;
  dynamic pageFrom;

  NotesItem({
    required this.notesId,
    required this.notes,
    required this.enteredBy,
    required this.entryDate,
    required this.intId,
    required this.requestId,
    required this.orderId,
    required this.rfqId,
    required this.uid,
    required this.regionId,
    required this.groupName,
    required this.notePrivacy,
    required this.notePrivacyText,
    required this.pageFrom,
  });

  factory NotesItem.fromJson(Map<String, dynamic>? json) => NotesItem(
        notesId: json?["Notes_ID"] ?? 0,
        notes: json?["Notes"] ?? "",
        enteredBy: json?["EnteredBy"] ?? "",
        entryDate: json?["EntryDate"] ?? "",
           
        intId: json?["Int_ID"] ?? 0,
        requestId: json?["Request_ID"] ?? 0,
        orderId: json?["Order_ID"] ?? 0,
        rfqId: json?["RFQ_ID"] ?? 0,
        uid: json?["UID"] ?? 0,
        regionId: json?["Region_ID"] ?? 0,
        groupName: json?["GroupName"],
        notePrivacy: json?["Note_Privacy"] ?? 0,
        notePrivacyText: json?["Note_PrivacyText"] ?? "",
        pageFrom: json?["PageFrom"],
      );

  Map<String, dynamic> toJson() => {
        "Notes_ID": notesId,
        "Notes": notes,
        "EnteredBy": enteredBy,
        "EntryDate": entryDate,
        "Int_ID": intId,
        "Request_ID": requestId,
        "Order_ID": orderId,
        "RFQ_ID": rfqId,
        "UID": uid,
        "Region_ID": regionId,
        "GroupName": groupName,
        "Note_Privacy": notePrivacy,
        "Note_PrivacyText": notePrivacyText,
        "PageFrom": pageFrom,
      };
}

class Permission {
  String mode;

  Permission({required this.mode});

  factory Permission.fromJson(Map<String, dynamic>? json) =>
      Permission(mode: json?["mode"] ?? "");

  factory Permission.empty() => Permission(mode: "");

  Map<String, dynamic> toJson() => {
        "mode": mode,
      };
}
