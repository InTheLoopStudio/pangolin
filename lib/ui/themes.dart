import 'package:flutter/material.dart';

const itlAccent = Color(0xff6200ee);

// const primaryColor = Colors.deepPurple;
const primaryColor = itlAccent;
// const secondaryColor = Colors.deepPurple;
const secondaryColor = itlAccent;
const backgroundLightColor = Color(0xFFFCFCFC);
const backgroundDarkColor = Color(0xff070a0d);
const navigationBarLightColor = Colors.white;
const navigationBarDarkColor = Color(0xff101418);

class Themes {
  static final themeLight = ThemeData.light().copyWith(
    backgroundColor: backgroundLightColor,
    // selected color
    primaryColor: primaryColor,

    colorScheme: ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      background: Colors.white,
    ),

    // floating action button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),

    // bottom bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: navigationBarLightColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black,
    ),
    // switch active color
    toggleableActiveColor: primaryColor,
    canvasColor: backgroundLightColor,
    appBarTheme: AppBarTheme(
      backgroundColor: itlAccent,
      foregroundColor: Colors.black,
    ),
    tabBarTheme: TabBarTheme(
      indicator: ShapeDecoration(
        shape: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
          style: BorderStyle.solid,
        )),
        gradient: LinearGradient(
          colors: [Color(0xff0081ff), Color(0xff01ff80)],
        ),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: itlAccent,
      inactiveTrackColor: itlAccent,
      thumbColor: itlAccent,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
      trackHeight: 2.0,
    ),
  );

  static final themeDark = ThemeData.dark().copyWith(
    backgroundColor: backgroundDarkColor,
    // selected color
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundDarkColor,
    ),
    // floating action button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    // bottom bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: navigationBarDarkColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.white,
    ),
    // switch active color
    toggleableActiveColor: primaryColor,
    canvasColor: backgroundDarkColor,
    appBarTheme: AppBarTheme(
      backgroundColor: navigationBarDarkColor,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: itlAccent,
      inactiveTrackColor: itlAccent,
      thumbColor: itlAccent,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
      trackHeight: 2.0,
    ),
  );
}
