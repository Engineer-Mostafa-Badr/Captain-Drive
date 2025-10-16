import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
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
import '../../../localization/localization_cubit.dart';
import '../../../presentation/widgets/place_item.dart';
import '../../../shared/local/cach_helper.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../reservation/success_reservation_screen.dart';
import 'offer_screen.dart';

class MapScreen extends StatefulWidget {
  final bool booking;
  DateTime? selectedDate = DateTime.now(); // Initialize with current date
  TimeOfDay? selectedTime = TimeOfDay.now(); // Initialize with current time
  String? formattedDateTime; // Output: 2024-08-28 10:00:00
  MapScreen(
      {super.key,
      required this.booking,
      this.selectedDate,
      this.selectedTime,
      this.formattedDateTime});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<PlaceSuggestion> places = [];
  FloatingSearchBarController controller = FloatingSearchBarController();
  static Position? position;
  final Completer<GoogleMapController> _mapController = Completer();

  // Variables to store latitude and longitude
  double? currentLatitude;
  double? currentLongitude;
  String? currentLocationName;

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  // these Pvariables for getPlaceLocation
  Set<Marker> markers = {};
  late PlaceSuggestion placeSuggestion;
  late Place selectedPlace;
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
  List<LatLng> polylinePoints = [];
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;

  //to way transopstion

  bool isTransportationOptionsVisible =
      false; // Track visibility of transportation options

  @override
  initState() {
    super.initState();
    getMyCurrentLocation();
    PassengerCubit.get(context).getPriceData();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  Future<void> getMyCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDeniedForeverDialog();
        return;
      }

      // Fetch the current location
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

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

// Show a dialog to enable location services
  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enable Location Services"),
        content: const Text(
            "Location services are disabled. Please enable them to proceed."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
              getMyCurrentLocation(); // Retry location fetching
            },
            child: const Text("Enable"),
          ),
        ],
      ),
    );
  }

