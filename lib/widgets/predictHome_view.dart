import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'package:camera_test/widgets/camera_view.dart';
import 'package:camera_test/widgets/Status_view.dart';

import 'package:camera_test/models/tflite_model.dart';
import 'package:camera_test/models/recognition_model.dart';

class PredictHome extends StatefulWidget {
  final List<CameraDescription> cameras;
  final PredictModel model;
  const PredictHome({required this.cameras, required this.model, super.key});

  @override
  State<PredictHome> createState() => _PredictHomeState();
}

class _PredictHomeState extends State<PredictHome> {
  final List<Recognition> _recognitions = List.filled(2, Recognition());
  Recognition curState = Recognition();
  int count = 0;
  String predOne = '';
  double confidence = 0;
  double index = 0;

  Future<void> initSyncState() async {
    String? res;
    try {
      res = await Tflite.loadModel(
          model: 'assets/tflite/${widget.model.modelFileName}',
          labels: 'assets/tflite/${widget.model.labelsFileName}',
          numThreads: 1,
          isAsset: true,
          useGpuDelegate: false);
      print(res);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  setRecognitions(List<Recognition> l) {
    if (mounted) {
      setState(() {
        if (l[0].id == 1 && curState.id == 0) count++;
        curState = l[0];

        if (l.length == 1 &&
            !(_recognitions[0].isEmpty() || _recognitions[1].isEmpty())) {
          _recognitions[l[0].id] = l.first;
          _recognitions[1 - l[0].id].score = 1 - l.first.score;
        } else if (l.length == 2) {
          for (var e in l) {
            _recognitions[e.id] = e;
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initSyncState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
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
                    Row(children: [
                      Expanded(
                          flex: 3,
                          child: Text('curState: ${curState.label}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0))),
                      Expanded(
                          flex: 5,
                          child: Text('count: ${count}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0)))
                    ]),
                    StatusCard(recognition: _recognitions[0]),
                    StatusCard(recognition: _recognitions[1])
                  ],
                )))
          ],
        ));
  }
}
