import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

extension Date on DateTime {
  static DateTime from({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
    TimeOfDay? timeOfDay,
    DateTime? date,
    DateTime? time,
  }) {
    final now = Date.now;
    return DateTime(
      year ?? date?.year ?? now.year,
      month ?? date?.month ?? now.month,
      day ?? date?.day ?? now.day,
      hour ?? time?.hour ?? timeOfDay?.hour ?? now.hour,
      minute ?? time?.minute ?? timeOfDay?.minute ?? now.minute,
      second ?? time?.second ?? now.second,
      millisecond ?? time?.millisecond ?? now.millisecond,
      microsecond ?? time?.microsecond ?? now.microsecond,
    );
  }

  DateTime setting({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
    TimeOfDay? timeOfDay,
    DateTime? date,
    DateTime? time,
  }) =>
      DateTime(
        year ?? date?.year ?? this.year,
        month ?? date?.month ?? this.month,
        day ?? date?.day ?? this.day,
        hour ?? time?.hour ?? timeOfDay?.hour ?? this.hour,
        minute ?? time?.minute ?? timeOfDay?.minute ?? this.minute,
        second ?? time?.second ?? this.second,
        millisecond ?? time?.millisecond ?? this.millisecond,
        microsecond ?? time?.microsecond ?? this.microsecond,
      );

  static DateTime get now => DateTime.now();

  DateTimeRange range(Duration duration) {
    final date = add(duration);
    return date > this
        ? DateTimeRange(start: this, end: date)
        : DateTimeRange(start: date, end: this);
  }

  int get inMilliseconds => millisecondsSinceEpoch;

  bool get isCurrentYear => year == now.year;

  TimeOfDay get timeOfDay => TimeOfDay.fromDateTime(this);

  DateTime get afterYear => add(365.days);

  DateTime get after3Month => add(93.days);

  DateTime get afterMonth => add(31.days);

  DateTime get startOfDay => setting(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  DateTime get endOfDay => setting(
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 0,
        microsecond: 0,
      );

  String get webTimeStamp => GetWebAPI.timeStamp + inMilliseconds.toString();

  bool operator >(DateTime other) => isAfter(other);

  bool operator <(DateTime other) => other.isAfter(this);

  String get formatEMMMdY => isCurrentYear ? formatEMMMd : formatEMMMdy;

  String get formatEMMMdYHma =>
      isCurrentYear ? formatEMMMdHma : formatEMMMdyHma;

  String get formatEMMMdy => GetDateFormat.inEMMMdy.format(this);

  String get formatEMMMdyHma => GetDateFormat.inEMMMdyHma.format(this);

  String get formatEMMMd => GetDateFormat.inEMMMd.format(this);

  String get formatEMMMdHma => GetDateFormat.inEMMMdHma.format(this);

  String get formatEEEEMMMMdY =>
      isCurrentYear ? formatEEEEMMMMd : formatEEEEMMMMdy;

  String get formatEEEEMMMMdYHma =>
      isCurrentYear ? formatEEEEMMMMdHma : formatEEEEMMMMdyHma;

  String get formatEEEEMMMMdy => GetDateFormat.inEEEEMMMMdy.format(this);

  String get formatEEEEMMMMdyHma => GetDateFormat.inEEEEMMMMdyHma.format(this);

  String get formatEEEEMMMMd => GetDateFormat.inEEEEMMMMd.format(this);

  String get formatEEEEMMMMdHma => GetDateFormat.inEEEEMMMMdHma.format(this);

  String get formatMMMMdY => isCurrentYear ? formatMMMMd : formatMMMMdy;

  String get formatMMMMdYHma =>
      isCurrentYear ? formatMMMMdHma : formatMMMMdyHma;

  String get formatMMMMdy => GetDateFormat.inMMMMdy.format(this);

  String get formatMMMMdyHma => GetDateFormat.inMMMMdyHma.format(this);

  String get formatMMMMd => GetDateFormat.inMMMMd.format(this);

  String get formatMMMMdHma => GetDateFormat.inMMMMdHma.format(this);

  String get formatMMMdY => isCurrentYear ? formatMMMd : formatMMMdy;

  String get formatMMMdYHma => isCurrentYear ? formatMMMdHma : formatMMMdyHma;

  String get formatMMMdy => GetDateFormat.inMMMdy.format(this);

  String get formatMMMdyHma => GetDateFormat.inMMMdyHma.format(this);

  String get formatMMMd => GetDateFormat.inMMMd.format(this);

  String get formatMMMdHma => GetDateFormat.inMMMdHma.format(this);

  String get formatMdY => isCurrentYear ? formatMd : formatMdy;

  String get formatMdYHma => isCurrentYear ? formatMdHma : formatMdyHma;

  String get formatMdy => GetDateFormat.inMdy.format(this);

  String get formatMdyHma => GetDateFormat.inMdyHma.format(this);

  String get formatMd => GetDateFormat.inMd.format(this);

  String get formatMdHma => GetDateFormat.inMdHma.format(this);

  /// dd-MMM-yyyy
  String get formatDMMMy => GetDateFormat.inDMMMy.format(this);

  String get formatDMMMyHm => GetDateFormat.inDMMMyHm.format(this);

  String get formatDMMy => GetDateFormat.inDMMy.format(this);

  String get formatDMMyHm => GetDateFormat.inDMMyHm.format(this);

  String get formatYMMd => GetDateFormat.inYMMd.format(this);

  String get formatYMMdHms => GetDateFormat.inYMMdHms.format(this);

  String get formatHma => GetDateFormat.inHma.format(this);

  String get formatHm => GetDateFormat.inHm.format(this);

  String get formatHms => GetDateFormat.inHms.format(this);
}

extension GetDateFormat on DateFormat {
  static DateFormat get inEMMMdy => DateFormat.yMMMEd();

