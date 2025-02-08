import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscure;
  final String? initialText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isObscure = false,
    this.initialText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initialText != null && initialText!.isNotEmpty) {
      controller.text = initialText!;
    }

    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(
        color: Color(0xFF192252),
        fontWeight: FontWeight.w400
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: const Color(0xFF424F7B).withOpacity(0.7),
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF424F7B).withOpacity(0.7),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF424F7B).withOpacity(0.7),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}