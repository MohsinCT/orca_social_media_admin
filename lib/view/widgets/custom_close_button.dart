import 'package:flutter/material.dart';

class CustomCloseButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomCloseButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading:  Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
            onPressed: onPressed ,
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.red,
            )),
      );
  }
}