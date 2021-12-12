import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercharged/supercharged.dart';

import '../../controllers/face_login_controller.dart';
import '../../widgets/face_painter.dart';
import '../../services/camera_service.dart';

class FaceLoginPage extends StatelessWidget {
  FaceLoginPage({Key? key}) : super(key: key);
  final primary = '3546AB'.toColor();
  final double mirror = math.pi;

  final faceCon = Get.find<FaceLoginController>();

  final _cameraService = CameraService();

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
        title: const Text('Scan Wajah', style: TextStyle(fontSize: 20)),
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
                height: context.height * 0.70,
                child: GetBuilder<FaceLoginController>(
                  builder: (_) => !faceCon.isLoading
                      ? faceCon.isLoginSuccess
                          ? Container(
                              alignment: Alignment.center,
                              color: Colors.green,
                              child: const FaIcon(
                                FontAwesomeIcons.solidCheckCircle,
                                size: 70,
                                color: Colors.white,
                              ),
                            )
                          : FutureBuilder<void>(
                              future: faceCon.initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (faceCon.stream == false) {
                                    return Transform(
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Image.file(
                                            File(faceCon.imagePath!)),
                                      ),
                                      transform: Matrix4.rotationY(mirror),
                                    );
                                  } else {
                                    return Transform.scale(
                                      scale: 1.0,
                                      child: AspectRatio(
                                        aspectRatio:
                                            context.mediaQuerySize.aspectRatio,
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
                                                    face: faceCon.faceDetected,
                                                    imageSize:
                                                        faceCon.imageSize!,
                                                  ),
                                                )
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
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
          GetBuilder<FaceLoginController>(
            builder: (_) => Text(
              faceCon.isLoginSuccess ? "Verified" : "Scanning",
              style: TextStyle(
                fontSize: 20,
                color: faceCon.isLoginSuccess ? Colors.green : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
