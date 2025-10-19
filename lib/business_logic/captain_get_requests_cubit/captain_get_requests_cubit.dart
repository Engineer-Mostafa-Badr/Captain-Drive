import 'dart:async';

import 'package:captain_drive/data/models/captain_get_requests_model.dart';
import 'package:captain_drive/core/network/end_points.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_get_requests_state.dart';

class CaptainGetRequestsCubit extends Cubit<CaptainGetRequestsState> {
  CaptainGetRequestsCubit() : super(CaptainGetRequestsInitial()) {
    getCaptainRequests();
  }

  static CaptainGetRequestsCubit get(context) => BlocProvider.of(context);

  Future<void> getCaptainRequests() async {
    emit(CaptainGetRequestsLoading());

    try {
      final response = await DioHelper.getData(
        url: GET_CAPTAIN_REQUESTS,
        token: CacheHelper.getData(key: 'token'),
      );

      if (response != null) {
        final captainGetRequestModel =
            CaptainGetRequestModel.fromJson(response.data);
        emit(CaptainGetRequestsSuccess(
            captainGetRequestModel: captainGetRequestModel));
      }
    } catch (error) {
      emit(CaptainGetRequestsFailure(message: error.toString()));
    }
  }
}
