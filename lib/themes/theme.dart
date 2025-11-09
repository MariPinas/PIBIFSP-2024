import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  primaryColor: const Color.fromARGB(255, 0, 0, 0),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
      .copyWith(
        secondary: const Color.fromARGB(159, 7, 7, 7),
        surface: const Color.fromARGB(255, 255, 255, 255),
        onPrimary: Colors.black, // Garante que o texto de widgets primários seja preto
      ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Defina a cor de fundo do botão
      foregroundColor: Colors.black, // Garante que o texto do botão seja preto
    ),
  ),
);

