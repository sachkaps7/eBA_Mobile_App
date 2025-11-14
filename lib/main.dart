// import 'package:eyvo_v3/Environment/environment.dart';
// import 'package:eyvo_v3/app/app_prefs.dart';
// import 'package:eyvo_v3/core/widgets/NotificationProvider.dart';
// import 'package:eyvo_v3/firebase_options.dart';
// import 'package:eyvo_v3/log_data.dart/logger_data.dart';
// import 'package:eyvo_v3/services/notification_service.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// import 'app/app.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// // void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   //Firebase Initialization
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   //Enviroment SetUP
//   const String environment =
//       String.fromEnvironment("ENVIRONMENT", defaultValue: Environment.DEV);

//   Environment().initConfig(environment);

//   //initialize enviroment in Logger
//   LoggerData.logEnviroment = environment;

//   // Initialize Firebase Notification
//   NotificationService.instance.initialize();

//   //Shared Prefs for Store user Data
//   await SharedPrefs().init();

//   runApp(
//     MyApp(),
//   );
// }
import 'package:eyvo_v3/Environment/environment.dart';
import 'package:eyvo_v3/app/app_prefs.dart';
import 'package:eyvo_v3/core/device_id.dart';
import 'package:eyvo_v3/core/widgets/NotificationProvider.dart';
import 'package:eyvo_v3/firebase_options.dart';
import 'package:eyvo_v3/log_data.dart/logger_data.dart';
import 'package:eyvo_v3/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Env setup
  const String environment =
      String.fromEnvironment("ENVIRONMENT", defaultValue: Environment.DEV);

  Environment().initConfig(environment);

  //initialize enviroment in Logger
  LoggerData.logEnviroment = environment;

  // SharedPrefs init
  await SharedPrefs().init();

  // Initialize Firebase Notification
  await NotificationService.instance
      .initialize(); //  add `await` to ensure init is complete
  await DeviceInfoHelper.initDeviceInfo();
  // Register provider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        // add other providers here if needed
      ],
      child: MyApp(),
    ),
  );
}
