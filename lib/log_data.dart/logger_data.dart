import 'dart:developer';

class LoggerData {
  static String logEnviroment = "";

  static void dataLog(String msg) {
    if (logEnviroment == "DEV" || logEnviroment == "STAGING") {
      log(msg);
    } else {}
  }

  // static void dataPrint(String msg) {
  //   if (logEnviroment == "DEV" || logEnviroment == "STAGING") {
  //     print(msg);
  //   } else {}
  // }
  static void dataPrint(String msg) {
    if (logEnviroment == "DEV" || logEnviroment == "STAGING") {
      const pink = "\x1B[95m";
      const reset = "\x1B[0m";
      print("$pink$msg$reset");
    }
  }
}
