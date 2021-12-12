import 'dart:convert';

import 'package:attendance_app/controllers/auth_controller.dart';
import 'package:attendance_app/models/setting.dart';
import 'package:attendance_app/services/camera_service.dart';
import 'package:attendance_app/services/face_recognition_service.dart';
import 'package:attendance_app/services/ml_kit_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:supercharged/supercharged.dart';

import '../providers/presensi_provider.dart';
import '../models/presensi.dart';

class PresensiController extends GetxController {
  CameraDescription? _cameraDescription;

  String? imagePath;
  Face? faceDetected;

  Size? _imageSize;
  Size? get imageSize => _imageSize;

  bool _detectingFaces = false;
  bool stream = true;

  Future? _initializeControllerFuture;
  Future? get initializeControllerFuture => _initializeControllerFuture;

  bool cameraInitialized = false;
  bool loading = false;

  List? _currFaceData;
  List? get currFaceData => _currFaceData;

  List _dataPresensi = [];
  List get dataPresensi => _dataPresensi;

  Setting _dataSetting = Setting();
  Setting get dataSetting => _dataSetting;

  Map<String, dynamic> _dataResponse = {};
  Map<String, dynamic> get dataResponse => _dataResponse;

  int statusUser = 0;
  int i = 0;

  Widget? statusPresensi;
  bool isPresensi = false;

  final authCon = Get.find<AuthController>();

  //service injection
  final _mlKitService = MlKitService();
  final _cameraService = CameraService();
  final _faceRecognitionService = FaceRecognitionService();

  //refresh controller
  RefreshController refreshCon = RefreshController();

  @override
  void onInit() async {
    getSetting();
    super.onInit();
  }

  void close() async {
    try {
      if (_detectingFaces) {
        await _cameraService.cameraController!.stopImageStream();
      }
      _initializeControllerFuture = null;
      faceDetected = null;
      statusPresensi = null;
      cameraInitialized = false;
      // _detectingFaces = false;
      stream = true;
      i = 0;
      // _faceRecognitionService.setCurrFaceData(null);
      // update();
      _faceRecognitionService.dispose();
      // _mlKitService.close();
      // print('$faceDetected $statusPresensi $cameraInitialized');
    } catch (err) {
      rethrow;
    }
  }

  void start() async {
    List<CameraDescription> cameras = await availableCameras();
    _cameraDescription = cameras.firstWhere((CameraDescription camera) =>
        camera.lensDirection == CameraLensDirection.front);
    await _faceRecognitionService.loadModel();
    _mlKitService.initialize();
    initialize();
  }

  void initialize() async {
    _initializeControllerFuture =
        _cameraService.startService(_cameraDescription!);
    await initializeControllerFuture;
    // Future.delayed(const Duration(milliseconds: 500));
    cameraInitialized = true;
    update();
    _frameFaces();
  }

  ///membuat bounding box ketika mendeteksi wajah
  void _frameFaces() {
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
            Future.delayed(const Duration(milliseconds: 500), () {
              _faceRecognitionService.setCurrentPrediction(
                  image, faceDetected!);
            });
            dynamic karyawan = _predictUser();
            if (karyawan['status'] == 1) {
              print('WAJAH SESUAI');
              presensiCondition();
              // update();
              await Future.delayed(const Duration(milliseconds: 800));
              await _cameraService.cameraController!.stopImageStream();
              await Future.delayed(const Duration(milliseconds: 300));
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
                  title: '',
                  middleText: 'Wajah Anda Tidak Sesuai',
                  textConfirm: 'Ok',
                  onConfirm: () {
                    Get.back();
                    Get.back();
                  },
                  barrierDismissible: false,
                );
              }
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

  dynamic _predictUser() {
    dynamic user = _faceRecognitionService.predict();
    return user;
  }

  void snackBar(String title, String message, bool isSuccess) => Get.snackbar(
        title,
        message,
        duration: const Duration(seconds: 2),
        colorText: Colors.white,
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        icon: Center(
          child: FaIcon(
            isSuccess
                ? FontAwesomeIcons.checkCircle
                : FontAwesomeIcons.exclamationCircle,
            color: Colors.white,
            size: 25,
          ),
        ),
      );

