import 'package:flutter/material.dart';

class CustomTweenContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool isSelected;
  final IconData icon;
  const CustomTweenContainer(
      {super.key,
      required this.onTap,
      required this.label,
       this.isSelected = false,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 1.0, end: isSelected ? 1.06 : 1.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInCirc,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: Column(
                  children: <Widget>[
                    Icon(icon,
                        size: 24,
                        color: isSelected ? Colors.orange : Colors.black),
                    const SizedBox(width: 16),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.orange : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
