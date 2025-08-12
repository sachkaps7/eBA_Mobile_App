import 'package:eyvo_inventory/Environment/base_configuration.dart';

class DevelopmentConfiguration implements BaseConfig {
  @override
//  String get apiHost => 'https://service.eyvo.net/eBA API 2.0';
  String get apiHost => 'http://10.0.2.2:5213';

  @override
  String get domainHost => '';
}
