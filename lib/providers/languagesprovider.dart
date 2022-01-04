import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeProvider with ChangeNotifier {
  static Locale? currentLocale;
  Locale? get current {
    return currentLocale;
  }

  Future<void> getLanguage() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final string = sharedPreferences.getString('languageKey')??'en';

     currentLocale = Locale(string);
  }

  Future<void> changeLocale(String _locale) async {
    currentLocale = Locale(_locale);
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'languageKey', currentLocale!.languageCode);
    notifyListeners();
  }

  void toggleLanguage() {
    if (currentLocale!.languageCode == 'en')
      changeLocale('ar');
    else
      changeLocale('en');
  }
}
