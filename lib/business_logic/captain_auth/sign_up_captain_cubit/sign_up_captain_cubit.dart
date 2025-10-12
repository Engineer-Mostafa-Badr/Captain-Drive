import 'dart:convert';
import 'dart:io';
import 'package:captain_drive/data/models/capatain_sign_up_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_captain_state.dart';

class SignUpCaptainCubit extends Cubit<SignUpCaptainState> {
  SignUpCaptainCubit() : super(SignUpCaptainInitial());

  static SignUpCaptainCubit get(context) => BlocProvider.of(context);

  CaptainSignUpModel? signUpCaptainModel;

  void driverSignUp({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String addPhone,
    required String status,
    required String nationalId,
    required String gender,
    required String password,
    required String confirmPassword,
    required File picture,
    required File nationalFront,
    required File nationalBack,
    required File driverLFront,
    required File driverLBack,
    required File vehicleFront,
    required File vehicleBack,
    required File criminalRecord,
    required String type,
    required String model,
    required String color,
    required String platesNumber,
  }) async {
    emit(SignUpCaptainLoading());

    try {
      Map<String, dynamic> formDataMap = {
        'name': name,
        'email': email,
        'phone': phone,
        'add_phone': addPhone,
        'social_status': status,
        'national_id': nationalId,
        'gender': gender,
        'password': password,
        'password_confirmation': confirmPassword,
        'type': type,
        'model': model,
        'color': color,
        'plates_number': platesNumber,
      };

      // Attach files to the formDataMap
      formDataMap['picture'] = await MultipartFile.fromFile(
        picture.path,
        filename: picture.path.split('/').last,
      );
      formDataMap['national_front'] = await MultipartFile.fromFile(
        nationalFront.path,
        filename: nationalFront.path.split('/').last,
      );
      formDataMap['national_back'] = await MultipartFile.fromFile(
        nationalBack.path,
        filename: nationalBack.path.split('/').last,
      );
      formDataMap['driverl_front'] = await MultipartFile.fromFile(
        driverLFront.path,
        filename: driverLFront.path.split('/').last,
      );
      formDataMap['driverl_back'] = await MultipartFile.fromFile(
        driverLBack.path,
        filename: driverLBack.path.split('/').last,
      );
      formDataMap['vehicle_front'] = await MultipartFile.fromFile(
        vehicleFront.path,
        filename: vehicleFront.path.split('/').last,
      );
      formDataMap['vehicle_back'] = await MultipartFile.fromFile(
        vehicleBack.path,
        filename: vehicleBack.path.split('/').last,
      );
      formDataMap['criminal_record'] = await MultipartFile.fromFile(
        criminalRecord.path,
        filename: criminalRecord.path.split('/').last,
      );

      // Create FormData object from map
      FormData formData = FormData.fromMap(formDataMap);

      // Make API call using DioHelper
      var response = await DioHelper.postImageData(
        url: SIGNUP,
        data: formData,
      );

      if (response != null && response.data != null) {
        print('Data Register: ${jsonEncode(response.data)}');

        signUpCaptainModel = CaptainSignUpModel.fromJson(response.data);

        print('Parsed status: ${signUpCaptainModel?.status}');
        print('Parsed token: ${signUpCaptainModel?.data?.token}');
        print('Parsed message: ${signUpCaptainModel?.message}');
        print('Parsed user name: ${signUpCaptainModel?.data?.user?.name}');

        emit(SignUpCaptainSuccess(signUpCaptainModel: signUpCaptainModel!));
      } else {
        emit(SignUpCaptainFailure(message: 'Null response received'));
      }
    } catch (error) {
      print(error.toString());
      emit(SignUpCaptainFailure(message: error.toString()));
    }
  }
}
