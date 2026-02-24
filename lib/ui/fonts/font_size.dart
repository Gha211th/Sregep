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

    if (width > 1600) return 20;
    if (width > 1200) return 18;
    if (width > 800) return 16;
    if (width > 480) return 14;
    return 14;
  }

  static double getMoreDetailFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > 1600) return 42;
    if (width > 1200) return 35;
    return 30;
  }

  static double getFontForSubDetail(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > 1600) return 20;
    if (width > 1200) return 16;
    return 14;
  }

  // for title and subtitle in stats screen hehe

  static double getFontSizeForStatsTitle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1600) return 42;
    if (width >= 1200) return 40;
    if (width >= 800) return 28;
    if (width >= 480) return 24;
    return 20;
  }

  static double getFontSizeForSubStats(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1600) return 24;
    if (width >= 1200) return 20;
    if (width >= 800) return 18;
    if (width >= 480) return 16;
    return 14;
  }

  // BIKIN FONT SIZE BUAT BARCHART CUYYYYY

  static double getFontSizeForChart(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1600) return 14;
    return 10;
  }

  static double getFontSizeForDate(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1600) return 13;
    if (width >= 1200) return 12;
    if (width >= 800) return 11;
    if (width >= 480) return 10;
    return 9;
  }

  // FOR SEARCH BAR

  static double getFontSizeForSeacrhBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1600) return 18;
    if (width >= 1200) return 16;
    if (width >= 800) return 16;
    if (width >= 480) return 14;
    return 14;
  }
}
