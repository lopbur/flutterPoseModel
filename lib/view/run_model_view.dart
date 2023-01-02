import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pose_webview_test/widget/webview_widget.dart';

class RunModel extends StatefulWidget {
  const RunModel({super.key});

  @override
  State<RunModel> createState() => _RunModelState();
}

class _RunModelState extends State<RunModel> {
  double curClass = 0.0;

  late var resultCallback = (String res) {
    var decoded = jsonDecode(res);
    setState(() {
      curClass = decoded['Tree Pose'];
    });
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pose Classifier")),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: WebView(
              path: "assets/model/index.html",
              results: resultCallback,
            ),
          ),
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
            ),
          ),
        ],
      ),
    );
  }
}
