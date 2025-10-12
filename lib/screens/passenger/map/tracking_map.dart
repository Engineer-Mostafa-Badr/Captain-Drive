import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

import '../../../components/constant.dart';
import '../model/set_to_destination_model.dart';

class TrackingMapScreen extends StatefulWidget {
  final SetToDestinationModel rideData;

  const TrackingMapScreen({super.key, required this.rideData});

  @override
  State<TrackingMapScreen> createState() => _TrackingMapScreenState();
}

class _TrackingMapScreenState extends State<TrackingMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  LatLng? _destinationLocation;
  BitmapDescriptor? _carIcon;
  Set<Polyline> _polylines = {};
  List<LatLng> polylinePoints = [];

  @override
  void initState() {
    super.initState();
    _setInitialLocations();
    _loadCarIcon();
    _trackCurrentLocation();
  }

  Future<void> _loadCarIcon() async {
    _carIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(45, 45)),
      'assets/images/carIcon.png',
    );
  }

  void _setInitialLocations() {
    _destinationLocation = LatLng(
      double.parse(widget.rideData.data.ride.offer.request.enLat),
      double.parse(widget.rideData.data.ride.offer.request.enLng),
    );
  }

  void _trackCurrentLocation() async {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        print('Current Location: $_currentLocation');
      });
      _animateToCurrentLocation();
      if (_currentLocation != null && _destinationLocation != null) {
        print('Destination Location: $_destinationLocation');
        _getRoutePolyline(); // Fetch the route between current location and the destination
      }
    });
  }

  void _animateToCurrentLocation() {
    if (_mapController != null && _currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );
    }
  }

  Future<void> _getRoutePolyline() async {
    const String apiKey = googleApiKey; // Replace with your API key

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}'
        '&destination=${_destinationLocation!.latitude},${_destinationLocation!.longitude}&key=$apiKey';

    print('Directions API URL: $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final points = data['routes'][0]['overview_polyline']['points'];
        print('Encoded Polyline: $points'); // Print encoded polyline string

        final decodedPoints = _decodePolyline(points);
        print(
            'Decoded Polyline Points: $decodedPoints'); // Print decoded points

        setState(() {
          polylinePoints = decodedPoints;
          print('Polyline Points Set: $polylinePoints');

          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylinePoints, // Use the decoded polyline points
              color: Colors.black,
              width: 3,
            ),
          };
          print('Polyline Set: $_polylines');
        });
      } else {
        print("No routes found in API response");
      }
    } else {
      print("Error fetching route: ${response.statusCode}");
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> decodedPath = [];
    int index = 0, lat = 0, lng = 0;

    while (index < polyline.length) {
      int b, shift = 0, result = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      decodedPath.add(LatLng(lat / 1E5, lng / 1E5));
    }

    print(
        'Decoded Polyline Points: $decodedPath'); // Print decoded polyline points
    return decodedPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null || _carIcon == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 15.0,
              ),
              markers: _createMarkers(),
              polylines: _polylines, // Pass the polyline set here
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
    );
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    if (_currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          icon: _carIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );
    }

    if (_destinationLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _destinationLocation!,
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );
    }

    return markers;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
