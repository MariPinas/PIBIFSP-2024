import 'package:first_project_flutter/themes/theme.dart';
import 'package:flutter/material.dart';
import 'widgets/app_widget.dart';
import 'package:get/get.dart';

main() {
  runApp(GetMaterialApp( // Use GetMaterialApp como widget raiz
    theme: theme,
    home: AppWidget(),
  ));
}
