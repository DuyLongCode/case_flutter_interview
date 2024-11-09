import 'package:flutter/material.dart';


var darkMode=ThemeData(
  brightness:Brightness.dark,
  primaryColor:const Color.fromARGB(255, 0, 0, 0),
  indicatorColor: Colors.white,
  disabledColor: Color.fromARGB(0, 0, 0, 0),
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
  disabledColor: Color.fromARGB(255, 255, 255, 255),
  primaryColor:const Color.fromARGB(255, 0, 0, 0),
  indicatorColor: Colors.black,
  appBarTheme: const AppBarTheme(
    color: Color.fromARGB(255, 114, 112, 255),
    foregroundColor: Colors.black,
  ),
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



