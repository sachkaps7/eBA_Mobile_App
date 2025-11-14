import 'package:flutter/material.dart';

// class NotificationProvider with ChangeNotifier {
//   String _title = '';
//   String _body = '';

//   String get title => _title;
//   String get body => _body;

//   void setNotificationData(String title, String body) {
//     _title = title;
//     _body = body;
//     notifyListeners();
//   }
// }

// class NotificationProvider with ChangeNotifier {
//   Map<String, String>? _notificationData;

//   Map<String, String>? get notificationData => _notificationData;

//   void setNotificationData(String title, String body) {
//     _notificationData = {
//       'title': title,
//       'body': body,
//       'time': DateTime.now().toString(),
//     };
//     notifyListeners();
//   }

//   void clearNotificationData() {
//     _notificationData = null;
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  Map<String, String>? _notificationData;

  Map<String, String>? get notificationData => _notificationData;

  void setNotificationData(String title, String body,
      {Map<String, String>? extraData}) {
    _notificationData = {
      'title': title,
      'body': body,
      'time': DateTime.now().toIso8601String(),
      ...?extraData,
    };
    notifyListeners();
  }

  /// Clear the stored notification
  void clearNotificationData() {
    _notificationData = null;
    notifyListeners();
  }

  /// Convenience getter for specific fields
  String? get title => _notificationData?['title'];
  String? get body => _notificationData?['body'];
  String? get orderId => _notificationData?['orderId'];
    String? get orderNo => _notificationData?['orderId'];
  String? get action => _notificationData?['action'];
}
