import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/resources/assets_manager.dart';
import 'package:eyvo_v3/core/widgets/NotificationProvider.dart';
import 'package:eyvo_v3/features/auth/view/screens/approval/order_details_view.dart';
import 'package:eyvo_v3/features/auth/view/screens/login/login.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:eyvo_v3/presentation/notification_dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eyvo_v3/main.dart'; // for navigatorKey
import 'package:http/http.dart' as http;
// class NotificationService {
//   NotificationService._privateConstructor();
//   static final NotificationService instance =
//       NotificationService._privateConstructor();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//   );

//   Future<void> initialize() async {
//     await _firebaseMessaging.requestPermission();

//     // Get the current token
//     String? token = await _firebaseMessaging.getToken();
//     LoggerData.dataLog("FCM Token: $token");

//     if (token != null && token.isNotEmpty) {
//       SharedPrefs.instance.fcmToken = token;
//     }

//     _firebaseMessaging.onTokenRefresh.listen((newToken) {
//       LoggerData.dataLog("FCM Token Refreshed: $newToken");
//       SharedPrefs.instance.fcmToken = newToken;
//     });

//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@drawable/ic_notification');

//     const InitializationSettings initSettings =
//         InitializationSettings(android: androidSettings);

//     await _flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) {
//         final payload = details.payload;
//         if (payload != null) {
//           _handleMessageFromPayload(payload);
//         }
//       },
//     );

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_channel);

//     // Listeners
//     FirebaseMessaging.onMessage.listen(_onForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

