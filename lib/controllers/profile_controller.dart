import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../providers/alamat_provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/form_controller.dart';
import '../models/user.dart';
import '../models/wajah.dart';
import '../providers/user_provider.dart';

class ProfileController extends GetxController {
  var user = User().obs;
  var dataResponse = {}.obs;
  // var dataJenisK = [].obs;
  var dataStatus = [].obs;
  var dataProvinsi = [].obs;
  var dataKota = [].obs;
  var dataKecamatan = [].obs;
  var dataKelurahan = [].obs;
  var fileImg = File("").obs;

  final authCon = Get.find<AuthController>();
  final formCon = Get.find<FormController>();

  @override
  void onInit() {
    user.value = authCon.user.value;
    // memberikan value awal ke form
    formCon.namaDepanController.text = user.value.namaDepan!;
    formCon.namaBelakangController.text = user.value.namaBelakang!;
    formCon.emailController.text = user.value.email!;
    formCon.noHpController.text = user.value.noHp!;
    formCon.tempatLahirController.text = user.value.tempatLahir!;
    formCon.tglLahirController.text = user.value.tglLahir!;
    formCon.jenisKController.text = user.value.jenisK!;

    formCon.jenisK = user.value.jenisK;
    formCon.statusP = user.value.statusP;
    formCon.alamatController.text = user.value.alamat!;
    formCon.idProvinsi.value = user.value.provinsi!;
    formCon.idKota.value = user.value.kota!;
    formCon.idKec.value = user.value.kecamatan!;
    formCon.idKel.value = user.value.kelurahan!;
    formCon.kodePosController.text = user.value.kodePos!;

    statusP();
    provinsi();
    kota(user.value.provinsi);
    kec(user.value.kota);
    kel(user.value.kecamatan);

    super.onInit();
  }

  void updateData({
    dynamic idUser,
    noHp,
    statusP,
    alamat,
    provinsi,
    kota,
    kecamatan,
    kelurahan,
    kodePos,
  }) {
    loading();
    UserProvider()
        .updateData(
      id: idUser,
      noHp: noHp,
      statusP: statusP,
      alamat: alamat,
      provinsi: provinsi,
      kota: kota,
      kecamatan: kecamatan,
      kelurahan: kelurahan,
      kodePos: int.parse(kodePos),
    )
        .then((value) {
      Get.back();
      if (value.status.isOk) {
        dataResponse.value = {
          'value': value.body['value'],
          'message': value.body['message']
        };
        if (dataResponse['value'] == 1) {
          List data = value.body['data'];

          for (var element in data) {
            authCon.tempDataUser.value = User(
              idUser: jsonDecode(element['ID_USER']),
              namaDepan: element['NAMA_DEPAN'],
              namaBelakang: element['NAMA_BELAKANG'],
              email: element['EMAIL'],
              noHp: element['NO_HP'],
              tempatLahir: element['TEMPAT_LAHIR'],
              tglLahir: element['TANGGAL_LAHIR'],
              jenisK: element['JENIS_KELAMIN'],
              statusP: element['STATUS_PERNIKAHAN'],
              alamat: element['ALAMAT'],
              provinsi: element['PROVINSI'],
              kota: element['KOTA'],
              kecamatan: element['KECAMATAN'],
              kelurahan: element['KELURAHAN'],
              kodePos: element['KODE_POS'],
              profilImg: authCon.user.value.profilImg,
            );
          }
          authCon.tempDataWajah.value = Wajah(
            id: authCon.dataWajah.value.id,
            idUser: authCon.dataWajah.value.idUser,
            dataWajah: authCon.dataWajah.value.dataWajah,
          );
          authCon.saveDataToStorage();
          snackBar('Success', dataResponse['message'], true);
        } else if (dataResponse['value'] == 2) {
          snackBar('Failed', dataResponse['message'], false);
        } else {
          snackBar('Failed', dataResponse['message'], false);
        }
      }
    }, onError: (e) {
      Get.back();
      snackBar('Error', e.toString(), false);
    });
  }

  void provinsi() {
    AlamatProvider().getProvinsi().then((value) {
      if (value.status.isOk) {
        dataProvinsi.value = value.body['provinsi'];
      } else if (value.status.connectionError) {
        snackBar('Error', 'Gagal Mengambil Data Alamat', false);
      }
    }, onError: (err) {
      snackBar('Error', err.toString(), false);
    });
  }

  void kota(idProvinsi) {
    AlamatProvider().getKota(idProvinsi).then((value) {
      if (value.status.isOk) {
        dataKota.value = value.body['kota_kabupaten'];
      } else if (value.status.connectionError) {
        snackBar('Error', 'Gagal Mengambil Data Alamat', false);
      }
    }, onError: (err) {
      snackBar('Error', err.toString(), false);
    });
  }

  void kec(idKota) {
    AlamatProvider().getKec(idKota).then((value) {
      if (value.status.isOk) {
        dataKecamatan.value = value.body['kecamatan'];
      } else if (value.status.connectionError) {
        snackBar('Error', 'Gagal Mengambil Data Alamat', false);
      }
    }, onError: (err) {
      snackBar('Error', err.toString(), false);
    });
  }

  void kel(idKec) {
    AlamatProvider().getKel(idKec).then((value) {
      if (value.status.isOk) {
        dataKelurahan.value = value.body['kelurahan'];
      } else if (value.status.connectionError) {
        snackBar('Error', 'Gagal Mengambil Data Alamat', false);
      }
    }, onError: (err) {
      snackBar('Error', err.toString(), false);
    });
  }

  void loading() {
    Get.dialog(
      Center(
        child: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void snackBar(String title, String message, bool isSuccess) => Get.snackbar(
        title,
        message,
        duration: const Duration(seconds: 2),
        colorText: Colors.white,
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        icon: Center(
          child: FaIcon(
            isSuccess
                ? FontAwesomeIcons.checkCircle
                : FontAwesomeIcons.exclamationCircle,
            color: Colors.white,
            size: 25,
          ),
        ),
      );

  void statusP() {
    dataStatus.value = ['Lajang', 'Cerai', 'Menikah'];
  }
}
