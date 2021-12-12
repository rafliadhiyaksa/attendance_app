import 'dart:convert';

import 'package:attendance_app/providers/base_url.dart';
import 'package:get/get.dart';

class WajahProvider extends GetConnect {
  //Auth wajah karyawan
  Future<Response> getAllDataWajah() async {
    var response = await get(BaseUrl.userAPI + "data_wajah");
    return response;
  }

  //get data karyawan
  Future<Response> getDataWajah(int idUser) async {
    var response = await get(BaseUrl.userAPI + "data_wajah/id_user=$idUser");
    return response;
  }

  //daftar wajah
  Future<Response> postData({
    required int idUser,
    required List dataWajah,
  }) async {
    final body = FormData({
      "USER_ID": idUser,
      "DATA_WAJAH": json.encode(dataWajah),
    });
    var response = await post(BaseUrl.userAPI + "data_wajah", body);
    return response;
  }
}
