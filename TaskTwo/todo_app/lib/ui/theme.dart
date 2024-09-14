import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';


const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);


class Themes {
  static final light = ThemeData(
    primaryColor: primaryClr,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryClr,
      onPrimary: Colors.white, // You can adjust this as needed
      secondary: Colors.blue, // You can adjust this as needed
      onSecondary: Colors.white, // You can adjust this as needed
      error: Colors.red, // You can adjust this as needed
      onError: Colors.white, // You can adjust this as needed
      background: Colors.white,
      onBackground: Colors.black, // You can adjust this as needed
      surface: Colors.white, // You can adjust this as needed
      onSurface: Colors.black, // You can adjust this as needed
    ),
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: darkGreyClr,
      onPrimary: Colors.white, // You can adjust this as needed
      secondary: Colors.teal, // You can adjust this as needed
      onSecondary: Colors.white, // You can adjust this as needed
      error: Colors.red, // You can adjust this as needed
      onError: Colors.white, // You can adjust this as needed
      background: darkGreyClr,
      onBackground: Colors.white, // You can adjust this as needed
      surface: darkGreyClr,
      onSurface: Colors.white, // You can adjust this as needed
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ));
}

TextStyle get bodyStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ));
}

TextStyle get body2Style {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.grey : Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ));
}
