// To parse this JSON data, do
//
//     final DropdownDataResponse = DropdownDataResponseFromJson(jsonString);

import 'dart:convert';

import 'package:eyvo_v3/api/response_models/order_header_response.dart';

DropdownDataResponse DropdownDataResponseFromJson(String str) =>
    DropdownDataResponse.fromJson(json.decode(str));

String DropdownDataResponseToJson(DropdownDataResponse data) =>
    json.encode(data.toJson());

class DropdownDataResponse {
  int code;
  List<String> message;
  List<DropdownData> data;
  int totalrecords;

  DropdownDataResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory DropdownDataResponse.fromJson(Map<String, dynamic> json) =>
      DropdownDataResponse(
        code: json["code"],
        message: List<String>.from(json["message"].map((x) => x)),
        data: List<DropdownData>.from(
            json["data"].map((x) => DropdownData.fromJson(x))),
        totalrecords: json["totalrecords"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalrecords": totalrecords,
      };
}

class DropdownData {
  int id;
  String code;
  String description;
  bool selected;

  DropdownData({
    required this.id,
    required this.code,
    required this.description,
    required this.selected,
  });

  factory DropdownData.fromJson(Map<String, dynamic> json) {
    return DropdownData(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      selected: json['selected'] ?? false,
    );
  }

  // Add this missing method
  DropdownItem toDropdownItem() {
    return DropdownItem(
        id: id.toString(), value: description, code: code.toString());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "selected": selected,
      };
}
