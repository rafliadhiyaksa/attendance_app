import 'package:attendance_app/controllers/presensi_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PresensiController());
  }
}
