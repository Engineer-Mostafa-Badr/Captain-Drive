import 'dart:convert';
import 'package:captain_drive/data/models/register_facebook_model.dart';
import 'package:captain_drive/data/models/register_google_model.dart';
import 'package:captain_drive/data/models/register_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'passenger_signup_state.dart';

class PassengerSignUpCubit extends Cubit<PassengerSignUpState> {
  PassengerSignUpCubit() : super(PassengerSignUpInitial());

  static PassengerSignUpCubit get(context) => BlocProvider.of(context);

  RegisterModel? passengerRegisterModel;
  RegisterGoogleModel? passengerRegisterGoogleModel;
  RegisterFacebookModel? passengerRegisterFacebookModel;

  void userRegister({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String password,
    required String password_confirmation,
  }) {
    emit(PassengerSignUpLoading());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'joined_with': 1,
        'password': password,
        'password_confirmation': password_confirmation,
      },
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        // if(!value.data['status']){
        //   emit(ShopRegisterErrorState(value.data['message']));
        // }
        passengerRegisterModel = RegisterModel.fromJson(value.data);
        print('Parsed status: ${passengerRegisterModel?.status}');
        print('Parsed token: ${passengerRegisterModel?.data?.token}');
        print('Parsed message: ${passengerRegisterModel?.message}');
        print('Parsed user name: ${passengerRegisterModel?.data?.user?.name}');

        emit(PassengerSignUpSuccess(passengerRegisterModel!));
      } else {
        emit(PassengerSignUpFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerSignUpFailure(message: error.toString()));
    });
  }

  void userRegisterWithGoogle({
    required BuildContext context,
    required String? name,
    required String email,
  }) {
    emit(PassengerSignUpWithGoogleLoading());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'joined_with': 2,
      },
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        // if(!value.data['status']){
        //   emit(ShopRegisterErrorState(value.data['message']));
        // }
        passengerRegisterGoogleModel = RegisterGoogleModel.fromJson(value.data);
        print('Parsed status: ${passengerRegisterModel?.status}');
        print('Parsed token: ${passengerRegisterModel?.data?.token}');
        print('Parsed message: ${passengerRegisterModel?.message}');
        print('Parsed user name: ${passengerRegisterModel?.data?.user?.name}');

        emit(PassengerSignUpWithGoogleSuccess());
      } else {
        emit(PassengerSignUpWithGoogleFailure(
            message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerSignUpWithGoogleFailure(message: error.toString()));
    });
  }

  void userRegisterWithFacebook({
    required BuildContext context,
    required String name,
  }) {
    emit(PassengerSignUpWithFacebookLoading());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'joined_with': 3,
      },
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        // if(!value.data['status']){
        //   emit(ShopRegisterErrorState(value.data['message']));
        // }
        passengerRegisterFacebookModel =
            RegisterFacebookModel.fromJson(value.data);
        print('Parsed status: ${passengerRegisterModel?.status}');
        print('Parsed token: ${passengerRegisterModel?.data?.token}');
        print('Parsed message: ${passengerRegisterModel?.message}');
        print('Parsed user name: ${passengerRegisterModel?.data?.user?.name}');

        emit(PassengerSignUpWithFacebookSuccess());
      } else {
        emit(PassengerSignUpWithFacebookFailure(
            message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerSignUpWithFacebookFailure(message: error.toString()));
    });
  }
}
