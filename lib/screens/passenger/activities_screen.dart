import 'package:captain_drive/components/constant.dart';
import 'package:captain_drive/screens/passenger/cubit/cubit.dart';
import 'package:captain_drive/screens/passenger/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  void initState() {
    super.initState();
    passengerCubit.get(context).getActivities();
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      const SizedBox(width: 125),
                      Text(
                        isArabic ? 'النشاط' : 'Activities',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<passengerCubit, PassengerStates>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    var activitiesData =
                        passengerCubit.get(context).getActivitiesModel?.data;

                    // Check if the data is not null and not empty
                    if (activitiesData == null || activitiesData.isEmpty) {
                      return Center(
                          child: Text(isArabic
                              ? 'لم يتم العثور على أي أنشطة'
                              : 'No activities found'));
                    }

// Proceed with the first element if the list is not empty
                    var cubit = activitiesData.first.data ?? [];
                    return cubit.isEmpty
                        ? Center(
                            child: Text(isArabic
                                ? 'لم يتم العثور على أي أنشطة'
                                : 'No activities found'))
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cubit.length,
                            itemBuilder: (context, index) {
                              var activity = cubit[index];
                              var offer = activity.offer;
                              var request = offer.request;

                              return Container(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        request.stLocation ??
                                                            'Unknown',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0XFF919191),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        request.stLocation ??
                                                            'Unknown',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0XFF919191),
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
                                                    request.enLocation ??
                                                        'Unknown',
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
                                                    request.enLocation ??
                                                        'Unknown',
                                                    textAlign: TextAlign.end,
                                                    style: const TextStyle(
                                                      color: Color(0XFF919191),
                                                      fontSize: 12,
                                                    ),
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
                                                        color:
                                                            Color(0XFF919191),
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
                                                        color:
                                                            Color(0XFF919191),
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
                              );
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
