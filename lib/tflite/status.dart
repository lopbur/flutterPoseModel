class Recognition {
  late int id;
  late String label;
  late double score;

  Recognition() {
    id = -1;
    label = "";
    score = 0.0;
  }

  Recognition.set(this.id, this.label, this.score) {
    id = id;
    label = label;
    score = score;
  }

  bool isEmpty() {
    if (id == -1) return true;
    return false;
  }

  @override
  String toString() {
    return 'Recognition(id: $id, label: $label, score: $score)';
  }
}
