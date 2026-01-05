import 'dart:convert';

GroupApprovalListResponse groupApprovalListResponseFromJson(String str) =>
    GroupApprovalListResponse.fromJson(json.decode(str));

String groupApprovalListResponseToJson(GroupApprovalListResponse data) =>
    json.encode(data.toJson());

/// MAIN RESPONSE
class GroupApprovalListResponse {
  final int code;
  final List<String> message;
  final GroupApprovalListResponseData data;
  final int totalRecords;

  GroupApprovalListResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory GroupApprovalListResponse.fromJson(Map<String, dynamic> json) =>
      GroupApprovalListResponse(
        code: json["code"] ?? 0,
        message: json["message"] != null
            ? List<String>.from(json["message"])
            : <String>[],
        data: json["data"] != null
            ? GroupApprovalListResponseData.fromJson(json["data"])
            : GroupApprovalListResponseData.empty(),
        totalRecords: json["totalrecords"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": List<dynamic>.from(message),
        "data": data.toJson(),
        "totalrecords": totalRecords,
      };
}

class GroupApprovalListResponseData {
   Permission permission;
   List<GroupApprovalItem> list;

  GroupApprovalListResponseData({
    required this.permission,
    required this.list,
  });

  /// Empty fallback
  factory GroupApprovalListResponseData.empty() =>
      GroupApprovalListResponseData(
        permission: Permission(mode: "NA"),
        list: [],
      );

  factory GroupApprovalListResponseData.fromJson(Map<String, dynamic> json) =>
      GroupApprovalListResponseData(
        permission: json["permission"] != null
            ? Permission.fromJson(json["permission"])
            : Permission(mode: "NA"),
        list: json["list"] != null
            ? List<GroupApprovalItem>.from(
                json["list"].map((x) => GroupApprovalItem.fromJson(x)),
              )
            : <GroupApprovalItem>[],
      );

  Map<String, dynamic> toJson() => {
        "permission": permission.toJson(),
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
      };
}

/// EACH GROUP ITEM
class GroupApprovalItem {
  final int userGroupId;
  final String groupCode;
  final String groupDescription;
  final String mandatory;
  final String approval;
  final int uid;

  GroupApprovalItem({
    required this.userGroupId,
    required this.groupCode,
    required this.groupDescription,
    required this.mandatory,
    required this.approval,
    required this.uid,
  });

  factory GroupApprovalItem.fromJson(Map<String, dynamic> json) =>
      GroupApprovalItem(
        userGroupId: json["UserGroupID"] ?? 0,
        groupCode: json["Group_Code"] ?? "",
        groupDescription: json["Group_Description"] ?? "",
        mandatory: json["Mandatory"] ?? "",
        approval: json["Approval"] ?? "",
        uid: json["UID"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "UserGroupID": userGroupId,
        "Group_Code": groupCode,
        "Group_Description": groupDescription,
        "Mandatory": mandatory,
        "Approval": approval,
        "UID": uid,
      };
}


class Permission {
  final String mode;

  Permission({required this.mode});

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        mode: json["mode"] ?? "NA",
      );

  Map<String, dynamic> toJson() => {
        "mode": mode,
      };
}
