import 'dart:typed_data';

class User {
  int? idUser;
  String? namaDepan,
      namaBelakang,
      email,
      noHp,
      tempatLahir,
      tglLahir,
      jenisK,
      statusP,
      alamat,
      provinsi,
      kota,
      kecamatan,
      kelurahan,
      kodePos;
  Uint8List? profilImg;

  User({
    this.idUser,
    this.namaDepan,
    this.namaBelakang,
    this.email,
    this.noHp,
    this.tempatLahir,
    this.tglLahir,
    this.jenisK,
    this.statusP,
    this.alamat,
    this.provinsi,
    this.kota,
    this.kecamatan,
    this.kelurahan,
    this.kodePos,
    this.profilImg,
  });
}
