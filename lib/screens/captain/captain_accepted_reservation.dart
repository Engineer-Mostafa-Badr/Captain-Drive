import 'package:captain_drive/business_logic/arrive_reservation_cubit/arrive_reservation_cubit.dart';
import 'package:captain_drive/business_logic/captain_auth/cancel_reservation_cubit/cancel_reservation_cubit.dart';
import 'package:captain_drive/business_logic/driver_get_reservation_offer_cubit/driver_get_reservation_offer_cubit.dart';
import 'package:captain_drive/business_logic/set_ride_arrive_cubit/set_ride_complete_cubit.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/data/models/driver_get_offer_model.dart';
import 'package:captain_drive/screens/captain/captain_map/views/google_map_view.dart';
import 'package:captain_drive/screens/captain/captain_reservation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:captain_drive/business_logic/captain_cancel_reservation_offer_cubit/captain_cancel_reservation_offer_cubit.dart';
import 'package:captain_drive/business_logic/captain_get_driver_reservation_cubit/captain_get_driver_reservation_cubit.dart';
import 'package:captain_drive/data/models/captain_get_driver_reservation_model.dart';
import 'package:captain_drive/screens/captain/captain_notification_screen.dart';
import 'package:captain_drive/components/constant.dart';
import 'package:intl/intl.dart';

import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';

class CaptainAcceptedReservation extends StatefulWidget {
  const CaptainAcceptedReservation({super.key});

  @override
  State<CaptainAcceptedReservation> createState() =>
      _CaptainAcceptedReservationState();
}

