import 'dart:convert';

class Order {
  int orderId;
  int regionId;
  String orderNumber;
  String? status; // new
  String? date; // new

  Order({
    required this.orderId,
    required this.regionId,
    required this.orderNumber,
    this.status,
    this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderid'],
      regionId: json['regionid'],
      orderNumber: json['ordernumber'],
      status: _getHardcodedStatus(json['orderid']), // hardcoded
      date: _getHardcodedDate(json['orderid']), // hardcoded
    );
  }

  static String _getHardcodedStatus(int orderId) {
    // Add your own mapping logic if needed
    return (orderId % 2 == 0) ? 'Approved' : 'Pending';
  }

  static String _getHardcodedDate(int orderId) {
    // Generate or map a date based on orderId or use a fixed format
    return '2025-05-${(orderId % 28 + 1).toString().padLeft(2, '0')}';
  }
}

class OrderResponse {
  String code;
  List<String> message;
  final dynamic data;
  int totalRecords;

  OrderResponse({
    required this.code,
    required this.message,
    this.data,
    required this.totalRecords,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    var dataList = [];
    List<Order> orders = [];
    if (json['data'] != null) {
      dataList = jsonDecode(json['data']) as List;
      orders = dataList.map((i) => Order.fromJson(i)).toList();
    }

    return OrderResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: json['data'] == null ? json['data'] : orders,
      totalRecords: json['totalrecords'],
    );
  }
}
