import 'package:attendance_app/providers/base_url.dart';
import 'package:get/get.dart';

class AlamatProvider extends GetConnect {
  Future<Response> getProvinsi() async {
    var response = await get(BaseUrl.alamatAPI + "provinsi");
    return response;
  }

  Future<Response> getKota(idProvinsi) async {
    var response =
        await get(BaseUrl.alamatAPI + "kota?id_provinsi=$idProvinsi");
    return response;
  }

  Future<Response> getKec(idKota) async {
    var response = await get(BaseUrl.alamatAPI + "kecamatan?id_kota=$idKota");
    return response;
  }

  Future<Response> getKel(idKec) async {
    var response =
        await get(BaseUrl.alamatAPI + "kelurahan?id_kecamatan=$idKec");
    return response;
  }
}
