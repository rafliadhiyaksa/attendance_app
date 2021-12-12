import 'package:attendance_app/controllers/auth_controller.dart';
import 'package:attendance_app/controllers/face_login_controller.dart';
import 'package:get/get.dart';

class FaceLoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FaceLoginController());
    Get.put(AuthController());
  }
}
