// ignore_for_file: constant_identifier_names

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
  please_wait,
  invalid,
  value,
  location_denied_permanently,
  location_denied,
  location_disabled,
  location_mocked,
  location_error,
  switch_user,
}

/// Get text data
const Map<String, Map<GetText, String>> _getTextMap = {
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
    GetText.please_wait: "Please wait...",
    GetText.invalid: "Invalid %s.",
    GetText.value: "Value",
    GetText.location_denied_permanently:
        "Location permission denied permanently. Please turn it on from the app settings.",
    GetText.location_denied: "Location permission denied.",
    GetText.location_disabled: "Location services are disabled.",
    GetText.location_mocked:
        "Mock location detected. Please turn it off to continue.",
    GetText.location_error: "Unable to get location.",
    GetText.switch_user: "Switch User",
  },
};

/// Extending GetText for localization support
extension GetTextX on GetText {
  /// Return the text from [GetText] map based on current locale
  String call([List<dynamic>? arguments]) => $localized(_getTextMap, arguments);
}
