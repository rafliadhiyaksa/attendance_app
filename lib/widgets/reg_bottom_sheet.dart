import 'package:attendance_app/controllers/form_controller.dart';
import 'package:attendance_app/controllers/registration_controller.dart';
import 'package:attendance_app/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

class RegBottomSheet extends StatelessWidget {
  const RegBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomheight = context.height * 0.4;
    final primary = '3546AB'.toColor();
    final regCon = Get.put(RegistrationController());
    final formCon = Get.put(FormController());

    return Container(
      height: bottomheight,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Registrasi Wajah",
            style: TextStyle(fontSize: 19),
            textAlign: TextAlign.center,
          ),
          const Text(
            "Masukkan email yang sudah pernah didaftarkan",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: bottomheight * 0.07),
          CustomTextField(
            text: "Email",
            type: TextInputType.emailAddress,
            controller: formCon.emailController,
          ),
          SizedBox(height: bottomheight * 0.1),
          SizedBox(
            height: bottomheight * 0.18,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                primary: primary,
              ),
              onPressed: () {
                regCon.checkEmail(formCon.emailController.text);
              },
              child: const Text(
                'Check Email',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
