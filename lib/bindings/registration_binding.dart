import 'package:get/get.dart';

import '../controllers/registration_controller.dart';
import '../controllers/form_controller.dart';

class RegistrationBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RegistrationController());
    Get.put(FormController());
  }
}
