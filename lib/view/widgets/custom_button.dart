import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget buttonText; // Accept any widget, including Text or CircularProgressIndicator
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.buttonText, // Use a widget instead of just text
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed, // The button will be clickable if this is not null
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,  // Text color
          backgroundColor: Colors.blue,   // Button background color
          minimumSize: const Size(double.infinity, 50), // Button size
        ),
        child: buttonText, // Render the passed widget (Text or any other widget)
      ),
    );
  }
}
