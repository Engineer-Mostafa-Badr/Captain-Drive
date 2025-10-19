import 'dart:async';

import 'package:captain_drive/data/models/captain_get_offer_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_get_offer_state.dart';

class CaptainGetOfferCubit extends Cubit<CaptainGetOfferState> {
  CaptainGetOfferCubit() : super(CaptainGetOfferInitial()) {
    getCaptainRideOffer();
  }

  static CaptainGetOfferCubit get(context) => BlocProvider.of(context);

  Future<void> getCaptainRideOffer() async {
    emit(CaptainGetOfferLoading());

    try {
      final response = await DioHelper.getData(
        url: GET_RIDE_OFFER,
        token: CacheHelper.getData(key: 'token'),
      );

      if (response != null) {
        final captainGetOfferModel =
            CaptainGetOfferModel.fromJson(response.data);

        emit(
            CaptainGetOfferSuccess(captainGetOfferModel: captainGetOfferModel));
      }
    } catch (error) {
      emit(CaptainGetOfferFailure(message: error.toString()));
    }
  }
}
