import 'package:captain_drive/data/models/driver_status_model.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'driver_status_state.dart';

class DriverStatusCubit extends Cubit<DriverStatusState> {
  DriverStatusCubit() : super(DriverStatusInitial());
  static DriverStatusCubit get(context) => BlocProvider.of(context);

  DriverStatusModel? driverStatusModel;

  // Function to send driver status to backend
  void driverStatus({
    required String status,
  }) async {
    emit(DriverStatusLoading());
    DioHelper.postData(
            url: DriverStatus,
            data: {
              'status': status,
            },
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      if (value != null) {
        driverStatusModel = DriverStatusModel.fromJson(value.data);

        emit(DriverStatusSuccess(driverStatusModel: driverStatusModel!));
      } else {
        emit(DriverStatusFailure(message: 'Null response received'));
      }
    }).catchError((error) {
      emit(DriverStatusFailure(message: error.toString()));
    });
  }
}
