import 'package:flutter/material.dart';

abstract class AppColor {
  static const Color primaryColor = Color.fromRGBO(58, 209, 46, 1);
  static const Color onBoardingColor = Color.fromRGBO(38, 67, 137, 1);
  static const Color textButtonColor = Color.fromRGBO(116, 86, 29, 1);
  static const Color buttonColor = Color.fromRGBO(119, 89, 11, 0.67);
  static const Color borderFieldColor = Color.fromRGBO(143, 143, 143, 0.89);
  static const Color backGroundColor = Color.fromRGBO(238, 238, 238, 1);
  static const Color selectedColor = Color.fromRGBO(223, 223, 223, 1);
}

dynamic userToken = '';
dynamic CaptienToken = '';

dynamic userEmail = '';
const googleApiKey = 'AIzaSyDQTqKgPF6Ru6vGYKQLUjB4ToYXql4ToqA';
const suggestionsBaseUrl =
    'https://maps.googleapis.com/maps/api/place/autocomplete/json';
const placeLocationBaseUrl =
    'https://maps.googleapis.com/maps/api/place/details/json';
const directionsBaseUrl =
    'https://maps.googleapis.com/maps/api/directions/json';
