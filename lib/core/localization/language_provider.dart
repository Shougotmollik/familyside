import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_localizations.dart';
import '../router/app_router.dart';

part 'language_provider.g.dart';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  @override
  Locale build() {
    return AppLocalizations.fallbackLocale;
  }

  Future<void> loadSavedLanguage() async {
    final savedLocale = await LanguageStorage.getSavedLanguage();
    state = savedLocale;
  }

  Future<void> changeLanguage(Locale locale) async {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    state = locale;
    await LanguageStorage.saveLanguage(locale);
    AppRouter.localeNotifier.value++;
  }
}
