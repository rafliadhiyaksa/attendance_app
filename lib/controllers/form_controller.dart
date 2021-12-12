import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  static FormController get to => Get.find();

  final formKey = GlobalKey<FormState>().obs;

  late TextEditingController namaDepanController,
      namaBelakangController,
      emailController,
      tempatLahirController,
      tglLahirController,
      noHpController,
      alamatController,
      kodePosController,
      jenisKController;

  String? jenisK, statusP;
  // dynamic idProvinsi, idKota, idKec, idKel;

  var idProvinsi = "".obs;
  var idKota = "".obs;
  var idKec = "".obs;
  var idKel = "".obs;

  void setGender(value) {
    jenisK = value;
    update();
  }

  void setStatus(value) {
    statusP = value;
    update();
  }

  void setProvinsi(value) {
    idProvinsi.value = value;
  }

  void setKota(value) {
    idKota.value = value;
  }

  void setKec(value) {
    idKec.value = value;
  }

  void setKel(value) {
    idKel.value = value;
  }

  @override
  void onInit() {
    namaDepanController = TextEditingController();
    namaBelakangController = TextEditingController();
    emailController = TextEditingController();
    tempatLahirController = TextEditingController();
    tglLahirController = TextEditingController();
    noHpController = TextEditingController();
    alamatController = TextEditingController();
    kodePosController = TextEditingController();
    jenisKController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    namaDepanController.dispose();
    namaBelakangController.dispose();
    emailController.dispose();
    tempatLahirController.dispose();
    tglLahirController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    kodePosController.dispose();
    jenisKController.dispose();
    super.onClose();
  }
}
