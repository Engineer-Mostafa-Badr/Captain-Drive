import 'package:captain_drive/data/models/captain_get_ride_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_get_active_ride_state.dart';

class CaptainGetActiveRideCubit extends Cubit<CaptainGetActiveRideState> {
  CaptainGetActiveRideCubit() : super(CaptainGetActiveRideInitial());
  static CaptainGetActiveRideCubit get(context) => BlocProvider.of(context);
  CaptainGetRideModel? captainGetRideModel;

  Future<void> getCaptainActiveRides() async {
    emit(CaptainGetActiveRideLoading());

    try {
      final response = await DioHelper.getData(
        url: GET_ACTIVE_RIDE,
        token: CacheHelper.getData(key: 'token'),
      );

      if (response != null) {
        final captainGetRideModel = CaptainGetRideModel.fromJson(response.data);
        // Immediately broadcast data
        emit(CaptainGetActiveRideSuccess(
            captainGetRideModel: captainGetRideModel));
      }
    } catch (error) {
      emit(CaptainGetActiveRideFailure(message: error.toString()));
    }
  }
}
