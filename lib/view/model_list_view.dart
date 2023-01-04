import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pose_webview_test/model/tf_model.dart';
import 'package:pose_webview_test/view/run_model_view.dart';

class ModelList extends StatefulWidget {
  const ModelList({Key? key}) : super(key: key);

  @override
  State<ModelList> createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
  final Map<String, String> _models = {
    'Tree': 'L1bAAtj82',
    'Raise arms': '7Zvxry4Iz',
    'Open arms': 'YgPVd6DwL',
  };
  List<Model> models = [];
  List<String> modelPath = [];

  @override
  initState() {
    loadModel(context);
    super.initState();
  }

  loadModel(BuildContext context) async {
    List<String> filteredAssetList = [];
    List<Model> _m = [];

    var assetsFile =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);

    List<String> m = manifestMap.keys
        .where((String key) => key.contains('assets/model'))
        .toList();

    for (var e in m) {
      filteredAssetList.add(e);
    }

    _models.forEach(
      (key, value) => _m.add(Model(name: key, uri: value)),
    );

    setState(() {
      modelPath = filteredAssetList;
      models = _m;
    });
  }

  Widget _buildListItem(BuildContext context, int index, Model m) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RunModel(targetModel: m)));
      },
      child: ListTile(title: Text(m.name ?? '')),
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
              itemCount: models.length,
              itemBuilder: (context, index) {
                return _buildListItem(context, index, models[index]);
              })
          : Container(),
    );
  }
}
