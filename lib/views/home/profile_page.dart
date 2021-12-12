import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:supercharged/supercharged.dart';

import '../../routes/route_name.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/form_controller.dart';
import '../../widgets/custom_dropdown_field.dart';
import '../../widgets/custom_text_field.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final authCon = Get.find<AuthController>();
  final formCon = Get.find<FormController>();
  final profilCon = Get.find<ProfileController>();
  final Color primary = '3546AB'.toColor();
  final requiredValidator = RequiredValidator(errorText: 'Required*');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.signOutAlt),
            iconSize: 20,
            onPressed: () => Get.defaultDialog(
              title: 'Logout',
              middleText: 'Apakah Anda Yakin Ingin Keluar?',
              textCancel: 'Tidak',
              textConfirm: 'Ya',
              confirmTextColor: Colors.white,
              onConfirm: () {
                authCon.logout();
                Get.offAllNamed(RouteName.login);
              },
            ),
          )
        ],
      ),
      backgroundColor: primary,
      body: SmartRefresher(
        controller: authCon.refreshCon,
        onRefresh: () => authCon.onRefresh(),
        header: const ClassicHeader(),
        child: SingleChildScrollView(
          child: Container(
            color: primary,
            child: Column(
              children: [
                SizedBox(
                  height: context.height * 0.18,
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: 'F8F8F8'.toColor(),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          top: 80, right: 32, left: 32, bottom: 32),
                      child: Obx(() {
                        return Form(
                          key: formCon.formKey.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              //NAMA
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: context.width * 0.40,
                                    child: CustomTextField(
                                      text: "Nama Depan",
                                      readOnly: true,
                                      controller: formCon.namaDepanController,
                                      // validator: requiredValidator,
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.width * 0.40,
                                    child: CustomTextField(
                                      text: "Nama Belakang",
                                      readOnly: true,
                                      controller:
                                          formCon.namaBelakangController,
                                      // validator: requiredValidator,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              // email
                              CustomTextField(
                                text: "Email",
                                controller: formCon.emailController,
                                readOnly: true,
                              ),
                              const SizedBox(height: 20.0),

                              // no hp
                              CustomTextField(
                                text: "No. Handphone",
                                type: TextInputType.phone,
                                controller: formCon.noHpController,
                                validator: requiredValidator,
                              ),
                              const SizedBox(height: 20.0),

                              // tempat lahir
                              CustomTextField(
                                text: "Tempat Lahir",
                                controller: formCon.tempatLahirController,
                                readOnly: true,
                              ),
                              const SizedBox(height: 20.0),

                              // tanggal lahir
                              CustomTextField(
                                readOnly: true,
                                text: "Tanggal Lahir",
                                suffixicon: Icon(
                                  Icons.date_range_rounded,
                                  color: primary,
                                ),
                                controller: formCon.tglLahirController,
                              ),
                              const SizedBox(height: 20.0),

                              // jenis kelamin
                              CustomTextField(
                                text: "Jenis Kelamin",
                                controller: formCon.jenisKController,
                                readOnly: true,
                              ),
                              const SizedBox(height: 20.0),

                              // status
                              CustomDropdownField(
                                label: "Status Pernikahan",
                                // hintText: formCon.statusP!,
                                value: formCon.statusP,
                                items: profilCon.dataStatus.map((e) {
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

                              // alamat
                              CustomTextField(
                                text: "Alamat",
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
                                items: profilCon.dataProvinsi.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['nama']),
                                    value: e['id'].toString(),
                                  );
                                }).toList(),
                                onchanged: (value) {
                                  print(value);
                                  formCon.setProvinsi(value);
                                  formCon.setKota("");
                                  formCon.setKec("");
                                  formCon.setKel("");

                                  profilCon.dataKota.value = [];
                                  profilCon.dataKecamatan.value = [];
                                  profilCon.dataKelurahan.value = [];

                                  profilCon.kota(value);
                                },
                              ),
                              const SizedBox(height: 20.0),

                              // kota
                              CustomDropdownField(
                                label: "Kota / Kabupaten",
                                value: formCon.idKota.value.isEmpty
                                    ? null
                                    : formCon.idKota.value,
                                items: profilCon.dataKota.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['nama']),
                                    value: e['id'].toString(),
                                  );
                                }).toList(),
                                onchanged: (value) {
                                  formCon.setKota(value);
                                  formCon.setKec("");
                                  formCon.setKel("");

                                  profilCon.dataKecamatan.value = [];
                                  profilCon.dataKelurahan.value = [];

                                  profilCon.kec(value);
                                },
                              ),
                              const SizedBox(height: 20.0),

                              // kecamatan
                              CustomDropdownField(
                                label: "Kecamatan",
                                value: formCon.idKec.value.isEmpty
                                    ? null
                                    : formCon.idKec.value,
                                items: profilCon.dataKecamatan.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['nama']),
                                    value: e['id'].toString(),
                                  );
                                }).toList(),
                                onchanged: (value) {
                                  print(value);
                                  formCon.setKec(value);
                                  formCon.setKel("");
                                  profilCon.dataKelurahan.value = [];
                                  profilCon.kel(value);
                                },
                              ),
                              const SizedBox(height: 20.0),

                              // kelurahan
                              CustomDropdownField(
                                label: "Kelurahan",
                                value: formCon.idKel.value.isEmpty
                                    ? null
                                    : formCon.idKel.value,
                                items: profilCon.dataKelurahan.map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['nama']),
                                    value: e['id'].toString(),
                                  );
                                }).toList(),
                                onchanged: (value) {
                                  print(value);
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
                              const SizedBox(height: 40.0),

                              /// tombol save
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
                                    Get.defaultDialog(
                                        title: 'Ubah Akun',
                                        middleText:
                                            "Apakah anda yakin ingin Mengubah akun?",
                                        barrierDismissible: false,
                                        textCancel: 'Tidak',
                                        textConfirm: 'Ya',
                                        confirmTextColor: Colors.white,
                                        onConfirm: () {
                                          Get.back();
                                          if (formCon
                                              .formKey.value.currentState!
                                              .validate()) {
                                            profilCon.updateData(
                                              idUser: authCon.user.value.idUser,
                                              noHp: formCon.noHpController.text,
                                              statusP: formCon.statusP,
                                              alamat:
                                                  formCon.alamatController.text,
                                              provinsi:
                                                  formCon.idProvinsi.value,
                                              kota: formCon.idKota.value,
                                              kecamatan: formCon.idKec.value,
                                              kelurahan: formCon.idKel.value,
                                              kodePos: formCon
                                                  .kodePosController.text,
                                            );
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
                                              backgroundColor:
                                                  Colors.orange.shade800,
                                              colorText: Colors.white,
                                            );
                                          }
                                        });
                                  },
                                  child: const Text(
                                    'Simpan',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    Positioned(
                      top: -80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.grey.shade300,
                          width: (context.width - 20) * 0.4,
                          height: (context.width - 20) * 0.4,
                          child: authCon.user.value.profilImg == null
                              ? Image.asset(
                                  "assets/image/profile.png",
                                  fit: BoxFit.cover,
                                )
                              : authCon.user.value.profilImg!.isEmpty
                                  ? Image.asset(
                                      "assets/image/profile.png",
                                      fit: BoxFit.cover,
                                    )
                                  : Image.memory(authCon.user.value.profilImg!,
                                      fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
