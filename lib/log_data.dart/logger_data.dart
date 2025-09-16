import 'dart:developer';

class LoggerData {
  static String logEnviroment = "";

  static void dataLog(String msg) {
    if (logEnviroment == "DEV" ||
        logEnviroment == "STAGING" ||
        logEnviroment == "PROD") {
      log(msg);
    } else {}
  }

  static void dataPrint(String msg) {
    if (logEnviroment == "DEV" ||
        logEnviroment == "STAGING" ||
        logEnviroment == "PROD") {
      print(msg);
    } else {}
  }
}
