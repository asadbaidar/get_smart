import 'package:flutter_test/flutter_test.dart';
import 'package:get_smart/get_smart.dart';

void main() {
  test('Test StringX: surround', () {
    final text = "hello";
    expect(text.surround("*"), "*hello*");
    expect(text.surround("*", doFor: 2), "**hello**");
    expect(text.surround("*", doFor: 3), "***hello***");
    expect(text.surround("*", between: " "), "* hello *");
    expect(text.surround(null), "hello");
    expect(text.surround("*", doIf: false), "hello");
  });
  test('Test StringX: pre', () {
    final text = "hello";
    expect(text.pre("*"), "*hello");
    expect(text.pre("*", doFor: 2), "**hello");
    expect(text.pre("*", doFor: 3), "***hello");
    expect(text.pre("*", between: " "), "* hello");
    expect(text.pre(null), "hello");
    expect(text.pre("*", doIf: false), "hello");
  });
  test('Test StringX: post', () {
    final text = "hello";
    expect(text.post("*"), "hello*");
    expect(text.post("*", doFor: 2), "hello**");
    expect(text.post("*", doFor: 3), "hello***");
    expect(text.post("*", between: " "), "hello *");
    expect(text.post(null), "hello");
    expect(text.post("*", doIf: false), "hello");
  });
  test('Test DateFormatX:', () {
    final date = Date.from(
      day: 1,
      month: 2,
      year: 2021,
      hour: 1,
      minute: 10,
      second: 0,
      microsecond: 0,
      millisecond: 0,
    );
    var time = Date.from(hour: 18, minute: 20, second: 0);
    expect(date.setting(time: time).formatYMMdHms, "2021-02-01 18:20:00");
    expect(date.setting(time: time).formatDMMyHm, "01-02-2021 18:20");
    expect(date.setting(time: time).formatHm, "18:20");
    expect(date.formatHm, "01:10");
    expect(date.formatDMMy, "01-02-2021");
  });
}
