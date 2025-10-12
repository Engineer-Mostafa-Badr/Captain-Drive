import 'package:captain_drive/data/models/captain_get_message_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'captain_get_message_state.dart';

class CaptainGetMessageCubit extends Cubit<CaptainGetMessageState> {
  CaptainGetMessageCubit() : super(CaptainGetMessageInitial());

  static CaptainGetMessageCubit get(context) => BlocProvider.of(context);

  CaptainGetMessageModel? captainGetMessageModel;

  Future<void> getCaptainMessage() async {
    emit(CaptainGetMessageLoading());

    try {
      final response = await DioHelper.getData(
        url: GET_MEssage,
        token: CacheHelper.getData(key: 'token'),
      );

      if (response != null) {
        final captainGetMessageModel =
            CaptainGetMessageModel.fromJson(response.data);

        emit(CaptainGetMessageSuccess(
            captainGetMessageModel: captainGetMessageModel));
      }
    } catch (error) {
      emit(CaptainGetMessageFailure(message: error.toString()));
    }
  }
}
