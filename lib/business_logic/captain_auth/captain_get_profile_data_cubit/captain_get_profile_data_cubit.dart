import 'dart:convert';

import 'package:captain_drive/data/models/captain_get_data_model/captain_get_data_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/network/dio_helper.dart';
import '../../../core/storage/cache_helper.dart';

part 'captain_get_profile_data_state.dart';

class CaptainGetProfileDataCubit extends Cubit<CaptainGetProfileDataState> {
  CaptainGetProfileDataCubit() : super(CaptainGetProfileDataInitial());
  static CaptainGetProfileDataCubit get(context) => BlocProvider.of(context);

  CaptainGetDataModel? captainGetDataModel;

  void getCaptainData() {
    emit(CaptainGetProfileDataLoading());

    DioHelper.getData(
      url: GET_CAPTAIN_DATA,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');

        captainGetDataModel = CaptainGetDataModel.fromJson(value.data);
        print('Parsed status: ${captainGetDataModel?.status}');
        print('Parsed message: ${captainGetDataModel?.message}');
        print('Parsed user name: ${captainGetDataModel?.data?.user?.name}');
        emit(
          CaptainGetProfileDataSuccess(
              captainGetDataModel: captainGetDataModel!),
        );
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainGetProfileDataFailure(message: error.toString()));
    });
  }
}
