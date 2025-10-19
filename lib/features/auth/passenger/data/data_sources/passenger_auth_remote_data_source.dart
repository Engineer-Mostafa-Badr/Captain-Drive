// lib/features/auth/passenger/data/data_sources/passenger_auth_remote_data_source.dart
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/dio_helper.dart';
import '../../../../../core/network/end_points.dart';
import '../models/passenger_login_model.dart';
import '../models/passenger_register_model.dart';

abstract class PassengerAuthRemoteDataSource {
  Future<PassengerLoginModel> loginPassenger(String email, String password);
  Future<PassengerRegisterModel> signUpPassenger(Map<String, dynamic> data);
  Future<void> logoutPassenger();
  Future<void> deletePassengerAccount();
}

class PassengerAuthRemoteDataSourceImpl
    implements PassengerAuthRemoteDataSource {
  final DioHelper dioHelper;

  PassengerAuthRemoteDataSourceImpl({required this.dioHelper});

  @override
  Future<PassengerLoginModel> loginPassenger(
      String email, String password) async {
    final response = await DioHelper.postData(
        url: LOGIN, data: {'email': email, 'password': password});
    if (response?.data == null) throw ServerException('Null response');
    return PassengerLoginModel.fromJson(response!.data);
  }

  @override
  Future<PassengerRegisterModel> signUpPassenger(
      Map<String, dynamic> data) async {
    final response = await DioHelper.postData(url: LOGIN, data: data);
    if (response?.data == null) throw ServerException('Null response');
    return PassengerRegisterModel.fromJson(response!.data);
  }

  @override
  Future<void> logoutPassenger() async {
    await DioHelper.postData(url: LOGIN, data: {});
  }

  @override
  Future<void> deletePassengerAccount() async {
    await DioHelper.deleteData(url: LOGIN);
  }
}
