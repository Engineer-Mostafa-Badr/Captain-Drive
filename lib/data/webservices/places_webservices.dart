import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../components/constant.dart';

class PlacesWebservices {
  late Dio dio;

  PlacesWebservices() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(milliseconds: 20 * 1000),
      receiveTimeout: const Duration(milliseconds: 20 * 1000),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> fetchSuggestions(
      String query, String sessionToken) async {
    List<dynamic> allPredictions = [];

    List<String> types = [
      'establishment', // For businesses
      'point_of_interest', // For points of interest
      'geocode', // For geographic features
      'address', // For specific addresses
      'taxi_stand', // For taxi stands
      'transit_station', // For transit stations
      'airport', // For airports
      'lodging', // For hotels
      'parking', // For parking facilities
      'restaurant', // For restaurants and dining
      'cafe', // For cafes and coffee shops
      'bar', // For bars and nightlife
      'shopping_mall', // For shopping centers and malls
      'hospital', // For hospitals and medical centers
      'pharmacy', // For pharmacies
      'school', // For schools
      'university', // For universities and higher education institutions
      'atm', // For ATMs
      'bank', // For banks and financial institutions
      'museum', // For museums and cultural centers
      'gym', // For gyms and fitness centers
      'park', // For parks and recreational areas
      'movie_theater', // For cinemas and theaters
      'spa', // For spas and wellness centers
      'zoo', // For zoos and animal-related attractions
      'amusement_park', // For amusement and theme parks
      'gas_station', // For gas stations
      'car_rental', // For car rental services
      'bus_station', // For bus stations
      'train_station', // For train stations
      'doctor', // For doctor’s offices or clinics
      'dentist', // For dental clinics
      'hardware_store', // For hardware stores
      'clothing_store', // For clothing and apparel stores
      'book_store', // For bookstores
      'library', // For libraries
      'street_address' // For specific street addresses with house numbers
    ];

    try {
      for (String type in types) {
        Response response = await dio.get(
          suggestionsBaseUrl,
          queryParameters: {
            'input': query,
            'types': type,
            'key': googleApiKey,
            'sessiontoken': sessionToken,
          },
        );

        if (response.data['predictions'] != null) {
          allPredictions.addAll(response.data['predictions']);
        }

        print('Type: $type - Predictions: ${response.data['predictions']}');
        print('Response Status Code: ${response.statusCode}');
      }

      return allPredictions; // Return all accumulated predictions
    } catch (error) {
      print("Error: ${error.toString()}");
      return [];
    }
  }

  Future<dynamic> getPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(
        placeLocationBaseUrl,
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': googleApiKey,
          'sessiontoken': sessionToken
        },
      );
      print(response.data['predictions']);
      print(response.statusCode);

      return response.data;
    } catch (error) {
      return Future.error("Place location error : ",
          StackTrace.fromString(('this is its trace')));
    }
  }

  // origin equals current location
  // destination equals searched for location

  Future<dynamic> getDirections(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio.get(
        directionsBaseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': googleApiKey,
        },
      );
      print("Abdoo I'm testing directions");
      print(response.data);
      return response.data;
    } catch (error) {
      return Future.error("Place location error : ",
          StackTrace.fromString(('this is its trace')));
    }
  }
}
