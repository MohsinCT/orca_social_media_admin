import 'package:flutter/material.dart';

class MediaQueryHelper {
  final BuildContext context;

  MediaQueryHelper(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
  bool get isKeyboardOpen => MediaQuery.of(context).viewInsets.bottom > 0;
  
  bool get isMobile => screenWidth < 1000;
  bool get isLarger => screenWidth > 1477;
  bool get isMedium => screenWidth > 1267;
}
