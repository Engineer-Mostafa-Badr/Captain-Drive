import 'dart:convert';

import 'package:captain_drive/data/models/set_arrive_ride_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'set_arrive_ride_state.dart';

class SetArriveRideCubit extends Cubit<SetArriveRideState> {
  SetArriveRideCubit() : super(SetArriveRideInitial());

  static SetArriveRideCubit get(context) => BlocProvider.of(context);
  SetArriveRideModel? setArriveRideModel;

  void captainSetArriveRide() {
    emit(SetArriveRideLoading());

    DioHelper.postData(
      url: SETARRIVERIDE,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        setArriveRideModel = SetArriveRideModel.fromJson(value.data);
        print('Parsed status: ${setArriveRideModel?.status}');
        print('Parsed message: ${setArriveRideModel?.message}');

        emit(SetArriveRideSuccess(setArriveRideModel: setArriveRideModel!));
      }
    }).catchError((error) {
      print(error.toString());
      emit(SetArriveRideFailure(message: error.toString()));
    });
  }
}
