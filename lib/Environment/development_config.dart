import 'package:eyvo_v3/Environment/base_configuration.dart';

class DevelopmentConfiguration implements BaseConfig {
  @override
  // String get apiHost => 'https://service.eyvo.net/eBA API 2.0';
  //String get apiHost => 'http://localhost:5213';
  String get apiHost =>
      'http://10.0.2.2:5214'; // is a special alias that the Android emulator uses to refer to your host (your PC).
  // String get apiHost => 'http://192.168.29.160:5213'; //for mobile
  @override
  String get domainHost => '';
}
