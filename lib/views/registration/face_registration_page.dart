import 'dart:io';
import 'dart:math' as math;

import 'package:attendance_app/controllers/registration_controller.dart';
import 'package:attendance_app/routes/route_name.dart';
import 'package:attendance_app/services/face_recognition_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercharged/supercharged.dart';

import '../../controllers/face_registration_controller.dart';
import '../../widgets/face_painter.dart';
import '../../services/camera_service.dart';

class FaceRegistrationPage extends StatelessWidget {
  FaceRegistrationPage({Key? key}) : super(key: key);

  final faceCon = Get.find<FaceRegistrationController>();
  final regCon = Get.find<RegistrationController>();

  final _cameraService = CameraService();
  final _faceRecognitionService = FaceRecognitionService();

  final double mirror = math.pi;
  final primary = '3546AB'.toColor();

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
            Get.back();
          },
        ),
        title: const Text('Registrasi Wajah', style: TextStyle(fontSize: 20)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: SizedBox(
                width: context.width * 0.90,
                height: context.height * 0.65,
                child: GetBuilder<FaceRegistrationController>(
                  builder: (_) => FutureBuilder<void>(
                    future: faceCon.initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (faceCon.pictureTaked) {
                          return Transform(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.file(File(faceCon.imagePath!)),
                            ),
                            transform: Matrix4.rotationY(mirror),
                          );
                        } else {
                          return Transform.scale(
                            scale: 1.0,
                            child: AspectRatio(
                              aspectRatio: context.mediaQuerySize.aspectRatio,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: context.width,
                                  height: context.width *
                                      _cameraService
                                          .cameraController!.value.aspectRatio,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CameraPreview(
                                          _cameraService.cameraController!),
                                      CustomPaint(
                                        painter: FacePainter(
                                          face: faceCon.faceDetected,
                                          imageSize: faceCon.imageSize!,
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
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          GetBuilder<FaceRegistrationController>(
            builder: (_) => Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Informasi',
                          titleStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          content: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Text(
                                    'Klik tombol capture untuk mengambil gambar wajah',
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
                                  child: const Text(
                                    'Tombol berubah warna hijau ketika gambar wajah berhasil diambil',
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
                                  child: const Text(
                                    'Klik lagi tombol yang sudah berwarna hijau untuk menyelesaikan proses pendaftaran wajah',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          textCancel: 'Ok',
                        );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.infoCircle,
                        size: 30,
                      )),
                  ElevatedButton(
                    child: Container(
                      child: faceCon.buttonClicked
                          ? const FaIcon(FontAwesomeIcons.check,
                              size: 25, color: Colors.white)
                          : const Image(
                              image: AssetImage('assets/image/face-id.png'),
                              width: 30,
                            ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      primary: faceCon.buttonClicked ? Colors.green : primary,
                      enableFeedback: true,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () async {
                      if (!faceCon.buttonClicked) {
                        try {
                          await faceCon.initializeControllerFuture;
                          await faceCon.onShoot();
                          if (faceCon.pictureTaked) {
                            if (Get.arguments != null) {
                              regCon.regWajah(
                                  idUser: int.parse(Get.arguments),
                                  dataWajah:
                                      _faceRecognitionService.currFaceData);
                              faceCon.setButtonClicked();
                            } else {
                              Get.find<RegistrationController>().setFaceValue(
                                  _faceRecognitionService.currFaceData!);
                              faceCon.setButtonClicked();
                            }
                          }
                        } catch (e) {
                          rethrow;
                        }
                      } else {
                        if (Get.arguments != null) {
                          Get.offAllNamed(RouteName.login);
                        } else {
                          Get.back();
                        }
                      }
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      faceCon.reload();
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.redoAlt,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
