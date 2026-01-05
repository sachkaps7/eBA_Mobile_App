import 'dart:convert';

AttachmentListResponse attachmentListResponseFromJson(String str) =>
    AttachmentListResponse.fromJson(json.decode(str));

String attachmentListResponseToJson(AttachmentListResponse data) =>
    json.encode(data.toJson());

class AttachmentListResponse {
  int code;
  List<String> message;
  AttachmentData data;
  int totalrecords;

  AttachmentListResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory AttachmentListResponse.fromJson(Map<String, dynamic>? json) =>
      AttachmentListResponse(
        code: json?["code"] ?? 0,
        message: json?["message"] == null
            ? []
            : List<String>.from(
                (json!["message"] as List).map((x) => x?.toString() ?? "")),
        data: json?["data"] == null
            ? AttachmentData.empty()
            : AttachmentData.fromJson(json!["data"]),
        totalrecords: json?["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": data.toJson(),
        "totalrecords": totalrecords,
      };
}

class AttachmentData {
  Permission permission;
  List<AttachmentItem> list;

  AttachmentData({
    required this.permission,
    required this.list,
  });

  factory AttachmentData.fromJson(Map<String, dynamic>? json) => AttachmentData(
        permission: json?["permission"] == null
            ? Permission.empty()
            : Permission.fromJson(json!["permission"]),
        list: json?["list"] == null
            ? []
            : List<AttachmentItem>.from(
                (json!["list"] as List).map((x) => AttachmentItem.fromJson(x))),
      );

  factory AttachmentData.empty() => AttachmentData(
        permission: Permission.empty(),
        list: [],
      );

  Map<String, dynamic> toJson() => {
        "permission": permission.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class AttachmentItem {
  String documentFileName;
  int documentPrivacy;
  String docPrivacyText;
  String docStamp;
  int recNum;
  int id;
  int hid;
  int lineId;
  dynamic groupName;
  dynamic documentFile;
  String documentDescription;
  String fileType;
  int uid;
  dynamic expReceipt;
  String documentImg;
  String enteredBy;
  dynamic fileUrl;

  AttachmentItem({
    required this.documentFileName,
    required this.documentPrivacy,
    required this.docPrivacyText,
    required this.docStamp,
    required this.recNum,
    required this.id,
    required this.hid,
    required this.lineId,
    required this.groupName,
    required this.documentFile,
    required this.documentDescription,
    required this.fileType,
    required this.uid,
    required this.expReceipt,
    required this.documentImg,
    required this.enteredBy,
    required this.fileUrl,
  });

  factory AttachmentItem.fromJson(Map<String, dynamic>? json) => AttachmentItem(
        documentFileName: json?["Document_FileName"] ?? "",
        documentPrivacy: json?["Document_Privacy"] ?? 0,
        docPrivacyText: json?["Doc_PrivacyText"] ?? "",
        docStamp: json?["Doc_Stamp"] ?? "",
        recNum: json?["RecNum"] ?? 0,
        id: json?["ID"] ?? 0,
        hid: json?["Hid"] ?? 0,
        lineId: json?["LineID"] ?? 0,
        groupName: json?["GroupName"],
        documentFile: json?["Document_File"],
        documentDescription: json?["Document_Description"] ?? "",
        fileType: json?["File_Type"] ?? "",
        uid: json?["UID"] ?? 0,
        expReceipt: json?["Exp_Receipt"],
        documentImg: json?["Document_Img"] ?? "",
        enteredBy: json?["EnteredBy"] ?? "",
        fileUrl: json?["File_Url"],
      );

  Map<String, dynamic> toJson() => {
        "Document_FileName": documentFileName,
        "Document_Privacy": documentPrivacy,
        "Doc_PrivacyText": docPrivacyText,
        "Doc_Stamp": docStamp,
        "RecNum": recNum,
        "ID": id,
        "Hid": hid,
        "LineID": lineId,
        "GroupName": groupName,
        "Document_File": documentFile,
        "Document_Description": documentDescription,
        "File_Type": fileType,
        "UID": uid,
        "Exp_Receipt": expReceipt,
        "Document_Img": documentImg,
        "EnteredBy": enteredBy,
        "File_Url": fileUrl,
      };
}

class Permission {
  String mode;

  Permission({
    required this.mode,
  });

  factory Permission.fromJson(Map<String, dynamic>? json) => Permission(
        mode: json?["mode"] ?? "",
      );

  factory Permission.empty() => Permission(mode: "");

  Map<String, dynamic> toJson() => {
        "mode": mode,
      };
}
