import 'package:flutter/material.dart';
import 'widgets/app_widget.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

main() {
  runApp(GetMaterialApp( // Use GetMaterialApp como widget raiz
    home: AppWidget(),
  ));
}
