import 'package:flutter/material.dart';

class ResponsiveText {
  static double getTitleSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1600) return 64;
    if (width > 1200) return 64;
    if (width > 800) return 42;
    if (width > 480) return 42;
    return 42;
  }

  static double getSubTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > 1600) return 30;
    if (width > 1200) return 28;
    if (width > 800) return 24;
    if (width > 480) return 20;
    return 20;
  }

  static double getMoreDetailFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > 1600) return 56;
    if (width > 1200) return 52;
    return 42;
  }
}
