import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('test get path', () async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    print(manifestContent);
  });
}
