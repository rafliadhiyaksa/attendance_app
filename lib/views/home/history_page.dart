import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercharged/supercharged.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:attendance_app/controllers/presensi_controller.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final Color primary = '3546AB'.toColor();
  final Color green = '3AA969'.toColor();
  final Color red = 'F44336'.toColor();
  EdgeInsets hrzPadd = const EdgeInsets.symmetric(horizontal: 20);

  final presCon = Get.find<PresensiController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Riwayat',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: GetBuilder<PresensiController>(
        initState: (_) {
          presCon.getPresensi(Get.arguments);
        },
        builder: (_) => SmartRefresher(
          controller: presCon.refreshCon,
          onRefresh: () => presCon.onRefresh(Get.arguments),
          header: const ClassicHeader(),
          child: presCon.dataPresensi.isEmpty
              ? const Center(
                  child: Text("Tidak Ada Data Presensi",
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  itemCount: presCon.dataPresensi.length,
                  itemBuilder: (context, index) {
                    List dataPresensi = presCon.dataPresensi.reversed.toList();
                    String statusP = "";
                    if (dataPresensi[index].status == '1') {
                      statusP = "Presensi Tepat Waktu";
                    } else if (dataPresensi[index].status == '2') {
                      statusP = "Presensi Terlambat";
                    } else {
                      statusP = "Tidak Melakukan Presensi (Bolos)";
                    }

                    DateTime dateTime =
                        DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                            .parse(dataPresensi[index].tanggal);
                    dateTime =
                        DateTime(dateTime.year, dateTime.month, dateTime.day);
                    var bulan = DateFormat('MMM', 'id_ID').format(dateTime);
                    var tanggal = DateFormat('dd').format(dateTime);

                    return Padding(
                      padding: EdgeInsets.only(
                          right: 20,
                          left: 20,
                          top: 5,
                          bottom: index == presCon.dataPresensi.length - 1
                              ? 100
                              : 5),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: const Offset(0, 1),
                              )
                            ]),
                        height: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(bulan.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 12, color: primary)),
                                Text(tanggal,
                                    style: TextStyle(
                                        fontSize: 32, color: primary)),
                                // buildText(tahun, 12, primary),
                              ],
                            ),
                            Container(
                              width: context.width * 0.65,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    statusP,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  Text(
                                    "Waktu Masuk : ${dataPresensi[index].jamMasuk == '-' ? "N/A" : dataPresensi[index].jamMasuk}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    "Waktu Pulang : ${dataPresensi[index].jamPulang == '-' ? "N/A" : dataPresensi[index].jamPulang}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
