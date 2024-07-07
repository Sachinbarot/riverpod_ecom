import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CustomFormFiled extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextEditingController controller;
  const CustomFormFiled(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.prefixIcon,
      this.validator,
      required this.obscureText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(prefixIcon)),
    );
  }
}
