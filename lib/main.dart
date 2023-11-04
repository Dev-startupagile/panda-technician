// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:panda_technician/routes/route.dart';
import 'package:panda_technician/store/AllProviders.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/service/init_app_service.dart';

main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initAppService();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.grey, systemStatusBarContrastEnforced: true));

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
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
