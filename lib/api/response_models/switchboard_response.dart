// To parse this JSON data, do
//
//     final SwitchboardResponse = SwitchboardResponseFromJson(jsonString);

import 'dart:convert';

SwitchboardResponse SwitchboardResponseFromJson(String str) =>
    SwitchboardResponse.fromJson(json.decode(str));

String SwitchboardResponseToJson(SwitchboardResponse data) =>
    json.encode(data.toJson());

class SwitchboardResponse {
  int code;
  List<String> message;
  Data data;
  int totalrecords;

  SwitchboardResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory SwitchboardResponse.fromJson(Map<String, dynamic> json) =>
      SwitchboardResponse(
        code: json["code"],
        message: List<String>.from(json["message"].map((x) => x)),
        data: Data.fromJson(json["data"]),
        totalrecords: json["totalrecords"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": data.toJson(),
        "totalrecords": totalrecords,
      };
}

class Data {
  SystemFunction systemFunction;
  UserPermissions userPermissions;
  UserApprovals userApprovals;

  Data({
    required this.systemFunction,
    required this.userPermissions,
    required this.userApprovals,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        systemFunction: SystemFunction.fromJson(json["SystemFunction"]),
        userPermissions: UserPermissions.fromJson(json["UserPermissions"]),
        userApprovals: UserApprovals.fromJson(json["UserApprovals"]),
      );

  Map<String, dynamic> toJson() => {
        "SystemFunction": systemFunction.toJson(),
        "UserPermissions": userPermissions.toJson(),
        "UserApprovals": userApprovals.toJson(),
      };
}

class SystemFunction {
  bool sysRequest;
  bool sysOrder;
  bool sysRfq;
  bool sysExpense;
  bool sysRecipe;
  bool sysInventory;
  bool sysPayments;
  int sysPaymentApprover;
  bool sysRegionFunction;
  bool sysRegionFunctionAvailable;
  dynamic sysRegionName;
  bool sysRequestApproval;
  bool sysRuleFunction;
  bool sysRuleApproval;
  bool sysCostCentreApproval;
  bool sysGroupApproval;

  SystemFunction({
    required this.sysRequest,
    required this.sysOrder,
    required this.sysRfq,
    required this.sysExpense,
    required this.sysRecipe,
    required this.sysInventory,
    required this.sysPayments,
    required this.sysPaymentApprover,
    required this.sysRegionFunction,
    required this.sysRegionFunctionAvailable,
    required this.sysRegionName,
    required this.sysRequestApproval,
    required this.sysRuleFunction,
    required this.sysRuleApproval,
    required this.sysCostCentreApproval,
    required this.sysGroupApproval,
  });

  factory SystemFunction.fromJson(Map<String, dynamic> json) => SystemFunction(
        sysRequest: json["Sys_Request"],
        sysOrder: json["Sys_Order"],
        sysRfq: json["Sys_RFQ"],
        sysExpense: json["Sys_Expense"],
        sysRecipe: json["Sys_Recipe"],
        sysInventory: json["Sys_Inventory"],
        sysPayments: json["Sys_Payments"],
        sysPaymentApprover: json["Sys_PaymentApprover"],
        sysRegionFunction: json["Sys_Region_Function"],
        sysRegionFunctionAvailable: json["Sys_Region_Function_Available"],
        sysRegionName: json["Sys_RegionName"],
        sysRequestApproval: json["Sys_RequestApproval"],
        sysRuleFunction: json["Sys_RuleFunction"],
        sysRuleApproval: json["Sys_RuleApproval"],
        sysCostCentreApproval: json["Sys_CostCentreApproval"],
        sysGroupApproval: json["Sys_GroupApproval"],
      );

  Map<String, dynamic> toJson() => {
        "Sys_Request": sysRequest,
        "Sys_Order": sysOrder,
        "Sys_RFQ": sysRfq,
        "Sys_Expense": sysExpense,
        "Sys_Recipe": sysRecipe,
        "Sys_Inventory": sysInventory,
        "Sys_Payments": sysPayments,
        "Sys_PaymentApprover": sysPaymentApprover,
        "Sys_Region_Function": sysRegionFunction,
        "Sys_Region_Function_Available": sysRegionFunctionAvailable,
        "Sys_RegionName": sysRegionName,
        "Sys_RequestApproval": sysRequestApproval,
        "Sys_RuleFunction": sysRuleFunction,
        "Sys_RuleApproval": sysRuleApproval,
        "Sys_CostCentreApproval": sysCostCentreApproval,
        "Sys_GroupApproval": sysGroupApproval,
      };
}

class UserApprovals {
  bool userRequestApproval;
  bool userOrderApproval;
  bool userInvoiceApproval;
  bool userExpenseApproval;

  UserApprovals({
    required this.userRequestApproval,
    required this.userOrderApproval,
    required this.userInvoiceApproval,
    required this.userExpenseApproval,
  });

  factory UserApprovals.fromJson(Map<String, dynamic> json) => UserApprovals(
        userRequestApproval: json["User_RequestApproval"],
        userOrderApproval: json["User_OrderApproval"],
        userInvoiceApproval: json["User_InvoiceApproval"],
        userExpenseApproval: json["User_ExpenseApproval"],
      );

  Map<String, dynamic> toJson() => {
        "User_RequestApproval": userRequestApproval,
        "User_OrderApproval": userOrderApproval,
        "User_InvoiceApproval": userInvoiceApproval,
        "User_ExpenseApproval": userExpenseApproval,
      };
}

class UserPermissions {
  String userRequest;
  String userOrder;
  String userRfq;
  String userGr;
  String userPayments;
  String userExpense;
  String userRecipe;
  String userInventory;

  UserPermissions({
    required this.userRequest,
    required this.userOrder,
    required this.userRfq,
    required this.userGr,
    required this.userPayments,
    required this.userExpense,
    required this.userRecipe,
    required this.userInventory,
  });

  factory UserPermissions.fromJson(Map<String, dynamic> json) =>
      UserPermissions(
        userRequest: json["User_Request"],
        userOrder: json["User_Order"],
        userRfq: json["User_RFQ"],
        userGr: json["User_GR"],
        userPayments: json["User_Payments"],
        userExpense: json["User_Expense"],
        userRecipe: json["User_Recipe"],
        userInventory: json["User_Inventory"],
      );

  Map<String, dynamic> toJson() => {
        "User_Request": userRequest,
        "User_Order": userOrder,
        "User_RFQ": userRfq,
        "User_GR": userGr,
        "User_Payments": userPayments,
        "User_Expense": userExpense,
        "User_Recipe": userRecipe,
        "User_Inventory": userInventory,
      };
}
