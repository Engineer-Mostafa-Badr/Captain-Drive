import 'dart:convert';

import 'package:captain_drive/data/models/get_captain_activities/get_captain_activities.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_activities_state.dart';

class CaptainActivitiesCubit extends Cubit<CaptainActivitiesState> {
  CaptainActivitiesCubit() : super(CaptainActivitiesInitial());

  static CaptainActivitiesCubit get(context) => BlocProvider.of(context);
  GetCaptainActivitiesModel? getCaptainActivitiesModel;

  void getCaptainData() {
    emit(CaptainActivitiesLoading());

    DioHelper.getData(
      url: GET_CAPTAIN_ACTIVITIES,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');

        getCaptainActivitiesModel =
            GetCaptainActivitiesModel.fromJson(value.data);
        print('Parsed status: ${getCaptainActivitiesModel?.status}');
        print('Parsed message: ${getCaptainActivitiesModel?.message}');
        emit(
          CaptainActivitiesSuccess(
              getCaptainActivitiesModel: getCaptainActivitiesModel!),
        );
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainActivitiesFailure(message: error.toString()));
    });
  }
}
