import 'dart:convert';
import 'dart:developer';

import 'package:captain_drive/data/models/captain_make_offer_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_make_offer_state.dart';

class CaptainMakeOfferCubit extends Cubit<CaptainMakeOfferState> {
  CaptainMakeOfferCubit() : super(CaptainMakeOfferInitial());

  static CaptainMakeOfferCubit get(context) => BlocProvider.of(context);

  CaptainMakeOfferModel? captainMakeOfferModel;

  void captainMakeOffer({
    required num? price,
    required int requestId,
  }) {
    emit(CaptainMakeOfferLoading());
    DioHelper.postData(
            url: CAPTAIN_MAKE_OFFER,
            data: {
              'price': price,
              'ride_request_id': requestId,
            },
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      if (value != null) {
        log('data Register : ${jsonEncode(value.data)}');

        captainMakeOfferModel = CaptainMakeOfferModel.fromJson(value.data);
        log('Parsed status: ${captainMakeOfferModel?.status}');
        log('Parsed message: ${captainMakeOfferModel?.message}');

        emit(CaptainMakeOfferSuccess(
            captainMakeOfferModel: captainMakeOfferModel!));
      } else {
        emit(CaptainMakeOfferFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainMakeOfferFailure(message: error.toString()));
    });
  }
}
