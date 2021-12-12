import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class CustomDropdownField extends StatelessWidget {
  CustomDropdownField({
    Key? key,
    this.items,
    required this.label,
    this.onchanged,
    this.value,
    // required this.hintText,
  }) : super(key: key);

  final List<DropdownMenuItem<Object>>? items;
  final String label;
  // final String hintText;
  final Function(Object?)? onchanged;
  final Color primary = '3546AB'.toColor();
  final Object? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsetsDirectional.only(start: 4.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(height: 5.0),
        DropdownButtonFormField(
          value: value,
          items: items,
          isExpanded: true,
          onChanged: onchanged,
          validator: (value) => value == null ? "Required*" : null,
          style: const TextStyle(
            fontFamily: "ProductSans",
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: label,
            fillColor: Colors.grey.shade300,
            filled: true,
            hintStyle: const TextStyle(
                fontFamily: "ProductSans", fontWeight: FontWeight.w700),
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
          ),
        ),
      ],
    );
  }
}
