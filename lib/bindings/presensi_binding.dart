import 'package:attendance_app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class PresensiBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    // Get.put(PresensiController());
  }
}
