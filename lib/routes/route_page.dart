import 'package:attendance_app/bindings/face_login_binding.dart';
import 'package:attendance_app/bindings/home_binding.dart';
import 'package:attendance_app/bindings/profile_binding.dart';
import 'package:attendance_app/views/login/login_page.dart';
import 'package:get/get.dart';

import '../routes/route_name.dart';
import '../bindings/face_binding.dart';
import '../bindings/registration_binding.dart';
import '../views/home/history_page.dart';
import '../views/home/presensi_page.dart';
import '../views/home/profile_page.dart';
import '../views/home/home_page.dart';
import '../views/registration/registration_page.dart';
import '../views/login/face_login_page.dart';
import '../views/registration/face_registration_page.dart';

class RoutePage {
  static final pages = [
    GetPage(
      name: RouteName.registration,
      page: () => RegistrationPage(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: RouteName.faceRegistration,
      page: () => FaceRegistrationPage(),
      binding: FaceBinding(),
    ),
    GetPage(
      name: RouteName.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: RouteName.faceLogin,
      page: () => FaceLoginPage(),
      binding: FaceLoginBinding(),
    ),
    GetPage(
      name: RouteName.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouteName.history,
      page: () => HistoryPage(),
    ),
    GetPage(
      name: RouteName.profil,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: RouteName.presensi,
      page: () => PresensiPage(),
    ),
  ];
}
