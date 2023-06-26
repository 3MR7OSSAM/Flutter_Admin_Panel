import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
      this.hintText,
      this.inputType,
      this.onChanged,
      this.obscureText = false,
      this.validator, required this.hasIcon,  this.onTap, required this.isNumber, this.controller,this.isEnabled}) : super(key: key);

  Function(String)? onChanged;
  String? hintText;
  TextInputType? inputType;
  bool obscureText;
  bool? isEnabled;
  final bool hasIcon;
  final FormFieldValidator<String>? validator;
  final Function? onTap;
  final bool isNumber;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        enabled: isEnabled ?? true,
        cursorColor: Colors.black,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        onChanged: onChanged,
        keyboardType: inputType,
        decoration: InputDecoration(
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ) ,
          suffixIcon: hasIcon? GestureDetector(
            onTap: (){
              onTap!();
            },
              child:Icon(
            Icons.remove_red_eye_outlined,
            color: Colors.black.withOpacity(0.5),
          )):const SizedBox(width: 0,height: 0,),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide:BorderSide(color: Colors.black.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        inputFormatters: isNumber ? [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
    ]
    : null,
      ),
    );
  }
}