// Show a dialog for permission permanently denied
  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission Denied"),
        content: const Text(
            "Location permission is permanently denied. Please enable it from app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  // //olddddddd
  // Future<void> getMyCurrentLocation() async {
  //   try {
  //     position = await LocationHelper.getCurrentLocation();
  //
  //     if (position != null) {
  //       setState(() {
  //         currentLatitude = position!.latitude;
  //         currentLongitude = position!.longitude;
  //       });
  //
  //       // Get the placemarks (location name details)
  //       List<Placemark> placemarks =
  //           await placemarkFromCoordinates(currentLatitude!, currentLongitude!);
  //
  //       if (placemarks.isNotEmpty) {
  //         // Save the location name (e.g., street, city, country, etc.)
  //         Placemark place = placemarks[0];
  //         setState(() {
  //           currentLocationName =
  //               "${place.street}, ${place.locality}, ${place.country}";
  //         });
  //         print('Current Location Name: $currentLocationName');
  //       } else {
  //         print('No location name found for the coordinates.');
  //       }
  //     } else {
  //       print('Failed to get current location.');
  //     }
  //   } catch (e) {
  //     print('Error getting current location: $e');
  //   }
  // }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.terrain,
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

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  Widget buildFloatingSearchBar(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: controller,
      elevation: 6,
      hintStyle: const TextStyle(fontSize: 12),
      queryStyle: const TextStyle(fontSize: 18),
      hint: isArabic ? "أين تريد الذهاب..؟" : 'Where you want to go..?',
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
    bool isArabic = LocalizationCubit.get(context).isArabic();
    // Function to get the location name from coordinates
    Future<String> getLocationName(double latitude, double longitude) async {
      try {
        // Get the list of placemarks for the coordinates
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);

        // Get the first placemark from the list (if any)
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          // Return a formatted address
          return '${placemark.locality} ${placemark.subAdministrativeArea}';
        } else {
          return isArabic ? 'موقع غير معروف' : 'Unknown location';
        }
      } catch (e) {
        print("Error fetching location name: $e");
        return isArabic ? 'موقع غير معروف' : 'Unknown location';
      }
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null
              ? buildMap()
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
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
                  // Check if position is available and fetch the location name
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Center(
                        child: FutureBuilder<String>(
                          future: position != null
                              ? getLocationName(
                                  position!.latitude, position!.longitude)
                              : Future.value(''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(isArabic ? 'انتظر...' : 'Loading...');
                            } else if (snapshot.hasError) {
                              return Text(isArabic
                                  ? 'خطأ في تحميل الموقع'
                                  : 'Error loading location');
                            } else if (snapshot.hasData) {
                              return Text(
                                textAlign: TextAlign.center,
                                position != null
                                    ? isArabic
                                        ? '${snapshot.data}'
                                        : '${snapshot.data}'
                                    : (isArabic ? 'انتظر...' : 'Loading...'),
                              );
                            } else {
                              return Text(isArabic
                                  ? 'الموقع غير متاح'
                                  : 'Location not available');
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),
                  const CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  // Search bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
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
                                hintText: isArabic ? 'إضافة توقف' : 'Add stop',
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
                      child:
                          Text(isArabic ? 'أضف محطة أخرى' : 'Add another stop'),
                    ),
                  ],

                  if (isTransportationOptionsVisible) ...[
                    secondChoseTransportation(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: Container(
      //
      //   margin: EdgeInsets.fromLTRB(0, 0, 8, 30),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.blue,
      //     onPressed: _goToMyCurrentLocation,
      //     child: Icon(Icons.place, color: Colors.white),
      //   ),
      // ),
    );
  }

  void onLocationChosen() {
    setState(() {
      isTransportationOptionsVisible = false; // or true based on your logic
    });
  }

  double getDistance() {
    if (placeDirections?.totalDistance != null) {
      // Extract the numeric part using a regular expression
      final match =
          RegExp(r'\d+(\.\d+)?').firstMatch(placeDirections!.totalDistance);
      if (match != null) {
        return double.tryParse(match.group(0) ?? "0") ?? 0;
      }
    }
    return 0;
  }

  double getTime() {
    if (placeDirections?.totalDuration != null) {
      // Extract the numeric part using a regular expression
      final match =
          RegExp(r'\d+(\.\d+)?').firstMatch(placeDirections!.totalDuration);
      if (match != null) {
        return double.tryParse(match.group(0) ?? "0") ?? 0;
      }
    }
    return 0;
  }

  //var scooter = 5;
  //var car = 6;
  //var conditionCar = 7;
  String selectedCarType = 'سكوتر'; // Default value
  var VehicleNumber = 3;
  var priceVehicle = 5; //start by scooter

  Widget secondChoseTransportation() {
    var cubit = PassengerCubit.get(context).getPriceModel?.data;
    var profit = cubit?.profits;

    int? car = 6;
    if (cubit?.profits != null) {
      for (var profit in cubit!.profits!) {
        if (profit.vehicleType == 1) {
          car = profit.perKilo;
          break; // Exit the loop once we find the matching vehicleType
        }
      }
    }

    int? scooter = 5;
    if (cubit?.profits != null) {
      for (var profit in cubit!.profits!) {
        if (profit.vehicleType == 3) {
          scooter = profit.perKilo;
          break; // Exit the loop once we find the matching vehicleType
        }
      }
    }

    int? conditionCar = 7;
    if (cubit?.profits != null) {
      for (var profit in cubit!.profits!) {
        if (profit.vehicleType == 2) {
          conditionCar = profit.perKilo;
          break; // Exit the loop once we find the matching vehicleType
        }
      }
    }

    int? taxi = 6;
    if (cubit?.profits != null) {
      for (var profit in cubit!.profits!) {
        if (profit.vehicleType == 4) {
          taxi = profit.perKilo;
          break; // Exit the loop once we find the matching vehicleType
        }
      }
    }

    double calculatedPrice =
        (VehicleNumber == 1 || VehicleNumber == 2 || VehicleNumber == 4) &&
                getDistance() < 8.0
            ? 35.0 // Fixed price for specific conditions
            : getDistance() * priceVehicle; // Calculated price otherwise

    //double calculatedPrice = getDistance() * priceVehicle; // Assuming this is your calculation logic

    String formattedPrice = calculatedPrice
        .toStringAsFixed(1); // Format the price to two decimal places

    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        children: [
          // الجزء القابل للتمرير
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'اختار سياره للمشوار',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  typeOfCar(
                      name: 'سكوتر',
                      image: 'assets/images/scooter.png',
                      type: scooter,
                      number: 3),
                  const SizedBox(height: 16),
                  typeOfCar(
                      name: 'سياره عاديه',
                      image: 'assets/images/car1.png',
                      type: car,
                      number: 1),
                  const SizedBox(height: 16),
                  typeOfCar(
                      name: 'سياره مكيفه',
                      image: 'assets/images/car2.png',
                      type: conditionCar,
                      number: 2),
                  const SizedBox(height: 20),
                  typeOfCar(
                      name: 'تاكسي',
                      image: 'assets/images/taxi.png',
                      type: taxi,
                      number: 4),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: false
                                ? Colors.white
                                : Colors
                                    .black, // Change border color based on selection
                            width: 5),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '100 ج.م ',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'باص',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'من الدقائق ',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                  Text(
                                    '${getTime()}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  const Text(
                                    ' المكان علي بعد',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ],
                              ),
                              // Text(
                              //        'Distance: ${placeDirections?.totalDistance ?? "N/A"}',
                              //      ),
                              //
                              // Text(
                              //        'Time: ${placeDirections?.totalDuration ?? "N/A"}',
                              //
                              //      ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: 65,
                              height: 65,
                              child: Image.asset('assets/images/bus.png')),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // الزر في الأسفل
          widget.booking
              ? BlocConsumer<PassengerCubit, PassengerStates>(
                  listener: (context, state) {
                    if (state is PassengerSendReservationRequestSuccess) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SuccessReservationScreen()));
                      // showModalBottomSheet(
                      //   context: context,
                      //   backgroundColor:
                      //   Colors.transparent, // اختياري لجعل الخلفية شفافة
                      //   builder: (context) {
                      //     return Container(
                      //       height:
                      //       600, // استبدل 600 بالارتفاع الثابت الذي تريده
                      //       decoration: BoxDecoration(
                      //         color:
                      //         Colors.white, // لون الخلفية للنافذة المنبثقة
                      //         borderRadius: BorderRadius.only(
                      //           topLeft: Radius.circular(16),
                      //           topRight: Radius.circular(16),
                      //         ),
                      //       ),
                      //       child: OfferScreen(), // هنا تعرض محتوى OfferScreen
                      //     );
                      //   },

                      // );
                    }
                  },
                  builder: (context, state) => ConditionalBuilder(
                    condition: state is! PassengerSendReservationRequestLoading,
                    builder: (context) => ElevatedButton(
                      onPressed: () {
                        print(currentLongitude);
                        print(currentLatitude);
                        print(currentLocationName);

                        print(destinationLatitude);
                        print(destinationLongitude);
                        print(destinationLocationName);

                        print('-----------------------------------');
                        print(widget.selectedTime);
                        print(widget.selectedDate);
                        print(widget.formattedDateTime);

                        // تنفيذ الطلب
                        PassengerCubit.get(context).reservationRequest(
                          st_lat: '$currentLatitude',
                          st_lng: '$currentLongitude',
                          en_lat: '$destinationLatitude',
                          en_lng: '$destinationLongitude',
                          st_location: '$currentLocationName',
                          en_location: '$destinationLocationName',
                          vehicle: VehicleNumber,
                          time: widget.formattedDateTime,
                          price: double.parse(
                              formattedPrice), // تحويل السعر إلى نوع double
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('احجز $selectedCarType'),
                    ),
                    fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                )
              : BlocConsumer<PassengerCubit, PassengerStates>(
                  listener: (context, state) {
                    if (state is PassengerSendRequestSuccess) {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            Colors.transparent, // اختياري لجعل الخلفية شفافة
                        isDismissible:
                            false, // Prevents closing the sheet by tapping outside
                        enableDrag: false, // Disables closing by swiping down
                        builder: (context) {
                          return Container(
                            height:
                                600, // استبدل 600 بالارتفاع الثابت الذي تريده
                            decoration: const BoxDecoration(
                              color:
                                  Colors.white, // لون الخلفية للنافذة المنبثقة
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child:
                                const OfferScreen(), // هنا تعرض محتوى OfferScreen
                          );
                        },
                      );
                    }
                  },
                  builder: (context, state) => ConditionalBuilder(
                    condition: state is! PassengerSendRequestLoading,
                    builder: (context) => ElevatedButton(
                      onPressed: () {
                        print(currentLongitude);
                        print(currentLatitude);
                        print(currentLocationName);

                        print(destinationLatitude);
                        print(destinationLongitude);
                        print(destinationLocationName);

                        // تنفيذ الطلب
                        PassengerCubit.get(context).rideRequest(
                          st_lat: '$currentLatitude',
                          st_lng: '$currentLongitude',
                          en_lat: '$destinationLatitude',
                          en_lng: '$destinationLongitude',
                          st_location: '$currentLocationName',
                          en_location: '$destinationLocationName',
                          vehicle: VehicleNumber,

                          price: double.parse(
                              formattedPrice), // تحويل السعر إلى نوع double
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('اطلب $selectedCarType'),
                    ),
                    fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
        ],
      ),
    );
  }

  Widget typeOfCar({
    required String name,
    required String image,
    required var type,
    required var number,
  }) {
    bool isSelected =
        selectedCarType == name; // Check if this car type is selected
    return GestureDetector(
      onTap: () {
        // Update the selected car type when clicked
        setState(() {
          selectedCarType = name;
          VehicleNumber = number;
          print(VehicleNumber);
          priceVehicle = type;
        });
      },
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected
                    ? Colors.white
                    : Colors.black, // Change border color based on selection
                width: 5),
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // //price
              // Text(
              //   '${(getDistance() * type).toStringAsFixed(1)} ج.م ',
              //   style: TextStyle(fontSize: 12, color: Colors.white),
              // ),

              // price
              Text(
                (number == 1 || number == 2 || number == 4) &&
                        getDistance() < 8.0
                    ? '35 ج.م ' // Fixed price for the condition
                    : '${(getDistance() * type).toStringAsFixed(1)} ج.م ', // Calculated price otherwise
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),

              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'من الدقائق ',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      Text(
                        '${getTime()}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      const Text(
                        ' المكان علي بعد',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ],
                  ),
                  // Text(
                  //        'Distance: ${placeDirections?.totalDistance ?? "N/A"}',
                  //      ),
                  //
                  // Text(
                  //        'Time: ${placeDirections?.totalDuration ?? "N/A"}',
                  //
                  //      ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(width: 65, height: 65, child: Image.asset(image)),
            ],
          ),
        ),
      ),
    );
  }
}
