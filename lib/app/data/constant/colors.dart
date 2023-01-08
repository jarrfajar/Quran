import 'package:flutter/material.dart';

// LIGHT
const appPurple = Color(0xff431aa1);
const appPurpleLight1 = Color(0xff9345f2);
const appPurpleLight2 = Color(0xffb9a2d8);
const appPurpleLight3 = Color.fromARGB(255, 243, 234, 255);
const appPurpleLight4 = Color.fromARGB(255, 24, 5, 92);
const appwhite = Color(0xfffaf8fc);

ThemeData themaLight = ThemeData(
  brightness: Brightness.light,
  primaryColor: appPurple,
  cardTheme: const CardTheme(
    color: appPurpleLight3,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appwhite,
    foregroundColor: appPurple,
  ),
  scaffoldBackgroundColor: appwhite,
  appBarTheme: const AppBarTheme(
    foregroundColor: appPurple,
    backgroundColor: appwhite,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: appPurpleDark),
    bodyText2: TextStyle(color: appPurpleDark),
    // headline6: TextStyle(color: appPurple),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appPurple,
    labelStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: appPurple, width: 2),
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: appPurple),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: appwhite,
      backgroundColor: appPurple,
    ),
  ),
);

// DARK
const appPurpleDark = Color(0xff1e0771);

ThemeData themaDark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: appPurpleDark,
  dialogBackgroundColor: appPurpleLight4,
  cardTheme: const CardTheme(
    color: appPurpleLight4,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appPurple,
    foregroundColor: appwhite,
  ),
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: appPurpleDark,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: appwhite),
    bodyText2: TextStyle(color: appwhite),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appwhite,
    labelStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: appwhite, width: 2),
      ),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    textColor: appwhite,
  ),
  iconTheme: const IconThemeData(color: appwhite),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: appwhite,
      backgroundColor: appPurple,
    ),
  ),
);
