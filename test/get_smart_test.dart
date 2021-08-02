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
