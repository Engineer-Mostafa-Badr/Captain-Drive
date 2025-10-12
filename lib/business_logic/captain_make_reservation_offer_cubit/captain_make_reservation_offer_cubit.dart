import 'dart:convert';
import 'dart:developer';

import 'package:captain_drive/data/models/captain_make_reservation_offer_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_make_reservation_offer_state.dart';

class CaptainMakeReservationOfferCubit
    extends Cubit<CaptainMakeReservationOfferState> {
  CaptainMakeReservationOfferCubit()
      : super(CaptainMakeReservationOfferInitial());
  static CaptainMakeReservationOfferCubit get(context) =>
      BlocProvider.of(context);

  CaptainMakeReservationOfferModel? captainMakeReservationOfferModel;

  void captainMakeReservationOffer({
    required num? price,
    required int? requestId,
  }) {
    emit(CaptainMakeReservationOfferLoading());
    DioHelper.postData(
            url: CAPTAIN_MAKE_RESERVATION_OFFER,
            data: {
              'price': price,
              'reservation_request_id': requestId,
            },
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      if (value != null) {
        log('data Register : ${jsonEncode(value.data)}');

        captainMakeReservationOfferModel =
            CaptainMakeReservationOfferModel.fromJson(value.data);
        log('Parsed status: ${captainMakeReservationOfferModel?.status}');
        log('Parsed message: ${captainMakeReservationOfferModel?.message}');

        emit(CaptainMakeReservationOfferSuccess(
            captainMakeReservationOfferModel:
                captainMakeReservationOfferModel!));
      } else {
        emit(CaptainMakeReservationOfferFailure(
            message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainMakeReservationOfferFailure(message: error.toString()));
    });
  }
}
