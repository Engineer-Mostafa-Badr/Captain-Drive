import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:captain_drive/business_logic/camera_model_cubit/camera_model_cubit.dart';
import 'package:captain_drive/business_logic/captain_cancel_offer_cubit/captain_cancel_offer_cubit.dart';
import 'package:captain_drive/business_logic/captain_cancel_ride_offer_cubit/captain_cancel_ride_offer_cubit.dart';
import 'package:captain_drive/business_logic/captain_get_active_ride_cubit/captain_get_active_ride_cubit.dart';
import 'package:captain_drive/business_logic/captain_get_offer_cubit/captain_get_offer_cubit.dart';
import 'package:captain_drive/business_logic/captain_get_requests_cubit/captain_get_requests_cubit.dart';
import 'package:captain_drive/business_logic/captain_make_offer_cubit/captain_make_offer_cubit.dart';
import 'package:captain_drive/business_logic/driver_set_current_location_cubit/driver_set_current_location_cubit.dart';
import 'package:captain_drive/business_logic/set_arrive_ride_cubit/set_arrive_ride_cubit.dart';
import 'package:captain_drive/business_logic/set_ride_arrive_cubit/set_ride_complete_cubit.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/data/models/captain_get_offer_model.dart';
import 'package:captain_drive/data/models/captain_get_requests_model.dart';
import 'package:captain_drive/data/models/captain_get_ride_model.dart';
import 'package:captain_drive/screens/captain/captain_map/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:captain_drive/screens/captain/captain_map/utils/map_services.dart';
import 'package:captain_drive/screens/captain/captain_map/widgets/custom_list_view.dart';
import 'package:captain_drive/screens/captain/chat/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

