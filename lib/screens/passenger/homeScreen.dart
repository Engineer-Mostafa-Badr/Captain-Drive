import 'dart:async';
import 'package:captain_drive/business_logic/maps/maps_cubit.dart';
import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/helpers/location_helper.dart';
import 'package:captain_drive/screens/passenger/notification_screen.dart';
import 'package:captain_drive/screens/passenger/reservation/reservation_start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/repository/maps_repo.dart';
import '../../data/webservices/places_webservices.dart';
import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';
import 'cubit/cubit.dart';
import 'map/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static Position? position;
  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _myCurrentLocation = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  Future<void> getMyCurrentLocation() async {
    await LocationHelper.getCurrentLocation();
    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState(() {});
    });
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: true,
      initialCameraPosition: _myCurrentLocation,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PassengerCubit.get(context).getActivities();
    // Load saved language code from SharedPreferences
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const MapScreen()));
                      },
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: backGroundColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26, // Shadow color
                                  blurRadius: 2, // Softening the shadow
                                  spreadRadius: 0.5, // Extending the shadow
                                  offset: Offset(
                                      0, 0), // No offset to center the shadow
                                ),
                              ],
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(189, 189, 189, 1))),
                          child: const Center(
                              child: Icon(
                            Icons.location_on_outlined,
                            color: primaryColor,
                          ))),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          isArabic ? 'مكانك' : 'Location',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Text(
                          isArabic ? 'مصر' : 'Egypte',
                          style: const TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: backGroundColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26, // Shadow color
                                blurRadius: 2, // Softening the shadow
                                spreadRadius: 0.5, // Extending the shadow
                                offset: Offset(
                                    0, 0), // No offset to center the shadow
                              ),
                            ],
                            border: Border.all(
                                color: const Color.fromRGBO(189, 189, 189, 1))),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationScreen()));
                          },
                          child: const Center(
                              child: Icon(
                            Icons.notifications_none_outlined,
                            color: primaryColor,
                          )),
                        )),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BlocProvider(
                                create: (context) => MapsCubit(
                                    MapsRepository(PlacesWebservices())),
                                child: MapScreen(
                                  booking: false,
                                ))));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromRGBO(
                            67, 67, 67, 0.28), // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 15),
                      child: Row(
                        children: [
                          Container(
                            width: 35,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryColor,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                isArabic
                                    ? 'الي اين ؟ '
                                    : 'where are you going ?',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // BlocConsumer<passengerCubit, PassengerStates>(
              //   listener: (context, state) {},
              //   builder: (context, state) {
              //
              //     var cubit = passengerCubit.get(context).getActivitiesModel?.data?.first.data ?? [];
              //
              //     if (cubit.isEmpty) {
              //       return const Center(
              //         child: Text('No activities available'),
              //       );
              //     }
              //
              //     var request = cubit.first.offer?.request;
              //
              //     return Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: Container(
              //         width: double.infinity,
              //         height: 300,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: primaryColor,
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(10.0),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               const Text(
              //                 'Location Visited:',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //               const SizedBox(height: 10),
              //               Text(
              //                 request?.enLocation ?? 'Unknown Location',
              //                 style: const TextStyle(
              //                   color: Colors.white,
              //                   fontSize: 14,
              //                 ),
              //                 overflow: TextOverflow.ellipsis,
              //                 maxLines: 2,
              //               ),
              //               const Spacer(),
              //               Row(
              //                 children: [
              //                   const Icon(Icons.location_on, color: Colors.white),
              //                   Text(
              //                     'Coordinates: (${request?.enLat ?? '0.0'}, ${request?.enLng ?? '0.0'})',
              //                     style: const TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 14,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      isArabic ? 'اقتراحات' : 'Suggestions',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildItem(
                              name: isArabic ? 'باص' : 'Bus',
                              image: 'assets/images/bus.png',
                              function: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                            create: (context) => MapsCubit(
                                                MapsRepository(
                                                    PlacesWebservices())),
                                            child: MapScreen(
                                              booking: false,
                                            ))));
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          buildItem(
                              name: isArabic ? 'طرد' : 'package',
                              image: 'assets/images/box.png',
                              function: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                            create: (context) => MapsCubit(
                                                MapsRepository(
                                                    PlacesWebservices())),
                                            child: MapScreen(
                                              booking: false,
                                            ))));
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          buildItem(
                              name: isArabic ? 'اسكوتر' : 'Scooter',
                              image: 'assets/images/scooter.png',
                              function: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                            create: (context) => MapsCubit(
                                                MapsRepository(
                                                    PlacesWebservices())),
                                            child: MapScreen(
                                              booking: false,
                                            ))));
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          buildItem(
                              name: isArabic ? 'تاكسي' : 'taxi',
                              image: 'assets/images/taxi.png',
                              function: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                            create: (context) => MapsCubit(
                                                MapsRepository(
                                                    PlacesWebservices())),
                                            child: MapScreen(
                                              booking: false,
                                            ))));
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          buildItem(
                              name: isArabic ? 'عربيه' : 'Car',
                              image: 'assets/images/car1.png',
                              function: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                            create: (context) => MapsCubit(
                                                MapsRepository(
                                                    PlacesWebservices())),
                                            child: MapScreen(
                                              booking: false,
                                            ))));
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      isArabic ? 'خدمات اخري' : 'Other services',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ReservationStart()));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 152,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.black54)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Image.asset('assets/images/reservation.png'),
                            ),
                            Text(
                              isArabic
                                  ? 'احجز رحلتك الان'
                                  : 'Book your trip now',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(
      {required String image, required String name, required var function}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
            border: Border.all(color: Colors.black54)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(width: 60, height: 50, child: Image.asset(image)),
              const SizedBox(
                height: 5,
              ),
              Text(
                name,
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
