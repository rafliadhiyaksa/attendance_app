import 'package:attendance_app/providers/base_url.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PresensiProvider extends GetConnect {
  String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());

  //melakukan presensi masuk
  Future<Response> presensiMasuk(int idUser, int status) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final String tglNow = formatter.format(now);

    final body = FormData({
      "USER_ID": idUser,
      "TGL_ABSEN": tglNow,
      "JAM_MASUK": timeNow,
      "STATUS_USER": status,
    });
    var response = await post(BaseUrl.presensiAPI, body);
    return response;
  }

  //melakukan presensi pulang
  Future<Response> presensiPulang(int id) async {
    var body = FormData({
      "JAM_PULANG": timeNow,
    });
    var response = await post(BaseUrl.presensiAPI + '$id', body);
    return response;
  }

  Future<Response> presensiBolos(int idUser) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final String tglNow = formatter.format(now);

    var body = FormData({
      "USER_ID": idUser,
      "TGL_ABSEN": tglNow,
      "JAM_MASUK": '-',
      "STATUS_USER": 3,
    });
    var response = await post(BaseUrl.presensiAPI, body);
    return response;
  }

  //get data presensi sesuai id karyawan
  Future<Response> getPresensi(int idUser) async {
    var response = await get(BaseUrl.presensiAPI + "id_user=$idUser");
    return response;
  }

  //get setting
  Future<Response> getSetting() async {
    var response = await get(BaseUrl.settingAPI);
    return response;
  }
}
