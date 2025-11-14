// To parse this JSON data, do
//
//     final HeaderListResponse = HeaderListResponseFromJson(jsonString);

import 'dart:convert';

HeaderListResponse HeaderListResponseFromJson(String str) =>
    HeaderListResponse.fromJson(json.decode(str));

String HeaderListResponseToJson(HeaderListResponse data) =>
    json.encode(data.toJson());

class HeaderListResponse {
  int code;
  List<String> message;
  HeaderLineData headerlineData;
  int totalrecords;

  HeaderListResponse({
    required this.code,
    required this.message,
    required this.headerlineData,
    required this.totalrecords,
  });

  factory HeaderListResponse.fromJson(Map<String, dynamic> json) =>
      HeaderListResponse(
        code: json["code"],
        message: List<String>.from(json["message"].map((x) => x)),
        headerlineData: HeaderLineData.fromJson(json["data"]),
        totalrecords: json["totalrecords"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": headerlineData.toJson(),
        "totalrecords": totalrecords,
      };
}

class HeaderLineData {
  int requestId;
  String requestNumber;
  String entryDate;
  String requestStatus;
  String referenceNo;
  int orderTypeId;
  String orderType;
  String contractNo;
  String instructions;
  String fao;
  String deliveryCode;
  String categoryCode;
  int expCode1Id;
  int expCode2Id;
  int expCode3Id;
  String expCode1;
  String expCode2;
  String expCode3;
  String expName1;
  String expName2;
  String expName3;
  String requestValueLabel;
  String ccyCode;
  String dataCcyCode;
  String fob;
  String shipVia;
  dynamic expenseType;
  String requestBudgetHeader;
  String requestDescription;
  int requestValue;
  int totalTax;
  int grossTotal;
  String ruleStatus;
  String requestApproverStatus;
  int originatorId;
  String originatorName;
  String originatorEmail;
  int requestApproverId;
  String requestApproverName;
  int buyerId;
  String buyerName;
  String buyerEmail;
  int regionId;
  String regionCode;
  bool bRfqLimitRequired;
  int decRfqLimit;
  bool boolPmAssignOwnership;
  int purchasingManagerId;
  bool boolSendEmail;
  dynamic strPurchaseDepEmail;
  int hdRuleEntityId;
  bool btnApprove;
  dynamic rejectReason;
  int customer;
  int requestLineId;
  int itemOrder;
  int itemId;
  int supplierId;
  int costCentreId;
  String itemCode;
  String description;
  String unit;
  int packSize;
  int quantity;
  int price;
  int discount;
  int tax;
  int taxValue;
  int netPrice;
  int grossPrice;
  String expName4;
  String expName5;
  String expName6;
  String expCode4;
  String expCode5;
  String expCode6;
  int expCode4Id;
  int expCode5Id;
  int expCode6Id;
  dynamic dueDate;
  int supplierCcyId;
  String supplierCcyCode;
  int supplierCcyRate;
  int discountType;
  dynamic suppliersPartNo;

  HeaderLineData({
    required this.requestId,
    required this.requestNumber,
    required this.entryDate,
    required this.requestStatus,
    required this.referenceNo,
    required this.orderTypeId,
    required this.orderType,
    required this.contractNo,
    required this.instructions,
    required this.fao,
    required this.deliveryCode,
    required this.categoryCode,
    required this.expCode1Id,
    required this.expCode2Id,
    required this.expCode3Id,
    required this.expCode1,
    required this.expCode2,
    required this.expCode3,
    required this.expName1,
    required this.expName2,
    required this.expName3,
    required this.requestValueLabel,
    required this.ccyCode,
    required this.dataCcyCode,
    required this.fob,
    required this.shipVia,
    required this.expenseType,
    required this.requestBudgetHeader,
    required this.requestDescription,
    required this.requestValue,
    required this.totalTax,
    required this.grossTotal,
    required this.ruleStatus,
    required this.requestApproverStatus,
    required this.originatorId,
    required this.originatorName,
    required this.originatorEmail,
    required this.requestApproverId,
    required this.requestApproverName,
    required this.buyerId,
    required this.buyerName,
    required this.buyerEmail,
    required this.regionId,
    required this.regionCode,
    required this.bRfqLimitRequired,
    required this.decRfqLimit,
    required this.boolPmAssignOwnership,
    required this.purchasingManagerId,
    required this.boolSendEmail,
    required this.strPurchaseDepEmail,
    required this.hdRuleEntityId,
    required this.btnApprove,
    required this.rejectReason,
    required this.customer,
    required this.requestLineId,
    required this.itemOrder,
    required this.itemId,
    required this.supplierId,
    required this.costCentreId,
    required this.itemCode,
    required this.description,
    required this.unit,
    required this.packSize,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.tax,
    required this.taxValue,
    required this.netPrice,
    required this.grossPrice,
    required this.expName4,
    required this.expName5,
    required this.expName6,
    required this.expCode4,
    required this.expCode5,
    required this.expCode6,
    required this.expCode4Id,
    required this.expCode5Id,
    required this.expCode6Id,
    required this.dueDate,
    required this.supplierCcyId,
    required this.supplierCcyCode,
    required this.supplierCcyRate,
    required this.discountType,
    required this.suppliersPartNo,
  });