  static DateFormat get inEMMMdyHma => inEMMMdy.add(inHma, ", ");

  static DateFormat get inEMMMd => DateFormat.MMMEd();

  static DateFormat get inEMMMdHma => inEMMMd.add(inHma, ", ");

  static DateFormat get inEEEEMMMMdy => DateFormat.yMMMMEEEEd();

  static DateFormat get inEEEEMMMMdyHma => inEEEEMMMMdy.add(inHma, ", ");

  static DateFormat get inEEEEMMMMd => DateFormat.MMMMEEEEd();

  static DateFormat get inEEEEMMMMdHma => inEEEEMMMMd.add(inHma, ", ");

  static DateFormat get inMMMMdy => DateFormat.yMMMMd();

  static DateFormat get inMMMMdyHma => inMMMMdy.add(inHma, ", ");

  static DateFormat get inMMMMd => DateFormat.MMMMd();

  static DateFormat get inMMMMdHma => inMMMMd.add(inHma, ", ");

  static DateFormat get inMMMdy => DateFormat.yMMMd();

  static DateFormat get inMMMdyHma => inMMMdy.add(inHma, ", ");

  static DateFormat get inMMMd => DateFormat.MMMd();

  static DateFormat get inMMMdHma => inMMMd.add(inHma, ", ");

  static DateFormat get inMdy => DateFormat.yMd();

  static DateFormat get inMdyHma => inMdy.add(inHma, ", ");

  static DateFormat get inMd => DateFormat.Md();

  static DateFormat get inMdHma => inMd.add(inHma, ", ");

  /// dd-MMM-yyyy
  static DateFormat get inDMMMy => DateFormat("dd-MMM-yyyy");

  static DateFormat get inDMMMyHm => inDMMMy.add_Hm();

  static DateFormat get inDMMy => DateFormat("dd-MM-yyyy");

  static DateFormat get inDMMyHm => inDMMy.add_Hm();

  static DateFormat get inYMMd => DateFormat("yyyy-MM-dd");

  static DateFormat get inYMMdHms => inYMMd.add_Hms();

  static DateFormat get inHma => DateFormat("h:mm a");

  static DateFormat get inHm => DateFormat.Hm();

  static DateFormat get inHms => DateFormat.Hms();

