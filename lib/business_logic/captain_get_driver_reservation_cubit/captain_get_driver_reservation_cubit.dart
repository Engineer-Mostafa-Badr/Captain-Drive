import 'dart:convert';

import 'package:captain_drive/data/models/captain_get_driver_reservation_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_get_driver_reservation_state.dart';

class CaptainGetDriverReservationCubit
    extends Cubit<CaptainGetDriverReservationState> {
  CaptainGetDriverReservationCubit()
      : super(CaptainGetDriverReservationInitial());

  static CaptainGetDriverReservationCubit get(context) =>
      BlocProvider.of(context);

  CaptainGetDriverReservationModel? captainGetDriverReservation;

  Future<void> getCaptainDriverReservation() async {
    emit(CaptainGetDriverReservationLoading());

    try {
      var value = await DioHelper.getData(
        url: CAPTAIN_GET_DRIVER_RESERVATION,
        token: CacheHelper.getData(key: 'token'),
      );

      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        captainGetDriverReservation =
            CaptainGetDriverReservationModel.fromJson(value.data);
        print('Parsed status: ${captainGetDriverReservation?.status}');
        print('Parsed message: ${captainGetDriverReservation?.message}');
        emit(CaptainGetDriverReservationSuccess(
            captainGetDriverReservation: captainGetDriverReservation!));
      }
    } catch (error) {
      print(error.toString());
      emit(CaptainGetDriverReservationFailure(message: error.toString()));
    }
  }
}
