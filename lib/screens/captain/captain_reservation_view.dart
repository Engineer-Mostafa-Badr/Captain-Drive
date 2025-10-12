import 'package:captain_drive/business_logic/capatin_get_reservation_cubit/captain_get_reservation_cubit.dart';
import 'package:captain_drive/business_logic/captain_make_reservation_offer_cubit/captain_make_reservation_offer_cubit.dart';
import 'package:captain_drive/business_logic/driver_get_reservation_offer_cubit/driver_get_reservation_offer_cubit.dart';
import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/data/models/captain_get_reservation_model.dart';
import 'package:captain_drive/data/models/driver_get_offer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';

class CaptainReservationView extends StatefulWidget {
  const CaptainReservationView({super.key});

  @override
  State<CaptainReservationView> createState() => _CaptainReservationViewState();
}

class _CaptainReservationViewState extends State<CaptainReservationView> {
  CaptainGetReservationModel? captainGetReservationModel;
  DriverGetOfferModel? driverGetReservationModel;
  Future<void> _refresh() async {
    await CaptainGetReservationCubit.get(context).getCaptainReservation();
  }

  late Map<int, String> requestStatus = {};

  @override
  void initState() {
    super.initState();

    CaptainGetReservationCubit.get(context).getCaptainReservation();

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
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/images/left_arrow.png',
                            ),
                          ),
                          const Spacer(),
                          Text(
                            isArabic
                                ? 'الحجوزات القريبة'
                                : 'Nearby Reservations',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    BlocConsumer<CaptainGetReservationCubit,
                        CaptainGetReservationState>(
                      listener: (context, state) {
                        if (state is CaptainGetReservationSuccess) {
                          if (state.captainGetReservationModel.status!) {
                            setState(() {
                              captainGetReservationModel =
                                  state.captainGetReservationModel;
                            });
                          } else {
                            showToast(
                              message:
                                  state.captainGetReservationModel.message!,
                              color: Colors.red,
                            );
                          }
                        } else if (state is CaptainGetReservationFailure) {
                          showToast(
                            message: state.message,
                            color: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (captainGetReservationModel == null ||
                            captainGetReservationModel!.data == null ||
                            captainGetReservationModel!
                                    .data!.reservationRequests ==
                                null) {
                          return Center(
                            child: Text(
                              isArabic
                                  ? 'ليس لديك أي حجوزات متاحة بالقرب منك'
                                  : 'You have No Reservations available Nearby',
                              style: const TextStyle(color: primaryColor),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: captainGetReservationModel!
                              .data!.reservationRequests!.length,
                          itemBuilder: (context, index) {
                            // Get the reversed index
                            final reversedIndex = captainGetReservationModel!
                                    .data!.reservationRequests!.length -
                                1 -
                                index;
                            final request = captainGetReservationModel!
                                .data!.reservationRequests![reversedIndex];

                            return BlocConsumer<
                                CaptainMakeReservationOfferCubit,
                                CaptainMakeReservationOfferState>(
                              listener: (context, state) {
                                if (state
                                    is CaptainMakeReservationOfferSuccess) {
                                  if (state.captainMakeReservationOfferModel
                                      .status) {
                                    showToast(
                                      message: isArabic
                                          ? 'تم إجراء عرض الحجز بنجاح'
                                          : 'Reservation offer made successfully',
                                      color: Colors.green,
                                    );
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    showToast(
                                      message: state
                                          .captainMakeReservationOfferModel
                                          .message,
                                      color: Colors.red,
                                    );
                                  }
                                } else if (state
                                    is CaptainMakeReservationOfferFailure) {
                                  showToast(
                                    message: state.message,
                                    color: Colors.red,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return BlocConsumer<
                                    DriverGetReservationOfferCubit,
                                    DriverGetReservationOfferState>(
                                  listener: (context, state) {
                                    if (state
                                        is DriverGetReservationOfferSuccess) {
                                      if (state
                                          .driverGetReservationModel.status) {
                                        setState(() {
                                          driverGetReservationModel =
                                              state.driverGetReservationModel;
                                        });
                                      } else {
                                        showToast(
                                          message: state
                                              .driverGetReservationModel
                                              .message,
                                          color: Colors.red,
                                        );
                                      }
                                    } else if (state
                                        is DriverGetReservationOfferFailure) {
                                      showToast(
                                        message: state.message,
                                        color: Colors.red,
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    const Text("From: "),
                                                    Text(
                                                      request.stLocation ??
                                                          'Unknown',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0XFF919191),
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
                                                      request.time != null
                                                          ? formatDate(
                                                              request.time!)
                                                          : 'Unknown Date',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0XFF919191),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    const Text("To: "),
                                                    Text(
                                                      request.enLocation ??
                                                          'Unknown',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0XFF919191),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/location (1).png'),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      '${request.distance?.toStringAsFixed(2) ?? '0.0'} Km away',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0XFF919191),
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
                                                      (request.price ?? 0.0)
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            Color(0xFF0A8800),
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: customMapButton(
                                                        title: 'Make Offer',
                                                        function: () {
                                                          CaptainMakeReservationOfferCubit
                                                                  .get(context)
                                                              .captainMakeReservationOffer(
                                                            price:
                                                                request.price ??
                                                                    100,
                                                            requestId:
                                                                request.id,
                                                          );
                                                        },
                                                        color: Colors.green,
                                                        width: 0,
                                                        height: 40,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    // Format to get day, month, hour, and minute
    String formattedDate = DateFormat('dd MMM, HH:mm').format(parsedDate);
    return formattedDate;
  }
}
