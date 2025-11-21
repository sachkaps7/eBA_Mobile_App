class OrderRequestCreateResponse {
  final int code;
  final List<String> message;
  final String data;
  final int totalRecords;

  OrderRequestCreateResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory OrderRequestCreateResponse.fromJson(Map<String, dynamic> json) {
    return OrderRequestCreateResponse(
      code: json['code'] ?? 0,
      message: List<String>.from(json['message'] ?? []),
      data: json['data']?.toString() ?? "",
      totalRecords: json['totalrecords'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
      'totalrecords': totalRecords,
    };
  }
}
