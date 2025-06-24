import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:first_project_flutter/conf_page.dart';
import 'package:first_project_flutter/livecam_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:social_share/social_share.dart';
import 'widgets/anexo.dart';
import 'package:get/get.dart';
import 'package:flutter_vision/flutter_vision.dart';

class CamPage extends StatefulWidget {
  const CamPage({Key? key}) : super(key: key);

  @override
  State<CamPage> createState() {
    return CamPageState();
  }
}

class CamPageState extends State<CamPage> {
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  File? arquivo;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;
  bool fotoTirada = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    vision = FlutterVision();
    try {
      await loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          yoloResults = [];
        });
      });
    } catch (e) {
      print('Erro ao inicializar: $e');
    }
  }

  Future<void> loadYoloModel() async {
    try {
      await vision.loadYoloModel(
          labels: 'assets/labels.txt',
          modelPath: 'assets/model.tflite',
          modelVersion: "yolov8",
          numThreads: 1,
          useGpu: true);
      print('modelo inicializado.');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  showPreview(File file) async {
    setState(() => arquivo = file);
    fotoTirada = true;
    Get.back();
  }

  // Future<void> _exportWhatsapp() async {
  //   if (arquivo != null) {
  //     await SocialShare.shareWhatsapp(arquivo!.path);
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Sem foto'),
  //           content: const Text(
  //               'Por favor, tire uma foto antes de exportar para o WhatsApp.'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Modelo nao foi carregado..."),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (arquivo != null) Anexo(arquivo: arquivo!),
                yoloResults.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: yoloResults.map((result) {
                          return Text(
                            'Objeto: ${result['tag']} - Confiança: ${(result['box'][4] * 100).toStringAsFixed(5)}%',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          );
                        }).toList(),
                      )
                    : SizedBox(
                        height: 5,
                        //child: Text("Nao ha objetos detectados"),
                      ),
                SizedBox(
                  height: 10,
                ),
                fotoTirada
                    ? ElevatedButton.icon(
                        onPressed: yoloOnImage,
                        icon: const Icon(Icons.share),
                        label: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Classificar'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 118, 204, 91),
                          elevation: 0.0,
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          foregroundColor: const Color.fromARGB(159, 0, 0, 0),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: () => Get.to(
                          () =>
                              CameraCamera(onFile: (file) => showPreview(file)),
                        ),
                        icon: const Icon(Icons.camera_alt),
                        label: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Tire uma foto'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 118, 204, 91),
                          elevation: 0.0,
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          foregroundColor: const Color.fromARGB(159, 0, 0, 0),
                        ),
                      ),
                const SizedBox(height: 16),
                fotoTirada
                    ? ElevatedButton(
                        onPressed: () => Get.to(
                          () =>
                              CameraCamera(onFile: (file) => showPreview(file)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                              color: Colors.black), // Adicionar borda preta
                        ),
                        child: Text('Tire outra foto',
                            style: TextStyle(color: Colors.black)),
                      )
                    : ElevatedButton(
                        onPressed: null, // Não faz nada até a foto ser tirada
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: Text('Classificar'),
                      ),
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ConfPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: () {
                    //para nao restartar e perder a foto tirada
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LiveCamPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.exit_to_app_outlined),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  yoloOnImage() async {
    yoloResults.clear();
    Uint8List byte = await arquivo!.readAsBytes();
    final image = await decodeImageFromList(byte);
    imageHeight = image.height;
    imageWidth = image.width;
    final result = await vision.yoloOnImage(
        bytesList: byte,
        imageHeight: image.height,
        imageWidth: image.width,
        iouThreshold: 0.4,
        confThreshold: 0.6,
        classThreshold: 0.6);
    if (result.isNotEmpty) {
      setState(() {
        print("Resultados: $result");
        yoloResults = result;
      });
    }
  }
}
