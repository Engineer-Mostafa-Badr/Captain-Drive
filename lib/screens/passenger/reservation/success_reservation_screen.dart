import 'package:captain_drive/core/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/cache_helper.dart';
import '../../../core/localization/localization_cubit.dart';

import '../../../features/home/passenger/presentation/views/layout_screen.dart';

class SuccessReservationScreen extends StatefulWidget {
  const SuccessReservationScreen({super.key});

  @override
  State<SuccessReservationScreen> createState() =>
      _SuccessReservationScreenState();
}

class _SuccessReservationScreenState extends State<SuccessReservationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(10), // Set the desired radius here
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isArabic
                          ? 'تم حجز الرحله بنجاح'
                          : 'The ride has been booked successfully.',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Image.asset('assets/images/true.png'),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      isArabic
                          ? 'يمكنك متابعه الرحله من صفحه الحجز'
                          : 'You can follow the trip from the booking page.',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LayoutScreen()));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isArabic
                                  ? 'العوده للرئيسيه'
                                  : 'Back to Home page',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
