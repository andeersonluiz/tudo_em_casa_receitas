// ignore_for_file: file_names
import 'package:flutter/material.dart';

class CustomTheme {
  static const Color primaryColor = Colors.white;
  static const Color greyColor = Color(0xff7C7C80);
  static const Color greyAccent = Color(0xffD9D9D9);
  static const Color thirdColor = Color(0xffE3351B);
  static const Color darkColor = Color(0xff1a1a1a);
  static final TextEditingController controller = TextEditingController();
  static ThemeData dataLight = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    secondaryHeaderColor: const Color(0xffE3351B),
    fontFamily: "CostaneraAltMedium",
    appBarTheme: const AppBarTheme(
      color: Colors.white,
    ),
    // ignore: deprecated_member_use
    backgroundColor: greyAccent,
    bottomAppBarTheme: const BottomAppBarTheme(color: greyColor),
    iconTheme: IconThemeData(color: greyColor.withOpacity(0.5)),
    indicatorColor: thirdColor,
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    dialogBackgroundColor: thirdColor,
    primarySwatch: Colors.blue,
    textTheme: const TextTheme(
        titleLarge:
            TextStyle(fontFamily: "CostaneraAltBold", color: Color(0xff121212)),
        titleMedium:
            TextStyle(fontFamily: "CostaneraAltBook", color: Color(0xff121212)),
        bodySmall: TextStyle(fontFamily: "CostaneraAltBook", color: greyColor),
        bodyLarge:
            TextStyle(fontFamily: "CostaneraAltBook", color: thirdColor)),
    primaryTextTheme: Typography(platform: TargetPlatform.iOS).black,
  );

  static ThemeData dataDark = ThemeData(
      brightness: Brightness.dark,
      primaryTextTheme: Typography(platform: TargetPlatform.iOS).black,
      indicatorColor: primaryColor,
      dialogBackgroundColor: Colors.white,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkColor,
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xff121212),
      ),
      iconTheme: const IconThemeData(color: primaryColor),
      secondaryHeaderColor: Colors.red[900],
      textTheme: const TextTheme(
          titleLarge:
              TextStyle(fontFamily: "CostaneraAltBold", color: Colors.white),
          titleMedium:
              TextStyle(fontFamily: "CostaneraAltBook", color: Colors.white),
          bodySmall:
              TextStyle(fontFamily: "CostaneraAltBook", color: Colors.white),
          bodyLarge: TextStyle(
              fontFamily: "CostaneraAltBook",
              fontWeight: FontWeight.bold,
              color: Colors.white)),
      bottomAppBarTheme: const BottomAppBarTheme(color: primaryColor));
}
