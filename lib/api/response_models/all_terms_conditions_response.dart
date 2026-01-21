// To parse this JSON data, do
//
//     final AllTermsListDetailResponseModel = AllTermsListDetailResponseModelFromJson(jsonString);

import 'dart:convert';

AllTermsListDetailResponseModel AllTermsListDetailResponseModelFromJson(
        String str) =>
    AllTermsListDetailResponseModel.fromJson(json.decode(str));

String AllTermsListDetailResponseModelToJson(
        AllTermsListDetailResponseModel data) =>
    json.encode(data.toJson());

class AllTermsListDetailResponseModel {
  int code;
  List<String> message;
  TermsListData data;
  int totalrecords;

  AllTermsListDetailResponseModel({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory AllTermsListDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      AllTermsListDetailResponseModel(
        code: json["code"],
        message: List<String>.from(json["message"].map((x) => x)),
        data: TermsListData.fromJson(json["data"]),
        totalrecords: json["totalrecords"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": data.toJson(),
        "totalrecords": totalrecords,
      };
}

class TermsListData {
  Permission permission;
  List<ListElement> list;

  TermsListData({
    required this.permission,
    required this.list,
  });

  factory TermsListData.fromJson(Map<String, dynamic> json) => TermsListData(
        permission: Permission.fromJson(json["permission"]),
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "permission": permission.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class ListElement {
  int id;
  int itemIndex;
  String code;
  String description;

  ListElement({
    required this.id,
    required this.itemIndex,
    required this.code,
    required this.description,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"] ?? 0,
        itemIndex: json["ItemIndex"] ?? 0,
        code: json["code"] ?? "",
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ItemIndex": itemIndex,
        "code": code,
        "description": description,
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
