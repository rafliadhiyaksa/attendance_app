import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercharged/supercharged.dart';

import '../../controllers/registration_controller.dart';
import '../../controllers/form_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown_field.dart';
import '../../routes/route_name.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({Key? key}) : super(key: key);

  //controller
  final regCon = Get.find<RegistrationController>();
  final formCon = Get.find<FormController>();

  final requiredValidator = RequiredValidator(errorText: 'Required*');

  final primary = '3546AB'.toColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          iconSize: 20,
          onPressed: () {
            Get.defaultDialog(
              title: 'Keluar Registrasi',
              middleText: 'Apakah Anda Yakin Ingin Keluar?',
              barrierDismissible: false,
              textCancel: 'Tidak',
              textConfirm: 'Ya',
              confirmTextColor: Colors.white,
              onConfirm: () {
                Get.back();
                Get.back();
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: Text(
                "Registrasi",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: Text(
                "Data Diri Karyawan",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              child: Obx(
                () => Form(
                  key: formCon.formKey.value,
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      //NAMA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: context.width * 0.40,
                            child: CustomTextField(
                              text: "Nama Depan",
                              controller: formCon.namaDepanController,
                              validator: requiredValidator,
                            ),
                          ),
                          SizedBox(
                            width: context.width * 0.40,
                            child: CustomTextField(
                              text: "Nama Belakang",
                              controller: formCon.namaBelakangController,
                              validator: requiredValidator,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      //EMAIL
                      CustomTextField(
                        text: "Email",
                        type: TextInputType.emailAddress,
                        controller: formCon.emailController,
                        validator: MultiValidator([
                          requiredValidator,
                          EmailValidator(errorText: "Required valid Email"),
                        ]),
                      ),
                      const SizedBox(height: 20.0),

                      //NOMOR HANDPHONE
                      CustomTextField(
                        text: "No. Handphone",
                        type: TextInputType.phone,
                        controller: formCon.noHpController,
                        validator: requiredValidator,
                      ),
                      const SizedBox(height: 20.0),

                      //TEMPAT LAHIR
                      CustomTextField(
                        text: "Tempat Lahir",
                        controller: formCon.tempatLahirController,
                        validator: requiredValidator,
                      ),
                      const SizedBox(height: 20.0),

                      //TANGGAL LAHIR
                      CustomTextField(
                        text: "Tanggal Lahir",
                        suffixicon: const Icon(Icons.date_range_rounded),
                        readOnly: true,
                        controller: formCon.tglLahirController,
                        validator: requiredValidator,
                        ontap: () async {
                          var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1960),
                            lastDate: DateTime.now(),
                            initialDatePickerMode: DatePickerMode.year,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          );
                          formCon.tglLahirController.text =
                              date.toString().substring(0, 10);
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // jenis kelamin
                      CustomDropdownField(
                        label: "Jenis Kelamin",
                        value: formCon.jenisK,
                        items: regCon.dataJenisK.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onchanged: (value) {
                          formCon.setGender(value);
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // status
                      CustomDropdownField(
                        label: "Status Pernikahan",
                        value: formCon.statusP,
                        items: regCon.dataStatus.map((e) {
                          return DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                        onchanged: (value) {
                          formCon.setStatus(value);
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // ---------ALAMAT----------
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 3,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: const Text(
                              "Alamat",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      // ALAMAT
                      CustomTextField(
                        text: "Alamat",
                        type: TextInputType.multiline,
                        controller: formCon.alamatController,
                        maxlines: null,
                        maxlength: 150,
                        minlines: 3,
                        validator: requiredValidator,
                      ),
                      const SizedBox(height: 20.0),

                      // provinsi
                      CustomDropdownField(
                        label: "Provinsi",
                        value: formCon.idProvinsi.value.isEmpty
                            ? null
                            : formCon.idProvinsi.value,
                        items: regCon.dataProvinsi.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['nama']),
                            value: e['id'].toString(),
                          );
                        }).toList(),
                        onchanged: (value) {
                          formCon.setProvinsi(value);
                          formCon.setKota("");
                          formCon.setKec("");
                          formCon.setKel("");
                          regCon.kota(value);
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // kota
                      CustomDropdownField(
                        label: "Kota / Kabupaten",
                        value: formCon.idKota.value.isEmpty
                            ? null
                            : formCon.idKota.value,
                        items: regCon.dataKota.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['nama']),
                            value: e['id'].toString(),
                          );
                        }).toList(),
                        onchanged: (value) {
                          formCon.setKota(value);
                          formCon.setKec("");
                          formCon.setKel("");
                          regCon.kec(value);
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // kecamatan
                      CustomDropdownField(
                        label: "Kecamatan",
                        value: formCon.idKec.value.isEmpty
                            ? null
                            : formCon.idKec.value,
                        items: regCon.dataKecamatan.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['nama']),
                            value: e['id'].toString(),
                          );
                        }).toList(),
                        onchanged: (value) {
                          formCon.setKec(value);
                          formCon.setKel("");
                          regCon.kel(value);
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // kelurahan
                      CustomDropdownField(
                        label: "Kelurahan",
                        value: formCon.idKel.value.isEmpty
                            ? null
                            : formCon.idKel.value,
                        items: regCon.dataKelurahan.map((e) {
                          return DropdownMenuItem(
                            child: Text(e['nama']),
                            value: e['id'].toString(),
                          );
                        }).toList(),
                        onchanged: (value) {
                          formCon.setKel(value);
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // kode pos
                      CustomTextField(
                        text: "Kode Pos",
                        type: TextInputType.number,
                        controller: formCon.kodePosController,
                        validator: requiredValidator,
                      ),
                      const SizedBox(height: 20.0),

                      // Face Registration
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.67,
                            height: 65.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: primary,
                                  enableFeedback: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                Get.toNamed(RouteName.faceRegistration);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Image(
                                    image:
                                        AssetImage('assets/image/face-id.png'),
                                    width: 30,
                                  ),
                                  Text(
                                    'Daftarkan Wajah',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.checkCircle,
                            color: regCon.face.isEmpty
                                ? Colors.grey
                                : Colors.green,
                            size: MediaQuery.of(context).size.width * 0.13,
                          )
                        ],
                      ),
                      const SizedBox(height: 40.0),

                      /// tombol daftar
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            primary: primary,
                          ),
                          onPressed: () {
                            if (formCon.formKey.value.currentState!
                                    .validate() &&
                                regCon.face.isNotEmpty) {
                              Get.defaultDialog(
                                  title: 'Registrasi Akun',
                                  middleText:
                                      "Apakah anda yakin ingin registrasi akun?",
                                  barrierDismissible: false,
                                  textCancel: 'Tidak',
                                  textConfirm: 'Ya',
                                  confirmTextColor: Colors.white,
                                  onConfirm: () {
                                    Get.back();
                                    regCon.registration(
                                      namaDepan:
                                          formCon.namaDepanController.text,
                                      namaBelakang:
                                          formCon.namaBelakangController.text,
                                      email: formCon.emailController.text,
                                      noHp: formCon.noHpController.text,
                                      tmpLahir:
                                          formCon.tempatLahirController.text,
                                      tglLahir: formCon.tglLahirController.text,
                                      jenisK: formCon.jenisK,
                                      statusP: formCon.statusP,
                                      alamat: formCon.alamatController.text,
                                      provinsi: formCon.idProvinsi,
                                      kota: formCon.idKota,
                                      kecamatan: formCon.idKec,
                                      kelurahan: formCon.idKel,
                                      kodePos: formCon.kodePosController.text,
                                      dataWajah: regCon.face,
                                    );
                                  });
                            } else {
                              Get.snackbar(
                                'Warning',
                                'Isi Semua Data',
                                icon: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.exclamation,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                backgroundColor: Colors.orange.shade800,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: const Text(
                            'Daftar',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
