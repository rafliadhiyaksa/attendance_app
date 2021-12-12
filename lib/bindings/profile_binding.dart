import 'package:attendance_app/controllers/form_controller.dart';
import 'package:attendance_app/controllers/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FormController());
    Get.put(ProfileController());
  }
}
