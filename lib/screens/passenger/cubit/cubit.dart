import 'dart:convert';
import 'dart:io';

import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/data/models/get_numbers_admin_model.dart';
import 'package:captain_drive/screens/passenger/cubit/states.dart';
import 'package:captain_drive/screens/passenger/model/get_active_ride_model.dart';
import 'package:captain_drive/screens/passenger/model/get_activites_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';

import '../../../network/end_points.dart';
import '../../../network/remote/dio_helper.dart';
import '../model/cahange_password_model.dart';
import '../model/get_all_offers_model.dart';
import '../model/get_price_model.dart';
import '../model/get_request_model.dart';
import '../model/get_reservatin_model.dart';
import '../model/get_user_model.dart';
import '../model/reservation_request_model.dart';
import '../model/ride_request_model.dart';
import '../model/set_to_destination_model.dart';
import '../model/update_model.dart';

class passengerCubit extends Cubit<PassengerStates> {
  passengerCubit() : super(PassengerInitialState());

  static passengerCubit get(context) => BlocProvider.of(context);

  ChangePasswordModel? forgetPassword;

  void askForgetPassword({
    required String email,
  }) {
    emit(LoadingForgetPasswordState());
    DioHelper.getData(
      url: FORGETPASSWORD,
      data: {'email': email},
    ).then((value) {
      if (value != null) {
        print('data Ask forget : ${jsonEncode(value.data)}');
        forgetPassword = ChangePasswordModel.fromJson(value.data);
        print('Parsed status: ${forgetPassword?.status}');
        print('Parsed message: ${forgetPassword?.message}');
        emit(SuccessForgetPasswordState(forgetPassword!));
      } else {
        emit(ErrorForgetPasswordState('Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorForgetPasswordState(error.toString()));
    });
  }

  ChangePasswordModel? createNewPassword;

  void newPassword({
    required String email,
    required String password,
    required String password_confirmation,
  }) {
    emit(LoadingForgetPasswordState());
    DioHelper.postData(
      url: CREATENEWPASSWORD,
      data: {
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
      },
    ).then((value) {
      if (value != null) {
        print('data create password forget : ${jsonEncode(value.data)}');
        createNewPassword = ChangePasswordModel.fromJson(value.data);
        print('Parsed status: ${createNewPassword?.status}');
        print('Parsed message: ${createNewPassword?.message}');
        emit(SuccessForgetPasswordState(createNewPassword!));
      } else {
        emit(ErrorForgetPasswordState('Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorForgetPasswordState(error.toString()));
    });
  }

  ChangePasswordModel? checkCodeModel;

  void checkCode({required String email, required String code}) {
    emit(LoadingCheckCodeState());
    DioHelper.postData(
      url: CHECKPASSWORD,
      data: {'email': email, 'code': code},
    ).then((value) {
      if (value != null) {
        print('data Ask forget : ${jsonEncode(value.data)}');
        checkCodeModel = ChangePasswordModel.fromJson(value.data);
        print('Parsed status: ${checkCodeModel?.status}');
        print('Parsed message: ${checkCodeModel?.message}');
        emit(SuccessCheckCodeState(checkCodeModel!));
      } else {
        emit(ErrorCheckCodeState('Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCheckCodeState(error.toString()));
    });
  }

  ChangePasswordModel? changePasswordModel;

  void changePassword(
      {required String old_password,
      required String password,
      required String password_confirmation}) {
    emit(LoadingChangePasswordState());
    DioHelper.postData(
            url: CHANGEPASSWORD,
            data: {
              'old_password': old_password,
              'password': password,
              'password_confirmation': password_confirmation,
            },
            token: userToken)
        .then((value) {
      if (value != null) {
        print('data changepassword : ${jsonEncode(value.data)}');
        changePasswordModel = ChangePasswordModel.fromJson(value.data);
        print('Parsed status: ${changePasswordModel?.status}');
        print('Parsed message: ${changePasswordModel?.message}');
        emit(SuccessChangePasswordState(changePasswordModel!));
      } else {
        emit(ErrorChangePasswordState('Null response received'));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorChangePasswordState(error.toString()));
    });
  }

  UpdateModel? updateModel;

  Future<void> updateProfile(
    File? image, {
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      emit(LoadingUpdateState());

      // Create a map to hold the form data
      Map<String, dynamic> formDataMap = {
        "name": name,
        "email": email,
        'phone': phone,
      };

      // If image is not null, add it to the form data
      if (image != null) {
        String filename = image.path.split('/').last;
        formDataMap["picture"] = await MultipartFile.fromFile(
          image.path,
          filename: filename,
          contentType: MediaType('image', 'png'),
        );
      }

      FormData formData = FormData.fromMap(formDataMap);

      DioHelper.postImageData(
        url: UPDATE,
        data: formData,
        token: userToken,
      ).then((value) {
        if (value != null) {
          print('data updateeeeeeeee : ${jsonEncode(value.data)}');
          updateModel = UpdateModel.fromJson(value.data);
          print('Parsed status: ${updateModel?.status}');
          print('Parsed message: ${updateModel?.message}');
          emit(SuccessUpdateState(updateModel!));
          getUserData();
        } else {
          emit(ErrorUpdateState('Null response received'));
        }
      }).catchError((error) {
        print(error.toString());
        emit(ErrorUpdateState(error.toString()));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  GetUserModel? userModel;

  void getUserData() {
    emit(GetUserLoadingState());
    DioHelper.getData(url: GETUSER, token: userToken, query: null)
        .then((value) {
      if (value != null) {
        // print('data get user : ${jsonEncode(value.data)}');
        userModel = GetUserModel.fromJson(value.data);
        // print('Parsed status: ${userModel?.status}');
        // print('Parsed token: ${userModel?.data?.token}');
        // print('Parsed message: ${userModel?.message}');
        // print('Parsed user name: ${userModel?.data?.user?.name}');
        emit(GetUserSuccessState());
      } else {
        emit(GetUserErrorState());
      }
    }).catchError((error) {
      emit(GetUserErrorState());
      print('error$error');
    });
  }

  RideRequestModel? rideRequestModel;

  void rideRequest({
    required var st_lng,
    required var st_lat,
    required var en_lng,
    required var en_lat,
    required var vehicle,
    required String st_location,
    required String en_location,
    required var price,
  }) {
    emit(PassengerSendRequestLoading());
    DioHelper.postData(
            url: SINDRIDEREQUEST,
            data: {
              'st_lng': st_lng,
              'st_lat': st_lat,
              'en_lng': en_lng,
              'en_lat': en_lat,
              'vehicle': vehicle,
              'st_location': st_location,
              'en_location': en_location,
              'price': price,
            },
            token: userToken)
        .then((value) {
      if (value != null) {
        print('data SEND Requset : ${jsonEncode(value.data)}');
        rideRequestModel = RideRequestModel.fromJson(value.data);
        print('Parsed status: ${rideRequestModel?.status}');
        print('Parsed message: ${rideRequestModel?.message}');
        emit(PassengerSendRequestSuccess());
      } else {
        emit(PassengerSendRequestError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerSendRequestError());
    });
  }

  ReservationRequestModel? reservationRequestModel;

  void reservationRequest({
    required var st_lng,
    required var st_lat,
    required var en_lng,
    required var en_lat,
    required var vehicle,
    required String st_location,
    required String en_location,
    required var price,
    required var time,
  }) {
    emit(PassengerSendReservationRequestLoading());
    DioHelper.postData(
            url: RESERVATIONREQUEST,
            data: {
              'vehicle': vehicle,
              'st_location': st_location,
              'en_location': en_location,
              'st_lng': st_lng,
              'st_lat': st_lat,
              'en_lng': en_lng,
              'en_lat': en_lat,
              'time': time,
              'price': price,
            },
            token: userToken)
        .then((value) {
      if (value != null) {
        print('data SEND RESERVATION Requset : ${jsonEncode(value.data)}');
        reservationRequestModel = ReservationRequestModel.fromJson(value.data);
        print('Parsed status: ${reservationRequestModel?.status}');
        print('Parsed message: ${reservationRequestModel?.message}');
        emit(PassengerSendReservationRequestSuccess());
      } else {
        emit(PassengerSendReservationRequestError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerSendReservationRequestError());
    });
  }

  ///ReservationRequestModel? cancelReservationModel;

  void cancelReservation({
    required var reservation_request_id,
  }) {
    emit(PassengerCancelReservationRequestLoading());
    DioHelper.postData(
            url: CANCELRESERVATION,
            data: {
              'reservation_request_id': reservation_request_id,
            },
            token: userToken)
        .then((value) {
      if (value != null) {
        print('data Cancel RESERVATION Requset : ${jsonEncode(value.data)}');
        // cancelReservationModel = ReservationRequestModel.fromJson(value.data);
        // print('Parsed status: ${cancelReservationModel?.status}');
        // print('Parsed message: ${cancelReservationModel?.message}');
        emit(PassengerCancelReservationRequestSuccess());
        getReservation();
      } else {
        emit(PassengerCancelReservationRequestError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerCancelReservationRequestError());
    });
  }

  GetAllOffersModel? getAllOffersModel;

  void getAllOffers() {
    emit(PassengerGetAllOffersLoading());
    DioHelper.getData(
      url: GETALLOFFERS,
      token: userToken,
    ).then((value) {
      if (value != null) {
        print('data GET ALL Offers: ${jsonEncode(value.data)}');
        try {
          getAllOffersModel = GetAllOffersModel.fromJson(value.data);
          print('Parsed status: ${getAllOffersModel?.status}');
          print('Parsed message: ${getAllOffersModel?.message}');
          emit(PassengerGetAllOffersSuccess());
        } catch (e) {
          print('Error parsing response: $e');
          emit(PassengerGetAllOffersError());
        }
      } else {
        emit(PassengerGetAllOffersError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerGetAllOffersError());
    });
  }

  GetReservationModel? getReservationModel;

  void getReservation() {
    emit(PassengerGetReservationLoading());
    DioHelper.getData(
      url: GETRESERVATION,
      token: userToken,
    ).then((value) {
      if (value != null) {
        print('data GET RESERVATION: ${jsonEncode(value.data)}');
        try {
          getReservationModel = GetReservationModel.fromJson(value.data);
          print('Parsed status: ${getReservationModel?.status}');
          print('Parsed message: ${getReservationModel?.message}');
          emit(PassengerGetReservationSuccess());
        } catch (e) {
          print('Error parsing response: $e');
          emit(PassengerGetReservationError());
        }
      } else {
        emit(PassengerGetReservationError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerGetReservationError());
    });
  }

  GetRequestModel? getRequestModel;

  void getRequest() {
    emit(PassengerGetRequestLoading());
    DioHelper.getData(
      url: GETRECUEST,
      token: userToken,
    ).then((value) {
      if (value != null) {
        print('data GET request: ${jsonEncode(value.data)}');
        try {
          getRequestModel = GetRequestModel.fromJson(value.data);
          print('Parsed status: ${getRequestModel?.status}');
          print('Parsed message: ${getRequestModel?.message}');
          emit(PassengerGetRequestSuccess(getRequestModel!));
        } catch (e) {
          print('Error parsing response: $e');
          emit(PassengerGetRequestError());
        }
      } else {
        emit(PassengerGetRequestError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerGetRequestError());
    });
  }

  void cancelRequest({
    required var ride_request_id,
  }) {
    emit(PassengerCancelRequestLoading());
    DioHelper.postData(
            url: CANCELRIDEREQUEST,
            data: {
              'ride_request_id': ride_request_id,
            },
            token: userToken)
        .then((value) {
      if (value != null) {
        print('data Cancel Requset : ${jsonEncode(value.data)}');
        emit(PassengerCancelRequestSuccess());
      } else {
        emit(PassengerCancelRequestError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerCancelRequestError());
    });
  }

  void acceptOffer({
    required var offer_id,
  }) {
    emit(PassengerAcceptOfferLoading());
    DioHelper.postData(
            url: ACCEPTOFFER,
            data: {
              'offer_id': offer_id,
            },
            token: userToken)
        .then((value) {
      if (value != null) {
        print('data Accept Offer : ${jsonEncode(value.data)}');
        emit(PassengerAcceptOfferSuccess());
      } else {
        emit(PassengerCancelRequestError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerAcceptOfferError());
    });
  }

  void rejectOffer({
    required var offer_id,
  }) {
    emit(PassengerRejectOfferLoading());
    DioHelper.postData(
            url: ACCEPTOFFER,
            data: {
              'offer_id': offer_id,
            },
            token: userToken)
        .then((value) {
      if (value != null) {
        print('data Accept Offer : ${jsonEncode(value.data)}');

        emit(PassengerRejectOfferSuccess());
        getAllOffers();
      } else {
        emit(PassengerRejectOfferError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerRejectOfferError());
    });
  }

  GetActiveRideModel? getActiveRideModel;

  void getActiveRide() {
    emit(PassengerGetActiveRideLoading());
    DioHelper.getData(
      url: GETACTIVERIDE,
      token: userToken,
    ).then((value) {
      if (value != null) {
        print('data GET Acctive Ride: ${jsonEncode(value.data)}');
        try {
          getActiveRideModel = GetActiveRideModel.fromJson(value.data);
          print('Parsed status: ${getActiveRideModel?.status}');
          print('Parsed message: ${getActiveRideModel?.message}');
          emit(PassengerGetActiveRideSuccess());
        } catch (e) {
          print('Error parsing response: $e');
          emit(PassengerGetActiveRideError());
        }
      } else {
        emit(PassengerGetActiveRideError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerGetActiveRideError());
    });
  }

  SetToDestinationModel? setToDestinationModel;

  void setToDestination() {
    emit(PassengerSetToDestinationLoading());
    DioHelper.postData(url: SETTODESTINITION, token: userToken).then((value) {
      if (value != null) {
        print('data setToDestination : ${jsonEncode(value.data)}');
        setToDestinationModel = SetToDestinationModel.fromJson(value.data);
        print('Parsed status: ${setToDestinationModel?.status}');
        print('Parsed message: ${setToDestinationModel?.message}');
        emit(PassengerSetToDestinationSuccess(setToDestinationModel!));
      } else {
        emit(PassengerSetToDestinationError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerSetToDestinationError());
    });
  }

  GetActivitiesModel? getActivitiesModel;

  void getActivities() {
    emit(PassengerGetActivitiesLoading());
    DioHelper.getData(
      url: GETACTIVITIES,
      token: userToken,
    ).then((value) {
      if (value != null) {
        print('data GET ACTIVITIES: ${jsonEncode(value.data)}');
        try {
          getActivitiesModel = GetActivitiesModel.fromJson(value.data);
          print('Parsed status: ${getActivitiesModel?.status}');
          print('Parsed message: ${getActivitiesModel?.message}');
          emit(PassengerGetActivitiesSuccess());
        } catch (e) {
          print('Error parsing response: $e');
          emit(PassengerGetActivitiesError());
        }
      } else {
        emit(PassengerGetActivitiesError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerGetActivitiesError());
    });
  }

  GetNumbersAdminModel? getNumbersAdminModel;

  void getNumbersAdmin() {
    emit(PassengerGetNumbersAdminLoading());
    DioHelper.getData(
      url: GETNUMBERSADMIN,
    ).then((value) {
      if (value != null) {
        print('data GET NUMBERS ADMIN: ${jsonEncode(value.data)}');
        try {
          getNumbersAdminModel = GetNumbersAdminModel.fromJson(value.data);
          print('Parsed status: ${getNumbersAdminModel?.status}');
          print('Parsed message: ${getNumbersAdminModel?.message}');
          emit(PassengerGetNumbersAdminSuccess());
        } catch (e) {
          print('Error parsing response: $e');
          emit(PassengerGetNumbersAdminError());
        }
      } else {
        emit(PassengerGetNumbersAdminError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerGetNumbersAdminError());
    });
  }

  GetPriceModel? getPriceModel;

  void getPriceData() {
    emit(PassengerGetPriceLoading());
    DioHelper.getData(
      url: GETPRICE,
      token: userToken,
    ).then((value) {
      if (value != null) {
        print('data GET Price: ${jsonEncode(value.data)}');
        try {
          getPriceModel = GetPriceModel.fromJson(value.data);
          print('Parsed status: ${getActivitiesModel?.status}');
          print('Parsed message: ${getActivitiesModel?.message}');
          emit(PassengerGetPriceSuccess());
        } catch (e) {
          print('Error parsing response: $e');
          emit(PassengerGetPriceError());
        }
      } else {
        emit(PassengerGetPriceError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(PassengerGetPriceError());
    });
  }
}
