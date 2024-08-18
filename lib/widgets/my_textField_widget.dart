import 'package:flutter/material.dart';

class MyTextFieldWidget extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? obscureText;

  const MyTextFieldWidget(
      {required this.hintText,
      this.keyboardType,
      required this.labelText,
      this.controller,
      this.onChanged,
      this.validator,
      this.obscureText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              labelText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            onChanged: onChanged,
            controller: controller,
            obscureText: obscureText ?? false,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
