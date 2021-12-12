import 'package:attendance_app/services/ml_kit_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../services/camera_service.dart';
import '../services/face_recognition_service.dart';

class FaceRegistrationController extends GetxController {
  CameraDescription? _cameraDescription;

  String? imagePath;
  Face? faceDetected;

  Size? _imageSize;
  Size? get imageSize => _imageSize;

  bool _detectingFaces = false;
  bool pictureTaked = false;
  bool facePredicted = false;

  Future? _initializeControllerFuture;
  Future? get initializeControllerFuture => _initializeControllerFuture;

  bool cameraInitialized = false;

  bool _saving = false;

  bool _buttonClicked = false;
  bool get buttonClicked => _buttonClicked;

  //service injection
  final _mlKitService = MlKitService();
  final _cameraService = CameraService();
  final _faceRecognitionService = FaceRecognitionService();

  @override
  void onInit() {
    start();
    super.onInit();
  }

  @override
  void onClose() {
    _cameraService.dispose();
    _faceRecognitionService.dispose();
    _mlKitService.close();
    super.onClose();
  }

  void start() async {
    List<CameraDescription> cameras = await availableCameras();
    _cameraDescription = cameras.firstWhere((CameraDescription camera) =>
        camera.lensDirection == CameraLensDirection.front);
    await _faceRecognitionService.loadModel();
    _mlKitService.initialize();

    _initializeControllerFuture =
        _cameraService.startService(_cameraDescription!);
    await initializeControllerFuture;
    cameraInitialized = true;
    update();
    _frameFaces();
  }

  ///ngehandle ketika tombol capture ditekan
  Future<bool> onShoot() async {
    if (faceDetected == null) {
      Get.defaultDialog(middleText: 'Tidak ada wajah yang terdeteksi');
      return false;
    } else {
      _saving = true;
      await Future.delayed(const Duration(milliseconds: 500));
      await _cameraService.cameraController!.stopImageStream();
      await Future.delayed(const Duration(milliseconds: 200));
      XFile file = await _cameraService.takePicture();
      imagePath = file.path;
      pictureTaked = true;
      update();
      return true;
    }
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
            update();
            if (_saving) {
              _faceRecognitionService.setCurrentPrediction(
                  image, faceDetected!);
              _saving = false;
              update();
            }
          } else {
            faceDetected = null;
            update();
          }
          _detectingFaces = false;
        } catch (e) {
          _detectingFaces = false;
        }
      }
    });
  }

  void reload() {
    cameraInitialized = false;
    pictureTaked = false;
    _buttonClicked = false;
    update();
  }

  void setButtonClicked() {
    _buttonClicked = !_buttonClicked;
    update();
  }
}
