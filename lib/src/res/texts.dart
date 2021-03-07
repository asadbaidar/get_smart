import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

/// Get text keys
enum GetText {
  done,
  cancel,
  ok,
  continue_,
  reset,
  delete,
  retry,
  refresh,
  succeeded,
  failed,
  failed_server,
  busy,
  please_enter,
  invalid,
}

/// Get text data
Map<Locale, Map<GetText, String>> _getTextMap = {
  GetLocalizations.english: {
    GetText.done: "Done",
    GetText.cancel: "Cancel",
    GetText.ok: "OK",
    GetText.continue_: "Continue",
    GetText.reset: "Reset",
    GetText.delete: "Delete",
    GetText.retry: "Retry",
    GetText.refresh: "Refresh",
    GetText.succeeded: "Great. It's all done.",
    GetText.failed: "Something went wrong. Please try again.",
    GetText.failed_server:
        "Sorry, Something went wrong on our end. Please try later.",
    GetText.busy: "Please wait. Good things are on the way.",
    GetText.please_enter: "Please enter the %s.",
    GetText.invalid: "Invalid %s.",
  },
};

/// Extending GetText for localization support
extension GetTextX on GetText {
  /// Return the text from [GetText] map based on current locale
  String call([List<dynamic> arguments]) => localized(_getTextMap, arguments);
}
