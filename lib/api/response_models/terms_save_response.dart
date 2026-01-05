// To parse this JSON data, do
//
//     final SaveTerms = SaveTermsFromJson(jsonString);

import 'dart:convert';

SaveTerms SaveTermsFromJson(String str) => SaveTerms.fromJson(json.decode(str));

String SaveTermsToJson(SaveTerms data) => json.encode(data.toJson());

class SaveTerms {
    int code;
    List<String> message;
    dynamic data;
    int totalrecords;

    SaveTerms({
        required this.code,
        required this.message,
        required this.data,
        required this.totalrecords,
    });

    factory SaveTerms.fromJson(Map<String, dynamic> json) => SaveTerms(
        code: json["code"],
        message: List<String>.from(json["message"].map((x) => x)),
        data: json["data"],
        totalrecords: json["totalrecords"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": data,
        "totalrecords": totalrecords,
    };
}
