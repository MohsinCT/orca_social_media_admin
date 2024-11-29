import 'package:flutter/material.dart';

class DashboradContents extends StatelessWidget {
  const DashboradContents({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Welcome to Dashborad',style: TextStyle(
         fontSize: 30,
         fontWeight: FontWeight.bold
        ),)
      ],
    );
  }
}