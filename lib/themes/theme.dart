import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  primaryColor: Colors.white,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
      .copyWith(secondary: Colors.black, surface: Colors.white),
  dividerColor: Colors.black,
);
