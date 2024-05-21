import 'package:flutter/material.dart';

class mytextfield extends StatelessWidget {
  const mytextfield({
    super.key,
    required this.txtController,
    required this.label,
    required this.validator,
  });

  final TextEditingController txtController;
  final String label;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightGreenAccent,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightGreenAccent,
          ),
        ),
        labelStyle: const TextStyle(fontSize: 18, color: Colors.black),
        labelText: label,
      ),
      controller: txtController,
      validator: validator,
    );
  }
}
