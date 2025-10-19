import 'dart:convert';

import 'package:captain_drive/data/models/captain_create_new_password_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/dio_helper.dart';

part 'captain_create_new_password_state.dart';

class CaptainCreateNewPasswordCubit
    extends Cubit<CaptainCreateNewPasswordState> {
  CaptainCreateNewPasswordCubit() : super(CaptainCreateNewPasswordInitial());

  static CaptainCreateNewPasswordCubit get(context) => BlocProvider.of(context);
  CaptainCreateNewPasswordModel? captainCreateNewPasswordModel;

  void createNewPassword({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(CaptainCreateNewPasswordLoading());

    DioHelper.postData(
      url: CREATE_NEW_PASSWORD,
      data: {
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      },
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        captainCreateNewPasswordModel =
            CaptainCreateNewPasswordModel.fromJson(value.data);
        print('Parsed status: ${captainCreateNewPasswordModel?.status}');
        print('Parsed message: ${captainCreateNewPasswordModel?.message}');
        emit(
          CaptainCreateNewPasswordSuccess(
              captainCreateNewPasswordModel: captainCreateNewPasswordModel!),
        );
      } else {
        emit(
            CaptainCreateNewPasswordFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainCreateNewPasswordFailure(message: error.toString()));
    });
  }
}
