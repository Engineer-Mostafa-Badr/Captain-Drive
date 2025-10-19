import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';

import '../../../business_logic/maps/maps_cubit.dart';
import '../../../data/models/Place_suggestion.dart';
import '../../../data/models/place.dart';
import '../../../data/models/place_directions.dart';
import '../../../core/helpers/location_helper.dart';
import '../../../core/widgets/place_item.dart';
import '../../captain/captain_map/utils/map_services.dart';

class MapReservationScreen extends StatefulWidget {
  static const String routeName = "MapReservationScreen";
  final bool showAppBar;

  const MapReservationScreen({
    super.key,
    required this.showAppBar,
  });

  @override
  State<MapReservationScreen> createState() => _MapReservationScreenState();
}

class _MapReservationScreenState extends State<MapReservationScreen> {
  late CameraPosition initialCameraPosition;
  late MapServices mapServices;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    mapServices = MapServices();

    // Set a default location (e.g., a city center) as the initial camera position
    initialCameraPosition = const CameraPosition(
      target: LatLng(
          30.0444, 31.2357), // Default to Cairo, Egypt (or another placeholder)
      zoom: 14.0,
    );

    // Initialize route data after setting the default position
    // Uncomment and use the real coordinates when available
    // LatLng origin = LatLng(double.parse(address.lat), double.parse(address.lng));
    // LatLng destination = LatLng(double.parse(branch.lat), double.parse(branch.lng));
    // _setMapMarkersAndRoute(origin, destination);
  }

  void initMapStyle() async {
    String nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');
    googleMapController.setMapStyle(nightMapStyle);
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  final Completer<GoogleMapController> _mapController = Completer();
  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  static Position? position;

  // Variables to store latitude and longitude
  double? currentLatitude;
  double? currentLongitude;
  String? currentLocationName;

  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;

  late CameraPosition goToSearchedForPlace;

  void buildCameraNewPosition() {
    goToSearchedForPlace = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      target: LatLng(
        selectedPlace.result.geometry.location.lat,
        selectedPlace.result.geometry.location.lng,
      ),
      zoom: 13,
    );
  }

  // these variables for getDirections
  PlaceDirections? placeDirections;
  var progressIndicator = false;
  late List<LatLng> polylinePoints;
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;

  //to way transopstion

  bool isTransportationOptionsVisible =
      false; // Track visibility of transportation options

  Future<void> getMyCurrentLocation() async {
    try {
      position = await LocationHelper.getCurrentLocation();

      if (position != null) {
        setState(() {
          currentLatitude = position!.latitude;
          currentLongitude = position!.longitude;
        });

        // Get the placemarks (location name details)
        List<Placemark> placemarks =
            await placemarkFromCoordinates(currentLatitude!, currentLongitude!);

        if (placemarks.isNotEmpty) {
          // Save the location name (e.g., street, city, country, etc.)
          Placemark place = placemarks[0];
          setState(() {
            currentLocationName =
                "${place.street}, ${place.locality}, ${place.country}";
          });
          print('Current Location Name: $currentLocationName');
        } else {
          print('No location name found for the coordinates.');
        }
      } else {
        print('Failed to get current location.');
      }
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: markers,
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      polylines: placeDirections != null
          ? {
              Polyline(
                polylineId: const PolylineId('my_polyline'),
                color: Colors.black,
                width: 2,
                points: polylinePoints,
              ),
            }
          : {},
    );
  }

  FloatingSearchBarController controller = FloatingSearchBarController();

  Widget buildFloatingSearchBar(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: controller,
      elevation: 6,
      hintStyle: const TextStyle(fontSize: 12),
      queryStyle: const TextStyle(fontSize: 18),
      hint: 'Where you want to go..?',
      border: const BorderSide(style: BorderStyle.none),
      margins: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 52,
      iconColor: Colors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      progress: progressIndicator,
      onQueryChanged: (query) {
        getPlacesSuggestions(query);
      },
      onFocusChanged: (isFocused) {
        // Update the focus state
        setState(() {
          isSearchBarFocused = isFocused;
          isTimeAndDistanceVisible = false;
          isTransportationOptionsVisible = false;
        });
        // Hide distance and time row
        setState(() {
          isTimeAndDistanceVisible = false;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
              icon: Icon(Icons.place, color: Colors.black.withOpacity(0.6)),
              onPressed: () {}),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionsBloc(),
              buildSelectedPlaceLocationBloc(),
              buildDiretionsBloc(),
            ],
          ),
        );
      },
    );
  }

  Widget buildDiretionsBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is DirectionsLoaded) {
          placeDirections = state.placeDirections;
          getPolylinePoints(); // Update the polyline points
        }
      },
      child: Container(),
    );
  }

  void getPolylinePoints() {
    setState(() {
      polylinePoints = placeDirections!.polylinePoints
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList();
    });
  }

  late Place selectedPlace;

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          selectedPlace = (state).place;

          goToMySearchedForLocation();
          getDirections();
        }
      },
      child: Container(),
    );
  }

  Future<void> goToMySearchedForLocation() async {
    buildCameraNewPosition();
    final GoogleMapController controller = await _mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(goToSearchedForPlace));
    buildSearchedPlaceMarker();
  }

  void buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      position: goToSearchedForPlace.target,
      markerId: const MarkerId('1'),
      onTap: () {
        buildCurrentLocationMarker();
        // show time and distance
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isTimeAndDistanceVisible = true;
          isTransportationOptionsVisible =
              true; // Show the transportation options
        });
      },
      infoWindow: InfoWindow(title: placeSuggestion.description),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    addMarkerToMarkersAndUpdateUI(searchedPlaceMarker);
  }

  List<PlaceSuggestion> places = [];
  late PlaceSuggestion placeSuggestion;

  void buildCurrentLocationMarker() {
    currentLocationMarker = Marker(
      position: LatLng(position!.latitude, position!.longitude),
      markerId: const MarkerId('2'),
      onTap: () {},
      infoWindow: const InfoWindow(title: "Your current Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkersAndUpdateUI(currentLocationMarker);
  }

  void addMarkerToMarkersAndUpdateUI(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }

  void getPlacesSuggestions(String query) {
    final sessionToken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceSuggestions(query, sessionToken);
  }

  Widget buildSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is PlacesLoaded) {
          places = (state).places;
          if (places.isNotEmpty) {
            return buildPlacesList();
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildPlacesList() {
    return ListView.builder(
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap: () async {
              placeSuggestion = places[index];
              controller.close();
              getSelectedPlaceLocation();
              polylinePoints.clear();
              removeAllMarkersAndUpdateUI();
            },
            child: PlaceItem(
              suggestion: places[index],
            ),
          );
        },
        itemCount: places.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics());
  }

  void removeAllMarkersAndUpdateUI() {
    setState(() {
      markers.clear();
    });
  }

  //new change

  // static CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
  //   bearing: 0.0,
  //   target: LatLng(position?.latitude ?? 0, position?.longitude ?? 0),
  //   tilt: 0.0,
  //   zoom: 17,
  // );

  double? destinationLatitude;
  double? destinationLongitude;
  String? destinationLocationName;

  void getDirections() {
    BlocProvider.of<MapsCubit>(context).emitPlaceDirections(
      LatLng(position!.latitude, position!.longitude), // Current location
      LatLng(
        selectedPlace.result.geometry.location.lat, // Destination latitude
        selectedPlace.result.geometry.location.lng, // Destination longitude
      ),
    );
    getDestinationLocationName();

    // Store the destination's latitude and longitude
    destinationLatitude = selectedPlace.result.geometry.location.lat;
    destinationLongitude = selectedPlace.result.geometry.location.lng;
  }

  Future<void> getDestinationLocationName() async {
    if (destinationLatitude != null && destinationLongitude != null) {
      try {
        // Get the placemarks (location name details) for the destination coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
            destinationLatitude!, destinationLongitude!);

        if (placemarks.isNotEmpty) {
          // Save the location name (e.g., street, city, country, etc.)
          Placemark place = placemarks[0];
          setState(() {
            destinationLocationName =
                "${place.street}, ${place.locality}, ${place.country}";
          });
          print('Destination Location Name: $destinationLocationName');
        } else {
          print('No location name found for the destination coordinates.');
        }
      } catch (e) {
        print('Error getting destination location name: $e');
      }
    } else {
      print('Destination coordinates are not set.');
    }
  }

  void getSelectedPlaceLocation() {
    final sessionToken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceLocation(placeSuggestion.placeId, sessionToken);

    BlocProvider.of<MapsCubit>(context).stream.listen((state) {
      if (state is PlaceLocationLoaded) {
        selectedPlace = state.place; // The selected place's location details
        goToMySearchedForLocation();
        getDirections(); // Calculate directions using current and destination coordinates
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isTimeAndDistanceVisible = true;
          isTransportationOptionsVisible = true;
        });
      }
    });
  }

  List<TextEditingController> stopControllers = [];

  bool isSearchBarFocused = false; // Track the focus state of the search bar

  //add stops
  void addStop() {
    setState(() {
      stopControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(title: const Text("Google Map View"))
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 60,
            bottom: 750,
            left: 325,
            right: 20,
            child: GestureDetector(
              onTap: _goToMyCurrentLocation,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 5, // Softening the shadow
                      spreadRadius: 0.5, // Extending the shadow
                      offset: Offset(0, 0), // No offset to center the shadow
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          GoogleMap(
            polylines: polylines,
            markers: markers,
            onMapCreated: (controller) {
              googleMapController = controller;
              initMapStyle(); // Apply custom map style
              googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
                  initialCameraPosition.target, 14.0));
            },
            zoomControlsEnabled: false,
            initialCameraPosition: initialCameraPosition,
          ),
          Positioned(
            top: 60,
            bottom: 750,
            left: 325,
            right: 20,
            child: GestureDetector(
              onTap: _goToMyCurrentLocation,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26, // Shadow color
                      blurRadius: 5, // Softening the shadow
                      spreadRadius: 0.5, // Extending the shadow
                      offset: Offset(0, 0), // No offset to center the shadow
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Search bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 400,
                    height: isSearchBarFocused ? 300 : 75,
                    child: buildFloatingSearchBar(context),
                  ),

                  if (!isTransportationOptionsVisible) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stopControllers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            TextField(
                              controller: stopControllers[index],
                              decoration: InputDecoration(
                                hintText: 'Add stop',
                                prefixIcon: const Icon(Icons.add_location,
                                    color: Colors.white),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: addStop,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add another stop'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Set the markers and draw the route between Address (origin) and Branch (destination)

  // Set the polyline for the route
}
