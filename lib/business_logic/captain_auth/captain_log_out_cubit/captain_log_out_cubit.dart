import 'dart:convert';

import 'package:captain_drive/data/models/captain_log_out_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'captain_log_out_state.dart';

class CaptainLogOutCubit extends Cubit<CaptainLogOutState> {
  CaptainLogOutCubit() : super(CaptainLogOutInitial());

  static CaptainLogOutCubit get(context) => BlocProvider.of(context);

  CaptainLogOutModel? captainLogOutModel;

  void captainLogOut({
    required BuildContext context,
  }) {
    emit(CaptainLogOutLoading());

    DioHelper.postData(
      url: SIGNOUT,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        captainLogOutModel = CaptainLogOutModel.fromJson(value.data);
        print('Parsed status: ${captainLogOutModel?.status}');
        print('Parsed message: ${captainLogOutModel?.message}');

        emit(CaptainLogOutSuccess(captainLogOutModel: captainLogOutModel!));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainLogOutFailure(message: error.toString()));
    });
  }
}
