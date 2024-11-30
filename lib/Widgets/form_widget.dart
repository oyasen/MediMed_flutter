import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class CustomFormField extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;
  final Icon? icon;
  final TextEditingController controller;
  final bool obsecure;
  final Validator? validator;

  const CustomFormField({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.icon,
    required this.controller,
    this.obsecure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obsecure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: icon,
      ),
    );
  }
}
