import 'package:camera/camera.dart';
import 'package:first_project_flutter/cam_page.dart';
import 'package:first_project_flutter/conf_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LiveCamPage extends StatefulWidget {
  const LiveCamPage({Key? key}): super(key: key);



  @override
  State<LiveCamPage> createState() => _LiveCamPageState();
}

class _LiveCamPageState extends State<LiveCamPage>{
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  

  @override
  void initState(){
    startCamera();
    super.initState();
  }
  bool _cameraInitialized = false;
  void startCamera() async{
    cameras = await availableCameras();

    cameraController = CameraController(
        cameras[0], 
        ResolutionPreset.high,
        enableAudio: false,
      );

    await cameraController.initialize().then((value){
      if(!mounted){
        return;
      }
      setState(() {_cameraInitialized = true;});
    }).catchError((e){
      print(e);
    });

    @override
      void dispose() {
      cameraController.dispose();
      super.dispose();
    }
 
  }
  
  @override
  Widget build(BuildContext context) {
    if(_cameraInitialized && cameraController.value.isInitialized){
        return Scaffold(
          body: Stack(
            children: [
              CameraPreview(cameraController),
            ],
          ),
          extendBody: true,
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
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CamPage()),
                    );
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
      }else{
        return const SizedBox();
      }
  }
  
  }
