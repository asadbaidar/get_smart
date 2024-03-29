import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

/// Platform localization to add multi-language support
/// * Usage
/// ```
///   [
///     GetLocalization.delegate,
///     GlobalMaterialLocalizations.delegate,
///     GlobalWidgetsLocalizations.delegate,
///   ];
/// ```
class GetLocalizations {
  static const english = "en";
  static final supportedLocales = [english.locale];

  static const GetLocalizationsDelegate delegate = GetLocalizationsDelegate();

  GetLocalizations(this.locale)
      : symbols =
            numberFormatSymbols[locale.code] ?? numberFormatSymbols[english],
        currencyFraction = currencyFractionDigits[
                (numberFormatSymbols[locale.code] ??
                        numberFormatSymbols[english])
                    .DEF_CURRENCY_CODE] ??
            2;

  final Locale locale;
  final NumberSymbols symbols;
  final int currencyFraction;

  static String? get currentLocale => current?.locale.code;

  static GetLocalizations? get current {
    return Get.context != null
        ? Localizations.of<GetLocalizations>(Get.context!, GetLocalizations)
        : null;
  }
}

/// Platform localization delegate to trigger language change in the device
class GetLocalizationsDelegate extends LocalizationsDelegate<GetLocalizations> {
  const GetLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      GetLocalizations.supportedLocales.contains(locale);

  @override
  Future<GetLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of Localization.
    return SynchronousFuture<GetLocalizations>(GetLocalizations(locale));
  }

  @override
  bool shouldReload(GetLocalizationsDelegate old) => false;
}

extension LocaleX on Locale {
  String get code =>
      toString().applyIf(countryCode?.notEmpty == null, (s) => languageCode);
}

extension ParseLocale on String {
  Locale get locale {
    final codes = split("_");
    final lang = codes.get(0);
    final country = codes.get(1);
    return lang?.isNotEmpty == true
        ? Locale(lang!, country)
        : const Locale("en");
  }
}
