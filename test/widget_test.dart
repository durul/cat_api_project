import 'package:cat_api_project/macros/class_modifier.dart';
import 'package:flutter_test/flutter_test.dart';

@FlutterBaseMacro()
class TestMacro {
  final String id;
}

void main() {
  test('a', () {
    final test = TestMacro(id: 'daa');
    print(test);
  });
}
