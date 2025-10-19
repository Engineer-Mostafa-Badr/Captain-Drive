import 'dart:convert';
import 'dart:developer';

import 'package:captain_drive/data/models/captain_cancel_reservation_offer_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_cancel_reservation_offer_state.dart';

class CaptainCancelReservationOfferCubit
    extends Cubit<CaptainCancelReservationOfferState> {
  CaptainCancelReservationOfferCubit()
      : super(CaptainCancelReservationOfferInitial());

  static CaptainCancelReservationOfferCubit get(context) =>
      BlocProvider.of(context);

  CaptainCancelReservationOfferModel? captainCancelReservationOfferModel;

  void captainCancelReservationOffer({
    required int offerId,
  }) {
    emit(CaptainCancelReservationOfferLoading());
    DioHelper.postData(
            url: CAPTAIN_Cancel_RESERVATION_OFFER,
            data: {
              'reservation_offer_id': offerId,
            },
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      if (value != null) {
        log('data Register : ${jsonEncode(value.data)}');

        captainCancelReservationOfferModel =
            CaptainCancelReservationOfferModel.fromJson(value.data);
        log('Parsed status: ${captainCancelReservationOfferModel?.status}');
        log('Parsed message: ${captainCancelReservationOfferModel?.message}');

        emit(CaptainCancelReservationOfferSuccess(
            captainCancelReservationOfferModel:
                captainCancelReservationOfferModel!));
      } else {
        emit(CaptainCancelReservationOfferFailure(
            message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainCancelReservationOfferFailure(message: error.toString()));
    });
  }
}
