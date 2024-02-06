import 'package:flutter/material.dart';

import 'conf_page.dart';
import 'themes/theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: ConfPage(),
    );
  }
}
