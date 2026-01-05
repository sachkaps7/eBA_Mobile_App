import 'dart:convert';

RuleApprovalResponse ruleApprovalResponseModelFromJson(String str) =>
    RuleApprovalResponse.fromJson(json.decode(str));

String ruleApprovalResponseModelToJson(RuleApprovalResponse data) =>
    json.encode(data.toJson());

class RuleApprovalResponse {
  final int code;
  final List<String> message;
  final List<RuleApprovalResponseData> data;
  final int totalrecords;

  RuleApprovalResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalrecords,
  });

  factory RuleApprovalResponse.fromJson(Map<String, dynamic> json) =>
      RuleApprovalResponse(
        code: json["code"] ?? 0,
        message: json["message"] != null
            ? List<String>.from(json["message"].map((x) => x ?? ""))
            : [],
        data: json["data"] != null
            ? List<RuleApprovalResponseData>.from(
                json["data"].map(
                    (x) => RuleApprovalResponseData.fromJson(x ?? {})))
            : [],
        totalrecords: json["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalrecords": totalrecords,
      };
}

class RuleApprovalResponseData {
  final int ruleStatusId;
  final int uid;
  final int uidGroup;
  final String approvalStatus;
  final int approvalOrder;
  final int proxyId;
  final String userGroupName;
  final String userGroupDescription;
  final String userName;
  final String proxyUserName;
  final String email;

  RuleApprovalResponseData({
    required this.ruleStatusId,
    required this.uid,
    required this.uidGroup,
    required this.approvalStatus,
    required this.approvalOrder,
    required this.proxyId,
    required this.userGroupName,
    required this.userGroupDescription,
    required this.userName,
    required this.proxyUserName,
    required this.email,
  });

  factory RuleApprovalResponseData.fromJson(Map<String, dynamic> json) =>
      RuleApprovalResponseData(
        ruleStatusId: json["Rule_Status_ID"] ?? 0,
        uid: json["UID"] ?? 0,
        uidGroup: json["UID_Group"] ?? 0,
        approvalStatus: json["Approval_Status"] ?? "",
        approvalOrder: json["Approval_Order"] ?? 0,
        proxyId: json["Proxy_ID"] ?? 0,
        userGroupName: json["User_Group_Name"] ?? "",
        userGroupDescription: json["User_Group_Description"] ?? "",
        userName: json["UserName"] ?? "",
        proxyUserName: json["Proxy_UserName"] ?? "",
        email: json["Email"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Rule_Status_ID": ruleStatusId,
        "UID": uid,
        "UID_Group": uidGroup,
        "Approval_Status": approvalStatus,
        "Approval_Order": approvalOrder,
        "Proxy_ID": proxyId,
        "User_Group_Name": userGroupName,
        "User_Group_Description": userGroupDescription,
        "UserName": userName,
        "Proxy_UserName": proxyUserName,
        "Email": email,
      };
}
