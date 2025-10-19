import '../../domain/params/driver_sign_up_params.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../../../core/network/end_points.dart';
import '../models/driver_sign_up_model.dart';
import '../models/driver_login_model.dart';
import 'package:dio/dio.dart';
import 'dart:io';

abstract class DriverAuthRemoteDataSource {
  Future<DriverLoginModel> loginDriver(String email, String password);
  Future<DriverSignUpModel> signUpDriver(DriverSignUpParams params);
  Future<void> logoutDriver();
  Future<void> deleteDriverAccount();
}

class DriverAuthRemoteDataSourceImpl implements DriverAuthRemoteDataSource {
  final DioHelper dioHelper;

  DriverAuthRemoteDataSourceImpl({required this.dioHelper});

  @override
  Future<DriverLoginModel> loginDriver(String email, String password) async {
    try {
      final response = await DioHelper.postData(
        url: SIGNIN,
        data: {'email': email, 'password': password},
      );

      if (response != null && response.data != null) {
        return DriverLoginModel.fromJson(response.data);
      } else {
        throw ServerException('Null response');
      }
    } on DioException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<DriverSignUpModel> signUpDriver(DriverSignUpParams params) async {
    try {
      final formDataMap = {
        'name': params.name,
        'email': params.email,
        'phone': params.phone,
        'add_phone': params.addPhone,
        'social_status': params.status,
        'national_id': params.nationalId,
        'gender': params.gender,
        'password': params.password,
        'password_confirmation': params.confirmPassword,
        'type': params.type,
        'model': params.model,
        'color': params.color,
        'plates_number': params.platesNumber,
      };

      // 🧩 Add all image files
      Future<void> addFile(String key, File file) async {
        formDataMap[key] = (await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        )) as String;
      }

      await addFile('picture', params.picture);
      await addFile('national_front', params.nationalFront);
      await addFile('national_back', params.nationalBack);
      await addFile('driverl_front', params.driverLFront);
      await addFile('driverl_back', params.driverLBack);
      await addFile('vehicle_front', params.vehicleFront);
      await addFile('vehicle_back', params.vehicleBack);
      await addFile('criminal_record', params.criminalRecord);

      final formData = FormData.fromMap(formDataMap);

      final response = await DioHelper.postImageData(
        url: SIGNUP,
        data: formData,
      );

      if (response != null && response.data != null) {
        return DriverSignUpModel.fromJson(response.data);
      } else {
        throw ServerException('Null response');
      }
    } on DioException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> logoutDriver() async {
    try {
      await DioHelper.postData(url: LOGOUT, data: {});
    } on DioException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> deleteDriverAccount() async {
    try {
      await DioHelper.deleteData(url: DELETE_ACCOUNT);
    } on DioException catch (e) {
      throw ServerException(e.message);
    }
  }
}
