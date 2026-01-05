import 'dart:convert';

LineItemListResponse LineItemListResponseFromJson(String str) =>
    LineItemListResponse.fromJson(json.decode(str));

String LineItemListResponseToJson(LineItemListResponse data) =>
    json.encode(data.toJson());

class LineItemListResponse {
  final int code;
  final List<String> message;
  final LineItemListResponseData data;
  final int totalrecords;

  LineItemListResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory LineItemListResponse.fromJson(Map<String, dynamic> json) =>
      LineItemListResponse(
        code: json["code"],
        message: List<String>.from(json["message"].map((x) => x)),
        data: LineItemListResponseData.fromJson(json["data"]),
        totalrecords: json["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
        "totalrecords": totalrecords,
      };
}

class LineItemListResponseData {
  final Permission permission;
  final List<LineItem> list;

  LineItemListResponseData({
    required this.permission,
    required this.list,
  });

  factory LineItemListResponseData.fromJson(Map<String, dynamic> json) =>
      LineItemListResponseData(
        permission: Permission.fromJson(json["permission"]),
        list:
            List<LineItem>.from(json["list"].map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "permission": permission.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

class Permission {
  final String mode;

  Permission({required this.mode});

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        mode: json["mode"],
      );

  Map<String, dynamic> toJson() => {
        "mode": mode,
      };
}

class LineItem {
  final int orderLineId;
  final int orderId;
  final int itemId;
  final int itemOrder;
  final String itemCode;
  final String description;
  final String? suppliersPartNo;
  final String? dueDate;
  final double quantity;
  final int unit;
  final double packSize;
  final double price;
  final int discountType;
  final double discount;
  final double tax;
  final double taxValue;
  final double netPrice;
  final double grossPrice;
  final int expCode4Id;
  final String expCode4;
  final int expCode5Id;
  final String expCode5;
  final int expCode6Id;
  final String expCode6;
  final double shippingCharges;
  final int supplierCcyId;
  final String supplierCcyCode;
  final int regionId;
  final double supplierCcyRate;
  final String expName4;
  final String expName5;
  final String expName6;

  LineItem({
    required this.orderLineId,
    required this.orderId,
    required this.itemId,
    required this.itemOrder,
    required this.itemCode,
    required this.description,
    required this.suppliersPartNo,
    required this.dueDate,
    required this.quantity,
    required this.unit,
    required this.packSize,
    required this.price,
    required this.discountType,
    required this.discount,
    required this.tax,
    required this.taxValue,
    required this.netPrice,
    required this.grossPrice,
    required this.expCode4Id,
    required this.expCode4,
    required this.expCode5Id,
    required this.expCode5,
    required this.expCode6Id,
    required this.expCode6,
    required this.shippingCharges,
    required this.supplierCcyId,
    required this.supplierCcyCode,
    required this.regionId,
    required this.supplierCcyRate,
    required this.expName4,
    required this.expName5,
    required this.expName6,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        orderLineId: json["Order_Line_ID"] is int
            ? json["Order_Line_ID"]
            : (json["Order_Line_ID"] is String
                ? int.tryParse(json["Order_Line_ID"]) ?? 0
                : 0),
        orderId: json["Order_ID"] is int
            ? json["Order_ID"]
            : (json["Order_ID"] is String
                ? int.tryParse(json["Order_ID"]) ?? 0
                : 0),
        itemId: json["ItemID"] is int
            ? json["ItemID"]
            : (json["ItemID"] is String
                ? int.tryParse(json["ItemID"]) ?? 0
                : 0),
        itemOrder: json["Item_Order"] is int
            ? json["Item_Order"]
            : (json["Item_Order"] is String
                ? int.tryParse(json["Item_Order"]) ?? 0
                : 0),
        itemCode: json["ItemCode"]?.toString() ?? "",
        description: json["Description"]?.toString() ?? "",
        suppliersPartNo: json["SuppliersPartNo"]?.toString(),
        dueDate: json["DueDate"]?.toString(),
        quantity: json["Quantity"] is double
            ? json["Quantity"]
            : (json["Quantity"] is int
                ? (json["Quantity"] as int).toDouble()
                : (json["Quantity"] is String
                    ? double.tryParse(json["Quantity"]) ?? 0.0
                    : 0.0)),
        unit: json["Unit"] is int
            ? json["Unit"]
            : (json["Unit"] is String 
                ? int.tryParse(json["Unit"]) ?? 0
                : 0), // Fixed this line
        packSize: json["PackSize"] is double
            ? json["PackSize"]
            : (json["PackSize"] is int
                ? (json["PackSize"] as int).toDouble()
                : (json["PackSize"] is String
                    ? double.tryParse(json["PackSize"]) ?? 0.0
                    : 0.0)),
        price: json["Price"] is double
            ? json["Price"]
            : (json["Price"] is int
                ? (json["Price"] as int).toDouble()
                : (json["Price"] is String
                    ? double.tryParse(json["Price"]) ?? 0.0
                    : 0.0)),
        discountType: json["Discount_Type"] is int
            ? json["Discount_Type"]
            : (json["Discount_Type"] is String
                ? int.tryParse(json["Discount_Type"]) ?? 0
                : 0),
        discount: json["Discount"] is double
            ? json["Discount"]
            : (json["Discount"] is int
                ? (json["Discount"] as int).toDouble()
                : (json["Discount"] is String
                    ? double.tryParse(json["Discount"]) ?? 0.0
                    : 0.0)),
        tax: json["Tax"] is double
            ? json["Tax"]
            : (json["Tax"] is int
                ? (json["Tax"] as int).toDouble()
                : (json["Tax"] is String
                    ? double.tryParse(json["Tax"]) ?? 0.0
                    : 0.0)),
        taxValue: json["TaxValue"] is double
            ? json["TaxValue"]
            : (json["TaxValue"] is int
                ? (json["TaxValue"] as int).toDouble()
                : (json["TaxValue"] is String
                    ? double.tryParse(json["TaxValue"]) ?? 0.0
                    : 0.0)),
        netPrice: json["NetPrice"] is double
            ? json["NetPrice"]
            : (json["NetPrice"] is int
                ? (json["NetPrice"] as int).toDouble()
                : (json["NetPrice"] is String
                    ? double.tryParse(json["NetPrice"]) ?? 0.0
                    : 0.0)),
        grossPrice: json["GrossPrice"] is double
            ? json["GrossPrice"]
            : (json["GrossPrice"] is int
                ? (json["GrossPrice"] as int).toDouble()
                : (json["GrossPrice"] is String
                    ? double.tryParse(json["GrossPrice"]) ?? 0.0
                    : 0.0)),
        expCode4Id: json["ExpCode4_ID"] is int
            ? json["ExpCode4_ID"]
            : (json["ExpCode4_ID"] is String
                ? int.tryParse(json["ExpCode4_ID"]) ?? 0
                : 0),
        expCode4: json["ExpCode4"]?.toString() ?? "",
        expCode5Id: json["ExpCode5_ID"] is int
            ? json["ExpCode5_ID"]
            : (json["ExpCode5_ID"] is String
                ? int.tryParse(json["ExpCode5_ID"]) ?? 0
                : 0),
        expCode5: json["ExpCode5"]?.toString() ?? "",
        expCode6Id: json["ExpCode6_ID"] is int
            ? json["ExpCode6_ID"]
            : (json["ExpCode6_ID"] is String
                ? int.tryParse(json["ExpCode6_ID"]) ?? 0
                : 0),
        expCode6: json["ExpCode6"]?.toString() ?? "",
        shippingCharges: json["Shipping_Charges"] is double
            ? json["Shipping_Charges"]
            : (json["Shipping_Charges"] is int
                ? (json["Shipping_Charges"] as int).toDouble()
                : (json["Shipping_Charges"] is String
                    ? double.tryParse(json["Shipping_Charges"]) ?? 0.0
                    : 0.0)),
        supplierCcyId: json["Supplier_CcyID"] is int
            ? json["Supplier_CcyID"]
            : (json["Supplier_CcyID"] is String
                ? int.tryParse(json["Supplier_CcyID"]) ?? 0
                : 0),
        supplierCcyCode: json["Supplier_CcyCode"]?.toString() ?? "",
        regionId: json["Region_ID"] is int
            ? json["Region_ID"]
            : (json["Region_ID"] is String
                ? int.tryParse(json["Region_ID"]) ?? 0
                : 0),
        supplierCcyRate: json["Supplier_CcyRate"] is double
            ? json["Supplier_CcyRate"]
            : (json["Supplier_CcyRate"] is int
                ? (json["Supplier_CcyRate"] as int).toDouble()
                : (json["Supplier_CcyRate"] is String
                    ? double.tryParse(json["Supplier_CcyRate"]) ?? 0.0
                    : 0.0)),
        expName4: json["ExpName4"]?.toString() ?? "",
        expName5: json["ExpName5"]?.toString() ?? "",
        expName6: json["ExpName6"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Order_Line_ID": orderLineId,
        "Order_ID": orderId,
        "ItemID": itemId,
        "Item_Order": itemOrder,
        "ItemCode": itemCode,
        "Description": description,
        "SuppliersPartNo": suppliersPartNo,
        "DueDate": dueDate,
        "Quantity": quantity,
        "Unit": unit,
        "PackSize": packSize,
        "Price": price,
        "Discount_Type": discountType,
        "Discount": discount,
        "Tax": tax,
        "TaxValue": taxValue,
        "NetPrice": netPrice,
        "GrossPrice": grossPrice,
        "ExpCode4_ID": expCode4Id,
        "ExpCode4": expCode4,
        "ExpCode5_ID": expCode5Id,
        "ExpCode5": expCode5,
        "ExpCode6_ID": expCode6Id,
        "ExpCode6": expCode6,
        "Shipping_Charges": shippingCharges,
        "Supplier_CcyID": supplierCcyId,
        "Supplier_CcyCode": supplierCcyCode,
        "Region_ID": regionId,
        "Supplier_CcyRate": supplierCcyRate,
        "ExpName4": expName4,
        "ExpName5": expName5,
        "ExpName6": expName6,
      };
}
