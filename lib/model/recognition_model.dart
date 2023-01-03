class Recognition {
  final String? label;
  final double? confidence;

  Recognition({this.label, this.confidence});

  @override
  String toString() =>
      'Recognition: {label: $label, confidence: ${confidence?.toStringAsFixed(2)}}';
}
