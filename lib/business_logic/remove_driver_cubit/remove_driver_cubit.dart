import 'dart:convert';

import 'package:captain_drive/data/models/remove_driver_model.dart';
import 'package:captain_drive/network/end_points.dart';
import 'package:captain_drive/network/remote/dio_helper.dart';
import 'package:captain_drive/shared/local/cach_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'remove_driver_state.dart';

class RemoveDriverCubit extends Cubit<RemoveDriverState> {
  RemoveDriverCubit() : super(RemoveDriverInitial());

  static RemoveDriverCubit get(context) => BlocProvider.of(context);

  RemoveDriverModel? removeDriverModel;

  void captainRemover() {
    emit(RemoveDriverLoading());

    DioHelper.postData(
      url: Delete_DRIVER,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        print('data Register : ${jsonEncode(value.data)}');
        removeDriverModel = RemoveDriverModel.fromJson(value.data);
        print('Parsed status: ${removeDriverModel?.status}');
        print('Parsed message: ${removeDriverModel?.message}');

        emit(RemoveDriverSuccess(removeDriverModel: removeDriverModel!));
      }
    }).catchError((error) {
      print(error.toString());
      emit(RemoveDriverFailure(message: error.toString()));
    });
  }
}
