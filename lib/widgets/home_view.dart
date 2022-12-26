import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'package:camera_test/widgets/camera_view.dart';
import 'package:camera_test/widgets/Status_view.dart';

class MyHomePage extends StatefulWidget {
  late List<CameraDescription> cameras;
  MyHomePage({required this.cameras, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<dynamic> _recognitions = [];
  String predOne = '';
  double confidence = 0;
  double index = 0;

  Future<void> initSyncState() async {
    Tflite.close();
    String? res;
    try {
      res = await Tflite.loadModel(
          model: 'assets/model_unquant.tflite',
          labels: 'assets/labels.txt',
          numThreads: 1,
          isAsset: true,
          useGpuDelegate: false);
      print(res);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  setRecognitions(recognitions) {
    setState(() {
      _recognitions = recognitions;
    });
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
        body: Stack(
          children: <Widget>[
            Camera(
              cameras: widget.cameras,
              setRecognitions: setRecognitions,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatusCard(
                        classname: _recognitions.isEmpty
                            ? ""
                            : _recognitions[0]['label'],
                        confidence: _recognitions.isEmpty
                            ? 0.0
                            : _recognitions[0]['confidence'])
                  ],
                )))
          ],
        ));
  }
}
