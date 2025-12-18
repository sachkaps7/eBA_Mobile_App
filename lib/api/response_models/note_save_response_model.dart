import 'dart:convert';

NoteSaveResponse noteSaveResponseFromJson(String str) =>
    NoteSaveResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String noteSaveResponseToJson(NoteSaveResponse data) =>
    json.encode(data.toJson());

class NoteSaveResponse {
  final int code;
  final List<String> message;
  final dynamic data;
  final int totalRecords;

  const NoteSaveResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory NoteSaveResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const NoteSaveResponse(
        code: 0,
        message: [],
        data: null,
        totalRecords: 0,
      );
    }

    return NoteSaveResponse(
      code: json['code'] is int ? json['code'] as int : 0,
      message: (json['message'] as List?)
              ?.whereType<String>()
              .toList() ??
          [],
      data: json['data'],
      totalRecords: json['totalrecords'] is int
          ? json['totalrecords'] as int
          : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data,
        'totalrecords': totalRecords,
      };
}
