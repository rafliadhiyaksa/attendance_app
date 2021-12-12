import 'package:attendance_app/widgets/reg_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

import '../../routes/route_name.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final primary = '3546AB'.toColor();

  @override
  Widget build(BuildContext context) {
    final bottomheight = context.height * 0.35;
    return Scaffold(
      backgroundColor: primary,
      body: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            //BACKGROUND IMAGE
            Column(
              children: [
                SizedBox(
                  height: bottomheight * 0.3,
                ),
                Image.asset(
                  'assets/image/illustration2.png',
                  width: context.width * 0.95,
                ),
                SizedBox(
                  height: bottomheight * 0.3,
                ),
                const Text(
                  "Attendance",
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
                const Text(
                  "CV. Destinasi Computindo",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
              ],
            ),
            //CONTENT
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: bottomheight,
                width: double.infinity,
                padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.16),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Login Karyawan",
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      Text(
                        "Masuk Menggunakan Deteksi Wajah",
                        style:
                            TextStyle(color: '878F95'.toColor(), fontSize: 15),
                      ),
                      SizedBox(
                        height: bottomheight * 0.05,
                      ),
                      SizedBox(
                        height: bottomheight / 3.5,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(RouteName.faceLogin);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: primary,
                            enableFeedback: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Image(
                                image: AssetImage('assets/image/face-id.png'),
                                width: 40,
                              ),
                              Text(
                                "Scan to Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ), // Icon(Icons.login_rounded)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: bottomheight * 0.1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Belum Daftarkan Wajah?",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                const RegBottomSheet(),
                                isScrollControlled: true,
                              );
                            },
                            child: Text(
                              " Daftar",
                              style: TextStyle(
                                  color: "#3546AB".toColor(), fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Tidak Punya Akun?",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(RouteName.registration);
                            },
                            child: Text(
                              "Daftar Sekarang",
                              style: TextStyle(
                                  color: "#3546AB".toColor(), fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
