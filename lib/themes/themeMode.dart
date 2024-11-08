import 'package:flutter/material.dart';


var darkMode=ThemeData(
  brightness:Brightness.dark,
  primaryColor:Colors.white,
  indicatorColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Color.fromARGB(255, 70, 49, 255),
  ),
  cardTheme: const CardTheme(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Color.fromARGB(255, 70, 49, 255)),
    ),
  ),
);
var lightMode=ThemeData(
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
    ),
  ),
  brightness:Brightness.light,
  primaryColor:const Color.fromARGB(255, 103, 54, 226),
  indicatorColor: Colors.black,
  cardTheme: const CardTheme(
    color: Colors.white,
    
    shape: RoundedRectangleBorder(
      
      side: BorderSide(color: Color.fromARGB(255, 70, 49, 255)),
    ),
  ),
);
class ThemeModeManager with ChangeNotifier {
  bool isDark = false;
  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}