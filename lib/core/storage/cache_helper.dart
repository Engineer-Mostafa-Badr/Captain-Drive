import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  /// تهيئة SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// حفظ بيانات
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _prefs!.setString(key, value);
    if (value is int) return await _prefs!.setInt(key, value);
    if (value is bool) return await _prefs!.setBool(key, value);
    if (value is double) return await _prefs!.setDouble(key, value);
    return false;
  }

  /// قراءة بيانات
  static dynamic getData({required String key}) {
    return _prefs!.get(key);
  }

  /// حذف مفتاح معين
  static Future<bool> removeData({required String key}) async {
    return await _prefs!.remove(key);
  }

  /// مسح كل البيانات (مثلاً عند تسجيل الخروج)
  static Future<bool> clearAll() async {
    return await _prefs!.clear();
  }
}