  factory HeaderLineData.fromJson(Map<String, dynamic> json) => HeaderLineData(
        requestId: json["Request_ID"] ?? 0,
        requestNumber: json["Request_Number"] ?? '',
        entryDate: json["Entry_Date"] ?? '',
        requestStatus: json["Request_Status"] ?? '',
        referenceNo: json["ReferenceNo"] ?? '',
        orderTypeId: json["OrderTypeID"] ?? 0,
        orderType: json["OrderType"] ?? '',
        contractNo: json["ContractNo"] ?? '',
        instructions: json["Instructions"] ?? '',
        fao: json["FAO"] ?? '',
        deliveryCode: json["DeliveryCode"] ?? '',
        categoryCode: json["CategoryCode"] ?? '',
        expCode1Id: json["ExpCode1_ID"] ?? 0,
        expCode2Id: json["ExpCode2_ID"] ?? 0,
        expCode3Id: json["ExpCode3_ID"] ?? 0,
        expCode1: json["ExpCode1"] ?? '',
        expCode2: json["ExpCode2"] ?? '',
        expCode3: json["ExpCode3"] ?? '',
        expName1: json["ExpName1"] ?? '',
        expName2: json["ExpName2"] ?? '',
        expName3: json["ExpName3"] ?? '',
        requestValueLabel: json["RequestValueLabel"] ?? '',
        ccyCode: json["CCYCode"] ?? '',
        dataCcyCode: json["Ccy_Code"] ?? '',
        fob: json["FOB"] ?? '',
        shipVia: json["Ship_Via"] ?? '',
        expenseType: json["Expense_Type"],
        requestBudgetHeader: json["Request_Budget_header"] ?? '',
        requestDescription: json["Request_Description"] ?? '',
        requestValue: (json["Request_Value"] ?? 0).toInt(),
        totalTax: (json["TotalTax"] ?? 0).toInt(),
        grossTotal: (json["GrossTotal"] ?? 0).toInt(),
        ruleStatus: json["Rule_status"] ?? '',
        requestApproverStatus: json["Request_Approver_Status"] ?? '',
        originatorId: json["Originator_ID"] ?? 0,
        originatorName: json["Originator_Name"] ?? '',
        originatorEmail: json["Originator_Email"] ?? '',
        requestApproverId: json["RequestApprover_ID"] ?? 0,
        requestApproverName: json["RequestApproverName"] ?? '',
        buyerId: json["Buyer_ID"] ?? 0,
        buyerName: json["Buyer_Name"] ?? '',
        buyerEmail: json["Buyer_Email"] ?? '',
        regionId: json["Region_ID"] ?? 0,
        regionCode: json["Region_Code"] ?? '',
        bRfqLimitRequired: json["bRFQ_Limit_Required"] ?? false,
        decRfqLimit: (json["decRFQ_Limit"] ?? 0).toInt(),
        boolPmAssignOwnership: json["boolPM_Assign_Ownership"] ?? false,
        purchasingManagerId: json["PurchasingManager_ID"] ?? 0,
        boolSendEmail: json["boolSendEmail"] ?? false,
        strPurchaseDepEmail: json["strPurchase_Dep_Email"],
        hdRuleEntityId: json["hd_Rule_EntityID"] ?? 0,
        btnApprove: json["btnApprove"] ?? false,
        rejectReason: json["Reject_Reason"],
        customer: json["Customer"] ?? 0,
        requestLineId: json["Request_Line_ID"] ?? 0,
        itemOrder: json["Item_Order"] ?? 0,
        itemId: json["ItemID"] ?? 0,
        supplierId: json["SupplierID"] ?? 0,
        costCentreId: json["CostCentre_ID"] ?? 0,
        itemCode: json["ItemCode"] ?? '',
        description: json["Description"] ?? '',
        unit: json["Unit"] ?? '',
        packSize: (json["PackSize"] ?? 0).toInt(),
        quantity: (json["Quantity"] ?? 0).toInt(),
        price: (json["Price"] ?? 0).toInt(),
        discount: (json["Discount"] ?? 0).toInt(),
        tax: (json["Tax"] ?? 0).toInt(),
        taxValue: (json["TaxValue"] ?? 0).toInt(),
        netPrice: (json["NetPrice"] ?? 0).toInt(),
        grossPrice: (json["GrossPrice"] ?? 0).toInt(),
        expName4: json["ExpName4"] ?? '',
        expName5: json["ExpName5"] ?? '',
        expName6: json["ExpName6"] ?? '',
        expCode4: json["ExpCode4"] ?? '',
        expCode5: json["ExpCode5"] ?? '',
        expCode6: json["ExpCode6"] ?? '',
        expCode4Id: json["ExpCode4_ID"] ?? 0,
        expCode5Id: json["ExpCode5_ID"] ?? 0,
        expCode6Id: json["ExpCode6_ID"] ?? 0,
        dueDate: json["DueDate"],
        supplierCcyId: json["Supplier_CcyID"] ?? 0,
        supplierCcyCode: json["Supplier_CcyCode"] ?? '',
        supplierCcyRate: (json["Supplier_CcyRate"] ?? 0).toInt(),
        discountType: json["Discount_Type"] ?? 0,
        suppliersPartNo: json["SuppliersPartNo"],
      );

