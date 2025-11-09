import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'themes/theme.dart';
import 'widgets/app_widget.dart';
import 'providers/conf_provider.dart'; // Crie a pasta providers

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ConfiguracaoProvider(),
      child: GetMaterialApp(
        theme: theme,
        home: AppWidget(),
      ),
    ),
  );
}
