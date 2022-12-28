import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera_test/models/tflite_model.dart';
import 'package:camera_test/widgets/predictHome_view.dart';

const List<String> _models = ['appleorange', 'standraise'];
final List<PredictModel> models = _models.map((e) => PredictModel(e)).toList();

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    cameras = await availableCameras();
  } catch (e) {
    return;
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PredictHome(cameras: cameras, model: models[1]),
  ));
}
