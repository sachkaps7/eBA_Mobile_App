// import 'dart:io';
// import 'package:eyvo_v3/app/app_prefs.dart';
// import 'package:eyvo_v3/log_data.dart/logger_data.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:uuid/uuid.dart';

// class DeviceInfoHelper {
//   static const _deviceIdKey = 'device_id_key';
//   static final _secureStorage = FlutterSecureStorage();

//   /// Initializes a UUID-based device ID that survives app restarts,
//   /// but NOT uninstalls (not possible to persist through uninstall).
//   static Future<void> initDeviceIdAndPlatform() async {
//     final prefs = SharedPrefs.instance;
//     String platform = Platform.isAndroid ? 'Android' : 'iOS';

//     String? secureId = await _secureStorage.read(key: _deviceIdKey);

//     if ((secureId?.isNotEmpty ?? false) && prefs.deviceId.isEmpty) {
//       prefs.deviceId = secureId!;
//       prefs.devicePlatform = platform;

//       LoggerData.dataLog('Existing UUID from secure storage: $secureId');
//       LoggerData.dataLog(' Platform: $platform');
//       return;
//     }

//     // Generate UUID and store
//     String newId = const Uuid().v4();
//     await _secureStorage.write(key: _deviceIdKey, value: newId);
//     prefs.deviceId = newId;
//     prefs.devicePlatform = platform;

//     LoggerData.dataLog('New UUID stored as device ID: $newId');
//     LoggerData.dataLog('Platform: $platform');
//   }

//   static Future<String> getStoredDeviceId() async {
//     return await _secureStorage.read(key: _deviceIdKey) ??
//         SharedPrefs.instance.deviceId;
//   }

//   static Future<String> getStoredPlatform() async {
//     return SharedPrefs.instance.devicePlatform;
//   }
// }
// import 'dart:io';
// import 'package:eyvo_v3/log_data.dart/logger_data.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';

// class DeviceInfoHelper {
//   static const _deviceIdKey = 'device_id_key';
//   static const _platformKey = 'device_platform_key';
//   static final _secureStorage = FlutterSecureStorage();
//   static final _uuid = Uuid();

//   /// Initializes device ID and platform info
//   static Future<void> initDeviceInfo() async {
//     LoggerData.dataLog('\n===== Initializing Device Info =====');

//     // Get platform (Android/iOS)
//     final platform = Platform.isAndroid ? 'Android' : 'iOS';
//     LoggerData.dataLog('Detected platform: $platform');

//     // Try to get existing device ID
//     final String? existingId = await _secureStorage.read(key: _deviceIdKey);

//     if (existingId != null && existingId.isNotEmpty) {
//       LoggerData.dataLog('Found existing device ID in secure storage: $existingId');

//       // Save to SharedPreferences for easier access
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_deviceIdKey, existingId);
//       await prefs.setString(_platformKey, platform);

//       LoggerData.dataLog('Device info initialized with existing ID');
//       return;
//     }

//     // Check SharedPreferences as fallback
//     final prefs = await SharedPreferences.getInstance();
//     final String? fallbackId = prefs.getString(_deviceIdKey);

//     if (fallbackId != null && fallbackId.isNotEmpty) {
//       LoggerData.dataLog('Found fallback device ID in SharedPreferences: $fallbackId');

//       // Store in secure storage for better security
//       await _secureStorage.write(key: _deviceIdKey, value: fallbackId);
//       await prefs.setString(_platformKey, platform);

//       LoggerData.dataLog('Device info initialized with fallback ID');
//       return;
//     }

//     // Generate new ID if none exists
//     final newId = _uuid.v4();
//     LoggerData.dataLog('Generating new device ID: $newId');

//     // Store in both secure storage and SharedPreferences
//     await _secureStorage.write(key: _deviceIdKey, value: newId);
//     await prefs.setString(_deviceIdKey, newId);
//     await prefs.setString(_platformKey, platform);

//     LoggerData.dataLog('Device info initialized with new ID');
//   }

//   /// Gets the device ID
//   static Future<String> getDeviceId() async {
//     LoggerData.dataLog('\n===== Getting Device ID =====');

//     // Try secure storage first
//     String? deviceId = await _secureStorage.read(key: _deviceIdKey);
//     if (deviceId != null) {
//       LoggerData.dataLog('Found device ID in secure storage: $deviceId');
//       return deviceId;
//     }

//     // Fallback to SharedPreferences
//     final prefs = await SharedPreferences.getInstance();
//     deviceId = prefs.getString(_deviceIdKey);
//     if (deviceId != null) {
//       LoggerData.dataLog('Found device ID in SharedPreferences: $deviceId');
//       return deviceId;
//     }

//     // Generate new ID if none exists (shouldn't happen if init was called)
//     deviceId = _uuid.v4();
//     LoggerData.dataLog('Generated new device ID: $deviceId');
//     return deviceId;
//   }

