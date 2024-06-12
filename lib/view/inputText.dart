import 'package:flutter/material.dart';
class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  CustomTextInput({
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
         borderSide: BorderSide.none, 
        ),
        suffixIcon: suffixIcon,
        fillColor: Color(0xFFEDEBEB),
        filled: true,
        focusedBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
    );
  }
}