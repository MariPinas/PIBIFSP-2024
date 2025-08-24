// LiveCamPage.dart
import 'package:first_project_flutter/providers/conf_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:first_project_flutter/cam_page.dart';
import 'package:first_project_flutter/conf_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

late List<CameraDescription> cameras;

class LiveCamPage extends StatefulWidget {
  const LiveCamPage({Key? key}) : super(key: key);

  @override
  State<LiveCamPage> createState() => _LiveCamPageState();
}

class _LiveCamPageState extends State<LiveCamPage> {
  String previousResult = '';
  DateTime lastSpokenTime = DateTime.now();

  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  FlutterTts flutterTts = FlutterTts();
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  bool soloudInitialized = false;

  final Map<String, Vector3> soundPositions = {
    "Topo Esquerda": Vector3(-1, 0, -1),
    "Topo": Vector3(0, 0, -1),
    "Topo Direita": Vector3(1, 0, -1),
    "Esquerda": Vector3(-1, 0, 0),
    "Centro": Vector3(0, 0, 0),
    "Direita": Vector3(1, 0, 0),
    "Baixo Esquerda": Vector3(-1, 0, 1),
    "Baixo": Vector3(0, 0, 1),
    "Baixo Direita": Vector3(1, 0, 1),
  };
  @override
  void initState() {
    super.initState();
    init();
  }

  // Future<void> configureTts() async {
  //   await flutterTts.setLanguage('pt-PT');
  //   await flutterTts.setSpeechRate(100.0);
  //   await flutterTts.setVolume(100.0);
  // }

  Future<void> initSoloud() async {
    if (!soloudInitialized) {
      final error = await SoLoud().startIsolate();
      if (error == PlayerErrors.noError) {
        soloudInitialized = true;
      }
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
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      print('Erro ao carregar modelo: $e');
    }
  }

  init() async {
    cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    try {
      await controller.initialize().then((value) async {
        await loadYoloModel().then((value) {
          setState(() {
            isLoaded = true;
            isDetecting = false;
            yoloResults = [];
          });
        });
        await initSoloud();
        await startDetection();
      });
    } catch (e) {
      print('Erro ao inicializar: $e');
    }
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await vision.closeYoloModel();
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) return;

    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        await yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.5,
      classThreshold: 0.6,
    );

    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
      //speakText(yoloResults);
      //await play3DSounds(result);
      await _playAudioBasedOnMode(context, result);
    }
  }

  Future<void> _playAudioBasedOnMode(
      BuildContext context, List<Map<String, dynamic>> detectedObjects) async {
    final audioMode =
        Provider.of<ConfiguracaoProvider>(context, listen: false).audioMode;

    if (audioMode == AudioMode.audio3d) {
      await play3DSounds(detectedObjects);
    } else {
      await speakText(detectedObjects);
    }
  }

  Future<void> play3DSounds(List<Map<String, dynamic>> detectedObjects) async {
    final screen = MediaQuery.of(context).size;

    for (var obj in detectedObjects) {
      String label = obj['tag'];
      double x = obj["box"][0] * screen.width / (cameraImage?.height ?? 1);
      double y = obj["box"][1] * screen.height / (cameraImage?.width ?? 1);
      double w = (obj["box"][2] - obj["box"][0]) *
          screen.width /
          (cameraImage?.height ?? 1);
      double h = (obj["box"][3] - obj["box"][1]) *
          screen.height /
          (cameraImage?.width ?? 1);
      double cx = x + w / 2;
      double cy = y + h / 2;

      String region = getPositionLabel(cx, cy, screen);
      Vector3? position = soundPositions[region];

      if (position != null) {
        final path = 'assets/audio/$label.mp3';
        final sound = await SoloudTools.loadFromAssets(path);
        if (sound != null) {
          await SoLoud().play3d(sound, position.x, position.y, position.z);
        }
      }
    }
  }

  Future<void> speakText(List<Map<String, dynamic>> detectedObjects) async {
    List<String> objectNames = detectedObjects.map((result) {
      return result['tag'].toString();
    }).toList();

    objectNames.sort();
    String currentResult = objectNames.join(', ');
    DateTime currentTime = DateTime.now();

    int timeIntervalInSeconds = 5;
    if (currentResult != previousResult ||
        currentTime.difference(lastSpokenTime).inSeconds >
            timeIntervalInSeconds) {
      await flutterTts.setSpeechRate(1.0);
      await flutterTts.speak(currentResult);
      previousResult = currentResult;
      lastSpokenTime = currentTime;
    }
  }

  String getPositionLabel(double centerX, double centerY, Size screen) {
    double thirdWidth = screen.width / 3;
    double thirdHeight = screen.height / 3;

    int row, col;

    // coluna esq dir centro
    if (centerX < thirdWidth) {
      col = 1;
    } else if (centerX < 2 * thirdWidth) {
      col = 2;
    } else {
      col = 3;
    }

    // linha topo, centro, baixo
    if (centerY < thirdHeight) {
      row = 1;
    } else if (centerY < 2 * thirdHeight) {
      row = 2;
    } else {
      row = 3;
    }

    int position = (row - 1) * 3 + col;

    switch (position) {
      case 1:
        return "Topo Esquerda";
      case 2:
        return "Topo";
      case 3:
        return "Topo Direita";
      case 4:
        return "Esquerda";
      case 5:
        return "Centro";
      case 6:
        return "Direita";
      case 7:
        return "Baixo Esquerda";
      case 8:
        return "Baixo";
      case 9:
        return "Baixo Direita";
      default:
        return "Desconhecido";
    }
  }

  List<Widget> buildBoxes(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      double offsetY =
          -objectHeight * 0.1; // teste -> coloca a bb um pouco para cima (10%)
      objectY += offsetY;

      double centerX = objectX + objectWidth / 2;
      double centerY = objectY + objectHeight / 2;

      return Stack(
        children: [
          Positioned(
            left: objectX,
            top: objectY,
            width: objectWidth,
            height: objectHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                    color: const Color.fromARGB(255, 221, 17, 17), width: 3.0),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${result['tag']}",
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Color.fromARGB(255, 7, 7, 7),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: objectX,
            top: objectY - 20, //acima da bb 20 px
            child: Text(
              getPositionLabel(centerX, centerY, screen),
              style: const TextStyle(
                color: CupertinoColors.systemYellow,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                backgroundColor: Color.fromARGB(255, 7, 7, 7),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Carregando modelo . . ."),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),
          ...buildBoxes(size),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 5, color: CupertinoColors.white),
              ),
              child: isDetecting
                  ? IconButton(
                      onPressed: stopDetection,
                      icon: const Icon(Icons.stop,
                          color: CupertinoColors.destructiveRed),
                      iconSize: 50,
                    )
                  : IconButton(
                      onPressed: startDetection,
                      icon: const Icon(Icons.play_arrow,
                          color: CupertinoColors.white),
                      iconSize: 50,
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: CupertinoColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ConfPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.image_outlined),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => CamPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => LiveCamPage()));
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
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.systemYellow
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final thirdWidth = size.width / 3;
    final thirdHeight = size.height / 3;

    canvas.drawLine(Offset(thirdWidth, 0), Offset(thirdWidth, size.height),
        paint); //     1/3
    canvas.drawLine(Offset(thirdWidth * 2, 0),
        Offset(thirdWidth * 2, size.height), paint); //       2/3
    canvas.drawLine(
        Offset(0, thirdHeight), Offset(size.width, thirdHeight), paint);
    canvas.drawLine(
        Offset(0, thirdHeight * 2), Offset(size.width, thirdHeight * 2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      false; //para nao ficar redesenhando
}
