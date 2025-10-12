import 'dart:convert';

import 'package:captain_drive/data/models/sign_in_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'passenger_signin_state.dart';

class PassengerSigninCubit extends Cubit<PassengerSigninState> {
  PassengerSigninCubit() : super(PassengerSigninInitial());

  static PassengerSigninCubit get(context) => BlocProvider.of(context);

  LoginModel? passengerLoginModel;

  void userLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    emit(PassengerSigninLoading());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        // if(!value.data['status']){
        //   emit(ShopRegisterErrorState(value.data['message']));
        // }
        passengerLoginModel = LoginModel.fromJson(value.data);
        print('Parsed status: ${passengerLoginModel?.status}');
        print('Parsed token: ${passengerLoginModel?.data?.token}');
        print('Parsed message: ${passengerLoginModel?.message}');

        emit(PassengerSigninSuccess(passengerLoginModel!));
      } else {
        emit(PassengerSigninFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerSigninFailure(message: error.toString()));
    });
  }
}
