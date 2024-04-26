import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField(
      {super.key,
      required this.txtController,
      required this.label,
      required this.validator,
      required this.iconVal,
      required this.obscurevalue});

  final TextEditingController txtController;
  final String label;
  final dynamic iconVal;
  final bool obscurevalue;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscurevalue,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightGreen,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightGreen,
          ),
        ),
        labelStyle: const TextStyle(fontSize: 18, color: Colors.black),
        labelText: label,
        suffixIcon: iconVal,
      ),
      controller: txtController,
      validator: validator,
    );
  }
}
