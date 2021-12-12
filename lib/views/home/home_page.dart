// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:supercharged/supercharged.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../controllers/presensi_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/route_name.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final Color primary = '3546AB'.toColor();
  final Color green = '3AA969'.toColor();
  final Color red = 'F6404F'.toColor();
  EdgeInsets hrzPadd = const EdgeInsets.symmetric(horizontal: 20);

  final presCon = Get.put(PresensiController());
  final authCon = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return Scaffold(
      body: SmartRefresher(
        controller: authCon.homeRefresh,
        onRefresh: () {
          authCon.onRefresh('home');
          Get.arguments != null
              ? presCon.onRefresh(Get.arguments)
              : presCon.onRefresh(authCon.user.value.idUser!);
        },
        header: const ClassicHeader(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: context.height * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                  gradient: RadialGradient(
                    colors: [
                      '#0575E6'.toColor(),
                      primary,
                    ],
                    center: const Alignment(-1.0, -1.0),
                    focal: const Alignment(0.3, -0.1),
                    focalRadius: 3,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Attendance',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    Text(
                      "${DateFormat.EEEE('id').format(DateTime.now())}, ${DateFormat('d MMM yyyy').format(DateTime.now())}",
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    SizedBox(
                      height: context.height * 0.05,
                    )
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      SizedBox(height: (context.height * 0.2 + 20)),

                      ///presensi hari ini
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Presensi Hari Ini',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GetBuilder<PresensiController>(
                        initState: (_) {
                          if (Get.arguments != null) {
                            presCon.getPresensi(Get.arguments);
                          } else {
                            presCon.getPresensi(authCon.user.value.idUser!);
                          }
                          // presCon.getSetting();
                        },
                        builder: (_) {
                          String now = DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                              .format(DateTime.now());
                          var data = presCon.dataPresensi
                              .where((element) => element.tanggal == now);

                          int index = presCon.dataPresensi
                              .indexWhere((element) => element.tanggal == now);

                          String today =
                              DateFormat.EEEE('id').format(DateTime.now());

                          return Container(
                            margin: hrzPadd,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: data.isNotEmpty
                                  ? presCon.dataPresensi[index].jamMasuk != '-'
                                      ? presCon.dataPresensi[index].status ==
                                              '1'
                                          ? green
                                          : Colors.orange
                                      : red
                                  : Colors.grey,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FaIcon(
                                      data.isNotEmpty
                                          ? presCon.dataPresensi[index]
                                                      .jamMasuk !=
                                                  '-'
                                              ? FontAwesomeIcons.checkCircle
                                              : FontAwesomeIcons.timesCircle
                                          : FontAwesomeIcons.timesCircle,
                                      color: Colors.white,
                                      size: (context.height * 0.09) - 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          today == 'Sabtu' || today == 'Minggu'
                                              ? "Hari Ini Presensi Libur"
                                              : data.isNotEmpty
                                                  ? presCon.dataPresensi[index]
                                                              .jamMasuk !=
                                                          '-'
                                                      ? "Sudah Melakukan Presensi"
                                                      : "Anda Bolos Presensi"
                                                  : "Belum Melakukan Presensi",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        () {
                                          if (data.isNotEmpty) {
                                            return Text(
                                              "${presCon.dataPresensi[index].jamMasuk}",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            );
                                          } else {
                                            return const Text("N/A",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15));
                                          }
                                        }(),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 65,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      primary: Colors.white,
                                    ),
                                    onPressed: () => Get.toNamed(
                                        RouteName.presensi,
                                        arguments: Get.arguments ??
                                            authCon.user.value.idUser),
                                    child: const Text(
                                      "Presensi",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  height: 65,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      primary: Colors.white,
                                    ),
                                    onPressed: () => Get.toNamed(
                                        RouteName.history,
                                        arguments: authCon.user.value.idUser),
                                    child: const Text(
                                      "Riwayat",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),

                  // info akun
                  GetX<AuthController>(
                    initState: (_) {
                      if (Get.arguments != null) {
                        authCon.getUser(Get.arguments);
                      }
                    },
                    builder: (_) => Positioned(
                      top: -context.height * 0.1,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: context.width - 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade500,
                                blurRadius: 4,
                                spreadRadius: 1)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            authCon.user.value.idUser == null
                                ? const ProfileShimmer(
                                    isRectBox: true,
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          color: Colors.grey,
                                          width: (context.width - 20) * 0.35,
                                          height: (context.width - 20) * 0.35,
                                          child: authCon.user.value.profilImg ==
                                                  null
                                              ? Container(
                                                  color: Colors.grey,
                                                  child: Center(
                                                      child: Image.asset(
                                                    "assets/image/profile.png",
                                                    height: 80,
                                                  )),
                                                )
                                              : authCon.user.value.profilImg!
                                                      .isEmpty
                                                  ? Container(
                                                      color: Colors.grey,
                                                      child: Center(
                                                          child: Image.asset(
                                                        "assets/image/profile.png",
                                                        height: 80,
                                                      )),
                                                    )
                                                  : Image.memory(
                                                      authCon.user.value
                                                          .profilImg!,
                                                      fit: BoxFit.cover),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "${authCon.user.value.namaDepan} ${authCon.user.value.namaBelakang}"
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17)),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "${authCon.user.value.email}",
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${authCon.user.value.noHp}",
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  Get.toNamed(RouteName.profil);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Profil",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}
