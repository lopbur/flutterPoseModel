import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'package:camera_test/widgets/camera_view.dart';
import 'package:camera_test/widgets/Status_view.dart';

import 'package:camera_test/tflite/status.dart';

class MyHomePage extends StatefulWidget {
  late List<CameraDescription> cameras;
  MyHomePage({required this.cameras, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Recognition> _recognitions = List.filled(2, Recognition());
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

  setRecognitions(List<Recognition> l) {
    setState(() {
      if (l.length == 1) {
        _recognitions[l[0].id] = l.first;
        _recognitions[1 - l[0].id].score = 1 - l.first.score;
      } else {
        for (var e in l) {
          _recognitions[e.id] = e;
        }
      }
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
                    StatusCard(recognition: _recognitions[0]),
                    StatusCard(recognition: _recognitions[1])
                  ],
                )))
          ],
        ));
  }
}
