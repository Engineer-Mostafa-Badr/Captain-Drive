import 'dart:convert';

import 'package:captain_drive/data/models/arrive_reservation.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'arrive_reservation_state.dart';

class ArriveReservationCubit extends Cubit<ArriveReservationState> {
  ArriveReservationCubit() : super(ArriveReservationInitial());

  static ArriveReservationCubit get(context) => BlocProvider.of(context);

  ArriveReservation? arriveReservation;

  void captainSetArriveReservation({
    required int reservationID,
  }) {
    emit(ArriveReservationLoading());

    DioHelper.postData(
      url: ARRIVE,
      data: {
        'ride_id': reservationID,
      },
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        arriveReservation = ArriveReservation.fromJson(value.data);
        print('Parsed status: ${arriveReservation?.status}');
        print('Parsed message: ${arriveReservation?.message}');

        emit(ArriveReservationSuccess(arriveReservation: arriveReservation!));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ArriveReservationFailure(message: error.toString()));
    });
  }
}
