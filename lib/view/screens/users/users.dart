import 'package:flutter/material.dart';


class UsersContents extends StatelessWidget {
  const UsersContents({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> users = ['John Doe', 'Jane Smith', 'Alice Johnson', 'Bob Brown'];
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(users[index]),
          subtitle: Text('User ID: ${index + 1}'),
          onTap: () {
            // Handle user click
          },
        );
      },
    );
  }
}