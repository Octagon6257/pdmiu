import 'package:flutter/material.dart';

class Responsive {
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 600 ? 32.0 : 16.0;
  }
}
