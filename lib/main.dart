import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supercharged/supercharged.dart';

import 'controllers/auth_controller.dart';
import 'routes/route_page.dart';
import 'views/home/home_page.dart';
import 'views/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final authCon = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: '3546AB'.toColor(),
        primarySwatch: Colors.indigo,
        fontFamily: "ProductSans",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontFamily: "ProductSans",
              fontWeight: FontWeight.w700,
              fontSize: 15),
          bodyText2: TextStyle(
              fontFamily: "ProductSans",
              fontWeight: FontWeight.w700,
              fontSize: 15),
          button:
              TextStyle(fontFamily: "ProductSans", fontWeight: FontWeight.w700),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontFamily: "ProductSans",
              color: Colors.white,
              fontWeight: FontWeight.w700),
          toolbarTextStyle: TextStyle(
              fontFamily: "ProductSans",
              color: Colors.white,
              fontWeight: FontWeight.w700),
        ),
      ),
      home: FutureBuilder(
        future: authCon.autoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(() => authCon.isAuth.value ? HomePage() : LoginPage());
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
      getPages: RoutePage.pages,
    );
  }
}
