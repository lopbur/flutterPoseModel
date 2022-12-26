import 'package:camera/camera.dart';
import 'package:camera_test/tflite/Recognition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

typedef void Callback(List<dynamic> list);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;

  const Camera(
      {required this.cameras, required this.setRecognitions, super.key});
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController cameraController;
  late List _recognitions;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    cameraController =
        CameraController(widget.cameras.first, ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});

      cameraController.startImageStream((CameraImage img) {
        if (!isDetecting) {
          isDetecting = true;

          int startTime = new DateTime.now().millisecondsSinceEpoch;

          Tflite.runModelOnFrame(
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: img.height,
            imageWidth: img.width,
            numResults: 1,
          ).then((recognitions) {
            int endTime = new DateTime.now().millisecondsSinceEpoch;
            print("Detection took ${endTime - startTime}");
            print(recognitions);

            isDetecting = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Container();
    }

    return Transform.scale(
      scale: 1 /
          (cameraController.value.aspectRatio *
              MediaQuery.of(context).size.aspectRatio),
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }
}
