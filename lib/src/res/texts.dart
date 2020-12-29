import 'package:flutter/material.dart';
import 'package:get_smart/src/res/localization.dart';
import 'package:get_smart/src/utils/utils.dart';
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
  processing,
}

/// Get text data
Map<Locale, Map<GetText, String>> _getTextMap = {
  Localization.english: {
    GetText.done: "DONE",
    GetText.cancel: "CANCEL",
    GetText.ok: "OK",
    GetText.reset: "RESET",
    GetText.delete: "DELETE",
    GetText.retry: "RETRY",
    GetText.recheck: "RECHECK",
    GetText.succeeded: "Great. It's all done.",
    GetText.failed: "Something went wrong. Please try again.",
    GetText.processing: "Please wait. Good things are on the way.",
  },
};

/// Extending [GetText] for localization support
extension LocalizationExt on GetText {
  /// Return the text from [GetText] map based on current locale
  String call([List<dynamic> arguments]) {
    return this == null
        ? null
        : _getTextMap[Localization.current.locale][this]
            ?.applyIf(arguments?.isNotEmpty, (s) => sprintf(s, arguments));
  }
}