//   /// Gets the device platform (Android/iOS)
//   static Future<String> getDevicePlatform() async {
//     LoggerData.dataLog('\n===== Getting Device Platform =====');

//     final prefs = await SharedPreferences.getInstance();
//     final platform = prefs.getString(_platformKey) ??
//                     (Platform.isAndroid ? 'Android' : 'iOS');

//     LoggerData.dataLog('Device platform: $platform');
//     return platform;
//   }

//   /// Debug function to print all stored values
//   static Future<void> debugPrintDeviceInfo() async {
//     LoggerData.dataLog('\n=== DEBUG DEVICE INFO ===');

//     // Get and print device ID
//     final deviceId = await getDeviceId();
//     LoggerData.dataLog('Device ID: $deviceId');

//     // Get and print platform
//     final platform = await getDevicePlatform();
//     LoggerData.dataLog('Platform: $platform');

//     // Print raw storage values
//     final prefs = await SharedPreferences.getInstance();
//     LoggerData.dataLog('\nStorage values:');
//     LoggerData.dataLog('SharedPrefs ID: ${prefs.getString(_deviceIdKey)}');
//     LoggerData.dataLog('SharedPrefs Platform: ${prefs.getString(_platformKey)}');

//     final secureId = await _secureStorage.read(key: _deviceIdKey);
//     LoggerData.dataLog('SecureStorage ID: $secureId');

//     LoggerData.dataLog('=== END DEBUG ===\n');
//   }
// }
import 'dart:io';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoHelper {
  static const _deviceIdKey = 'device_id_key'; // only for secure storage
  static final _secureStorage = FlutterSecureStorage();
  static final _uuid = Uuid();

  /// Initializes device ID and platform info
  static Future<void> initDeviceInfo() async {
    LoggerData.dataLog('\n===== Initializing Device Info =====');

    final platform = Platform.isAndroid ? 'Android' : 'iOS';
    final String? existingId = await _secureStorage.read(key: _deviceIdKey);

    if (existingId != null && existingId.isNotEmpty) {
      LoggerData.dataLog(
          'Found existing device ID in secure storage: $existingId');
      SharedPrefs().deviceId = existingId;
      SharedPrefs().devicePlatform = platform;
      LoggerData.dataLog('Device info initialized with existing ID');
      return;
    }

    if (SharedPrefs().deviceId.isNotEmpty) {
      LoggerData.dataLog(
          'Found fallback device ID in SharedPrefs: ${SharedPrefs().deviceId}');
      await _secureStorage.write(
          key: _deviceIdKey, value: SharedPrefs().deviceId);
      SharedPrefs().devicePlatform = platform;
      LoggerData.dataLog('Device info initialized with fallback ID');
      return;
    }

    final newId = _uuid.v4();
    LoggerData.dataLog('Generating new device ID: $newId');

    await _secureStorage.write(key: _deviceIdKey, value: newId);
    SharedPrefs().deviceId = newId;
    SharedPrefs().devicePlatform = platform;

    LoggerData.dataLog('Device info initialized with new ID');
  }

  /// Gets the device ID
  static Future<String> getDeviceId() async {
    LoggerData.dataLog('\n===== Getting Device ID =====');

    String? deviceId = await _secureStorage.read(key: _deviceIdKey);
    if (deviceId != null && deviceId.isNotEmpty) {
      LoggerData.dataLog('Found device ID in secure storage: $deviceId');
      return deviceId;
    }

    if (SharedPrefs().deviceId.isNotEmpty) {
      LoggerData.dataLog(
          'Found device ID in SharedPrefs: ${SharedPrefs().deviceId}');
      return SharedPrefs().deviceId;
    }

    deviceId = _uuid.v4();
    LoggerData.dataLog('Generated new device ID: $deviceId');
    return deviceId;
  }

  /// Gets the device platform (Android/iOS)
  static Future<String> getDevicePlatform() async {
    LoggerData.dataLog('\n===== Getting Device Platform =====');

    final platform = SharedPrefs().devicePlatform.isNotEmpty
        ? SharedPrefs().devicePlatform
        : (Platform.isAndroid ? 'Android' : 'iOS');

    LoggerData.dataLog('Device platform: $platform');
    return platform;
  }

  /// Debug function to print all stored values
  static Future<void> debugPrintDeviceInfo() async {
    LoggerData.dataLog('\n=== DEBUG DEVICE INFO ===');

    final deviceId = await getDeviceId();
    LoggerData.dataLog('Device ID: $deviceId');

    final platform = await getDevicePlatform();
    LoggerData.dataLog('Platform: $platform');

    LoggerData.dataLog('\nStorage values:');
    LoggerData.dataLog('SharedPrefs ID: ${SharedPrefs().deviceId}');
    LoggerData.dataLog('SharedPrefs Platform: ${SharedPrefs().devicePlatform}');

    final secureId = await _secureStorage.read(key: _deviceIdKey);
    LoggerData.dataLog('SecureStorage ID: $secureId');

    LoggerData.dataLog('=== END DEBUG ===\n');
  }
}
