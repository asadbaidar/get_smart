import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';
import 'package:sprintf/sprintf.dart';

/// Get text keys
enum GetText {
  done,
  cancel,
  ok,
  reset,
  delete,
  retry,
  recheck,
  succeeded,
  failed,
  busy,
  please_enter,
  invalid,
}

/// Get text data
Map<Locale, Map<GetText, String>> _getTextMap = {
  GetLocalizations.english: {
    GetText.done: "DONE",
    GetText.cancel: "CANCEL",
    GetText.ok: "OK",
    GetText.reset: "RESET",
    GetText.delete: "DELETE",
    GetText.retry: "RETRY",
    GetText.recheck: "RECHECK",
    GetText.succeeded: "Great. It's all done.",
    GetText.failed: "Something went wrong. Please try again.",
    GetText.busy: "Please wait. Good things are on the way.",
    GetText.please_enter: "Please enter the %s.",
    GetText.invalid: "Invalid %s.",
  },
};

/// Extending [GetText] for localization support
extension LocalizationExt on GetText {
  /// Return the text from [GetText] map based on current locale
  String call([List<dynamic> arguments]) {
    return this == null
        ? null
        : _getTextMap[GetLocalizations.current.locale][this]?.applyIf(
            arguments?.isNotEmpty,
            (s) => sprintf(s, arguments.map((e) => e ?? "").toList()),
          );
  }
}
