import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

/// Platform localization to add multi-language support
class Localization {
  static const english = const Locale('en', '');
  static const supportedLocales = [Localization.english];

  Localization(this.locale);

  final Locale locale;

  static Localization get current {
    return Localizations.of<Localization>(Get.context, Localization);
  }
}

/// Platform localization delegate to trigger language change in the device
class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  static const Iterable<LocalizationsDelegate> values = [
    const LocalizationDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      Localization.supportedLocales.contains(locale);

  @override
  Future<Localization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of Localization.
    return SynchronousFuture<Localization>(Localization(locale));
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
