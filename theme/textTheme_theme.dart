// ignore_for_file: file_names
import 'package:flutter/material.dart';

class CustomTheme {
  static const Color primaryColor = Colors.white;
  static const Color greyColor = Color(0xff7C7C80);
  static const Color greyAccent = Color(0xffD9D9D9);
  static const Color thirdColor = Color(0xffE3351B);
  static final TextEditingController controller = TextEditingController();
  static ThemeData data = ThemeData(
      fontFamily: "CostaneraAltMedium",
      primaryTextTheme: Typography(platform: TargetPlatform.iOS).black,
      textTheme: Typography(platform: TargetPlatform.iOS).black,
      accentColor: thirdColor);
}
