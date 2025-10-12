import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/screens/passenger/model/get_all_offers_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../../localization/localization_cubit.dart';
import '../../../network/end_points.dart';
import '../../../shared/local/cach_helper.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'active_ride_screen.dart'; // تأكد من وجود الاستيراد الصحيح لـ cubit

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  List<dynamic> _offers = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startOfferCheck();
    passengerCubit.get(context).getRequest();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startOfferCheck() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // Fetch latest offers and request model
      passengerCubit.get(context).getRequest();
      passengerCubit.get(context).getAllOffers();

      // Replace with actual logic to fetch and set offers data
      final offers = await _fetchOffers(); // Assume this method fetches offers

      if (offers!.isNotEmpty) {
        setState(() {
          _offers = offers;
        });
        timer.cancel(); // Stop checking once offers are available
      }
    });
  }

  Future<List<Offer>?> _fetchOffers() async {
    // Replace this with your actual method to fetch offers
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return passengerCubit
        .get(context)
        .getAllOffersModel
        ?.data
        ?.offers; // Replace with actual offer data
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<passengerCubit, PassengerStates>(
      listener: (context, state) {
        if (state is PassengerRejectOfferSuccess) {
          showToast(message: 'تم الغاء هذا العرض', color: Colors.red);
        }
      },
      builder: (context, state) => Scaffold(
        body: _offers.isEmpty ? _buildLoadingView() : _buildOffersListView(),
      ),
    );
  }

  Widget _buildLoadingView() {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    // final location = state.getRequestModel!.data.requests[0].enLocation;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                _offers.isEmpty
                    ? isArabic
                        ? "...في انتظار العرض"
                        : 'Waiting for Offer...'
                    : isArabic
                        ? "طلب من"
                        : 'Request from',
                style: const TextStyle(color: Colors.blueAccent)),
            const SizedBox(
              height: 20,
            ),
            Text(
              isArabic
                  ? "! نحن نُجهز أفضل العروض لك"
                  : 'We are preparing the best offers for you!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 30),
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueAccent,
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(isArabic ? "...انتظر" : 'Waiting...'),
                      TyperAnimatedText(isArabic
                          ? "...لا تزال في الانتظار"
                          : 'Still Waiting...'),
                      TyperAnimatedText(
                          isArabic ? "...من فضلك انتظر" : 'Please Wait...'),
                      TyperAnimatedText(isArabic
                          ? "...من فضلك انتظر، نحن نقوم بتحضير سيارتك"
                          : 'Please Wait, we are preparing your car...'),
                      TyperAnimatedText(isArabic
                          ? "...نحن نعمل على تجهيز كل شيء"
                          : 'We are working on preparing everything...'),
                      TyperAnimatedText(isArabic
                          ? "...سيارتك في الطريق"
                          : 'Your car is on the way...'),
                    ],
                    repeatForever: true,
                    pause: const Duration(
                        milliseconds: 1000), // Pause between each animation
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  passengerCubit
                          .get(context)
                          .getRequestModel
                          ?.data
                          .requests[0]
                          .stLocation ??
                      '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Icon(Icons.arrow_downward_outlined),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  passengerCubit
                          .get(context)
                          .getRequestModel
                          ?.data
                          .requests[0]
                          .enLocation ??
                      '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      '${passengerCubit.get(context).getRequestModel?.data.requests[0].price}' ' LE',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    //Icon(Icons.monetization_on_outlined,color:Colors.black54 ,),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        passengerCubit.get(context).cancelRequest(
                            ride_request_id: passengerCubit
                                .get(context)
                                .getRequestModel
                                ?.data
                                .requests[0]
                                .id);
                        Navigator.pop(context);
                        // Add logic to cancel waiting or refresh
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      child: const Text('Cancel Waiting',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersListView() {
    return ListView.builder(
      itemCount: _offers.length,
      itemBuilder: (context, index) {
        final offer = _offers[index]; // Access the current offer
        final driver = offer.driver; // Access the driver details from the offer

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageDomain + driver.picture,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name ?? 'Unknown Driver',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(driver.vehicle!.driverId.toString(),
                              style:
                                  const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        driver.vehicle?.model ??
                            'Unknown Model', // Display the vehicle model
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 14, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            '${driver.rate ?? 'No Rating'}', // Display 'No Rating' if driver.rate is null
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${offer.price} EGP', // Display the offer price
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              // Reject the offer
                              passengerCubit
                                  .get(context)
                                  .rejectOffer(offer_id: offer.id);

                              // After rejecting the offer, check if the offers list is empty
                              setState(() {
                                _offers.remove(
                                    offer); // Remove the offer from the list
                                if (_offers.isEmpty) {
                                  // If no offers are available, show loading view
                                  _buildLoadingView();
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        BlocConsumer<passengerCubit, PassengerStates>(
                          listener: (context, state) {
                            if (state is PassengerAcceptOfferSuccess) {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors
                                    .transparent, // اختياري لجعل الخلفية شفافة
                                isDismissible:
                                    false, // Prevents closing the sheet by tapping outside
                                enableDrag:
                                    false, // Disables closing by swiping down

                                builder: (context) {
                                  return Container(
                                    height:
                                        600, // استبدل 600 بالارتفاع الثابت الذي تريده
                                    decoration: const BoxDecoration(
                                      color: Colors
                                          .white, // لون الخلفية للنافذة المنبثقة
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child:
                                        const ActiveRideScreen(), // هنا تعرض محتوى OfferScreen
                                  );
                                },
                              );
                            }
                          },
                          builder: (context, state) => ConditionalBuilder(
                            condition: state is! PassengerAcceptOfferLoading,
                            builder: (context) => CircleAvatar(
                              backgroundColor: Colors.green,
                              child: IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.white),
                                onPressed: () {
                                  print(offer.id);
                                  passengerCubit
                                      .get(context)
                                      .acceptOffer(offer_id: offer.id);
                                  // Handle accept action
                                },
                              ),
                            ),
                            fallback: (context) =>
                                const Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