  Future<void> getPresensi(int idUser) async {
    PresensiProvider().getPresensi(idUser).then((value) {
      if (value.status.isOk) {
        List data = value.body['data'];
        _dataPresensi.clear();
        for (var element in data) {
          var presensi = Presensi(
            id: jsonDecode(element['ID_ABSENSI']),
            idUser: jsonDecode(element['USER_ID']),
            tanggal: element['TGL_ABSEN'],
            jamMasuk: element['JAM_MASUK'],
            jamPulang: element['JAM_PULANG'],
            status: element['STATUS_USER'],
          );
          _dataPresensi.add(presensi);
        }
        update();
      }
    });
  }

  void onRefresh(int idUser) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      getPresensi(idUser);
      refreshCon.refreshCompleted();
    } catch (e) {
      refreshCon.refreshFailed();
    }
  }

  void getSetting() {
    PresensiProvider().getSetting().then((value) {
      if (value.status.isOk) {
        List data = value.body['data'];
        for (var element in data) {
          var setting = Setting(
            id: int.parse(element['ID_SETTING']),
            namaApp: element['NAMA_APP'],
            mulaiPresensi: element['ABSEN_MULAI'],
            batasTepatWaktu: element['ABSEN_MULAI_SAMPAI'],
            batasPresensiMasuk: element['ABSEN_VALID'],
            presensiPulang: element['ABSEN_PULANG'],
          );
          _dataSetting = setting;
        }
        update();
      } else if (value.status.connectionError) {
        snackBar('Error', 'No Internet Connection', false);
      }
    });
  }

  Widget presensiStatus({Color? color, IconData? icon, String text = ""}) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(icon, size: 60, color: Colors.white),
          const SizedBox(height: 10),
          Center(
              child: Text(text,
                  style: const TextStyle(color: Colors.white, fontSize: 15)))
        ],
      ),
    );
  }

  void presensiCondition() {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('HH:mm:ss');

    DateTime start = dateFormat.parse(dataSetting.mulaiPresensi!);
    start = DateTime(
        now.year, now.month, now.day, start.hour, start.minute, start.second);

    DateTime onTime = dateFormat.parse(dataSetting.batasTepatWaktu!);
    onTime = DateTime(now.year, now.month, now.day, onTime.hour, onTime.minute,
        onTime.second);

    DateTime end = dateFormat.parse(dataSetting.batasPresensiMasuk!);
    end = DateTime(
        now.year, now.month, now.day, end.hour, end.minute, end.second);

    DateTime goHome = dateFormat.parse(dataSetting.presensiPulang!);
    goHome = DateTime(now.year, now.month, now.day, goHome.hour, goHome.minute,
        goHome.second);

    //cek tanggal libur
    String today = DateFormat.EEEE('id').format(now);
    if (today == 'Sabtu' || today == 'Minggu') {
      statusPresensi = presensiStatus(
          color: Colors.red,
          icon: FontAwesomeIcons.timesCircle,
          text: "Hari Ini Presensi Libur");
      update();
    } else {
      if (now.isBetween(start, end)) {
        print('JALANKAN');
        PresensiProvider()
            .presensiMasuk(authCon.user.value.idUser!,
                now.isBetween(start, onTime) ? 1 : 2)
            .then((value) {
          if (value.status.isOk) {
            _dataResponse = value.body;
            if (dataResponse['value'] == 1) {
              List data = dataResponse['data'];
              for (var element in data) {
                var presensi = Presensi(
                  id: jsonDecode(element['ID_ABSENSI']),
                  idUser: jsonDecode(element['USER_ID']),
                  tanggal: element['TGL_ABSEN'],
                  jamMasuk: element['JAM_MASUK'],
                  jamPulang: element['JAM_PULANG'],
                  status: element['STATUS_USER'],
                );
                // int index = dataPresensi
                //     .indexWhere((element) => element.idUser == presensi.idUser);
                // _dataPresensi[index] = presensi;
                _dataPresensi.add(presensi);
              }
              // update();
              if (now.isBetween(start, onTime)) {
                statusPresensi = presensiStatus(
                    color: Colors.green,
                    icon: FontAwesomeIcons.solidCheckCircle,
                    text: "Presensi Berhasil (Tepat Waktu)");
                // update();
              } else {
                statusPresensi = presensiStatus(
                    color: Colors.orange,
                    icon: FontAwesomeIcons.solidCheckCircle,
                    text: "Presensi Berhasil (Terlambat)");
              }
              // update();
            } else if (dataResponse['value'] == 2) {
              statusPresensi = presensiStatus(
                  color: Colors.orange,
                  icon: FontAwesomeIcons.exclamationCircle,
                  text: "Sudah Presensi");
              // update();
            } else {
              statusPresensi = presensiStatus(
                  color: Colors.red,
                  icon: FontAwesomeIcons.timesCircle,
                  text: "Presensi Gagal");
              // update();
            }
          } else if (value.status.hasError) {
            snackBar('Error', 'Connection Error', false);
            statusPresensi = Container();
            // update();
          }
          update();
        });
      } else if (now.isAfter(end)) {
        var tanggal =
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
        var data = dataPresensi.where((element) => element.tanggal == tanggal);
        print('Presensi Pulang');
        bool bolos = false;
        data.map((e) {
          if (e.jamMasuk == '-') {
            bolos = true;
          }
        }).toList();
        if (data.isNotEmpty) {
          if (now.isAfter(goHome)) {
            int index = dataPresensi
                .indexWhere((element) => element.tanggal == tanggal);
            PresensiProvider()
                .presensiPulang(dataPresensi[index].id)
                .then((value) {
              if (value.status.isOk) {
                _dataResponse = value.body;
                if (dataResponse['value'] == 1) {
                  List data = dataResponse['data'];
                  for (var element in data) {
                    var presensi = Presensi(
                      id: jsonDecode(element['ID_ABSENSI']),
                      idUser: jsonDecode(element['USER_ID']),
                      tanggal: element['TGL_ABSEN'],
                      jamMasuk: element['JAM_MASUK'],
                      jamPulang: element['JAM_PULANG'],
                      status: element['STATUS_USER'],
                    );
                    // int index = dataPresensi.indexWhere(
                    //     (element) => element.idUser == presensi.idUser);
                    // dataPresensi[index] = presensi;
                    _dataPresensi.add(presensi);
                  }
                  // update();
                  statusPresensi = presensiStatus(
                      color: Colors.green,
                      icon: FontAwesomeIcons.solidCheckCircle,
                      text: "Presensi Pulang Berhasil");
                  // update();
                } else if (dataResponse['value'] == 2) {
                  statusPresensi = presensiStatus(
                      color: Colors.red,
                      icon: FontAwesomeIcons.timesCircle,
                      text: "Anda Bolos Presensi");
                  // update();
                } else {
                  statusPresensi = presensiStatus(
                      color: Colors.red,
                      icon: FontAwesomeIcons.timesCircle,
                      text: "Presensi Pulang Gagal");
                  // update();
                }
                update();
              } else if (value.status.hasError) {
                snackBar('Error', 'Connection Error', false);
                statusPresensi = Container();
              }
            });
          } else {
            if (bolos) {
              statusPresensi = presensiStatus(
                  color: Colors.red,
                  icon: FontAwesomeIcons.timesCircle,
                  text: "Anda Bolos Presensi");
            } else {
              statusPresensi = presensiStatus(
                  color: Colors.orange,
                  icon: FontAwesomeIcons.exclamationCircle,
                  text: "Belum Saatnya Presensi Pulang");
            }
            update();
          }
        } else {
          PresensiProvider()
              .presensiBolos(authCon.user.value.idUser!)
              .then((value) {
            if (value.status.isOk) {
              _dataResponse = value.body;
              if (dataResponse['value'] == 1) {
                List data = dataResponse['data'];
                print(data);
                for (var element in data) {
                  var presensi = Presensi(
                    id: jsonDecode(element['ID_ABSENSI']),
                    idUser: jsonDecode(element['USER_ID']),
                    tanggal: element['TGL_ABSEN'],
                    jamMasuk: element['JAM_MASUK'],
                    jamPulang: element['JAM_PULANG'],
                    status: element['STATUS_USER'],
                  );

                  // int index = dataPresensi.indexWhere((element) {
                  //   return element.idUser == presensi.idUser;
                  // });

                  // print(index);
                  _dataPresensi.add(presensi);
                }
                update();
                statusPresensi = presensiStatus(
                    color: Colors.red,
                    icon: FontAwesomeIcons.timesCircle,
                    text: "Anda Bolos Presensi");
                // update();
              } else if (dataResponse['value'] == 2) {
                statusPresensi = presensiStatus(
                    color: Colors.red,
                    icon: FontAwesomeIcons.timesCircle,
                    text: "Anda Bolos Presensi");
                // update();
              } else {
                statusPresensi = presensiStatus(
                    color: Colors.red,
                    icon: FontAwesomeIcons.timesCircle,
                    text: "Presensi Gagal");
                // update();
              }
              update();
            }
          });
        }
      } else {
        statusPresensi = presensiStatus(
            color: Colors.orange,
            icon: FontAwesomeIcons.exclamationCircle,
            text: "Belum Saatnya Presensi");
        update();
      }
    }
  }
}
