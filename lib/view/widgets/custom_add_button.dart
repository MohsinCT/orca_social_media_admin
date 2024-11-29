import 'package:flutter/material.dart';
import 'package:orca_social_media_admin/constants/colors.dart';
import 'package:orca_social_media_admin/constants/media_query.dart';

class CustomAddButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomAddButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: mediaQuery.screenWidth * 0.15,
        height: mediaQuery.screenHeight * 0.05,
        decoration: BoxDecoration(
            color: WebColors.oRLightGrey,
            borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(text,
            style: TextStyle(
              fontSize: mediaQuery.screenWidth * 0.010,
            ),), const Icon(Icons.add)],
          ),
        ),
      ),
    );
  }
}
