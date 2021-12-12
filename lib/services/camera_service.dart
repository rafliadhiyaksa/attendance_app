import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraService {
  static final CameraService _cameraService = CameraService._internal();
  factory CameraService() {
    return _cameraService;
  }
  CameraService._internal();

  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  CameraDescription? _cameraDescription;

  InputImageRotation _cameraRotation = InputImageRotation.Rotation_0deg;
  InputImageRotation get cameraRotation => _cameraRotation;

  String _imagePath = "";
  String get imagePath => _imagePath;

  /// mulai camera
  Future startService(CameraDescription cameraDescription) async {
    _cameraDescription = cameraDescription;
    _cameraController = CameraController(
      _cameraDescription!,
      ResolutionPreset.high,
      enableAudio: false,
    );

    //set rotasi dari image
    _cameraRotation =
        rotationIntToImageRotation(_cameraDescription!.sensorOrientation);

    //inisialize controller, return future
    return _cameraController!.initialize();
  }

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.Rotation_90deg;
      case 180:
        return InputImageRotation.Rotation_180deg;
      case 270:
        return InputImageRotation.Rotation_270deg;
      default:
        return InputImageRotation.Rotation_0deg;
    }
  }

  //ambil gambar dan simpan di path
  Future<XFile> takePicture() async {
    XFile file = await _cameraController!.takePicture();
    _imagePath = file.path;
    return file;
  }

  //return image size
  Size getImageSize() {
    return Size(
      _cameraController!.value.previewSize!.height,
      _cameraController!.value.previewSize!.width,
    );
  }

  dispose() {
    _cameraController!.dispose();
  }
}
