import 'package:flutter/material.dart';

class Responsive {
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 32.0 : 16.0;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