  /// Add [format] to this instance as a pattern.
  ///
  /// If there was a previous pattern, then this appends to it, separating the
  /// two by [separator].  [format] is first looked up in our list of
  /// known skeletons.  If it's found there, then use the corresponding pattern
  /// for this locale.  If it's not, then treat [format] as an explicit
  /// pattern.
  DateFormat add(DateFormat format, [String separator = ' ']) =>
      addPattern(format.pattern, separator);
}

extension GetDateTimePickerX on GetInterface {
  Future<void> timePicker({
    DateTime? withTime,
    String? cancelText,
    String? confirmText,
    String? helpText,
    TimePickerEntryMode entryMode = TimePickerEntryMode.input,
    TransitionBuilder? builder,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    required void Function(DateTime time) onPick,
    VoidCallback? onCancel,
  }) async {
    final time = await showTimePicker(
      context: context!,
      initialTime: withTime?.timeOfDay ?? TimeOfDay.now(),
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      initialEntryMode: entryMode,
      builder: builder,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
    if (time != null) {
      onPick(withTime?.setting(timeOfDay: time) ?? Date.from(timeOfDay: time));
    } else {
      onCancel?.call();
    }
  }

  Future<void> datePicker({
    DateTime? withDate,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? currentDate,
    String? cancelText,
    String? confirmText,
    String? helpText,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    DatePickerEntryMode entryMode = DatePickerEntryMode.calendar,
    DatePickerMode calenderMode = DatePickerMode.day,
    SelectableDayPredicate? selectableDayPredicate,
    Locale? locale,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    TransitionBuilder? builder,
    required void Function(DateTime date) onPick,
    VoidCallback? onCancel,
  }) async {
    final date = await showDatePicker(
      context: context!,
      initialDate: withDate ?? Date.now,
      firstDate: minDate ?? Date.from(year: 2000),
      lastDate: maxDate ?? Date.now,
      currentDate: currentDate,
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      fieldHintText: fieldHintText,
      fieldLabelText: fieldLabelText,
      initialEntryMode: entryMode,
      initialDatePickerMode: calenderMode,
      selectableDayPredicate: selectableDayPredicate,
      locale: locale,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: builder,
    );
    if (date != null) {
      onPick(withDate?.setting(date: date) ?? date);
    } else {
      onCancel?.call();
    }
  }

  Future<void> dateRangePicker({
    DateTimeRange? withRange,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? currentDate,
    String? cancelText,
    String? confirmText,
    String? saveText,
    String? helpText,
    String? errorFormatText,
    String? errorInvalidText,
    String? errorInvalidRangeText,
    String? fieldEndHintText,
    String? fieldEndLabelText,
    String? fieldStartHintText,
    String? fieldStartLabelText,
    DatePickerEntryMode entryMode = DatePickerEntryMode.calendar,
    ui.TextDirection? textDirection,
    Locale? locale,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    TransitionBuilder? builder,
    required void Function(DateTimeRange range) onPick,
    VoidCallback? onCancel,
  }) async {
    final range = await showDateRangePicker(
      context: context!,
      initialDateRange: withRange,
      firstDate: minDate ?? Date.from(year: 2000),
      lastDate: maxDate ?? Date.now,
      currentDate: currentDate,
      cancelText: cancelText,
      confirmText: confirmText,
      saveText: saveText,
      helpText: helpText,
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      errorInvalidRangeText: errorInvalidRangeText,
      initialEntryMode: entryMode,
      fieldEndHintText: fieldEndHintText,
      fieldEndLabelText: fieldEndLabelText,
      fieldStartHintText: fieldStartHintText,
      fieldStartLabelText: fieldStartLabelText,
      textDirection: textDirection,
      locale: locale,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: builder ??
          (context, child) => Theme(
                data: context.theme.copyWith(brightness: Brightness.dark),
                child: child!,
              ),
    );
    if (range != null) {
      onPick(withRange?.apply(() => withRange
            ..start.setting(date: range.start)
            ..end.setting(date: range.end)) ??
          range);
    } else {
      onCancel?.call();
    }
  }
}