class _CaptainAcceptedReservationState
    extends State<CaptainAcceptedReservation> {
  CaptainGetDriverReservationModel? captainGetDriverReservation;

  Future<void> _refresh() async {
    await CaptainGetDriverReservationCubit.get(context)
        .getCaptainDriverReservation();
    await DriverGetReservationOfferCubit.get(context).getCaptainOffer();
  }

  @override
  void initState() {
    CaptainGetDriverReservationCubit.get(context).getCaptainDriverReservation();
    DriverGetReservationOfferCubit.get(context).getCaptainOffer();
    super.initState();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  DriverGetOfferModel? driverGetReservationModel;

  bool hasDriverReservationData = false;
  bool hasCaptainReservationData = false;

  // late Map<int, String> activeRide = {};
  // Future<void> _loadActiveRideStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final statusCount = prefs.getInt('activeeRide') ?? 0;

  //   setState(() {
  //     activeRide = {
  //       for (var i in List.generate(statusCount, (i) => i))
  //         statusCount - 1 - i:
  //             prefs.getString('activeeRide_status_${statusCount - 1 - i}') ??
  //                 'activeeRide_default'
  //     };
  //     log("Loaded requestStatus in reverse order: $activeRide");
  //   });
  // }

  // Future<void> _saveActiveRideStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('activeeRide', activeRide.length);
  //   activeRide.forEach((index, status) async {
  //     await prefs.setString('activeeRide_status_$index', status);
  //     log("Saved status for index $index: $status");
  //   });
  // }

  Widget buildReservationFallbackUI() {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    // Show fallback UI only if neither Cubit has data
    if (!hasDriverReservationData && !hasCaptainReservationData) {
      return Column(
        children: [
          Center(
            child: Text(
              isArabic ? 'لا يوجد حجوزات متاحة.' : 'No reservations available.',
              style: const TextStyle(color: primaryColor),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          customMapButton(
            width: 300,
            height: 50,
            title: isArabic
                ? 'البحث عن الحجوزات القريبة'
                : 'Find nearby reservations',
            function: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CaptainReservationView(),
                ),
              );
            },
            color: primaryColor,
          ),
        ],
      );
    }
    return const SizedBox(); // Return empty widget if data exists
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GoogleMapView()));
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: backGroundColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    spreadRadius: 0.5,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                border: Border.all(
                                    color: const Color.fromRGBO(
                                        189, 189, 189, 1))),
                            child: const Center(
                              child: Icon(
                                Icons.location_on_outlined,
                                color: primaryColor,
                              ),
                            ),
                          ),
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
                              isArabic ? 'مصر' : 'Egypt',
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
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  spreadRadius: 0.5,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(189, 189, 189, 1))),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CaptainNotificationScreen()));
                            },
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  BlocConsumer<DriverGetReservationOfferCubit,
                      DriverGetReservationOfferState>(
                    listener: (context, state) {
                      if (state is DriverGetReservationOfferSuccess) {
                        setState(() {
                          driverGetReservationModel =
                              state.driverGetReservationModel;
                          hasDriverReservationData =
                              driverGetReservationModel != null &&
                                  driverGetReservationModel!.data != null &&
                                  driverGetReservationModel!
                                      .data!.reservationOffers.isNotEmpty;
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is DriverGetReservationOfferLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        );
                      } else if (state is DriverGetReservationOfferSuccess &&
                          hasDriverReservationData) {
                        // Data is available, show reservations
                        final reservationOffers = driverGetReservationModel!
                            .data!.reservationOffers[0];
                        return buildReservationOffer(reservationOffers);
                      } else if (state is DriverGetReservationOfferFailure) {
                        // return const Center(
                        //   child: Text(
                        //     'Failed to load reservations.',
                        //     style: TextStyle(color: Colors.red),
                        //   ),
                        // );
                      }
                      return const SizedBox();
                    },
                  ),

                  BlocConsumer<CaptainGetDriverReservationCubit,
                      CaptainGetDriverReservationState>(
                    listener: (context, state) {
                      if (state is CaptainGetDriverReservationSuccess) {
                        setState(() {
                          captainGetDriverReservation =
                              state.captainGetDriverReservation;
                          hasCaptainReservationData =
                              captainGetDriverReservation != null &&
                                  captainGetDriverReservation!.data != null;
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is CaptainGetDriverReservationSuccess &&
                          hasCaptainReservationData) {
                        // Data is available, show reservations
                        final reservation =
                            captainGetDriverReservation!.data!.reservation;
                        return buildReservationCard(reservation);
                      } else if (state is CaptainGetDriverReservationFailure) {
                        // return const Center(
                        //   child: Text(
                        //     'Failed to load reservations.',
                        //     style: TextStyle(color: Colors.red),
                        //   ),
                        // );
                      }
                      return const SizedBox();
                    },
                  ),

                  // Render fallback UI after both BlocConsumers if needed
                  if (!hasDriverReservationData && !hasCaptainReservationData)
                    buildReservationFallbackUI(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReservationCard(Reservation reservation) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArriveReservationCubit(),
        ),
        BlocProvider(
          create: (context) => SetRideCompleteCubit(),
        ),
      ],
      child: BlocConsumer<ArriveReservationCubit, ArriveReservationState>(
        listener: (context, state) {
          if (state is ArriveReservationSuccess) {
            if (state.arriveReservation.status!) {
              showToast(
                message: state.arriveReservation.message!,
                color: Colors.green,
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GoogleMapView()));
            } else {
              print(state.arriveReservation.message);
              print('تاكد من البيانات المدخله');
              showToast(
                message: state.arriveReservation.message!,
                color: Colors.red,
              );
            }
          }
          if (state is ArriveReservationFailure) {
            showToast(
              message: state.message,
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          // final activeRideStatus = activeRide[0] ?? 'activeeRide_default';
          return BlocConsumer<SetRideCompleteCubit, SetRideCompleteState>(
            listener: (context, state) {
              if (state is SetRideCompleteSuccess) {
                if (state.setRideCompleteModel.status) {
                  showToast(
                    message: state.setRideCompleteModel.message,
                    color: Colors.green,
                  );
                  // setState(() {
                  //   activeRide[0] = 'activeeRide_complete';

                  //   _saveActiveRideStatus();
                  // });
                } else {
                  print(state.setRideCompleteModel.message);
                  print('تاكد من البيانات المدخله');
                  showToast(
                    message: state.setRideCompleteModel.message,
                    color: Colors.red,
                  );
                }
              }
              if (state is SetRideCompleteFailure) {
                showToast(
                  message: state.message,
                  color: Colors.red,
                );
              }
            },
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF3F3F3),
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
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("From: "),
                          Text(
                            reservation.offer.request.stLocation,
                            style: const TextStyle(
                              color: Color(0XFF919191),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/time.png',
                            height: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            formatDate(reservation.createdAt),
                            style: const TextStyle(
                              color: Color(0XFF919191),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("To:     "),
                          Text(
                            reservation.offer.request.enLocation,
                            style: const TextStyle(
                              color: Color(0XFF919191),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/location (1).png'),
                          const SizedBox(width: 5),
                          Text(
                            '${reservation.offer.request.distance ?? '0.0'} Km away',
                            style: const TextStyle(
                              color: Color(0XFF919191),
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
                            "Price: ",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${reservation.offer.price}',
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
                          Image.asset('assets/images/chat.png'),
                          const SizedBox(width: 10),
                          Image.asset('assets/images/phone.png'),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // if (activeRideStatus == 'activeeRide_arrive')
                          //   Expanded(
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Expanded(
                          //           child: customMapButton(
                          //             title: 'Complete',
                          //             function: () {
                          //               SetRideCompleteCubit.get(context)
                          //                   .captainSetCompleteRide();
                          //             },
                          //             color: Colors.green,
                          //             width: 0,
                          //             height: 40,
                          //           ),
                          //         ),
                          //         const SizedBox(width: 10),
                          //         Expanded(
                          //           child: customMapButton(
                          //             title: 'Cancel',
                          //             function: () {
                          //               showCancelRide(
                          //                 context,
                          //               );
                          //             },
                          //             color: Colors.red,
                          //             width: 0,
                          //             height: 40,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   )
                          // else
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: customMapButton(
                                    title: 'Arriving',
                                    function: () {
                                      ArriveReservationCubit.get(context)
                                          .captainSetArriveReservation(
                                              reservationID: reservation.id);
                                      // setState(() {
                                      //   activeRide[0] = 'activeeRide_arrive';
                                      //   _saveActiveRideStatus();
                                      // });
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
                                      showCancelConfirmation(context,
                                          reservationID: reservation.id);
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
      ),
    );
  }

  String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    String formattedDate = DateFormat('dd MMM, HH:mm').format(parsedDate);
    return formattedDate;
  }

  void showCancelConfirmation(BuildContext context,
      {required int reservationID}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => CancelReservationCubit(),
          child: BlocConsumer<CancelReservationCubit, CancelReservationState>(
            listener: (context, state) {
              if (state is CancelReservationSuccess) {
                // Show success message or perform an action
                Navigator.pop(dialogContext); // Close the dialog
                showToast(
                    message: 'Reservation canceled successfully',
                    color: Colors.green);
              } else if (state is CancelReservationFailure) {
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
                          CancelReservationCubit.get(context)
                              .captainCancelReservation(
                                  reservationID: reservationID);
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

  Widget buildReservationOffer(ReservationOffer reservationOffer) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF3F3F3),
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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("From: "),
                Text(
                  reservationOffer.request.stLocation,
                  style: const TextStyle(
                    color: Color(0XFF919191),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/time.png',
                  height: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  formatDate(reservationOffer.createdAt),
                  style: const TextStyle(
                    color: Color(0XFF919191),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("To:     "),
                Text(
                  reservationOffer.request.enLocation,
                  style: const TextStyle(
                    color: Color(0XFF919191),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/location (1).png'),
                const SizedBox(width: 5),
                Text(
                  '${reservationOffer.request.distance ?? '0.0'} Km away',
                  style: const TextStyle(
                    color: Color(0XFF919191),
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
                  "Price: ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  '${reservationOffer.price}',
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
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: customMapButton(
                    title: 'Wait..',
                    function: () {},
                    color: Colors.grey,
                    width: 0,
                    height: 40,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: customMapButton(
                    title: 'Cancel',
                    function: () {
                      showCancelOffer(
                        context,
                        driverGetReservationModel!
                            .data!.reservationOffers[0].id,
                      );
                    },
                    color: Colors.red,
                    width: 0,
                    height: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showCancelOffer(BuildContext context, int offerId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => CaptainCancelReservationOfferCubit(),
          child: BlocConsumer<CaptainCancelReservationOfferCubit,
              CaptainCancelReservationOfferState>(
            listener: (context, state) {
              if (state is CaptainCancelReservationOfferSuccess) {
                Navigator.pop(dialogContext);
                showToast(
                  message: 'Reservation Offer canceled successfully',
                  color: Colors.green,
                );
              } else if (state is CaptainCancelReservationOfferFailure) {
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
                        'Are you sure that you want to cancel this reservation?',
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
                          CaptainCancelReservationOfferCubit.get(context)
                              .captainCancelReservationOffer(
                            offerId: offerId,
                          );
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

  // void showCancelRide(
  //   BuildContext context,
  // ) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext dialogContext) {
  //       return BlocProvider(
  //         create: (context) => CaptainCancelOfferCubit(),
  //         child: BlocConsumer<CaptainCancelOfferCubit, CaptainCancelOfferState>(
  //           listener: (context, state) {
  //             if (state is CaptainCancelOfferSuccess) {
  //               // Show success message or perform an action
  //               Navigator.pop(dialogContext); // Close the dialog
  //               showToast(
  //                   message: 'Ride canceled successfully', color: Colors.green);
  //             } else if (state is CaptainCancelOfferFailure) {
  //               // Show failure message
  //               showToast(message: state.message, color: Colors.red);
  //             }
  //           },
  //           builder: (context, state) {
  //             return Dialog(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0),
  //               ),
  //               child: Container(
  //                 padding: const EdgeInsets.all(20.0),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   color: const Color(0xffF2F2F2),
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Image.asset(
  //                       'assets/images/iconamoon_question-mark-circle.png',
  //                       height: 150,
  //                       fit: BoxFit.contain,
  //                     ),
  //                     const SizedBox(height: 20),
  //                     const Text(
  //                       'Are you sure that you want to cancel this ride?',
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.red,
  //                         fontFamily: 'PoppinsBold',
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                     const SizedBox(height: 25),
  //                     customMapButton(
  //                       width: double.infinity,
  //                       height: 50,
  //                       title: 'Cancel',
  //                       color: Colors.red,
  //                       function: () {
  //                         CaptainCancelOfferCubit.get(context)
  //                             .captainCancelOffer();
  //                         setState(() {
  //                           activeRide[0] = 'activeeRide_canceled';
  //                           _saveActiveRideStatus();
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
