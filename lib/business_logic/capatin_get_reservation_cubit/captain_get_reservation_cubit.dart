import 'dart:convert';

import 'package:captain_drive/data/models/captain_get_reservation_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../core/network/dio_helper.dart';
import '../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_get_reservation_state.dart';

class CaptainGetReservationCubit extends Cubit<CaptainGetReservationState> {
  CaptainGetReservationCubit() : super(CaptainGetReservationInitial());

  static CaptainGetReservationCubit get(context) => BlocProvider.of(context);

  CaptainGetReservationModel? captainGetReservationModel;

  Future<void> getCaptainReservation() async {
    emit(CaptainGetReservationLoading());

    try {
      var value = await DioHelper.getData(
        url: CAPTAIN_GET_RESERVATION,
        token: CacheHelper.getData(key: 'token'),
      );

      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        captainGetReservationModel =
            CaptainGetReservationModel.fromJson(value.data);
        print('Parsed status: ${captainGetReservationModel?.status}');
        print('Parsed message: ${captainGetReservationModel?.message}');
        emit(CaptainGetReservationSuccess(
            captainGetReservationModel: captainGetReservationModel!));
      }
    } catch (error) {
      print(error.toString());
      emit(CaptainGetReservationFailure(message: error.toString()));
    }
  }
}
