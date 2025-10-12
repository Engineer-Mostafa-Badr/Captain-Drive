import 'dart:convert';
import 'dart:developer';

import 'package:captain_drive/data/models/captain_cancel_offer_ride_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_cancel_ride_offer_state.dart';

class CaptainCancelRideOfferCubit extends Cubit<CaptainCancelRideOfferState> {
  CaptainCancelRideOfferCubit() : super(CaptainCancelRideOfferInitial());
  static CaptainCancelRideOfferCubit get(context) => BlocProvider.of(context);

  CaptainCancelRideOfferModel? cancelRideOfferModel;

  void captainCancelRideOffer({
    required int offerId,
  }) {
    emit(CaptainCancelRideOfferLoading());
    DioHelper.postData(
      url: CAPTAIN_RIDE_Cancel_OFFER,
      data: {
        'offer_id': offerId,
      },
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        log('data Register : ${jsonEncode(value.data)}');

        cancelRideOfferModel = CaptainCancelRideOfferModel.fromJson(value.data);
        log('Parsed status: ${cancelRideOfferModel?.status}');
        log('Parsed message: ${cancelRideOfferModel?.message}');

        emit(CaptainCancelRideOfferSuccess(
            captainCancelRideOfferModel: cancelRideOfferModel!));
      } else {
        emit(CaptainCancelRideOfferFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainCancelRideOfferFailure(message: error.toString()));
    });
  }
}
