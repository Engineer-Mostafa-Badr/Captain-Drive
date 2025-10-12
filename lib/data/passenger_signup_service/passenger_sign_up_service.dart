import 'dart:convert';
import 'dart:developer';

import 'package:captain_drive/data/models/register_model.dart';
import 'package:dio/dio.dart';

class PassengerSignUpService {
  final Dio dio;
  PassengerSignUpService(this.dio);

  RegisterModel? passengerRegisterModel;

  Future<Map<String, dynamic>> userSignUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      Response response = await dio.post(
        'https://captain-drive.webbing-agency.com/api/user/register',
        data: FormData.fromMap({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        log(json.encode(response.data));
        passengerRegisterModel = RegisterModel.fromJson(response.data);
        return response.data;
      } else if (response.statusCode == 200 &&
          response.data['status'] == false) {
        throw Exception('oops there was an error, please try again');
      } else {
        log(json.encode(response.statusMessage));
        throw Exception('oops there was an error, please try again');
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

  // _saveToken(String token) async {
  //   final pref = await SharedPreferences.getInstance();
  //   const key = "data";
  //   final value = token;
  //   pref.setString(key, value);
  // }
}
