import 'dart:convert';
import 'dart:developer';

import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/captain_cancel_offer.dart';

part 'captain_cancel_offer_state.dart';

class CaptainCancelOfferCubit extends Cubit<CaptainCancelOfferState> {
  CaptainCancelOfferCubit() : super(CaptainCancelOfferInitial());

  static CaptainCancelOfferCubit get(context) => BlocProvider.of(context);

  CaptainCancelOfferModel? cancelOfferModel;

  void captainCancelOffer() {
    emit(CaptainCancelOfferLoading());
    DioHelper.postData(
      url: CAPTAIN_Cancel_OFFER,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        log('data Register : ${jsonEncode(value.data)}');

        cancelOfferModel = CaptainCancelOfferModel.fromJson(value.data);
        log('Parsed status: ${cancelOfferModel?.status}');
        log('Parsed message: ${cancelOfferModel?.message}');

        emit(CaptainCancelOfferSuccess(cancelOfferModel: cancelOfferModel!));
      } else {
        emit(CaptainCancelOfferFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(CaptainCancelOfferFailure(message: error.toString()));
    });
  }
}
