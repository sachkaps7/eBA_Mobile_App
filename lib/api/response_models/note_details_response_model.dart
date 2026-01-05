class NotesResponse {
  final int code;
  final List<String> message;
  final NotesWrapper data;
  final int totalRecords;

  NotesResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory NotesResponse.fromJson(Map<String, dynamic> json) {
    return NotesResponse(
      code: json['code'] ?? 0,
      message: json['message'] != null
          ? List<String>.from(json['message'])
          : [],
      data: NotesWrapper.fromJson(json['data'] ?? {}),
      totalRecords: json['totalrecords'] ?? 0,
    );
  }
}
class NotesWrapper {
  final Permission permission;
  final NotesData notesData;

  NotesWrapper({
    required this.permission,
    required this.notesData,
  });

  factory NotesWrapper.fromJson(Map<String, dynamic> json) {
    return NotesWrapper(
      permission: Permission.fromJson(json['permission'] ?? {}),
      notesData: NotesData.fromJson(json['data'] ?? {}),
    );
  }
}
class Permission {
  final String mode;

  Permission({required this.mode});

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      mode: json['mode'] ?? '',
    );
  }
}
class NotesData {
  final int notesId;
  final String? notes;
  final String? enteredBy;
  final String? entryDate;
  final int intId;
  final int requestId;
  final int orderId;
  final int rfqId;
  final int uid;
  final int regionId;
  final String? groupName;
  final int notePrivacy;
  final String? notePrivacyText;
  final String? pageFrom;

  NotesData({
    required this.notesId,
    this.notes,
    this.enteredBy,
    this.entryDate,
    required this.intId,
    required this.requestId,
    required this.orderId,
    required this.rfqId,
    required this.uid,
    required this.regionId,
    this.groupName,
    required this.notePrivacy,
    this.notePrivacyText,
    this.pageFrom,
  });

  factory NotesData.fromJson(Map<String, dynamic> json) {
    return NotesData(
      notesId: json['Notes_ID'] ?? 0,
      notes: json['Notes'],
      enteredBy: json['EnteredBy'],
      entryDate: json['EntryDate'],
      intId: json['Int_ID'] ?? 0,
      requestId: json['Request_ID'] ?? 0,
      orderId: json['Order_ID'] ?? 0,
      rfqId: json['RFQ_ID'] ?? 0,
      uid: json['UID'] ?? 0,
      regionId: json['Region_ID'] ?? 0,
      groupName: json['GroupName'],
      notePrivacy: json['Note_Privacy'] ?? 0,
      notePrivacyText: json['Note_PrivacyText'],
      pageFrom: json['PageFrom'],
    );
  }
}
