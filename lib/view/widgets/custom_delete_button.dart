import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final String content;
  final VoidCallback conformButton;
  final VoidCallback declineButton;
  const DeleteButton(
      {super.key, required this.content,  required this.conformButton, required this.declineButton});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Are you sure?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.redAccent, // Highlighting the warning
                ),
              ),
              content: Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: declineButton,
                  style: ElevatedButton.styleFrom(
                    // "No" button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.black, // Text color for better contrast
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: conformButton,
                  icon: const Icon(Icons.delete_forever, color: Colors.white),
                  label: const Text(
                    'Yes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    elevation: 5,
                  ),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red, // Delete icon color
        size: 28, // Slightly larger size
      ),
      tooltip: 'Delete Category', // Tooltip for context
    );
  }
}
