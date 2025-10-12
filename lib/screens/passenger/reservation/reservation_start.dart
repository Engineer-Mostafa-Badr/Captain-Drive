import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/components/widget.dart';
import 'package:captain_drive/screens/passenger/cubit/cubit.dart';
import 'package:captain_drive/screens/passenger/layout_screen.dart';
import 'package:captain_drive/screens/passenger/reservation/reservation_time_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../localization/localization_cubit.dart';
import '../../../shared/local/cach_helper.dart';
import '../cubit/states.dart';

class ReservationStart extends StatefulWidget {
  const ReservationStart({super.key});

  @override
  State<ReservationStart> createState() => _ReservationStartState();
}

class _ReservationStartState extends State<ReservationStart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passengerCubit.get(context).getReservation();
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
    String nameVehicle({required var number}) {
      switch (number) {
        case '3':
          return isArabic ? 'اسكوتر' : 'Scooter';
        case '1':
          return isArabic ? 'سياره عاديه' : 'Car';
        case '2':
          return isArabic ? 'سياره مكيفه' : 'Air-conditioned car';
        case '4':
          return isArabic ? 'تاكسي' : 'taxi';
        case '5':
          return isArabic ? 'باص' : 'Bus';
      }
      return 'غير معروف';
    }

    return BlocConsumer<passengerCubit, PassengerStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var reservationData =
            passengerCubit.get(context).getReservationModel?.data;

        // Check if the data is not null and not empty
        if (reservationData == null) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top image
                      Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: Image.asset(
                              'assets/images/trip.png', // Replace with your image
                              fit: BoxFit.contain,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LayoutScreen()));
                              },
                              icon: const Icon(Icons.arrow_back_ios)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ), // Push content to the bottom
                      Text(
                        isArabic ? 'احجز' : 'Booking',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // List of instructions with icons
                      Column(
                        children: [
                          _buildOptionRow(
                            icon: Icons.calendar_today,
                            text: isArabic
                                ? 'اختر موعد الالتقاء الدقيق '
                                : 'Choose the exact meeting time', // Arabic text
                          ),
                          _buildOptionRow(
                            icon: Icons.access_time,
                            text: isArabic
                                ? 'يشمل وقت انتظار إضافي لتلبية متطلبات مشوارك'
                                : 'Includes additional waiting time to accommodate your ride requirements.', // Arabic text
                          ),
                          _buildOptionRow(
                            icon: Icons.cancel,
                            text: isArabic
                                ? 'يمكنك إلغاء الحجز بدون تحمل أي رسوم قبل موعده بمدة تصل إلى 60 دقيقة'
                                : 'You can cancel your reservation without any fees up to 60 minutes before your scheduled time.', // Arabic text
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Reserve button
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the Choose Date & Time screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChooseDateTimeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          backgroundColor: primaryColor, // Button color
                        ),
                        child: Text(
                          isArabic ? 'احجز مشواراً' : 'Book a ride',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        var request = reservationData.request;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LayoutScreen()));
                              },
                              icon: const Icon(Icons.arrow_back_ios)),
                          const SizedBox(width: 125),
                          Text(
                            isArabic ? 'الحجز' : 'Booking',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
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
                          children: [
                            isArabic
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              request.stLocation ?? 'Unknown',
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                color: Color(0XFF919191),
                                                fontSize: 12,
                                              ),
                                              // overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Text("  : من "),
                                      const SizedBox(width: 5),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      const Text("From :   "),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              request.stLocation ?? 'Unknown',
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                color: Color(0XFF919191),
                                                fontSize: 12,
                                              ),
                                              // overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            isArabic
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          request.enLocation ?? 'Unknown',
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            color: Color(0XFF919191),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const Text("  :  الي"),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      const Text("To :       "),
                                      Expanded(
                                        child: Text(
                                          request.enLocation ?? 'Unknown',
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            color: Color(0XFF919191),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            isArabic
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          request.time.split(' ')[0] ??
                                              'Unknown', // Extract only the date
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            color: Color(0XFF919191),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const Text("  :  التاريخ"),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      const Text("date :       "),
                                      Text(
                                        request.time.split(' ')[0] ??
                                            'Unknown',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          color: Color(0XFF919191),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            isArabic
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          request.time.split(' ')[1] ??
                                              'Unknown', // Extract only the date
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            color: Color(0XFF919191),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const Text("  :  الساعه"),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      const Text("time :       "),
                                      Text(
                                        request.time.split(' ')[1] ??
                                            'Unknown',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          color: Color(0XFF919191),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            isArabic
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          nameVehicle(
                                                  number: request.vehicle
                                                      .toString()) ??
                                              'Unknown', // Extract only the date
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            color: Color(0XFF919191),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const Text("  :  نوع السياره"),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      const Text("vehicle type :  "),
                                      Text(
                                        nameVehicle(
                                                number: request.vehicle
                                                    .toString()) ??
                                            'Unknown', // Extract only the date
                                        textAlign: TextAlign.end,

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
                            isArabic
                                ? Row(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/time.png',
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            request.createdAt
                                                    .split('T')
                                                    .first ??
                                                '',
                                            style: const TextStyle(
                                              color: Color(0XFF919191),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      const Text(
                                        ' ج ',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        '${request.price ?? 0.0}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF0A8800),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
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
                                        '${request.price ?? 0.0}',
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
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/time.png',
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            request.createdAt
                                                    .split('T')
                                                    .first ??
                                                '',
                                            style: const TextStyle(
                                              color: Color(0XFF919191),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ConditionalBuilder(
                      condition:
                          state is! PassengerCancelReservationRequestLoading,
                      builder: (context) => customButton(
                          title:
                              isArabic ? 'الغاء الحجز' : 'cancel reservation',
                          function: () {
                            passengerCubit.get(context).cancelReservation(
                                reservation_request_id: request.id);
                          }),
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16), // Text color set to black
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: primaryColor),
        ],
      ),
    );
  }
}
