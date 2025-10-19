import 'dart:convert';

import 'package:captain_drive/data/models/captain_check_mail_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../../core/network/dio_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'captain_check_mail_state.dart';

class CaptainCheckMailCubit extends Cubit<CaptainCheckMailState> {
  CaptainCheckMailCubit() : super(CaptainCheckMailInitial());

  static CaptainCheckMailCubit get(context) => BlocProvider.of(context);

  CaptainCheckMailModel? captainCheckMailModel;

  void checkMail({
    required BuildContext context,
    required String email,
    required String otp,
  }) {
    emit(CaptainCheckMailLoading());
    DioHelper.postData(
      url: CHECK_MAIL,
      data: {
        'email': email,
        'code': otp,
      },
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        // if(!value.data['status']){
        //   emit(ShopRegisterErrorState(value.data['message']));
        // }
        captainCheckMailModel = CaptainCheckMailModel.fromJson(value.data);
        print('Parsed status: ${captainCheckMailModel?.status}');
        print('Parsed message: ${captainCheckMailModel?.message}');

        emit(CaptainCheckMailSuccess(
            captainCheckMailModel: captainCheckMailModel!));
      } else {
        emit(CaptainCheckMailFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainCheckMailFailure(message: error.toString()));
    });
  }
}
