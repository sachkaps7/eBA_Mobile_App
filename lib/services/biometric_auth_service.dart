import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final LocalAuthentication _localAuth = LocalAuthentication();
  String clientName = 'Eyvo';

  /// Toggle this to enable/disable real biometric authentication.
  /// If set to true, it will simulate success without showing native popup.
  final bool simulateBiometrics;

  BiometricAuth({this.simulateBiometrics = false});

  /// Check if device supports any biometrics (Android or iOS)
  Future<bool> checkBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      LoggerData.dataLog("Error checking biometrics: $e");
      return false;
    }
  }

  /// Authenticate using any available biometric method (or simulate)
  // Future<bool> authenticate() async {
  //   if (simulateBiometrics) {
  //     LoggerData.dataLog("Simulated biometric authentication success.");
  //     return true;
  //   }

  //   try {
  //     final didAuthenticate = await _localAuth.authenticate(
  //       localizedReason: 'Authenticate to access your account',
  //       options: const AuthenticationOptions(
  //         biometricOnly: true,
  //         useErrorDialogs: true,
  //         stickyAuth: false,
  //       ),
  //     );
  //     LoggerData.dataLog("Authentication result: $didAuthenticate");
  //     return didAuthenticate;
  //   } catch (e, s) {
  //     LoggerData.dataLog("Biometric Auth Error: $e\nStackTrace: $s");
  //     return false;
  //   }
  // }
  Future<bool> authenticate() async {
    if (simulateBiometrics) {
      LoggerData.dataLog("Simulated biometric authentication success.");
      return true;
    }

    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason:
            'Authenticate to access your $clientName account securely',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: false,
        ),
      );
      LoggerData.dataLog("Authentication result: $didAuthenticate");
      return didAuthenticate;
    } catch (e, s) {
      LoggerData.dataLog("Biometric Auth Error: $e\nStackTrace: $s");
      return false;
    }
  }

  /// Enable biometric authentication
  Future<void> enableBiometric() async {
    SharedPrefs.instance.isBiometricEnabled = true;
    LoggerData.dataLog("Biometric authentication enabled.");
  }

  /// Disable biometric authentication
  Future<void> disableBiometric() async {
    SharedPrefs.instance.isBiometricEnabled = false;
    LoggerData.dataLog("Biometric authentication disabled.");
  }

  /// Check if biometric is enabled by the user
  bool isBiometricEnabled() {
    return SharedPrefs.instance.isBiometricEnabled;
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final available = await _localAuth.getAvailableBiometrics();
      for (final type in available) {
        LoggerData.dataLog("Available biometric: $type");
      }
      return available;
    } catch (e) {
      LoggerData.dataLog("Error getting available biometrics: $e");
      return [];
    }
  }

  /// Store biometric authentication ID
  Future<void> setBiometricAuthId(String value) async {
    SharedPrefs().biometricAuthId = value;
  }

  /// Get stored biometric authentication ID
  String getBiometricAuthId() {
    return SharedPrefs().biometricAuthId;
  }

  /// Log available biometric methods
  Future<void> logAvailableBiometricMethods() async {
    final available = await getAvailableBiometrics();

    if (available.contains(BiometricType.face)) {
      LoggerData.dataLog("Face ID is available on this device.");
    }

    if (available.contains(BiometricType.fingerprint)) {
      LoggerData.dataLog("Fingerprint is available on this device.");
    }
  }
}
