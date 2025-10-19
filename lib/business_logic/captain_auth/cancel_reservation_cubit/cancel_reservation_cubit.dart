import 'dart:convert';
import 'dart:developer';

import 'package:captain_drive/data/models/cancel_reservation.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'cancel_reservation_state.dart';

class CancelReservationCubit extends Cubit<CancelReservationState> {
  CancelReservationCubit() : super(CancelReservationInitial());

  static CancelReservationCubit get(context) => BlocProvider.of(context);
  CancelReservation? cancelReservation;
  void captainCancelReservation({
    required int reservationID,
  }) {
    emit(CancelReservationLoading());
    DioHelper.postData(
            url: CANECEL,
            data: {
              'reservation_id': reservationID,
            },
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      if (value != null) {
        log('data Register : ${jsonEncode(value.data)}');

        cancelReservation = CancelReservation.fromJson(value.data);
        log('Parsed status: ${cancelReservation?.status}');
        log('Parsed message: ${cancelReservation?.message}');

        emit(CancelReservationSuccess(cancelReservation: cancelReservation!));
      } else {
        emit(CancelReservationFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CancelReservationFailure(message: error.toString()));
    });
  }
}
