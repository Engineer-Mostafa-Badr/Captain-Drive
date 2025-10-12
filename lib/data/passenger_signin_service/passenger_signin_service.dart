import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class PassengerSignInService {
  final Dio dio;
  PassengerSignInService(this.dio);

  Future<void> userSignIn({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await dio.post(
        'https://captain-drive.webbing-agency.com/api/user/login',
        data: FormData.fromMap({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        log(json.encode(response.data));
      } else if (response.statusCode == 200 &&
          response.data['status'] == false) {
        throw Exception('oops there was an error, please try again');
      } else {
        log(json.encode(response.statusMessage));
      }
    } on DioException catch (e) {
      final String errorMessage = e.response?.data['error']['message'] ??
          'oops there was an error, please try again';
      throw Exception(errorMessage);
    } catch (e) {
      log(e.toString());
      throw Exception('oops there was an error, please try again');
    }
  }
}
