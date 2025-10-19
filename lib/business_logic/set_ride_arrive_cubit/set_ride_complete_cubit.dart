import 'dart:convert';

import 'package:captain_drive/data/models/set_ride_complete_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'set_ride_complete_state.dart';

class SetRideCompleteCubit extends Cubit<SetRideCompleteState> {
  SetRideCompleteCubit() : super(SetRideCompleteInitial());
  static SetRideCompleteCubit get(context) => BlocProvider.of(context);

  SetRideCompleteModel? setRideCompleteModel;

  void captainSetCompleteRide() {
    emit(SetRideCompleteLoading());

    DioHelper.postData(
      url: SETCompleteRIDE,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        setRideCompleteModel = SetRideCompleteModel.fromJson(value.data);
        print('Parsed status: ${setRideCompleteModel?.status}');
        print('Parsed message: ${setRideCompleteModel?.message}');

        emit(SetRideCompleteSuccess(
            setRideCompleteModel: setRideCompleteModel!));
      }
    }).catchError((error) {
      print(error.toString());
      emit(SetRideCompleteFailure(message: error.toString()));
    });
  }
}
