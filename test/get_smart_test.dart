import 'package:flutter_test/flutter_test.dart';
import 'package:get_smart/get_smart.dart';

void main() {
  test('Test StringX: surround', () {
    final text = "hello";
    expect(text.surround("*"), "*hello*");
    expect(text.surround("*", doFor: 2), "**hello**");
    expect(text.surround("*", doFor: 3), "***hello***");
    expect(text.surround("*", doIf: false), "hello");
  });
}
