import 'package:flutter/material.dart';

class Dimensions {
  static late double screenHeight;
  static late double screenWidth;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenHeight = mediaQuery.size.height;
    screenWidth = mediaQuery.size.width;
  }

  // Heights
  static double get height10 => screenHeight / 84.4;
  static double get height15 => screenHeight / 56.27;
  static double get height20 => screenHeight / 42.2;
  static double get height30 => screenHeight / 28.13;
  static double get height45 => screenHeight / 18.76;

  // Widths
  static double get width10 => screenWidth / 84.4;
  static double get width15 => screenWidth / 56.27;
  static double get width20 => screenWidth / 42.2;
  static double get width30 => screenWidth / 28.13;

  // Font sizes
  static double get font16 => screenHeight / 52.75;
  static double get font20 => screenHeight / 42.2;
  static double get font26 => screenHeight / 32.46;

  // Radius
  static double get radius15 => screenHeight / 56.27;
  static double get radius20 => screenHeight / 42.2;
  static double get radius30 => screenHeight / 28.13;

  // Icon sizes
  static double get iconSize16 => screenHeight / 52.75;
  static double get iconSize24 => screenHeight / 35.17;
}