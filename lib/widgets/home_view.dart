import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'package:camera_test/widgets/camera_view.dart';

class MyHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MyHomePage({required this.cameras, super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? res = "";
  bool isModelLoaded = false;
  late List<dynamic> _recognitions;

  Future<void> initSyncState() async {
    Tflite.close();
    try {
      res = await Tflite.loadModel(
          model: 'assets/model_unquant.tflite',
          labels: 'assets/labels.txt',
          numThreads: 1,
          isAsset: true,
          useGpuDelegate: false);
      isModelLoaded = true;
      print(res);
    } on PlatformException catch (e) {
      print('error: ');
      print(e.message);
    }
  }

  setRecognitions(recognitions) {
    setState(() {
      _recognitions = recognitions;
    });
    print(_recognitions);
  }

  @override
  void initState() {
    super.initState();
    initSyncState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Demo App",
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: isModelLoaded
            ? const Text("Wait for initiation.")
            : Stack(
                children: <Widget>[
                  Camera(
                    cameras: widget.cameras,
                    setRecognitions: setRecognitions,
                  )
                ],
              ));
  }
}
