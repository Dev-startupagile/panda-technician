// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:panda_technician/routes/route.dart';
import 'package:panda_technician/store/AllProviders.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/service/init_app_service.dart';

final transaction = Sentry.startTransaction('init service', 'task');
Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://6b115b14911040855bdb75a6c02a1ebf@o4506670618378240.ingest.sentry.io/4506670621130752';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: startApp,
  );
}

Future<void> startApp() async {
  try {
    var x = [1, 2];
    print(x[3]);
  } catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initAppService();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.grey, systemStatusBarContrastEnforced: true));

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
  transaction.finish();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (context, _) => AllProviders(
          initialApp: GetMaterialApp(
        initialRoute: initPage,
        title: 'Panda Technician',
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        getPages: getPages,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        // home: const OnboardingSlider(),
      )),
    );
  }
}
