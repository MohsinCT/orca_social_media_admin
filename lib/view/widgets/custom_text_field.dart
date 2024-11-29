import 'package:flutter/material.dart';

class NewCustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final String? prefixText;
  final bool? obscureText; // Accept the obscureText value as a parameter
  final VoidCallback? toggleObscureText;
  final IconButton? suffixIcon; // Accept a callback for toggling password visibility

  const NewCustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.validator,
    this.isPassword = false,
    this.prefixText,
    this.obscureText, // Include the parameter
    this.toggleObscureText,  this.suffixIcon, // Include the toggle function
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && (obscureText ?? true), // Use the provided obscureText value
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 10.0,
        ),
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  (obscureText ?? true) ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: toggleObscureText, // Call the toggle function
              )
            : null,
      ),
      validator: validator,
    );
  }
}
