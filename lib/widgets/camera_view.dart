import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
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
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    cameraController =
        CameraController(widget.cameras.first, ResolutionPreset.high);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});

      cameraController.startImageStream((img) {
        if (!isDetecting) {
          isDetecting = true;
          List<Uint8List> bytesList = img.planes.map((e) {
            return e.bytes;
          }).toList();
          Tflite.runModelOnFrame(
            bytesList: bytesList,
            imageHeight: img.height,
            imageWidth: img.width,
            numResults: 2,
          ).then((recognitions) {
            if (recognitions != null) {
              widget.setRecognitions(recognitions);
            }
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
    Tflite.close();
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (!cameraController.value.isInitialized) {
  //     return Container();
  //   }

  //   return Transform.scale(
  //     scale: 1 /
  //         (cameraController.value.aspectRatio *
  //             MediaQuery.of(context).size.aspectRatio),
  //     child: Center(
  //       child: CameraPreview(cameraController),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = cameraController.value.previewSize!;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(cameraController),
    );
  }
}
