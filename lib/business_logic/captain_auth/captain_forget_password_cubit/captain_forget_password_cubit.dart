// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:captain_drive/data/models/captain_forget_password_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'captain_forget_password_state.dart';

class CaptainForgetPasswordCubit extends Cubit<CaptainForgetPasswordState> {
  CaptainForgetPasswordCubit() : super(CaptainForgetPasswordInitial());

  static CaptainForgetPasswordCubit get(context) => BlocProvider.of(context);

  CaptainForgetPasswordModel? captainForgetPasswordModel;

  void userForgetPassword({
    required BuildContext context,
    required String email,
  }) {
    emit(CaptainForgetPasswordLoading());

    DioHelper.getData(
      url: FORGET_PASSWORD,
      data: {
        'email': email,
      },
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        captainForgetPasswordModel =
            CaptainForgetPasswordModel.fromJson(value.data);
        print('Parsed status: ${captainForgetPasswordModel?.status}');
        print('Parsed message: ${captainForgetPasswordModel?.message}');
        emit(
          CaptainForgetPasswordSuccess(
              captainForgetPasswordModel: captainForgetPasswordModel!),
        );
      } else {
        emit(CaptainForgetPasswordFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainForgetPasswordFailure(message: error.toString()));
    });
  }
}
