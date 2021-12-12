import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../../services/camera_service.dart';

class MlKitService {
  static final MlKitService _mlKitService = MlKitService._internal();

  factory MlKitService() {
    return _mlKitService;
  }

  MlKitService._internal();

  final _cameraService = CameraService();

  FaceDetector? _faceDetector;
  FaceDetector? get faceDetector => _faceDetector;

  void initialize() {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      const FaceDetectorOptions(
        mode: FaceDetectorMode.fast,
      ),
    );
  }

  Future<List<Face>> getFacesFromImage(CameraImage image) async {
    //preprocess image
    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final InputImageFormat? inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw);

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    InputImageData _inputImageData = InputImageData(
      size: imageSize,
      imageRotation: _cameraService.cameraRotation,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    InputImage _inputImage = InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      inputImageData: _inputImageData,
    );

    //proses image dan membuat kesimpulan
    List<Face> faces = await _faceDetector!.processImage(_inputImage);
    return faces;
  }

  void close() {
    _faceDetector!.close();
  }
}
