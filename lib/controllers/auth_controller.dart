import 'dart:convert';
import 'dart:typed_data';

import 'package:attendance_app/models/wajah.dart';
import 'package:attendance_app/providers/wajah_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:attendance_app/models/user.dart';
import 'package:attendance_app/providers/user_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AuthController extends GetxController {
  var user = User().obs;
  var listDataWajah = <Wajah>[].obs;
  var dataWajah = Wajah().obs;
  var isLoading = true.obs;

  var tempDataUser = User().obs;
  var tempDataWajah = Wajah().obs;
  var uint8ListWajah = Uint8List(0).obs;

  //refresh controller
  RefreshController refreshCon = RefreshController();

  void onRefresh() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      getUser(user.value.idUser);
      refreshCon.refreshCompleted();
    } catch (e) {
      refreshCon.refreshFailed();
    }
  }

  Future<void> saveDataToStorage() async {
    user.value = tempDataUser.value;
    dataWajah.value = tempDataWajah.value;

    final box = GetStorage();

    final authDataStorage = {
      'idUser': tempDataUser.value.idUser,
      'namaDepan': tempDataUser.value.namaDepan,
      'namaBelakang': tempDataUser.value.namaBelakang,
      'email': tempDataUser.value.email,
      'noHp': tempDataUser.value.noHp,
      'tempatLahir': tempDataUser.value.tempatLahir,
      'tglLahir': tempDataUser.value.tglLahir,
      'jenisK': tempDataUser.value.jenisK,
      'statusP': tempDataUser.value.statusP,
      'alamat': tempDataUser.value.alamat,
      'provinsi': tempDataUser.value.provinsi,
      'kota': tempDataUser.value.kota,
      'kecamatan': tempDataUser.value.kecamatan,
      'kelurahan': tempDataUser.value.kelurahan,
      'kodePos': tempDataUser.value.kodePos,
      'profilImg': tempDataUser.value.profilImg,
    };
    final authWajahStorage = {
      'id': tempDataWajah.value.id,
      'idUser': tempDataWajah.value.idUser,
      'dataWajah': tempDataWajah.value.dataWajah,
    };
    box.write('authData', authDataStorage);
    box.write('authWajah', authWajahStorage);
  }

  void logout() {
    final storage = GetStorage();
    storage.erase();
    dataWajah.value = Wajah();
    listDataWajah.clear();
  }

  Future<void> autoLogin() async {
    final storage = GetStorage();

    if (storage.read('authData') != null && storage.read('authWajah') != null) {
      final authData = storage.read('authData') as Map<String, dynamic>;
      final authWajah = storage.read('authWajah') as Map<String, dynamic>;

      Uint8List uint8list =
          Uint8List.fromList(authData['profilImg'].cast<int>().toList());

      user.value = User(
        idUser: authData['idUser'],
        namaDepan: authData['namaDepan'],
        namaBelakang: authData['namaBelakang'],
        email: authData['email'],
        noHp: authData['noHp'],
        tempatLahir: authData['tempatLahir'],
        tglLahir: authData['tglLahir'],
        jenisK: authData['jenisK'],
        statusP: authData['statusP'],
        alamat: authData['alamat'],
        provinsi: authData['provinsi'],
        kota: authData['kota'],
        kecamatan: authData['kecamatan'],
        kelurahan: authData['kelurahan'],
        kodePos: authData['kodePos'],
        profilImg: uint8list,
      );

      dataWajah.value = Wajah(
        id: authWajah['id'],
        idUser: authWajah['idUser'],
        dataWajah: authWajah['dataWajah'],
      );
    }
  }

  get isAuth => user.value.idUser != null && dataWajah.value.id != null
      ? true.obs
      : false.obs;

  // ambil semua data wajah
  Future<void> getAllDataWajah() async {
    WajahProvider().getAllDataWajah().then((value) {
      if (value.status.isOk) {
        List data = value.body['data'];
        for (var element in data) {
          var wajah = Wajah(
            id: jsonDecode(element['ID_DATA_WAJAH']),
            idUser: jsonDecode(element['USER_ID']),
            dataWajah: jsonDecode(element['DATA_WAJAH']),
          );
          if (listDataWajah
              .every((element) => element.idUser != wajah.idUser)) {
            listDataWajah.add(wajah);
          }
        }
      } else if (value.status.connectionError) {
        Get.snackbar(
          'Error',
          'No Internet Connection',
          duration: const Duration(seconds: 2),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const FaIcon(
            FontAwesomeIcons.exclamationCircle,
            color: Colors.white,
            size: 15,
          ),
        );
      }
    });
  }

  Future<void> getUser(id) async {
    print(id);
    UserProvider().getData(id).then((value) {
      if (value.status.isOk) {
        List data = value.body['data'];
        for (var element in data) {
          tempDataUser.value = User(
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
            profilImg: uint8ListWajah.value,
          );
        }
        WajahProvider().getDataWajah(id).then((value) {
          print(id);
          if (value.status.isOk) {
            List data = value.body['data'];
            for (var element in data) {
              tempDataWajah.value = Wajah(
                id: jsonDecode(element['ID_DATA_WAJAH']),
                idUser: jsonDecode(element['USER_ID']),
                dataWajah: jsonDecode(element['DATA_WAJAH']),
              );
            }
            saveDataToStorage();
          } else if (value.status.connectionError) {
            Get.snackbar(
              'Error',
              'No Internet Connection',
              duration: const Duration(seconds: 2),
              colorText: Colors.white,
              backgroundColor: Colors.red,
              icon: const FaIcon(
                FontAwesomeIcons.exclamationCircle,
                color: Colors.white,
                size: 15,
              ),
            );
          }
        });
        // update();
      } else if (value.status.connectionError) {
        Get.snackbar(
          'Error',
          'No Internet Connection',
          duration: const Duration(seconds: 2),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const FaIcon(
            FontAwesomeIcons.exclamationCircle,
            color: Colors.white,
            size: 15,
          ),
        );
      }
    });
  }

  void imgWajah(Uint8List value) {
    uint8ListWajah.value = value;
  }
}