  Map<String, dynamic> toJson() => {
        "Request_ID": requestId,
        "Request_Number": requestNumber,
        "Entry_Date": entryDate,
        "Request_Status": requestStatus,
        "ReferenceNo": referenceNo,
        "OrderTypeID": orderTypeId,
        "OrderType": orderType,
        "ContractNo": contractNo,
        "Instructions": instructions,
        "FAO": fao,
        "DeliveryCode": deliveryCode,
        "CategoryCode": categoryCode,
        "ExpCode1_ID": expCode1Id,
        "ExpCode2_ID": expCode2Id,
        "ExpCode3_ID": expCode3Id,
        "ExpCode1": expCode1,
        "ExpCode2": expCode2,
        "ExpCode3": expCode3,
        "ExpName1": expName1,
        "ExpName2": expName2,
        "ExpName3": expName3,
        "RequestValueLabel": requestValueLabel,
        "CCYCode": ccyCode,
        "Ccy_Code": dataCcyCode,
        "FOB": fob,
        "Ship_Via": shipVia,
        "Expense_Type": expenseType,
        "Request_Budget_header": requestBudgetHeader,
        "Request_Description": requestDescription,
        "Request_Value": requestValue,
        "TotalTax": totalTax,
        "GrossTotal": grossTotal,
        "Rule_status": ruleStatus,
        "Request_Approver_Status": requestApproverStatus,
        "Originator_ID": originatorId,
        "Originator_Name": originatorName,
        "Originator_Email": originatorEmail,
        "RequestApprover_ID": requestApproverId,
        "RequestApproverName": requestApproverName,
        "Buyer_ID": buyerId,
        "Buyer_Name": buyerName,
        "Buyer_Email": buyerEmail,
        "Region_ID": regionId,
        "Region_Code": regionCode,
        "bRFQ_Limit_Required": bRfqLimitRequired,
        "decRFQ_Limit": decRfqLimit,
        "boolPM_Assign_Ownership": boolPmAssignOwnership,
        "PurchasingManager_ID": purchasingManagerId,
        "boolSendEmail": boolSendEmail,
        "strPurchase_Dep_Email": strPurchaseDepEmail,
        "hd_Rule_EntityID": hdRuleEntityId,
        "btnApprove": btnApprove,
        "Reject_Reason": rejectReason,
        "Customer": customer,
        "Request_Line_ID": requestLineId,
        "Item_Order": itemOrder,
        "ItemID": itemId,
        "SupplierID": supplierId,
        "CostCentre_ID": costCentreId,
        "ItemCode": itemCode,
        "Description": description,
        "Unit": unit,
        "PackSize": packSize,
        "Quantity": quantity,
        "Price": price,
        "Discount": discount,
        "Tax": tax,
        "TaxValue": taxValue,
        "NetPrice": netPrice,
        "GrossPrice": grossPrice,
        "ExpName4": expName4,
        "ExpName5": expName5,
        "ExpName6": expName6,
        "ExpCode4": expCode4,
        "ExpCode5": expCode5,
        "ExpCode6": expCode6,
        "ExpCode4_ID": expCode4Id,
        "ExpCode5_ID": expCode5Id,
        "ExpCode6_ID": expCode6Id,
        "DueDate": dueDate,
        "Supplier_CcyID": supplierCcyId,
        "Supplier_CcyCode": supplierCcyCode,
        "Supplier_CcyRate": supplierCcyRate,
        "Discount_Type": discountType,
        "SuppliersPartNo": suppliersPartNo,
      };
}
