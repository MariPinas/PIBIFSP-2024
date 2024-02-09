import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'preview_page.dart';
import 'widgets/anexo.dart';

class CamPage extends StatefulWidget {
  const CamPage({super.key});

  @override
  State<CamPage> createState() {
    return CamPageState();
  }
}

class CamPageState extends State<CamPage> {
  late File arquivo;

  showPreview(file) async {
    file = await Get.to(() => PreviewPage(file: file));

    if (file != null) {
      setState(() => arquivo = file);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (arquivo != null) Anexo(arquivo: arquivo),
                ElevatedButton.icon(
                  onPressed: () => Get.to(
                    () => CameraCamera(onFile: (file) => showPreview(file)),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Classificar'),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
        ),
        child: BottomAppBar(
          height: 60,
          color: Colors.white,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.exit_to_app_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
