import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pose_webview_test/view/run_model_view.dart';

class ModelList extends StatefulWidget {
  const ModelList({Key? key}) : super(key: key);

  @override
  State<ModelList> createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
  List<String> modelPath = [];

  @override
  initState() {
    loadModelPath(context);
    super.initState();
  }

  loadModelPath(BuildContext context) async {
    List<String> filteredAssetList = [];

    var assetsFile =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);

    List<String> m = manifestMap.keys
        .where((String key) => key.contains('assets/model'))
        .toList();

    for (var e in m) {
      filteredAssetList.add(e);
    }

    setState(() {
      modelPath = filteredAssetList;
    });
  }

  Widget _buildListItem(BuildContext context, String path) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RunModel()));
      },
      child: ListTile(title: Text(path)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Choose model",
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: modelPath.isNotEmpty
          ? ListView.builder(
              itemCount: modelPath.length,
              itemBuilder: (context, index) {
                return _buildListItem(context, modelPath[index]);
              })
          : Container(),
    );
  }
}
