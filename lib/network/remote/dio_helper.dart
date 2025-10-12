// dio_helper.dart
import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://captain-drive.webbing-agency.com/api/',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response?> getData(
      {required String? url,
      Map<String, dynamic>? query,
      Map<String, dynamic>? data,
      String? token}) async {
    dio?.options.headers = {'Authorization': 'Bearer $token'};
    return await dio?.get(url!, queryParameters: query, data: data);
  }

  static Future<Response?> postData({
    required String? url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    dio?.options.headers = {
      'Authorization': 'Bearer $token',
    };
    print(token);
    print('Sending data: $data');
    try {
      if (dio == null) {
        throw Exception('Dio is not initialized');
      }
      Response response = await dio!.post(
        url!,
        queryParameters: query,
        data: data,
      );
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response;
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Error: $e');
      }
      return null;
    }
  }

  static Future<Response?> postImageData({
    required String? url,
    Map<String, dynamic>? query,
    required FormData data,
    String? token,
  }) async {
    dio?.options.headers = {
      'Authorization': 'Bearer $token',
      "Content-Type": "multipart/form-data",
      "accept": "*/*",
    };
    print('Sending data: $data');
    try {
      if (dio == null) {
        throw Exception('Dio is not initialized');
      }
      Response response = await dio!.post(
        url!,
        queryParameters: query,
        data: data,
      );
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response;
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Error: $e');
      }
      return null;
    }
  }
}
