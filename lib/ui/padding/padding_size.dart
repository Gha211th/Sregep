import 'package:flutter/material.dart';

class PaddingSize {
  static double getPaddingVer(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1600) return 30;
    if (width >= 800) return 25;
    return 20;
  }

  static double getPaddingHor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1600) return 35;
    if (width >= 800) return 30;
    return 25;
  }

  static double getPaddingTextConHor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1600) return 20;
    if (width >= 800) return 15;
    return 10;
  }
}
