import 'dart:io';

import 'package:eyvo_inventory/Environment/environment.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:eyvo_inventory/log_data.dart/logger_data.dart';

class SSLError implements Exception {
  final String message;
  final String? host;
  final int? port;

  SSLError(this.message, {this.host, this.port});

  @override
  String toString() =>
      'SSLError: $message${host != null ? ' (Host: $host, Port: $port)' : ''}';
}

Future<http.Client> getHttpClient() async {
  // const env = String.fromEnvironment(
  //   "ENVIRONMENT",
  //   defaultValue: "PROD",
  // );
  final env = Environment.current;
  LoggerData.dataLog('getHttpClient ENV = $env');

  if (env == "PROD") {
    LoggerData.dataLog('SSL PINNING ENABLED (PROD)');

    try {
      // Load ONLY the LEAF server certificate
      final sslCert = await rootBundle.load(
        'assets/certificates/certificate_prod.pem',
      );
      LoggerData.dataLog('Certificate loaded successfully');

      final context = SecurityContext(withTrustedRoots: false);
      context.setTrustedCertificatesBytes(
        sslCert.buffer.asUint8List(),
      );
      LoggerData.dataLog(' Certificate added to security context');

      final client = HttpClient(context: context);

      // NEVER accept invalid certs in PROD
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        LoggerData.dataLog(' SSL Certificate Verification Failed:');
        LoggerData.dataLog('   Host: $host');
        LoggerData.dataLog('   Port: $port');
        LoggerData.dataLog('   Subject: ${cert.subject}');
        LoggerData.dataLog('   Issuer: ${cert.issuer}');
        return false;
      };

      client.connectionTimeout = const Duration(seconds: 30);

      return IOClient(client);
    } catch (e) {
      LoggerData.dataLog(' Critical SSL setup error: $e');
      throw SSLError('SSL setup failed: $e');
    }
  }

  // DEV / STAGING → system trust store
  LoggerData.dataLog(' USING SYSTEM SSL (DEV / STAGING)');
  return http.Client();
}
