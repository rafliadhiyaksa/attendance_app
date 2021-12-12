import 'package:attendance_app/controllers/face_registration_controller.dart';
import 'package:get/get.dart';

class FaceBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FaceRegistrationController());
  }
}
