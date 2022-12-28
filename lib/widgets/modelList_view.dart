import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:camera_test/models/tflite_model.dart';
import 'package:camera_test/widgets/predictHome_view.dart';

class ModelList extends StatefulWidget {
  final List<CameraDescription> cameras;
  final List<PredictModel> models;
  const ModelList({required this.models, required this.cameras, super.key});

  @override
  State<ModelList> createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
  Widget _buildListItem(BuildContext context, PredictModel model) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PredictHome(cameras: widget.cameras, model: model)));
        },
        child: ListTile(
          title: Text(model.originalName),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Choose model",
          ),
          backgroundColor: Color.fromARGB(255, 93, 114, 150),
        ),
        body: ListView.builder(
            itemCount: widget.models.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, widget.models[index]);
            }));
  }
}
