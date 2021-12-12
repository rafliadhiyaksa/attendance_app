import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/presensi_controller.dart';
import '../../widgets/face_painter.dart';
import '../../services/camera_service.dart';

class PresensiPage extends StatelessWidget {
  PresensiPage({Key? key}) : super(key: key);

  final presCon = Get.find<PresensiController>();
  final authCon = Get.find<AuthController>();

  final double mirror = math.pi;

  final _cameraService = CameraService();

  final Color primary = '3546AB'.toColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primary,
          elevation: 0,
          leading: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
            color: Colors.black,
            iconSize: 20,
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Presensi',
            style: TextStyle(fontSize: 20),
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ]),
                width: context.width * 0.90,
                height: context.height * 0.60,
                child: GetBuilder<PresensiController>(
                  initState: (_) {
                    presCon.getPresensi(Get.arguments);
                    presCon.start();
                  },
                  dispose: (_) {
                    presCon.close();
                  },
                  builder: (_) => presCon.cameraInitialized
                      ? presCon.statusPresensi ??
                          FutureBuilder<void>(
                            future: presCon.initializeControllerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (presCon.stream == false) {
                                  return Transform(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child:
                                          Image.file(File(presCon.imagePath!)),
                                    ),
                                    transform: Matrix4.rotationY(mirror),
                                  );
                                } else {
                                  return Transform.scale(
                                    scale: 1.0,
                                    child: AspectRatio(
                                      aspectRatio: MediaQuery.of(context)
                                          .size
                                          .aspectRatio,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: context.width,
                                          height: context.width *
                                              _cameraService.cameraController!
                                                  .value.aspectRatio,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              CameraPreview(_cameraService
                                                  .cameraController!),
                                              CustomPaint(
                                                painter: FacePainter(
                                                  face: presCon.faceDetected,
                                                  imageSize: presCon.imageSize!,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          )
                      : const Center(
                          child: CircularProgressIndicator(strokeWidth: 6.0)),
                ),
              ),
            ),
          ),

          /// waktu presensi
          TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
            final now = DateTime.now();
            final String getSystemTime = DateFormat("HH:mm:ss").format(now);
            return Text(
              getSystemTime,
              style: const TextStyle(color: Colors.green, fontSize: 35),
            );
          }),

          ///bottom button
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ///tombol informasi
                IconButton(
                  onPressed: () => Get.defaultDialog(
                    title: 'Informasi',
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    content: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: const Text(
                              'Arahkan wajah pada kamera untuk melakukan presensi',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              children: [
                                const Text(
                                  'Ketentuan Presensi:',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${presCon.dataSetting.mulaiPresensi} - ${presCon.dataSetting.batasTepatWaktu} : Tepat Waktu',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '${presCon.dataSetting.batasTepatWaktu} - ${presCon.dataSetting.batasPresensiMasuk} : Terlambat',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '> ${presCon.dataSetting.batasPresensiMasuk} : Bolos Presensi',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    textCancel: 'Ok',
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.infoCircle,
                    size: 30,
                  ),
                ),

                ///tombol refresh
                // IconButton(
                //   onPressed: () {
                //     presCon.reload();
                //   },
                //   icon: const FaIcon(
                //     FontAwesomeIcons.syncAlt,
                //     size: 25,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
