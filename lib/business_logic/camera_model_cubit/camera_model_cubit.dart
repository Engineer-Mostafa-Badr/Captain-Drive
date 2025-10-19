import 'dart:developer';
import 'dart:io';

import 'package:captain_drive/data/models/camera_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../core/network/dio_helper.dart';
import '../../core/storage/cache_helper.dart';
import '../../core/network/end_points.dart';

part 'camera_model_state.dart';

class CameraModelCubit extends Cubit<CameraModelState> {
  CameraModelCubit() : super(CameraModelInitial());
  static CameraModelCubit get(context) => BlocProvider.of(context);

  CameraModel? cameraModel;

  void uploadVideo({
    required int rideId,
    required File? video,
  }) async {
    emit(CameraModelLoading());

    Map<String, dynamic> formDataMap = {
      'ride_id': rideId,
    };

    formDataMap['video'] = await MultipartFile.fromFile(
      video!.path,
      filename: video.path.split('/').last,
    );

    FormData formData = FormData.fromMap(formDataMap);
    DioHelper.postImageData(
      url: VIEDO,
      data: formData,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      if (value != null) {
        cameraModel = CameraModel.fromJson(value.data);
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        log('Parsed status: ${cameraModel?.status}');
        log('Parsed message: ${cameraModel?.message}');
        emit(CameraModelSuccess(cameraModel: cameraModel!));
      } else {
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        log('error.toString()');
        emit(
          CameraModelFailure(message: 'Null response received'),
        );
      }
    }).catchError((error) {
      log(error.toString());
      log(error.toString());
      log(error.toString());
      log(error.toString());
      log(error.toString());
      log(error.toString());
      log(error.toString());
      emit(CameraModelFailure(message: error.toString()));
    });
  }
}
