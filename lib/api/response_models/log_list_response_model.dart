import 'dart:convert';

LogListResponse logListResponseFromJson(String str) =>
    LogListResponse.fromJson(json.decode(str));

String logListResponseToJson(LogListResponse data) =>
    json.encode(data.toJson());

/// MAIN RESPONSE
class LogListResponse {
  final int code;
  final List<String> message;
  final List<LogListResponseData> data;
  final int totalRecords;

  LogListResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory LogListResponse.fromJson(Map<String, dynamic> json) =>
      LogListResponse(
        code: json["code"] ?? 0,
        message: json["message"] != null
            ? List<String>.from(json["message"].map((x) => x ?? ""))
            : <String>[],
        data: json["data"] != null
            ? List<LogListResponseData>.from(
                json["data"].map((x) => LogListResponseData.fromJson(x)))
            : <LogListResponseData>[],
        totalRecords: json["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalrecords": totalRecords,
      };
}


class LogListResponseData {
  final int recNum;
  final int id;
  final int uid;
  final String eventDate;
  final String eventUser;
  final String event;

  LogListResponseData({
    required this.recNum,
    required this.id,
    required this.uid,
    required this.eventDate,
    required this.eventUser,
    required this.event,
  });

  factory LogListResponseData.fromJson(Map<String, dynamic> json) =>
      LogListResponseData(
        recNum: json["RecNum"] ?? 0,
        id: json["ID"] ?? 0,
        uid: json["UID"] ?? 0,
        eventDate: json["EventDate"] ?? "",
        eventUser: json["EventUser"] ?? "",
        event: json["Event"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "RecNum": recNum,
        "ID": id,
        "UID": uid,
        "EventDate": eventDate,
        "EventUser": eventUser,
        "Event": event,
      };
}
