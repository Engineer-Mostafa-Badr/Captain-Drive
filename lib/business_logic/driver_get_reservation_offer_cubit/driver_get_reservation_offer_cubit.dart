import 'dart:convert';

import 'package:captain_drive/data/models/driver_get_offer_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'driver_get_reservation_offer_state.dart';

class DriverGetReservationOfferCubit
    extends Cubit<DriverGetReservationOfferState> {
  DriverGetReservationOfferCubit() : super(DriverGetReservationOfferInitial());

  static DriverGetReservationOfferCubit get(context) =>
      BlocProvider.of(context);
  DriverGetOfferModel? driverGetReservationModel;

  Future<void> getCaptainOffer() async {
    emit(DriverGetReservationOfferLoading());

    try {
      var value = await DioHelper.getData(
        url: GET_RESERVATION_OFFER,
        token: CacheHelper.getData(key: 'token'),
      );

      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        driverGetReservationModel = DriverGetOfferModel.fromJson(value.data);
        print('Parsed status: ${driverGetReservationModel?.status}');
        print('Parsed message: ${driverGetReservationModel?.message}');
        emit(DriverGetReservationOfferSuccess(
            driverGetReservationModel: driverGetReservationModel!));
      }
    } catch (error) {
      print(error.toString());
      emit(DriverGetReservationOfferFailure(message: error.toString()));
    }
  }
}
