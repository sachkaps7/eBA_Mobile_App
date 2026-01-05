// To parse this JSON data:
//
//   final orderDetails = orderDetailsResponseFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

OrderDetailsResponse orderDetailsResponseFromJson(String str) =>
    OrderDetailsResponse.fromJson(json.decode(str));

String orderDetailsResponseToJson(OrderDetailsResponse data) =>
    json.encode(data.toJson());

class OrderDetailsResponse {
  int code;
  List<String> message;
  OrderDetailsResponseData data;
  int totalrecords;

  OrderDetailsResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) =>
      OrderDetailsResponse(
        code: json["code"] ?? 0,
        message: json["message"] == null
            ? []
            : List<String>.from(json["message"].map((x) => x.toString())),
        data: OrderDetailsResponseData.fromJson(json["data"] ?? {}),
        totalrecords: json["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": data.toJson(),
        "totalrecords": totalrecords,
      };
}

class OrderDetailsResponseData {
  Header header;
  String lineItemsCount;
  String ruleCount;
  String ruleApproversCount;
  String costcenterCount;
  String approverCount;
  String grpapproverCount;
  String attachdocCount;
  String termsCount;
  String notesCount;
  String logCount;
  String buttonName;
  String buttonAction;
  String buttonAlert;

  OrderDetailsResponseData({
    required this.header,
    required this.lineItemsCount,
    required this.ruleCount,
    required this.ruleApproversCount,
    required this.costcenterCount,
    required this.approverCount,
    required this.grpapproverCount,
    required this.attachdocCount,
    required this.termsCount,
    required this.notesCount,
    required this.logCount,
    required this.buttonName,
    required this.buttonAction,
    required this.buttonAlert,
  });

  factory OrderDetailsResponseData.fromJson(Map<String, dynamic> json) =>
      OrderDetailsResponseData(
        header: Header.fromJson(json["header"] ?? {}),
        lineItemsCount: json["lineItemsCount"]?.toString() ?? "0",
        ruleCount: json["ruleCount"]?.toString() ?? "0",
        ruleApproversCount: json["ruleApproversCount"]?.toString() ?? "0",
        costcenterCount: json["costcenterCount"]?.toString() ?? "0",
        approverCount: json["approverCount"]?.toString() ?? "0",
        grpapproverCount: json["grpapproverCount"]?.toString() ?? "0",
        attachdocCount: json["attachdocCount"]?.toString() ?? "0",
        termsCount: json["termsCount"]?.toString() ?? "0",
        notesCount: json["notesCount"]?.toString() ?? "0",
        logCount: json["logCount"]?.toString() ?? "0",
        buttonName: json["ButtonName"]?.toString() ?? "",
        buttonAction: json["ButtonAction"]?.toString() ?? "",
        buttonAlert: json["ButtonAlert"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "lineItemsCount": lineItemsCount,
        "ruleCount": ruleCount,
        "ruleApproversCount": ruleApproversCount,
        "costcenterCount": costcenterCount,
        "approverCount": approverCount,
        "grpapproverCount": grpapproverCount,
        "attachdocCount": attachdocCount,
        "termsCount": termsCount,
        "notesCount": notesCount,
        "logCount": logCount,
        "ButtonName": buttonName,
        "ButtonAction": buttonAction,
        "ButtonAlert": buttonAlert,
      };
}

class Header {
  int orderId;
  String orderNumber;
  String orderStatus;
  String orderDate;
  double orderValue;
  String referenceNo;
  int supplierId;
  String supplierName;
  String fao;
  int deliveryId;
  int invoicePtId;
  int categoryId;
  int orderTypeId;
  int expCode1Id;
  int expCode2Id;
  int expCode3Id;
  int contractId;
  String fob;
  String orderBudgetHeader;
  String approvalType;
  String ccApproverStatus;
  String groupApproverStatus;
  String ruleStatus;
  String invoicePtCode;
  String deliveryCode;
  String categoryCode;
  String expCode1;
  String expCode2;
  String expCode3;
  String expName1;
  String expName2;
  String expName3;
  double orderGrossTotal;
  String orderValueLabel;
  String ccyCode;
  String uid;
  String userSession;
  String apptype;
  String clientcode;
  String accesskey;
  String connectionstring;

