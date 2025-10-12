import 'dart:convert';

import 'package:captain_drive/data/models/captain_login_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_captain_state.dart';

class SignInCaptainCubit extends Cubit<SignInCaptainState> {
  SignInCaptainCubit() : super(SignInCaptainInitial());

  static SignInCaptainCubit get(context) => BlocProvider.of(context);
  CaptainLoginModel? captainLoginModel;

  void signInCaptain({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    emit(SignInCaptainLoading());
    DioHelper.postData(
      url: SIGNIN,
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
        captainLoginModel = CaptainLoginModel.fromJson(value.data);
        print('Parsed status: ${captainLoginModel?.status}');
        print('Parsed token: ${captainLoginModel?.data?.token}');
        print('Parsed message: ${captainLoginModel?.message}');

        emit(SignInCaptainSuccess(captainLoginModel: captainLoginModel!));
      } else {
        emit(SignInCaptainFailure('Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(SignInCaptainFailure(error.toString()));
    });
  }
}
