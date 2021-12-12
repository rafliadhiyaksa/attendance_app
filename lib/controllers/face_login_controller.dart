import 'package:attendance_app/controllers/auth_controller.dart';
import 'package:attendance_app/models/user.dart';
import 'package:attendance_app/routes/route_name.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'package:attendance_app/services/camera_service.dart';
import 'package:attendance_app/services/face_recognition_service.dart';
import 'package:attendance_app/services/ml_kit_service.dart';

class FaceLoginController extends GetxController {
  CameraDescription? _cameraDescription;

  String? imagePath;
  Face? faceDetected;

  Size? _imageSize;
  Size? get imageSize => _imageSize;

  bool _detectingFaces = false;

  Future? _initializeControllerFuture;
  Future? get initializeControllerFuture => _initializeControllerFuture;

  bool cameraInitialized = false;
  bool isLoginSuccess = false;
  bool isLoading = true;
  bool stream = true;
  int i = 0;

  //service injection
  final _mlKitService = MlKitService();
  final _cameraService = CameraService();
  final _faceRecognitionService = FaceRecognitionService();

  final authCon = Get.find<AuthController>();

  @override
  void onInit() {
    start();
    super.onInit();
  }

  @override
  void onClose() {
    _cameraService.dispose();
    _faceRecognitionService.dispose();
    // _mlKitService.close();

    super.onClose();
  }

  void start() async {
    List<CameraDescription> cameras = await availableCameras();
    _cameraDescription = cameras.firstWhere((CameraDescription camera) =>
        camera.lensDirection == CameraLensDirection.front);
    await _faceRecognitionService.loadModel();
    _mlKitService.initialize();

    authCon.user.value = User();
    authCon.getAllDataWajah().then((_) async {
      _initializeControllerFuture =
          _cameraService.startService(_cameraDescription!);
      await initializeControllerFuture;
      cameraInitialized = true;
      isLoading = false;
      update();
      _frameFaces();
    });
  }

  ///membuat bounding box ketika mendeteksi wajah
  _frameFaces() {
    _imageSize = _cameraService.getImageSize();
    update();

    _cameraService.cameraController!.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlKitService.getFacesFromImage(image);

          if (faces.isNotEmpty) {
            faceDetected = faces[0];
            faces.clear();
            update();

            Future.delayed(const Duration(milliseconds: 700), () {
              _faceRecognitionService.setCurrentPrediction(
                  image, faceDetected!);
            });

            dynamic idUser = _predictUser();

            // if (authCon.listDataWajah.isNotEmpty) {
            if (idUser != null) {
              _detectingFaces = false;
              isLoginSuccess = true;
              update();
              try {
                await _cameraService.cameraController!.stopImageStream();
                Future.delayed(const Duration(seconds: 1),
                    () => Get.offAllNamed(RouteName.home, arguments: idUser));
                // Get.offAllNamed(RouteName.home, arguments: idUser);
              } catch (e) {
                rethrow;
              }
            } else {
              i++;
              print("WAJAH TIDAK SESUAI");
              if (i == 3) {
                await Future.delayed(const Duration(milliseconds: 800));
                await _cameraService.cameraController!.stopImageStream();
                await Future.delayed(const Duration(milliseconds: 300));
                XFile file = await _cameraService.takePicture();
                imagePath = file.path;
                stream = false;
                update();
                Get.defaultDialog(
                  title: 'Wajah Belum Terdaftar',
                  middleText: 'Daftarkan akun atau wajah terlebih dahulu',
                  textConfirm: 'Ok',
                  onConfirm: () {
                    Get.offAllNamed(RouteName.login);
                  },
                  barrierDismissible: false,
                );
              }
            }
            // }
          } else {
            faceDetected = null;
            update();
          }
          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  dynamic _predictUser() {
    dynamic user = _faceRecognitionService.predict();
    return user;
  }
}
