class Model {
  final String? name;
  final String? uri;

  Model({this.name, this.uri});

  @override
  String toString() => 'Model: {name: $name, uri: $uri}';
}
