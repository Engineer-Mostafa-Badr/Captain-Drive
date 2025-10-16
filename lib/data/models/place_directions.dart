import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDirections {
  late LatLngBounds bounds;
  late List<PointLatLng> polylinePoints;
  late String totalDistance;
  late String totalDuration;

  PlaceDirections({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });
  factory PlaceDirections.fromJson(Map<String, dynamic> json) {
    if (json['routes'] == null || (json['routes'] as List).isEmpty) {
      print("⚠️ No routes found in Directions API response: $json");
      return PlaceDirections(
        bounds: LatLngBounds(
          northeast: const LatLng(0, 0),
          southwest: const LatLng(0, 0),
        ),
        polylinePoints: [],
        totalDistance: '0',
        totalDuration: '0',
      );
    }

    final data = Map<String, dynamic>.from(json['routes'][0]);

    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    String distance = '';
    String duration = '';

    if (data['legs'] != null && (data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    final overviewPolyline = data['overview_polyline'];
    final points = overviewPolyline != null
        ? PolylinePoints().decodePolyline(overviewPolyline['points'])
        : <PointLatLng>[];

    return PlaceDirections(
      bounds: bounds,
      polylinePoints: points,
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
