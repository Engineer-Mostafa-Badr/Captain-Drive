import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationCubit extends Cubit<Map<String, String>> {
  String currentLanguage = 'en';

  LocalizationCubit() : super({}) {
    _loadLanguagePreference();
  }

  static LocalizationCubit get(context) => BlocProvider.of(context);

  bool isArabic() => currentLanguage == 'ar';

  // Method to load language from JSON
  Future<void> loadLanguage(String languageCode) async {
    currentLanguage = languageCode;
    String jsonString;
    try {
      jsonString =
          await rootBundle.loadString('assets/lang/$languageCode.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Convert dynamic map to a map of string to string
      Map<String, String> localizedStrings =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));
      emit(localizedStrings);
      await _saveLanguagePreference(languageCode);
    } catch (e) {
      print("Error loading language file: $e");
      emit({});
    }
  }

  // Method to translate a key to the appropriate localized string
  String? translate(String key) {
    return state[key];
  }

  // Save the selected language in SharedPreferences
  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  // Load the language preference from SharedPreferences
  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      loadLanguage(languageCode);
    } else {
      loadLanguage('en'); // Default to English
    }
  }
}
