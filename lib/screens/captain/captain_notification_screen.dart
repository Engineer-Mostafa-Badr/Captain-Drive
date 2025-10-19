import 'package:captain_drive/core/components/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/localization_cubit.dart';
import '../../core/storage/cache_helper.dart';

class CaptainNotificationScreen extends StatefulWidget {
  const CaptainNotificationScreen({super.key});

  @override
  State<CaptainNotificationScreen> createState() =>
      _CaptainNotificationScreenState();
}

class _CaptainNotificationScreenState extends State<CaptainNotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLanguage();
  }

  String? languageCode;
  // Variable to hold the language code
  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      const SizedBox(
                        width: 100,
                      ),
                      Text(
                        isArabic ? 'إشعارات' : 'Notifications',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
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
                        Row(
                          children: [
                            SizedBox(
                              width: 75,
                              height: 75,
                              child: Image.asset('assets/images/photo.png'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Admin',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        'assets/images/time.png',
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        '1 sec ago',
                                        style: TextStyle(
                                          color: Color(0XFF919191),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                            color: const Color(0xFFEDEDED),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('WAYمرحبا بيك في '),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
