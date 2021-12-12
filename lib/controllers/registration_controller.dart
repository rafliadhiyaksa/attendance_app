import 'package:attendance_app/providers/wajah_provider.dart';
import 'package:attendance_app/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/alamat_provider.dart';
import '../providers/user_provider.dart';

class RegistrationController extends GetxController {
  var dataResponse = {}.obs;
  var dataJenisK = [].obs;
  var dataStatus = [].obs;

  var dataProvinsi = [].obs;
  var dataKota = [].obs;
  var dataKecamatan = [].obs;
  var dataKelurahan = [].obs;

  var dataEmail = [].obs;

  var face = [].obs;

  final registrationFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    jenisK();
    statusP();
    provinsi();
    super.onInit();
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

  void checkEmail(email) {
    UserProvider().checkEmail(email: email).then((value) {
      if (value.status.isOk) {
        dataResponse.value = (value.body);
        if (dataResponse['status'] == 1) {
          dataEmail.value = (value.body)['data'];
          Get.defaultDialog(
            title: "",
            middleText:
                "Email telah terdaftar, Silakan lakukan registrasi wajah",
            textConfirm: "Ok",
            onConfirm: () {
              Get.back();
              Get.toNamed(RouteName.faceRegistration,
                  arguments: dataEmail[0]['ID_USER']);
            },
          );
        } else {
          snackBar('Invalid', dataResponse['message'], false);
        }
      } else if (value.status.connectionError) {
        snackBar('Error', 'No Internet Connection', false);
      }
    });
  }

  void regWajah({idUser, dataWajah}) {
    WajahProvider()
        .postData(idUser: idUser, dataWajah: dataWajah)
        .then((value) {
      if (value.status.isOk) {
        dataResponse.value = (value.body);
        if (dataResponse['value'] == 1) {
          snackBar('Success', dataResponse['message'], true);
        } else if (dataResponse['value'] == 2) {
          snackBar('Invalid', dataResponse['message'], false);
        } else {
          snackBar('Failed', dataResponse['message'], false);
        }
      } else if (value.status.connectionError) {
        snackBar('Error', 'No Internet Connection', false);
      }
    });
  }

  // registrasi data diri
  void registration({
    dynamic namaDepan,
    namaBelakang,
    email,
    noHp,
    tmpLahir,
    tglLahir,
    jenisK,
    statusP,
    alamat,
    provinsi,
    kota,
    kecamatan,
    kelurahan,
    kodePos,
    dataWajah,
  }) {
    loading();
    UserProvider()
        .postData(
      namaDepan: namaDepan,
      namaBelakang: namaBelakang,
      email: email,
      noHp: noHp,
      tempatLahir: tmpLahir,
      tanggalLahir: tglLahir,
      jenisKelamin: jenisK,
      statusP: statusP,
      alamat: alamat,
      provinsi: provinsi,
      kota: kota,
      kecamatan: kecamatan,
      kelurahan: kelurahan,
      kodePos: kodePos,
    )
        .then((value) {
      if (value.status.isOk) {
        dataResponse.value = value.body;
        if (dataResponse['value'] == 1) {
          // registrasi wajah
          WajahProvider()
              .postData(
            idUser: int.parse(dataResponse['data'][0]['ID_USER']),
            dataWajah: dataWajah,
          )
              .then((value) {
            Get.back();
            if (value.status.isOk) {
              dataResponse.value = value.body;
              if (dataResponse['value'] == 1) {
                snackBar('Success', 'Registratrion Success', true);
              } else {
                snackBar('Failed', 'Registration Failed', false);
              }
            }
          });
        } else if (dataResponse['value'] == 2) {
          Get.back();
          snackBar('Failed', dataResponse['message'], false);
        } else {
          Get.back();
          snackBar('Failed', dataResponse['message'], false);
        }
      } else if (value.status.connectionError) {
        Get.back();
        snackBar('Error', 'No Internet Connection', false);
      }
    });
  }

  void jenisK() {
    dataJenisK.value = ['Pria', 'Wanita'];
  }

  void statusP() {
    dataStatus.value = ['Lajang', 'Cerai', 'Menikah'];
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

  void setFaceValue(List value) {
    face.value = value;
  }
}
