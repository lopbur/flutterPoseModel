import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pose_webview_test/widgets/run_model_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Permission.camera.request();
  await Permission.microphone.request();

  print(await Permission.camera.status);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter pose demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainHome());
  }
}

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  double curClass = 0.0;
  late var resultCallback = (String res) {
    var decoded = jsonDecode(res);
    setState(() {
      curClass = decoded['Tree Pose'];
      print(curClass);
    });
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Pose Classifier")),
        body: Column(children: [
          Expanded(
              flex: 8,
              child: RunModel(
                  path: "assets/tf_models/index.html",
                  results: resultCallback)),
          Expanded(
              flex: 2,
              child: SizedBox(
                child: Stack(
                  children: [
                    LinearProgressIndicator(
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                      value: curClass,
                      backgroundColor: Colors.redAccent.withOpacity(0.2),
                      minHeight: 50.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${(curClass * 100.0).toStringAsFixed(1)}%',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              )),
        ]));
  }
}