import '../../../../localization/localization_cubit.dart';
import '../../../../shared/local/cach_helper.dart';
import '../widgets/custom_text_field.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late CameraPosition initalCameraPoistion;

  late MapServices mapServices;
  late TextEditingController textEditingController;
  GoogleMapController? googleMapController;
  String? sesstionToken;
  late Uuid uuid;
  Set<Marker> markers = {};

  List<PlaceModel> places = [];
  Set<Polyline> polyLines = {};

  late LatLng desintation;

  Timer? locationUpdateTimer; // Timer for periodic location updates
  Timer? debounce;
  Timer? dataTimer;

  CaptainGetRequestModel? captainGetRequestModel;

  @override
  void initState() {
    mapServices = MapServices();
    uuid = const Uuid();
    textEditingController = TextEditingController();
    initalCameraPoistion = const CameraPosition(target: LatLng(0, 0));
    fetchPredictions();
    super.initState();
    _loadStatus();
    _loadNearByStatus();
    updateCurrentLocation();
    _loadMakerOfferStatus();
    _loadActiveRideStatus();
    _startOfferCheck();
    _initCamera();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  void fetchPredictions() {
    textEditingController.addListener(() {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }
      debounce = Timer(const Duration(milliseconds: 100), () async {
        if (textEditingController.text.isEmpty) return;
        sesstionToken ??= uuid.v4();
        await mapServices.getPredictions(
            input: textEditingController.text,
            sesstionToken: sesstionToken!,
            places: places);
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateCurrentLocation();
  }

  Future<void> initMapStyle() async {
    if (!mounted || googleMapController == null) return;

    var nightMapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/night_map_style.json');

    googleMapController?.setMapStyle(nightMapStyle);
  }

  void updateCurrentLocation() {
    if (!mounted || googleMapController == null) return;
    try {
      mapServices.updateCurrentLocation(
        onUpdatecurrentLocation: () {
          if (!mounted) return; // Ensure the widget is mounted
          setState(() {});
          if (locationUpdateTimer == null || !locationUpdateTimer!.isActive) {
            locationUpdateTimer =
                Timer.periodic(const Duration(seconds: 2), (timer) {
              if (mounted &&
                  googleMapController != null &&
                  markers.isNotEmpty) {
                final currentLocation = markers.first.position;
                setState(() {
                  DriverSetCurrentLocationCubit.get(context).setCurrentLocation(
                    lng: currentLocation.longitude.toString(),
                    lat: currentLocation.latitude.toString(),
                  );
                });
              }
            });
          }
        },
        googleMapController: googleMapController!,
        markers: markers,
      );
    } catch (e) {}
  }

  late Map<int, String> requestStatus = {};
  late Map<int, String> nearBy = {};
  late Map<int, String> makeOffer = {};
  late Map<int, String> activeRide = {};

  Future<void> _loadNearByStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final statusCount = prefs.getInt('nearBy') ?? 0;

    setState(() {
      requestStatus = {
        for (var i in List.generate(statusCount, (i) => i))
          statusCount - 1 - i:
              prefs.getString('nearBy_status_${statusCount - 1 - i}') ??
                  'nearBy_default'
      };
      log("Loaded requestStatus in reverse order: $requestStatus");
    });
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final statusCount = prefs.getInt('status_Count') ?? 0;

    setState(() {
      requestStatus = {
        for (var i in List.generate(statusCount, (i) => i))
          statusCount - 1 - i:
              prefs.getString('status_${statusCount - 1 - i}') ?? 'default'
      };
      log("Loaded requestStatus in reverse order: $requestStatus");
    });
  }

  Future<void> _loadMakerOfferStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final statusCount = prefs.getInt('makeOffer') ?? 0;

    setState(() {
      requestStatus = {
        for (var i in List.generate(statusCount, (i) => i))
          statusCount - 1 - i:
              prefs.getString('makeOffer_status_${statusCount - 1 - i}') ??
                  'makeOffer_default'
      };
      log("Loaded requestStatus in reverse order: $requestStatus");
    });
  }

  Future<void> _loadActiveRideStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final statusCount = prefs.getInt('activeRide') ?? 0;

    setState(() {
      requestStatus = {
        for (var i in List.generate(statusCount, (i) => i))
          statusCount - 1 - i:
              prefs.getString('activeRide_status_${statusCount - 1 - i}') ??
                  'activeRide_default'
      };
      log("Loaded requestStatus in reverse order: $requestStatus");
    });
  }

  Future<void> _saveMakeOfferStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('makeOffer', requestStatus.length);
    requestStatus.forEach((index, status) async {
      await prefs.setString('makeOffer_status_$index', status);
      log("Saved status for index $index: $status");
    });
  }

  Future<void> _saveNearByStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('nearBy', requestStatus.length);
    requestStatus.forEach((index, status) async {
      await prefs.setString('nearBy_status_$index', status);
      log("Saved status for index $index: $status");
    });
  }

  Future<void> _saveStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('status_Count', requestStatus.length);
    requestStatus.forEach((index, status) async {
      await prefs.setString('status_$index', status);
      log("Saved status for index $index: $status");
    });
  }

  Future<void> _saveActiveRideStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('activeRide', requestStatus.length);
    requestStatus.forEach((index, status) async {
      await prefs.setString('activeRide_status_$index', status);
      log("Saved status for index $index: $status");
    });
  }

  void _startOfferCheck() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      setState(() {
        CaptainGetActiveRideCubit.get(context).getCaptainActiveRides();
        CaptainGetOfferCubit.get(context).getCaptainRideOffer();
        CaptainGetRequestsCubit.get(context).getCaptainRequests();
      });
    });
  }

  CaptainGetOfferModel? captainGetOfferModel;

  CaptainGetRideModel? captainGetRideModel;

  List<LatLng> _routePoints = [];

  bool _isRouteInitialized = false;

  Future<void> _updateMap(LatLng destination) async {
    if (_isRouteInitialized) {
      return;
    }

    if (captainGetRideModel != null &&
        captainGetRideModel!.data != null &&
        captainGetRideModel!.data!.ride != null &&
        captainGetRideModel!.data!.ride!.offer != null) {
      try {
        // Use the passed destination
        desintation = destination;

        // Fetch the route data only if it's not initialized
        if (!_isRouteInitialized) {
          final points = await mapServices.getRouteData(
            desintation: desintation,
          );

          setState(() {
            _routePoints = points;
            _isRouteInitialized = true;
          });
        }

        if (googleMapController != null) {
          mapServices.displayRoute(
            _routePoints,
            polyLines: polyLines,
            googleMapController: googleMapController!,
          );
        }
      } catch (e) {
        print('Error updating map: $e');
      }
    }
  }

  bool _isRecording = false;
  late CameraController _cameraController;

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.low);
    await _cameraController.initialize();
  }

  _startRecording() async {
    if (_isRecording) {
      return;
    }
    if (!_isRecording) {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  _stopRecording() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);

      context.read<CameraModelCubit>().uploadVideo(
          rideId: captainGetRideModel!.data!.ride!.id, video: File(file.path));
    }
  }

  List<UserEntity>? users;
  String? currentUserEmail;

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              polylines: polyLines,
              markers: markers,
              onMapCreated: (controller) {
                googleMapController = controller;
                if (mounted) {
                  initMapStyle();
                  updateCurrentLocation();
                }
              },
              zoomControlsEnabled: false,
              initialCameraPosition: initalCameraPoistion,
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  CustomTextField(
                    textEditingController: textEditingController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomListView(
                    onPlaceSelect: (placeDetailsModel) async {
                      textEditingController.clear();
                      places.clear();
                      sesstionToken = null;
                      if (mounted) {
                        setState(() {}); // Check if the widget is still mounted
                      }

                      desintation = LatLng(
                          placeDetailsModel.geometry!.location!.lat!,
                          placeDetailsModel.geometry!.location!.lng!);

                      var points = await mapServices.getRouteData(
                          desintation: desintation);
                      if (googleMapController != null) {
                        try {
                          mapServices.displayRoute(
                            points,
                            polyLines: polyLines,
                            googleMapController: googleMapController!,
                          );
                        } catch (e) {
                          // Handle errors in route display
                        }
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    places: places,
                    mapServices: mapServices,
                  ),
                ],
              ),
            ),
            BlocConsumer<CaptainGetOfferCubit, CaptainGetOfferState>(
              listener: (context, state) {
                if (state is CaptainGetOfferSuccess) {
                  if (state.captainGetOfferModel.status) {
                    setState(() {
                      captainGetOfferModel = state.captainGetOfferModel;
                    });
                  } else {
                    // print(state.captainGetOfferModel.message);
                    // showToast(
                    //   message: state.captainGetOfferModel.message,
                    //   color: Colors.red,
                    // );
                  }
                }
                if (state is CaptainGetOfferFailure) {
                  // showToast(
                  //   message: state.message,
                  //   color: Colors.red,
                  // );
                }
              },
              builder: (context, state) {
                return BlocConsumer<CaptainGetRequestsCubit,
                    CaptainGetRequestsState>(
                  listener: (context, state) {
                    if (state is CaptainGetRequestsSuccess) {
                      if (state.captainGetRequestModel.status) {
                        setState(() {
                          captainGetRequestModel = state.captainGetRequestModel;
                        });
                      } else {
                        // print(state.captainGetRequestModel.message);
                        // showToast(
                        //   message: state.captainGetRequestModel.message,
                        //   color: Colors.red,
                        // );
                      }
                    }
                    if (state is CaptainGetRequestsFailure) {
                      // showToast(
                      //   message: state.message,
                      //   color: Colors.red,
                      // );
                    }
                  },
                  builder: (context, state) {
                    return BlocConsumer<CaptainGetActiveRideCubit,
                        CaptainGetActiveRideState>(
                      listener: (context, state) async {
                        if (state is CaptainGetActiveRideSuccess) {
                          if (state.captainGetRideModel.status) {
                            setState(() {
                              captainGetRideModel = state.captainGetRideModel;
                            });
                            if (!_isRouteInitialized) {
                              final enLat = double.parse(captainGetRideModel!
                                  .data!.ride!.offer!.request!.stLat);
                              final enLng = double.parse(captainGetRideModel!
                                  .data!.ride!.offer!.request!.stLng);

                              desintation = LatLng(enLat, enLng);
                              await _updateMap(desintation);
                            }
                          } else {
                            // print(state.captainGetRideModel.message);
                            // showToast(
                            //   message: state.captainGetRideModel.message,
                            //   color: Colors.red,
                            // );
                          }
                        }
                        if (state is CaptainGetActiveRideFailure) {
                          // showToast(
                          //   message: state.message,
                          //   color: Colors.red,
                          // );
                        }
                      },
                      builder: (context, state) {
                        if (captainGetRideModel != null &&
                            captainGetRideModel!.data != null &&
                            captainGetRideModel!.data!.ride != null &&
                            captainGetRideModel!.data!.ride!.offer != null) {
                          final activeRideStatus =
                              activeRide[0] ?? 'activeRide_default';

                          // final filteredUsers = users!
                          //     .where((user) => user.email != currentUserEmail)
                          //     .toList();
                          // final selectedUser = filteredUsers.first;
                          return Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    color: Color(0xff263c3f),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        isArabic ? 'رحلة نشطة' : 'Active Ride',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: BlocConsumer<
                                            CaptainCancelOfferCubit,
                                            CaptainCancelOfferState>(
                                          listener: (context, state) {
                                            if (state
                                                is CaptainCancelOfferSuccess) {
                                              if (state
                                                  .cancelOfferModel.status) {
                                                showToast(
                                                  message: state
                                                      .cancelOfferModel.message,
                                                  color: Colors.green,
                                                );
                                                setState(() {
                                                  activeRide[0] =
                                                      'activeRide_canceled';
                                                  _routePoints
                                                      .clear(); // Clear the route points
                                                  _isRouteInitialized =
                                                      false; // Reset the route initialization flag
                                                  polyLines
                                                      .clear(); // Clear the polylines
                                                  _saveActiveRideStatus(); // Save status to SharedPreferences
                                                });
                                                if (_isRecording) {
                                                  _stopRecording();
                                                }
                                              } else {
                                                print(state
                                                    .cancelOfferModel.message);
                                                print(
                                                    'تاكد من البيانات المدخله');
                                                showToast(
                                                  message: state
                                                      .cancelOfferModel.message,
                                                  color: Colors.red,
                                                );
                                              }
                                            }
                                            if (state
                                                is CaptainCancelOfferFailure) {
                                              showToast(
                                                message: state.message,
                                                color: Colors.red,
                                              );
                                            }
                                          },
                                          builder: (context, state) {
                                            return BlocConsumer<
                                                SetRideCompleteCubit,
                                                SetRideCompleteState>(
                                              listener: (context, state) {
                                                if (state
                                                    is SetRideCompleteSuccess) {
                                                  if (state.setRideCompleteModel
                                                      .status) {
                                                    showToast(
                                                      message: state
                                                          .setRideCompleteModel
                                                          .message,
                                                      color: Colors.green,
                                                    );
                                                    setState(() {
                                                      activeRide[0] =
                                                          'activeRide_complete';
                                                      _routePoints
                                                          .clear(); // Clear the route points
                                                      _isRouteInitialized =
                                                          false; // Reset the route initialization flag
                                                      polyLines
                                                          .clear(); // Clear the polylines
                                                      _saveActiveRideStatus();
                                                    });
                                                    if (_isRecording) {
                                                      _stopRecording();
                                                    }
                                                  } else {
                                                    print(state
                                                        .setRideCompleteModel
                                                        .message);
                                                    print(
                                                        'تاكد من البيانات المدخله');
                                                    showToast(
                                                      message: state
                                                          .setRideCompleteModel
                                                          .message,
                                                      color: Colors.red,
                                                    );
                                                  }
                                                }
                                                if (state
                                                    is SetRideCompleteFailure) {
                                                  showToast(
                                                    message: state.message,
                                                    color: Colors.red,
                                                  );
                                                }
                                              },
                                              builder: (context, state) {
                                                return BlocConsumer<
                                                    SetArriveRideCubit,
                                                    SetArriveRideState>(
                                                  listener: (context, state) {
                                                    if (state
                                                        is SetArriveRideSuccess) {
                                                      if (state
                                                          .setArriveRideModel
                                                          .status) {
                                                        showToast(
                                                          message: state
                                                              .setArriveRideModel
                                                              .message,
                                                          color: Colors.green,
                                                        );
                                                        setState(() {
                                                          activeRide[0] =
                                                              'activeRide_arrive';
                                                          _saveActiveRideStatus();
                                                          setState(() {
                                                            _isRouteInitialized =
                                                                false;

                                                            final enLat =
                                                                double.parse(
                                                                    captainGetRideModel!
                                                                        .data!
                                                                        .ride!
                                                                        .offer!
                                                                        .request!
                                                                        .enLat);
                                                            final enLng =
                                                                double.parse(
                                                                    captainGetRideModel!
                                                                        .data!
                                                                        .ride!
                                                                        .offer!
                                                                        .request!
                                                                        .enLng);

                                                            LatLng endLocation =
                                                                LatLng(enLat,
                                                                    enLng);

                                                            // Call updateMap with the new destination
                                                            _updateMap(
                                                                endLocation);
                                                          });
                                                        });
                                                        if (!_isRecording) {
                                                          _startRecording();
                                                        }
                                                      } else {
                                                        print(state
                                                            .setArriveRideModel
                                                            .message);
                                                        print(
                                                            'تاكد من البيانات المدخله');
                                                        showToast(
                                                          message: state
                                                              .setArriveRideModel
                                                              .message,
                                                          color: Colors.red,
                                                        );
                                                      }
                                                    }
                                                    if (state
                                                        is SetArriveRideFailure) {
                                                      showToast(
                                                        message: state.message,
                                                        color: Colors.red,
                                                      );
                                                    }
                                                  },
                                                  builder: (context, state) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        color: const Color(
                                                            0xFFF3F3F3),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            blurRadius: 5,
                                                            spreadRadius: 0.5,
                                                            offset:
                                                                Offset(0, 0),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: isArabic
                                                            ? Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        captainGetRideModel!
                                                                            .data!
                                                                            .ride!
                                                                            .offer!
                                                                            .request!
                                                                            .stLocation,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0XFF919191),
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      const Text(
                                                                          ": من"),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        captainGetRideModel!
                                                                            .data!
                                                                            .ride!
                                                                            .offer!
                                                                            .request!
                                                                            .enLocation,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0XFF919191),
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      const Text(
                                                                          ": الي"),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Image.asset(
                                                                          'assets/images/location (1).png'),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                          '${double.tryParse(captainGetRideModel!.data!.ride!.offer!.request!.distance.toString())?.toStringAsFixed(1)}'),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      const Text(
                                                                        'Km away',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0XFF919191),
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Divider(
                                                                    color: Colors
                                                                        .black26,
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                  isArabic
                                                                      ? Row(
                                                                          children: [
                                                                            Image.asset('assets/images/phone.png'),
                                                                            const SizedBox(width: 10),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                // Navigator
                                                                                //     .pushReplacement(
                                                                                //   context,
                                                                                //   MaterialPageRoute(
                                                                                //     builder:
                                                                                //         (context) =>
                                                                                //             ChatView(
                                                                                //       receiverEmail:
                                                                                //           selectedUser.email,
                                                                                //       receiverName:
                                                                                //           selectedUser.name,
                                                                                //       receiverProfileImageUrl:
                                                                                //           selectedUser.profileImageUrl,
                                                                                //     ),
                                                                                //   ),
                                                                                // );
                                                                              },
                                                                              child: Image.asset('assets/images/chat.png'),
                                                                            ),
                                                                            const Spacer(),
                                                                            const Text(
                                                                              'ج',
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 5),
                                                                            Text(
                                                                              double.parse(captainGetRideModel!.data!.ride!.offer!.request!.price.toString()).toStringAsFixed(2),
                                                                              style: const TextStyle(
                                                                                fontSize: 20,
                                                                                color: Color(0xFF0A8800),
                                                                              ),
                                                                            ),
                                                                            const Text(
                                                                              ": السعر  ",
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Row(
                                                                          children: [
                                                                            const Text(
                                                                              "Price : ",
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              double.parse(captainGetRideModel!.data!.ride!.offer!.request!.price.toString()).toStringAsFixed(2),
                                                                              style: const TextStyle(
                                                                                fontSize: 20,
                                                                                color: Color(0xFF0A8800),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 5),
                                                                            const Text(
                                                                              'EGP',
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                              ),
                                                                            ),
                                                                            const Spacer(),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                // Navigator
                                                                                //     .pushReplacement(
                                                                                //   context,
                                                                                //   MaterialPageRoute(
                                                                                //     builder:
                                                                                //         (context) =>
                                                                                //             ChatView(
                                                                                //       receiverEmail:
                                                                                //           selectedUser.email,
                                                                                //       receiverName:
                                                                                //           selectedUser.name,
                                                                                //       receiverProfileImageUrl:
                                                                                //           selectedUser.profileImageUrl,
                                                                                //     ),
                                                                                //   ),
                                                                                // );
                                                                              },
                                                                              child: Image.asset('assets/images/chat.png'),
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            Image.asset('assets/images/phone.png'),
                                                                          ],
                                                                        ),
                                                                  const SizedBox(
                                                                      height:
                                                                          25),
                                                                  // if (activeRideStatus ==
                                                                  //         'activeRide_canceled' ||
                                                                  //     activeRideStatus ==
                                                                  //         'activeRide_complete')
                                                                  //   const SizedBox()
                                                                  // else
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      if (activeRideStatus ==
                                                                          'activeRide_arrive')
                                                                        Expanded(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: customMapButton(
                                                                                  title: isArabic ? 'اكتمل' : 'Complete',
                                                                                  function: () {
                                                                                    SetRideCompleteCubit.get(context).captainSetCompleteRide();
                                                                                  },
                                                                                  color: Colors.green,
                                                                                  width: 0,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 10),
                                                                              Expanded(
                                                                                child: customMapButton(
                                                                                  title: isArabic ? 'الغاء' : 'Cancel',
                                                                                  function: () {
                                                                                    showCancelConfirmation(
                                                                                      context,
                                                                                    );
                                                                                  },
                                                                                  color: Colors.red,
                                                                                  width: 0,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      else
                                                                        Expanded(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: customMapButton(
                                                                                  title: isArabic ? 'وصلت' : 'Arrive',
                                                                                  function: () {
                                                                                    SetArriveRideCubit.get(context).captainSetArriveRide();

                                                                                    setState(() {
                                                                                      activeRide[0] = 'activeRide_arrive';
                                                                                      _saveActiveRideStatus();
                                                                                    });
                                                                                  },
                                                                                  color: Colors.green,
                                                                                  width: 0,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 10),
                                                                              Expanded(
                                                                                child: customMapButton(
                                                                                  title: isArabic ? 'الغاء' : 'Cancel',
                                                                                  function: () {
                                                                                    showCancelConfirmation(
                                                                                      context,
                                                                                    );
                                                                                  },
                                                                                  color: Colors.red,
                                                                                  width: 0,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            : Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    children: [
                                                                      const Text(
                                                                          "From :   "),
                                                                      Text(
                                                                        captainGetRideModel!
                                                                            .data!
                                                                            .ride!
                                                                            .offer!
                                                                            .request!
                                                                            .stLocation,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0XFF919191),
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                  Row(
                                                                    children: [
                                                                      const Text(
                                                                          "To :       "),
                                                                      Text(
                                                                        captainGetRideModel!
                                                                            .data!
                                                                            .ride!
                                                                            .offer!
                                                                            .request!
                                                                            .enLocation,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0XFF919191),
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          15),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Image.asset(
                                                                          'assets/images/location (1).png'),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                          '${double.tryParse(captainGetRideModel!.data!.ride!.offer!.request!.distance.toString())?.toStringAsFixed(1)}'),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      const Text(
                                                                        'Km away',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0XFF919191),
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Divider(
                                                                    color: Colors
                                                                        .black26,
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Text(
                                                                        "Price : ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        double.parse(captainGetRideModel!.data!.ride!.offer!.request!.price.toString())
                                                                            .toStringAsFixed(2),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Color(0xFF0A8800),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      const Text(
                                                                        'EGP',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                      const Spacer(),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          // Navigator
                                                                          //     .pushReplacement(
                                                                          //   context,
                                                                          //   MaterialPageRoute(
                                                                          //     builder:
                                                                          //         (context) =>
                                                                          //             ChatView(
                                                                          //       receiverEmail:
                                                                          //           selectedUser.email,
                                                                          //       receiverName:
                                                                          //           selectedUser.name,
                                                                          //       receiverProfileImageUrl:
                                                                          //           selectedUser.profileImageUrl,
                                                                          //     ),
                                                                          //   ),
                                                                          // );
                                                                        },
                                                                        child: Image.asset(
                                                                            'assets/images/chat.png'),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              10),
                                                                      Image.asset(
                                                                          'assets/images/phone.png'),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          25),
                                                                  // if (activeRideStatus ==
                                                                  //         'activeRide_canceled' ||
                                                                  //     activeRideStatus ==
                                                                  //         'activeRide_complete')
                                                                  //   const SizedBox()
                                                                  // else
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      if (activeRideStatus ==
                                                                          'activeRide_arrive')
                                                                        Expanded(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: customMapButton(
                                                                                  title: 'Complete',
                                                                                  function: () {
                                                                                    SetRideCompleteCubit.get(context).captainSetCompleteRide();
                                                                                  },
                                                                                  color: Colors.green,
                                                                                  width: 0,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 10),
                                                                              Expanded(
                                                                                child: customMapButton(
                                                                                  title: 'Cancel',
                                                                                  function: () {
                                                                                    showCancelConfirmation(
                                                                                      context,
                                                                                    );
                                                                                  },
                                                                                  color: Colors.red,
                                                                                  width: 0,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      else
                                                                        Expanded(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: customMapButton(
                                                                                  title: 'Arrive',
                                                                                  function: () {
                                                                                    SetArriveRideCubit.get(context).captainSetArriveRide();

                                                                                    setState(() {
                                                                                      activeRide[0] = 'activeRide_arrive';
                                                                                      _saveActiveRideStatus();
                                                                                    });
                                                                                  },
                                                                                  color: Colors.green,
                                                                                  width: 0,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 10),
                                                                              Expanded(
                                                                                child: customMapButton(
                                                                                  title: 'Cancel',
                                                                                  function: () {
                                                                                    showCancelConfirmation(
                                                                                      context,
                                                                                    );
                                                                                  },
                                                                                  color: Colors.red,
                                                                                  width: 0,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_isRecording)
                                isArabic
                                    ? Positioned(
                                        bottom: 150,
                                        left: 0,
                                        width: 120,
                                        height: 120,
                                        child: CameraPreview(_cameraController),
                                      )
                                    : Positioned(
                                        bottom: 150,
                                        right: 0,
                                        width: 120,
                                        height: 120,
                                        child: CameraPreview(_cameraController),
                                      ),
                            ],
                          );
                        } else if (captainGetOfferModel != null &&
                            captainGetOfferModel!.data != null &&
                            captainGetOfferModel!.data!.offers.isNotEmpty) {
                          return Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xff263c3f),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Offers',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      itemCount: captainGetOfferModel!
                                              .data?.offers.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final reversedIndex =
                                            (captainGetOfferModel!
                                                        .data?.offers.length ??
                                                    0) -
                                                1 -
                                                index;
                                        final request = captainGetOfferModel!
                                            .data?.offers[reversedIndex];
                                        final status =
                                            makeOffer[reversedIndex] ??
                                                'makeOffer_default';

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: BlocConsumer<
                                              CaptainCancelRideOfferCubit,
                                              CaptainCancelRideOfferState>(
                                            listener: (context, state) {
                                              if (state
                                                  is CaptainCancelRideOfferSuccess) {
                                                if (state
                                                    .captainCancelRideOfferModel
                                                    .status) {
                                                  showToast(
                                                    message: state
                                                        .captainCancelRideOfferModel
                                                        .message,
                                                    color: Colors.green,
                                                  );
                                                  setState(() {
                                                    makeOffer[reversedIndex] =
                                                        'make_offer_canceled';
                                                    _saveMakeOfferStatus();
                                                  });
                                                } else {
                                                  print(state
                                                      .captainCancelRideOfferModel
                                                      .message);
                                                  print(
                                                      'تاكد من البيانات المدخله');
                                                  showToast(
                                                    message: state
                                                        .captainCancelRideOfferModel
                                                        .message,
                                                    color: Colors.red,
                                                  );
                                                }
                                              }
                                              if (state
                                                  is CaptainCancelRideOfferFailure) {
                                                showToast(
                                                  message: state.message,
                                                  color: Colors.red,
                                                );
                                              }
                                            },
                                            builder: (context, state) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color:
                                                      const Color(0xFFF3F3F3),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 5,
                                                      spreadRadius: 0.5,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              "From :   "),
                                                          Text(
                                                            request!.request
                                                                .stLocation,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0XFF919191),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              "To :       "),
                                                          Text(
                                                            request.request
                                                                .enLocation,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0XFF919191),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                              'assets/images/location (1).png'),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                              '${double.tryParse(request.request.distance.toString())?.toStringAsFixed(1)}'),
                                                          const SizedBox(
                                                              width: 5),
                                                          const Text(
                                                            'Km away',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0XFF919191),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(
                                                        color: Colors.black26,
                                                        thickness: 1,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            "Price : ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Text(
                                                            double.parse(request
                                                                    .price
                                                                    .toString())
                                                                .toStringAsFixed(
                                                                    2),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              color: Color(
                                                                  0xFF0A8800),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          const Text(
                                                            'EGP',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 25),
                                                      if (status ==
                                                          'make_offer_canceled')
                                                        const SizedBox()
                                                      else
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        customMapButton(
                                                                      title:
                                                                          'Wait..',
                                                                      function:
                                                                          () {},
                                                                      color: const Color(
                                                                          0xFF6D6D6D),
                                                                      width: 0,
                                                                      height:
                                                                          40,
                                                                      enabled:
                                                                          false,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Expanded(
                                                                    child:
                                                                        customMapButton(
                                                                      title:
                                                                          'Cancel',
                                                                      function:
                                                                          () {
                                                                        showCancel(
                                                                            context,
                                                                            index:
                                                                                reversedIndex,
                                                                            offerId:
                                                                                request.id);
                                                                      },
                                                                      color: Colors
                                                                          .red,
                                                                      width: 0,
                                                                      height:
                                                                          40,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (captainGetOfferModel != null &&
                            captainGetOfferModel!.data != null &&
                            captainGetOfferModel!.data!.offers.isNotEmpty &&
                            captainGetRequestModel != null &&
                            captainGetRequestModel!.data != null &&
                            captainGetRequestModel!.data!.requests.isNotEmpty) {
                          return Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xff263c3f),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    isArabic ? 'العروض' : 'Offers',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      itemCount: captainGetOfferModel!
                                              .data?.offers.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final reversedIndex =
                                            (captainGetOfferModel!
                                                        .data?.offers.length ??
                                                    0) -
                                                1 -
                                                index;
                                        final request = captainGetOfferModel!
                                            .data?.offers[reversedIndex];
                                        final status =
                                            makeOffer[reversedIndex] ??
                                                'makeOffer_default';

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: BlocConsumer<
                                              CaptainCancelRideOfferCubit,
                                              CaptainCancelRideOfferState>(
                                            listener: (context, state) {
                                              if (state
                                                  is CaptainCancelRideOfferSuccess) {
                                                if (state
                                                    .captainCancelRideOfferModel
                                                    .status) {
                                                  showToast(
                                                    message: state
                                                        .captainCancelRideOfferModel
                                                        .message,
                                                    color: Colors.green,
                                                  );
                                                  setState(() {
                                                    makeOffer[reversedIndex] =
                                                        'make_offer_canceled';
                                                    _saveMakeOfferStatus();
                                                  });
                                                } else {
                                                  print(state
                                                      .captainCancelRideOfferModel
                                                      .message);
                                                  print(
                                                      'تاكد من البيانات المدخله');
                                                  showToast(
                                                    message: state
                                                        .captainCancelRideOfferModel
                                                        .message,
                                                    color: Colors.red,
                                                  );
                                                }
                                              }
                                              if (state
                                                  is CaptainCancelRideOfferFailure) {
                                                showToast(
                                                  message: state.message,
                                                  color: Colors.red,
                                                );
                                              }
                                            },
                                            builder: (context, state) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color:
                                                      const Color(0xFFF3F3F3),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 5,
                                                      spreadRadius: 0.5,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              "From :   "),
                                                          Text(
                                                            request!.request
                                                                .stLocation,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0XFF919191),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              "To :       "),
                                                          Text(
                                                            request.request
                                                                .enLocation,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0XFF919191),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                              'assets/images/location (1).png'),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                              '${double.tryParse(request.request.distance.toString())?.toStringAsFixed(1)}'),
                                                          const SizedBox(
                                                              width: 5),
                                                          const Text(
                                                            'Km away',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0XFF919191),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(
                                                        color: Colors.black26,
                                                        thickness: 1,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            "Price : ",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Text(
                                                            double.parse(request
                                                                    .price
                                                                    .toString())
                                                                .toStringAsFixed(
                                                                    2),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              color: Color(
                                                                  0xFF0A8800),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          const Text(
                                                            'EGP',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 25),
                                                      if (status ==
                                                          'make_offer_canceled')
                                                        const SizedBox()
                                                      else
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        customMapButton(
                                                                      title:
                                                                          'Wait..',
                                                                      function:
                                                                          () {},
                                                                      color: const Color(
                                                                          0xFF6D6D6D),
                                                                      width: 0,
                                                                      height:
                                                                          40,
                                                                      enabled:
                                                                          false,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Expanded(
                                                                    child:
                                                                        customMapButton(
                                                                      title:
                                                                          'Cancel',
                                                                      function:
                                                                          () {
                                                                        showCancel(
                                                                            context,
                                                                            index:
                                                                                reversedIndex,
                                                                            offerId:
                                                                                request.id);
                                                                      },
                                                                      color: Colors
                                                                          .red,
                                                                      width: 0,
                                                                      height:
                                                                          40,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (captainGetRequestModel != null &&
                            captainGetRequestModel!.data != null &&
                            captainGetRequestModel!.data!.requests.isNotEmpty) {
                          return Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xff263c3f),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    isArabic
                                        ? 'الرحلات القريبة'
                                        : 'Nearby Rides',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      itemCount: captainGetRequestModel!
                                              .data?.requests.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        final reversedIndex =
                                            (captainGetRequestModel!.data
                                                        ?.requests.length ??
                                                    0) -
                                                1 -
                                                index;
                                        final request = captainGetRequestModel!
                                            .data!.requests[reversedIndex];
                                        final status = nearBy[reversedIndex] ??
                                            'nearBy_default';

                                        log("Request index $reversedIndex has status: $status");

                                        return BlocConsumer<
                                            CaptainMakeOfferCubit,
                                            CaptainMakeOfferState>(
                                          listener: (context, state) {
                                            if (state
                                                is CaptainMakeOfferSuccess) {
                                              if (state.captainMakeOfferModel
                                                  .status) {
                                                showToast(
                                                  message: isArabic
                                                      ? 'تم تقديم العرض'
                                                      : 'Make Offer Done',
                                                  color: Colors.green,
                                                );
                                                setState(() {
                                                  requestStatus[reversedIndex] =
                                                      'make_Offer';
                                                  _saveStatus();
                                                });
                                              } else {
                                                print(state
                                                    .captainMakeOfferModel
                                                    .message);
                                                print(
                                                    'تاكد من البيانات المدخله');
                                                showToast(
                                                  message: state
                                                      .captainMakeOfferModel
                                                      .message,
                                                  color: Colors.red,
                                                );
                                              }
                                            }
                                            if (state
                                                is CaptainMakeOfferFailure) {
                                              showToast(
                                                message: state.message,
                                                color: Colors.red,
                                              );
                                            }
                                          },
                                          builder: (context, state) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color:
                                                      const Color(0xFFF3F3F3),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 5,
                                                      spreadRadius: 0.5,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: isArabic
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    request
                                                                        .stLocation,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0XFF919191),
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                const Text(
                                                                    ": من"),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    maxLines: 2,
                                                                    request
                                                                        .enLocation,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0XFF919191),
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                const Text(
                                                                    ": الي"),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 15),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    'assets/images/location (1).png'),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                    '${double.tryParse(request.distance.toString())?.toStringAsFixed(1)}'),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const Text(
                                                                  'Km away',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0XFF919191),
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const Divider(
                                                              color: Colors
                                                                  .black26,
                                                              thickness: 1,
                                                            ),
                                                            isArabic
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      const Text(
                                                                        'ج',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                        double.parse(request.price?.toString() ??
                                                                                "0.0")
                                                                            .toStringAsFixed(2),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Color(0xFF0A8800),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      const Text(
                                                                        ": السعر",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      const Text(
                                                                        "Price : ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        double.parse(request.price?.toString() ??
                                                                                "0.0")
                                                                            .toStringAsFixed(2),
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Color(0xFF0A8800),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      const Text(
                                                                        'EGP',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            const SizedBox(
                                                                height: 25),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                if (status ==
                                                                    'make_offer')
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              customMapButton(
                                                                            title: isArabic
                                                                                ? 'انتظر..'
                                                                                : 'Wait..',
                                                                            function:
                                                                                () {},
                                                                            color:
                                                                                Colors.grey,
                                                                            width:
                                                                                0,
                                                                            height:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                else
                                                                  Expanded(
                                                                    child:
                                                                        customMapButton(
                                                                      title: isArabic
                                                                          ? 'تقديم عرض'
                                                                          : 'Make Offer',
                                                                      function:
                                                                          () {
                                                                        CaptainMakeOfferCubit.get(context)
                                                                            .captainMakeOffer(
                                                                          price:
                                                                              request.price ?? 100,
                                                                          requestId:
                                                                              request.id,
                                                                        );
                                                                        setState(
                                                                            () {
                                                                          nearBy[reversedIndex] =
                                                                              'make_offer';
                                                                          _saveNearByStatus();
                                                                        });
                                                                      },
                                                                      color: Colors
                                                                          .green,
                                                                      width: 0,
                                                                      height:
                                                                          40,
                                                                    ),
                                                                  )
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                    "From :   "),
                                                                Text(
                                                                  request
                                                                      .stLocation,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0XFF919191),
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                    "To :       "),
                                                                Text(
                                                                  request
                                                                      .enLocation,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0XFF919191),
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 15),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    'assets/images/location (1).png'),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                    '${double.tryParse(request.distance.toString())?.toStringAsFixed(1)}'),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const Text(
                                                                  'Km away',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0XFF919191),
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const Divider(
                                                              color: Colors
                                                                  .black26,
                                                              thickness: 1,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  "Price : ",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  double.parse(request
                                                                              .price
                                                                              ?.toString() ??
                                                                          "0.0")
                                                                      .toStringAsFixed(
                                                                          2),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Color(
                                                                        0xFF0A8800),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                const Text(
                                                                  'EGP',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 25),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                if (status ==
                                                                    'make_offer')
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              customMapButton(
                                                                            title:
                                                                                'Wait..',
                                                                            function:
                                                                                () {},
                                                                            color:
                                                                                Colors.grey,
                                                                            width:
                                                                                0,
                                                                            height:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                else
                                                                  Expanded(
                                                                    child:
                                                                        customMapButton(
                                                                      title:
                                                                          'Make Offer',
                                                                      function:
                                                                          () {
                                                                        CaptainMakeOfferCubit.get(context)
                                                                            .captainMakeOffer(
                                                                          price:
                                                                              request.price ?? 100,
                                                                          requestId:
                                                                              request.id,
                                                                        );
                                                                        setState(
                                                                            () {
                                                                          nearBy[reversedIndex] =
                                                                              'make_offer';
                                                                          _saveNearByStatus();
                                                                        });
                                                                      },
                                                                      color: Colors
                                                                          .green,
                                                                      width: 0,
                                                                      height:
                                                                          40,
                                                                    ),
                                                                  )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showCancelConfirmation(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => CaptainCancelOfferCubit(),
          child: BlocConsumer<CaptainCancelOfferCubit, CaptainCancelOfferState>(
            listener: (context, state) {
              if (state is CaptainCancelOfferSuccess) {
                // Show success message or perform an action
                Navigator.pop(dialogContext); // Close the dialog
                showToast(
                    message: 'Ride canceled successfully', color: Colors.green);
                setState(() {
                  _routePoints.clear(); // Clear the route points
                  _isRouteInitialized =
                      false; // Reset the route initialization flag
                  polyLines.clear(); // Clear the polylines
                });
                if (_isRecording) {
                  _stopRecording();
                }
              } else if (state is CaptainCancelOfferFailure) {
                // Show failure message
                showToast(message: state.message, color: Colors.red);
              }
            },
            builder: (context, state) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffF2F2F2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/iconamoon_question-mark-circle.png',
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Are you sure that you want to cancel this ride?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontFamily: 'PoppinsBold',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      customMapButton(
                        width: double.infinity,
                        height: 50,
                        title: 'Cancel',
                        color: Colors.red,
                        function: () {
                          CaptainCancelOfferCubit.get(context)
                              .captainCancelOffer();
                          setState(() {
                            activeRide[0] = 'activeRide_canceled';
                            _saveActiveRideStatus();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showCancel(BuildContext context,
      {required int index, required int offerId}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => CaptainCancelRideOfferCubit(),
          child: BlocConsumer<CaptainCancelRideOfferCubit,
              CaptainCancelRideOfferState>(
            listener: (context, state) {
              if (state is CaptainCancelRideOfferSuccess) {
                // Show success message or perform an action
                Navigator.pop(dialogContext); // Close the dialog
                showToast(message: 'Offer canceled', color: Colors.green);
              } else if (state is CaptainCancelRideOfferFailure) {
                // Show failure message
                showToast(message: state.message, color: Colors.red);
              }
            },
            builder: (context, state) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffF2F2F2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/iconamoon_question-mark-circle.png',
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Are you sure that you want to cancel this offer?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontFamily: 'PoppinsBold',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      customMapButton(
                        width: double.infinity,
                        height: 50,
                        title: 'Cancel',
                        color: Colors.red,
                        function: () {
                          CaptainCancelRideOfferCubit.get(context)
                              .captainCancelRideOffer(offerId: offerId);
                          setState(() {
                            makeOffer[index] = 'make_offer_canceled';
                            _saveMakeOfferStatus();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    textEditingController.dispose();
    debounce?.cancel();
    dataTimer?.cancel();
    locationUpdateTimer?.cancel();
    _cameraController.dispose();
    mapServices.locationService.stopRealTimeLocationUpdates();

    super.dispose();
  }
}
