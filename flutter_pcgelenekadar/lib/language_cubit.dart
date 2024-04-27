
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(Locale('tr','TR'));

  Locale _locale = Locale('tr','TR');
  Locale get locale => _locale;

  Future changeLanguage(String languageCode) async{
    print(languageCode);
    switch (languageCode) {
      case 'tr': _locale=Locale('tr','TR');
        break;
      case 'en': _locale=Locale('en','US');
      break;
      default:
       _locale=Locale('en','US');
    }
}
}