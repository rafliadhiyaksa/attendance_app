import 'package:get/get.dart';

import 'package:attendance_app/providers/base_url.dart';

class UserProvider extends GetConnect {
  //get data karyawan
  Future<Response> getData(int id) async {
    var response = await get(BaseUrl.userAPI + "$id");
    return response;
  }

  //post data karyawan
  Future<Response> postData({
    dynamic namaDepan,
    namaBelakang,
    email,
    noHp,
    tempatLahir,
    tanggalLahir,
    jenisKelamin,
    statusP,
    alamat,
    provinsi,
    kota,
    kecamatan,
    kelurahan,
    kodePos,
  }) async {
    final body = FormData({
      "NAMA_DEPAN": namaDepan,
      "NAMA_BELAKANG": namaBelakang,
      "EMAIL": email,
      "NO_HP": noHp,
      "TEMPAT_LAHIR": tempatLahir,
      "TANGGAL_LAHIR": tanggalLahir,
      "JENIS_KELAMIN": jenisKelamin,
      "STATUS_PERNIKAHAN": statusP,
      "ALAMAT": alamat,
      "PROVINSI": provinsi,
      "KOTA": kota,
      "KECAMATAN": kecamatan,
      "KELURAHAN": kelurahan,
      "KODE_POS": kodePos,
      "LENGKAP_FOTO": 0,
    });
    var response = await post(BaseUrl.userAPI, body);
    return response;
  }

  // update data karyawan
  Future<Response> updateData({
    dynamic id,
    noHp,
    statusP,
    alamat,
    provinsi,
    kota,
    kecamatan,
    kelurahan,
    kodePos,
  }) async {
    final body = FormData({
      "NO_HP": noHp,
      "STATUS_PERNIKAHAN": statusP,
      "ALAMAT": alamat,
      "PROVINSI": provinsi,
      "KOTA": kota,
      "KECAMATAN": kecamatan,
      "KELURAHAN": kelurahan,
      "KODE_POS": kodePos,
    });
    var response = await post(BaseUrl.userAPI + "$id", body);
    return response;
  }

  //cek email
  Future<Response> checkEmail({
    required String email,
  }) async {
    final body = FormData({
      "EMAIL": email,
    });
    var response = await post(BaseUrl.userAPI + "email", body);
    return response;
  }
}