//     // App killed state
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _onMessageOpenedApp(message);
//         });
//       }
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   void _onForegroundMessage(RemoteMessage message) {
//     final notification = message.notification;
//     final data = message.data;

//     if (notification != null) {
//       _showLocalNotification(notification, data);
//       _saveNotificationToProvider(notification.title, notification.body,
//           extraData: data);
//     }
//   }

//   void _onMessageOpenedApp(RemoteMessage message) {
//     final data = message.data;
//     final title = message.notification?.title ?? data['title'];
//     final body = message.notification?.body ?? data['body'];

//     _saveNotificationToProvider(title, body, extraData: data);

//     final action = data['action'];
//     final idStr = data['orderId'] ?? data['requestId'];
//     final id = int.tryParse(idStr ?? '');

//     if (id != null) {
//       if (action == 'order') {
//         navigatorKey.currentState?.push(
//           MaterialPageRoute(
//             builder: (_) => OrderDetailsView(
//               orderId: id,
//             ),
//           ),
//         );
//       } else if (action == 'request') {
//         navigatorKey.currentState?.push(
//           MaterialPageRoute(
//             builder: (_) => NotificationDashboard(
//                 notificationData: Map<String, String>.from(data)),
//           ),
//         );
//       } else {
//         navigatorKey.currentState?.push(MaterialPageRoute(
//           builder: (_) => NotificationDashboard(
//               notificationData: Map<String, String>.from(data)),
//         ));
//       }
//     } else {
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(
//           builder: (_) => NotificationDashboard(
//               notificationData: Map<String, String>.from(data)),
//         ),
//       );
//     }
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();
//     final title = message.notification?.title ?? message.data['title'];
//     final body = message.notification?.body ?? message.data['body'];

//     NotificationService.instance
//         ._saveNotificationToProvider(title, body, extraData: message.data);
//   }

//   void _handleMessageFromPayload(String payload) {
//     try {
//       final Map<String, dynamic> decoded = jsonDecode(payload);
//       final Map<String, String> data = decoded.map(
//         (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
//       );

//       _saveNotificationToProvider(data['title'], data['body'], extraData: data);

//       final action = data['action'];
//       final idStr = data['orderId'] ?? data['requestId'];
//       final id = int.tryParse(idStr ?? '');

//       if (id != null) {
//         if (action == 'order') {
//           navigatorKey.currentState?.push(
//             MaterialPageRoute(
//               builder: (_) => OrderDetailsView(
//                 orderId: id,
//               ),
//             ),
//           );
//         } else if (action == 'request') {
//           navigatorKey.currentState?.push(
//             MaterialPageRoute(
//               builder: (_) => NotificationDashboard(notificationData: data),
//             ),
//           );
//         } else {
//           navigatorKey.currentState?.push(
//             MaterialPageRoute(
//               builder: (_) => NotificationDashboard(notificationData: data),
//             ),
//           );
//         }
//       } else {
//         navigatorKey.currentState?.push(
//           MaterialPageRoute(
//             builder: (_) => NotificationDashboard(notificationData: data),
//           ),
//         );
//       }
//     } catch (e) {
//       LoggerData.dataLog('Failed to parse payload: $e');
//     }
//   }

//   void _showLocalNotification(
//       RemoteNotification notification, Map<String, dynamic> data) async {
//     final fullPayload = jsonEncode({
//       'title': notification.title,
//       'body': notification.body,
//       'time': DateTime.now().toIso8601String(),
//       ...data.map((key, value) => MapEntry(key, value.toString())),
//     });

//     await _flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           _channel.id,
//           _channel.name,
//           icon: 'ic_notification',
//           //    color: Colors.white,
//           channelDescription: _channel.description,
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       payload: fullPayload,
//     );
//   }

//   void _saveNotificationToProvider(String? title, String? body,
//       {Map<String, dynamic>? extraData}) {
//     try {
//       if (navigatorKey.currentContext != null &&
//           title != null &&
//           body != null) {
//         final provider = Provider.of<NotificationProvider>(
//           navigatorKey.currentContext!,
//           listen: false,
//         );

//         final data = {
//           'title': title,
//           'body': body,
//           'time': DateTime.now().toIso8601String(),
//           if (extraData != null)
//             ...extraData.map((key, value) => MapEntry(key, value.toString())),
//         };
//         LoggerData.dataLog("extraData: ${jsonEncode(data)}");

//         provider.setNotificationData(data['title']!, data['body']!,
//             extraData: data);
//       }
//     } catch (e) {
//       LoggerData.dataLog('Notification Provider Error: $e');
//     }
//   }

//   Future<void> sendNotification({
//     required String targetToken,
//     required String title,
//     required String body,
//     required String id,
//     required String action,
//   }) async {
//     const String serverKey = 'approvalmobiletesting';
//     final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

//     // Prepare custom data payload
//     final dataPayload = {
//       'action': action,
//       if (action.toLowerCase() == 'order') 'orderId': id else 'requestId': id,
//     };

//     // Construct the FCM notification payload
//     final payload = {
//       'to': targetToken,
//       'notification': {
//         'title': title,
//         'body': body,
//         'android_channel_id': 'high_importance_channel',
//         'icon': 'ic_notification',
//       },
//       'data': dataPayload,
//       'android': {
//         'notification': {
//           'icon': 'ic_notification',
//           'channel_id': 'high_importance_channel',
//         }
//       }
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$serverKey',
//         },
//         body: jsonEncode(payload),
//       );

//       if (response.statusCode == 200) {
//         LoggerData.dataLog('Notification sent successfully');
//       } else {
//         LoggerData.dataLog(
//             ' Failed to send notification: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       LoggerData.dataLog(' Error sending notification: $e');
//     }
//   }
// }

class NotificationService {
  NotificationService._privateConstructor();
  static final NotificationService instance =
      NotificationService._privateConstructor();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    // Get the current token
    String? token = await _firebaseMessaging.getToken();
    LoggerData.dataLog("FCM Token: $token");

    if (token != null && token.isNotEmpty) {
      SharedPrefs.instance.fcmToken = token;
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      LoggerData.dataLog("FCM Token Refreshed: $newToken");
      SharedPrefs.instance.fcmToken = newToken;
    });

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null) {
          _handleMessageFromPayload(payload);
        }
      },
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Listeners
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // App killed state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _onMessageOpenedApp(message);
        });
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      _showLocalNotification(notification, data);
      _saveNotificationToProvider(notification.title, notification.body,
          extraData: data);
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    final Map<String, dynamic> data = message.data;
    final title = message.notification?.title ?? data['title'];
    final body = message.notification?.body ?? data['body'];

    _saveNotificationToProvider(title, body, extraData: data);
    
    // Convert Map<String, dynamic> to Map<String, String>
    final Map<String, String> stringData = _convertToStringMap(data);
    _handleNotificationNavigation(stringData);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    final title = message.notification?.title ?? message.data['title'];
    final body = message.notification?.body ?? message.data['body'];

    NotificationService.instance
        ._saveNotificationToProvider(title, body, extraData: message.data);
  }

  void _handleMessageFromPayload(String payload) {
    try {
      final Map<String, dynamic> decoded = jsonDecode(payload);
      
      // Convert Map<String, dynamic> to Map<String, String>
      final Map<String, String> data = _convertToStringMap(decoded);

      _saveNotificationToProvider(data['title'], data['body'], extraData: data);
      _handleNotificationNavigation(data);
    } catch (e) {
      LoggerData.dataLog('Failed to parse payload: $e');
    }
  }

  // Helper method to convert Map<String, dynamic> to Map<String, String>
  Map<String, String> _convertToStringMap(Map<String, dynamic> dynamicMap) {
    return dynamicMap.map((key, value) => 
      MapEntry(key, value?.toString() ?? '')
    );
  }

  void _handleNotificationNavigation(Map<String, String> data) async {
    // Check login status
    bool isLoggedIn = SharedPrefs.instance.isLoggedIn;
    
    if (!isLoggedIn) {
      // User not logged in, redirect to login screen with notification data
      LoggerData.dataLog("User not logged in, redirecting to login screen");
      
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginViewPage(
            notificationData: data,
          ),
        ),
        (route) => false,
      );
      return;
    }

    // User is logged in, proceed with normal navigation
    _navigateToTargetScreen(data);
  }

  void _navigateToTargetScreen(Map<String, String> data) {
    final action = data['action'];
    final idStr = data['orderId'] ?? data['requestId'];
    final id = int.tryParse(idStr ?? '');

    if (id != null) {
      if (action == 'order') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => OrderDetailsView(
              orderId: id,
            ),
          ),
        );
      } else if (action == 'request') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => NotificationDashboard(
                notificationData: data), 
          ),
        );
      } else {
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => NotificationDashboard(
              notificationData: data), 
        ));
      }
    } else {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => NotificationDashboard(
              notificationData: data), 
        ),
      );
    }
  }

  void _showLocalNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {
    final fullPayload = jsonEncode({
      'title': notification.title,
      'body': notification.body,
      'time': DateTime.now().toIso8601String(),
      ...data.map((key, value) => MapEntry(key, value.toString())),
    });

    await _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          icon: 'ic_notification',
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: fullPayload,
    );
  }

  void _saveNotificationToProvider(String? title, String? body,
      {Map<String, dynamic>? extraData}) {
    try {
      if (navigatorKey.currentContext != null &&
          title != null &&
          body != null) {
        final provider = Provider.of<NotificationProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );

        final data = {
          'title': title,
          'body': body,
          'time': DateTime.now().toIso8601String(),
          if (extraData != null)
            ...extraData.map((key, value) => MapEntry(key, value.toString())),
        };
        LoggerData.dataLog("extraData: ${jsonEncode(data)}");

        provider.setNotificationData(data['title']!, data['body']!,
            extraData: data);
      }
    } catch (e) {
      LoggerData.dataLog('Notification Provider Error: $e');
    }
  }

  Future<void> sendNotification({
    required String targetToken,
    required String title,
    required String body,
    required String id,
    required String action,
  }) async {
    const String serverKey = 'approvalmobiletesting';
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    // Prepare custom data payload
    final dataPayload = {
      'action': action,
      if (action.toLowerCase() == 'order') 'orderId': id else 'requestId': id,
    };

    // Construct the FCM notification payload
    final payload = {
      'to': targetToken,
      'notification': {
        'title': title,
        'body': body,
        'android_channel_id': 'high_importance_channel',
        'icon': 'ic_notification',
      },
      'data': dataPayload,
      'android': {
        'notification': {
          'icon': 'ic_notification',
          'channel_id': 'high_importance_channel',
        }
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        LoggerData.dataLog('Notification sent successfully');
      } else {
        LoggerData.dataLog(
            ' Failed to send notification: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      LoggerData.dataLog(' Error sending notification: $e');
    }
  }
}