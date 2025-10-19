import 'dart:convert';

import 'package:captain_drive/data/models/captain_set_driver_location_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'driver_set_current_location_state.dart';

class DriverSetCurrentLocationCubit
    extends Cubit<DriverSetCurrentLocationState> {
  DriverSetCurrentLocationCubit() : super(DriverSetCurrentLocationInitial());

  static DriverSetCurrentLocationCubit get(context) => BlocProvider.of(context);

  DriverSetCurrentLocationModel? setCurrentLocationModel;

  void setCurrentLocation({
    required String lng,
    required String lat,
  }) {
    emit(DriverSetCurrentLocationLoading());
    DioHelper.postData(
            url: SET_CURRENT_LOACTION,
            data: {
              'lng': lng,
              'lat': lat,
            },
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');

        setCurrentLocationModel =
            DriverSetCurrentLocationModel.fromJson(value.data);
        print('Parsed status: ${setCurrentLocationModel?.status}');
        print('Parsed message: ${setCurrentLocationModel?.message}');

        emit(DriverSetCurrentLocationSuccess(
            setCurrentLocationModel: setCurrentLocationModel!));
      } else {
        emit(
            DriverSetCurrentLocationFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(DriverSetCurrentLocationFailure(message: error.toString()));
    });
  }
}
