import 'package:flutter/material.dart';

/// The light theme for this app
ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    // Farbe für NICHT ausgewählte Icons (Ihr Problemfall)
    unselectedIconTheme: IconThemeData(color: Colors.black),

    // Farbe für ausgewählte Icons
    selectedIconTheme: IconThemeData(color: Colors.blue),

    // Farbe für Labels
    unselectedItemColor: Colors.black,
    selectedItemColor: Colors.blue,
  ),
);
