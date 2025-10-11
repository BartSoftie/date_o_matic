import 'package:date_o_matic/ui/themes/button_styles.dart';
import 'package:flutter/material.dart';

/// The default background color for cards, dialogs, etc.
const cardColorDark = Color.fromARGB(255, 80, 90, 100);

/// The light theme for this app
ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    // Farbe für NICHT ausgewählte Icons (Ihr Problemfall)
    unselectedIconTheme: IconThemeData(color: Colors.black),

    // Farbe für ausgewählte Icons
    selectedIconTheme: IconThemeData(color: Colors.blue),

    // Farbe für Labels
    unselectedItemColor: Colors.white,
    selectedItemColor: Colors.blue,
  ),
);
    // colorScheme: const ColorScheme.dark(primary: Colors.grey),
    // // floatingActionButtonTheme: const FloatingActionButtonThemeData(
    // //     backgroundColor: Color.fromARGB(255, 177, 147, 0),
    // //     foregroundColor: Colors.white),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //     style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.grey, foregroundColor: Colors.black)),
    // textButtonTheme: TextButtonThemeData(
    //   style: standardButtonStyle,
    // ),
    // scaffoldBackgroundColor: Colors.black,
    // switchTheme: SwitchThemeData(
    //   thumbColor: WidgetStateColor.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return const Color.fromARGB(245, 255, 255, 255);
    //     }
    //     return const Color.fromARGB(245, 188, 196, 204);
    //   }),
    //   trackColor: WidgetStateColor.resolveWith((states) {
    //     if (states.contains(WidgetState.selected)) {
    //       return const Color.fromARGB(255, 7, 209, 0);
    //     }
    //     return const Color.fromARGB(255, 48, 52, 55);
    //   }),
    // ),
    // cardColor: cardColorDark,
    // appBarTheme: ThemeData.dark().appBarTheme.copyWith(centerTitle: false),
    // dialogTheme: DialogThemeData(backgroundColor: cardColorDark));
