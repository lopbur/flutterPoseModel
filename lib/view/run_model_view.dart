import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pose_webview_test/model/recognition_model.dart';
import 'package:pose_webview_test/widget/status_bar_widget.dart';
import 'package:pose_webview_test/widget/webview_widget.dart';

class RunModel extends StatefulWidget {
  const RunModel({super.key});

  @override
  State<RunModel> createState() => _RunModelState();
}

class _RunModelState extends State<RunModel> {
  List<Recognition> re = [];
  double curClass = 0.0;

  late var resultCallback = (String res) {
    if (mounted) {
      List<Recognition> r = [];
      Map<String, dynamic> decoded = jsonDecode(res);

      decoded.forEach(
          (key, value) => r.add(Recognition(label: key, confidence: value)));
      setState(() {
        re = r;
      });
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pose fiClassier")),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              path: "assets/model/index.html",
              results: resultCallback,
            ),
          ),
          Column(
            children:
                List.generate(re.length, (index) => StatusBar(re: re[index])),
          ),
        ],
      ),
    );
  }
}
