import 'package:captain_drive/screens/passenger/model/set_to_destination_model.dart';

import '../model/cahange_password_model.dart';
import '../model/get_request_model.dart';
import '../model/update_model.dart';

abstract class PassengerStates {}

class PassengerInitialState extends PassengerStates {}

class PassengerSendRequestLoading extends PassengerStates {}

class PassengerSendRequestSuccess extends PassengerStates {}

class PassengerSendRequestError extends PassengerStates {}

class PassengerSendReservationRequestLoading extends PassengerStates {}

class PassengerSendReservationRequestSuccess extends PassengerStates {}

class PassengerSendReservationRequestError extends PassengerStates {}

class PassengerCancelReservationRequestLoading extends PassengerStates {}

class PassengerCancelReservationRequestSuccess extends PassengerStates {}

class PassengerCancelReservationRequestError extends PassengerStates {}

class GetUserLoadingState extends PassengerStates {}

class GetUserSuccessState extends PassengerStates {}

class GetUserErrorState extends PassengerStates {}

class LoadingForgetPasswordState extends PassengerStates {}

class SuccessForgetPasswordState extends PassengerStates {
  late final ChangePasswordModel forgetPassword;
  SuccessForgetPasswordState(this.forgetPassword);
}

class ErrorForgetPasswordState extends PassengerStates {
  final String error;
  ErrorForgetPasswordState(this.error);
}

class LoadingCheckCodeState extends PassengerStates {}

class SuccessCheckCodeState extends PassengerStates {
  late final ChangePasswordModel forgetPassword;
  SuccessCheckCodeState(this.forgetPassword);
}

class ErrorCheckCodeState extends PassengerStates {
  final String error;
  ErrorCheckCodeState(this.error);
}

class LoadingChangePasswordState extends PassengerStates {}

class SuccessChangePasswordState extends PassengerStates {
  late final ChangePasswordModel changePasswordModel;
  SuccessChangePasswordState(this.changePasswordModel);
}

class ErrorChangePasswordState extends PassengerStates {
  final String error;
  ErrorChangePasswordState(this.error);
}

class LoadingUpdateState extends PassengerStates {}

class SuccessUpdateState extends PassengerStates {
  late final UpdateModel updateModel;
  SuccessUpdateState(this.updateModel);
}

class ErrorUpdateState extends PassengerStates {
  final String error;
  ErrorUpdateState(this.error);
}

class PassengerSetToDestinationLoading extends PassengerStates {}

class PassengerSetToDestinationSuccess extends PassengerStates {
  late final SetToDestinationModel setToDestinationModel;
  PassengerSetToDestinationSuccess(this.setToDestinationModel);
}

class PassengerSetToDestinationError extends PassengerStates {}

class PassengerCancelRequestLoading extends PassengerStates {}

class PassengerCancelRequestSuccess extends PassengerStates {}

class PassengerCancelRequestError extends PassengerStates {}

class PassengerAcceptOfferLoading extends PassengerStates {}

class PassengerAcceptOfferSuccess extends PassengerStates {}

class PassengerAcceptOfferError extends PassengerStates {}

class PassengerRejectOfferLoading extends PassengerStates {}

class PassengerRejectOfferSuccess extends PassengerStates {}

class PassengerRejectOfferError extends PassengerStates {}

class PassengerGetAllOffersLoading extends PassengerStates {}

class PassengerGetAllOffersSuccess extends PassengerStates {}

class PassengerGetAllOffersError extends PassengerStates {}

class PassengerGetReservationLoading extends PassengerStates {}

class PassengerGetReservationSuccess extends PassengerStates {}

class PassengerGetReservationError extends PassengerStates {}

class PassengerGetActiveRideLoading extends PassengerStates {}

class PassengerGetActiveRideSuccess extends PassengerStates {}

class PassengerGetActiveRideError extends PassengerStates {}

class PassengerGetActivitiesLoading extends PassengerStates {}

class PassengerGetActivitiesSuccess extends PassengerStates {}

class PassengerGetActivitiesError extends PassengerStates {}

class PassengerGetPriceLoading extends PassengerStates {}

class PassengerGetPriceSuccess extends PassengerStates {}

class PassengerGetPriceError extends PassengerStates {}

class PassengerGetNumbersAdminLoading extends PassengerStates {}

class PassengerGetNumbersAdminSuccess extends PassengerStates {}

class PassengerGetNumbersAdminError extends PassengerStates {}

class PassengerGetRequestLoading extends PassengerStates {}

class PassengerGetRequestSuccess extends PassengerStates {
  late final GetRequestModel getRequestModel;
  PassengerGetRequestSuccess(this.getRequestModel);
}

class PassengerGetRequestError extends PassengerStates {}