  Header({
    required this.orderId,
    required this.orderNumber,
    required this.orderStatus,
    required this.orderDate,
    required this.orderValue,
    required this.referenceNo,
    required this.supplierId,
    required this.supplierName,
    required this.fao,
    required this.deliveryId,
    required this.invoicePtId,
    required this.categoryId,
    required this.orderTypeId,
    required this.expCode1Id,
    required this.expCode2Id,
    required this.expCode3Id,
    required this.contractId,
    required this.fob,
    required this.orderBudgetHeader,
    required this.approvalType,
    required this.ccApproverStatus,
    required this.groupApproverStatus,
    required this.ruleStatus,
    required this.invoicePtCode,
    required this.deliveryCode,
    required this.categoryCode,
    required this.expCode1,
    required this.expCode2,
    required this.expCode3,
    required this.expName1,
    required this.expName2,
    required this.expName3,
    required this.orderGrossTotal,
    required this.orderValueLabel,
    required this.ccyCode,
    required this.uid,
    required this.userSession,
    required this.apptype,
    required this.clientcode,
    required this.accesskey,
    required this.connectionstring,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        orderId: json["Order_ID"] ?? 0,
        orderNumber: json["OrderNumber"] ?? "",
        orderStatus: json["Order_Status"] ?? "",
        orderDate: json["Order_Date"] ?? "",
        orderValue: json["Order_Value"] ?? 0.00,
        referenceNo: json["ReferenceNo"] ?? "",
        supplierId: json["SupplierID"] ?? 0,
        supplierName: json["Supplier_Name"] ?? "",
        fao: json["FAO"] ?? "",
        deliveryId: json["DeliveryID"] ?? 0,
        invoicePtId: json["InvoicePtID"] ?? 0,
        categoryId: json["CategoryID"] ?? 0,
        orderTypeId: json["OrderTypeID"] ?? 0,
        expCode1Id: json["ExpCode1_ID"] ?? 0,
        expCode2Id: json["ExpCode2_ID"] ?? 0,
        expCode3Id: json["ExpCode3_ID"] ?? 0,
        contractId: json["ContractID"] ?? 0,
        fob: json["FOB"] ?? "",
        orderBudgetHeader: json["Order_Budget_Header"] ?? "",
        approvalType: json["ApprovalType"]?.toString() ?? "",
        ccApproverStatus: json["CC_Approver_Status"] ?? "",
        groupApproverStatus: json["Group_Approver_Status"] ?? "",
        ruleStatus: json["Rule_status"] ?? "",
        invoicePtCode: json["InvoicePtCode"] ?? "",
        deliveryCode: json["DeliveryCode"] ?? "",
        categoryCode: json["CategoryCode"] ?? "",
        expCode1: json["ExpCode1"] ?? "",
        expCode2: json["ExpCode2"] ?? "",
        expCode3: json["ExpCode3"] ?? "",
        expName1: json["ExpName1"] ?? "",
        expName2: json["ExpName2"] ?? "",
        expName3: json["ExpName3"] ?? "",
        orderGrossTotal: json["OrderGrossTotal"] ?? 0.0,
        orderValueLabel: json["OrderValueLabel"] ?? "",
        ccyCode: json["Ccy_code"] ?? "",
        uid: json["uid"]?.toString() ?? "",
        userSession: json["userSession"]?.toString() ?? "",
        apptype: json["apptype"]?.toString() ?? "",
        clientcode: json["clientcode"] ?? "",
        accesskey: json["accesskey"] ?? "",
        connectionstring: json["connectionstring"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Order_ID": orderId,
        "OrderNumber": orderNumber,
        "Order_Status": orderStatus,
        "Order_Date": orderDate,
        "Order_Value": orderValue,
        "ReferenceNo": referenceNo,
        "SupplierID": supplierId,
        "Supplier_Name": supplierName,
        "FAO": fao,
        "DeliveryID": deliveryId,
        "InvoicePtID": invoicePtId,
        "CategoryID": categoryId,
        "OrderTypeID": orderTypeId,
        "ExpCode1_ID": expCode1Id,
        "ExpCode2_ID": expCode2Id,
        "ExpCode3_ID": expCode3Id,
        "ContractID": contractId,
        "FOB": fob,
        "Order_Budget_Header": orderBudgetHeader,
        "ApprovalType": approvalType,
        "CC_Approver_Status": ccApproverStatus,
        "Group_Approver_Status": groupApproverStatus,
        "Rule_status": ruleStatus,
        "InvoicePtCode": invoicePtCode,
        "DeliveryCode": deliveryCode,
        "CategoryCode": categoryCode,
        "ExpCode1": expCode1,
        "ExpCode2": expCode2,
        "ExpCode3": expCode3,
        "ExpName1": expName1,
        "ExpName2": expName2,
        "ExpName3": expName3,
        "OrderGrossTotal": orderGrossTotal,
        "OrderValueLabel": orderValueLabel,
        "Ccy_code": ccyCode,
        "uid": uid,
        "userSession": userSession,
        "apptype": apptype,
        "clientcode": clientcode,
        "accesskey": accesskey,
        "connectionstring": connectionstring,
      };
}
