// dio_helper.dart
// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../../shared/local/cach_helper.dart';

class DioHelper {
  static Dio? dio;

  // ====================== INIT ======================
  static Future<void> init() async {
    final passengerToken = await CacheHelper.getData(key: 'token');
    final captainToken = await CacheHelper.getData(key: 'Captientoken');
    final savedToken = captainToken ?? passengerToken;

    dio = Dio(
      BaseOptions(
        baseUrl: 'https://captain-drive.webbing-agency.com/api/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          if (savedToken != null && savedToken.isNotEmpty)
            'Authorization': 'Bearer $savedToken',
        },
      ),
    );

    print('✅ Dio initialized with token: $savedToken');
  }

  // ====================== GET DATA ======================
  static Future<Response?> getData({
    required String? url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    final passengerToken = await CacheHelper.getData(key: 'token');
    final captainToken = await CacheHelper.getData(key: 'Captientoken');
    final savedToken = token ?? captainToken ?? passengerToken;

    dio?.options.headers = {
      'Accept': 'application/json',
      if (savedToken != null && savedToken.isNotEmpty)
        'Authorization': 'Bearer $savedToken',
    };

    try {
      print('📥 GET -> $url');
      Response response = await dio!.get(url!, queryParameters: query);
      print('✅ Response: ${response.statusCode}');
      return response;
    } on DioException catch (e) {
      print('❌ DioError: ${e.response?.statusCode} - ${e.response?.data}');
      return e.response;
    } catch (e) {
      print('💥 Unknown Error: $e');
      return null;
    }
  }

  // ====================== POST DATA (JSON) ======================
  static Future<Response?> postData({
    required String? url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    final passengerToken = await CacheHelper.getData(key: 'token');
    final captainToken = await CacheHelper.getData(key: 'Captientoken');
    final savedToken = token ?? captainToken ?? passengerToken;

    dio?.options.headers = {
      'Accept': 'application/json',
      if (savedToken != null && savedToken.isNotEmpty)
        'Authorization': 'Bearer $savedToken',
    };

    try {
      print('📤 POST -> $url');
      print('🧾 Body: $data');

      Response response = await dio!.post(
        url!,
        queryParameters: query,
        data: data,
      );

      print('✅ Response ${response.statusCode}: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('❌ DioError: ${e.response?.statusCode} - ${e.response?.data}');
      return e.response;
    } catch (e) {
      print('💥 Unknown Error: $e');
      return null;
    }
  }

  // ====================== POST IMAGE DATA (Multipart) ======================
  static Future<Response?> postImageData({
    required String? url,
    Map<String, dynamic>? query,
    required FormData data,
    String? token,
  }) async {
    final passengerToken = await CacheHelper.getData(key: 'token');
    final captainToken = await CacheHelper.getData(key: 'Captientoken');
    final savedToken = token ?? captainToken ?? passengerToken;

    try {
      if (dio == null) throw Exception('Dio is not initialized');

      print('📤 Sending Multipart POST to: $url');
      print('🧾 Fields: ${data.fields}');
      print('📦 Files: ${data.files.map((e) => e.value.filename).toList()}');

      Response response = await dio!.post(
        url!,
        queryParameters: query,
        data: data,
        options: Options(
          headers: {
            'Accept': 'application/json',
            if (savedToken != null && savedToken.isNotEmpty)
              'Authorization': 'Bearer $savedToken',
          },
          contentType: 'multipart/form-data',
        ),
      );

      print('✅ Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('❌ Dio error: ${e.response?.statusCode} - ${e.response?.data}');
      return e.response;
    } catch (e, stack) {
      print('💥 Unknown error: $e');
      print(stack);
      return null;
    }
  }
}
