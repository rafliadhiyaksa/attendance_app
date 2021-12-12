import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.text,
    this.controller,
    this.isPassword = false,
    this.readOnly = false,
    this.type = TextInputType.text,
    this.maxlines = 1,
    this.prefixicon,
    this.suffixicon,
    this.ontap,
    this.maxlength,
    this.minlines,
    this.validator,
  }) : super(key: key);

  final Color primary = '3546AB'.toColor();
  final String text;
  final bool isPassword, readOnly;
  final TextInputType type;
  final int? maxlines, minlines;
  final TextEditingController? controller;
  final Icon? prefixicon, suffixicon;
  final Function()? ontap;
  final int? maxlength;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsetsDirectional.only(start: 4.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(height: 5.0),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: maxlength,
          readOnly: readOnly,
          controller: controller,
          onTap: ontap,
          validator: validator,
          maxLines: maxlines,
          obscureText: isPassword,
          cursorColor: primary,
          keyboardType: type,
          textInputAction: TextInputAction.done,
          minLines: minlines,
          style: const TextStyle(
              fontFamily: "ProductSans", fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            hintText: text,
            alignLabelWithHint: true,
            fillColor: Colors.grey.shade300,
            filled: true,
            labelStyle: const TextStyle(
                fontFamily: "ProductSans", fontWeight: FontWeight.w700),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(15)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(15)),
            suffixIcon: suffixicon,
          ),
        ),
      ],
    );
  }
}
