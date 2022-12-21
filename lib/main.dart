import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera_test/ui/homeview.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(
      cameras!,
    ),
  ));
}
