class PredictModel {
  final String originalName;
  late String lowerName;
  late String modelFileName;
  late String labelsFileName;

  PredictModel(this.originalName) {
    lowerName = originalName.toLowerCase();
    modelFileName = '${lowerName}_model.tflite';
    labelsFileName = '${lowerName}_labels.txt';
  }

  @override
  String toString() {
    return 'PredictModel(originalName: $originalName, lowerName: $lowerName, modelFileName: $modelFileName, labelsFileName: $labelsFileName)';
  }
}
