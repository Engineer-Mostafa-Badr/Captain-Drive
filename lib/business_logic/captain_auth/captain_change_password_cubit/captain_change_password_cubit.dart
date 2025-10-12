import 'dart:convert';

import 'package:captain_drive/data/models/captain_change_password_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'captain_change_password_state.dart';

class CaptainChangePasswordCubit extends Cubit<CaptainChangePasswordState> {
  CaptainChangePasswordCubit() : super(CaptainChangePasswordInitial());

  static CaptainChangePasswordCubit get(context) => BlocProvider.of(context);
  CaptainChangePasswordModel? captainChangePasswordModel;

  void changePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    emit(CaptainChangePasswordLoading());
    DioHelper.postData(
      url: CHANGE_PASSWORD,
      data: {
        'old_password': oldPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        captainChangePasswordModel =
            CaptainChangePasswordModel.fromJson(value.data);
        print('Parsed status: ${captainChangePasswordModel?.status}');
        print('Parsed message: ${captainChangePasswordModel?.message}');
        emit(
          CaptainChangePasswordSuccess(
              captainChangePasswordModel: captainChangePasswordModel!),
        );
      } else {
        emit(CaptainChangePasswordFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainChangePasswordFailure(message: error.toString()));
    });
  }
}
