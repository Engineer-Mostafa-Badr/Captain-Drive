import 'package:captain_drive/data/models/get_captain_activities/get_captain_activities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../localization/localization_cubit.dart';
import '../../shared/local/cach_helper.dart';

class ContainerListView extends StatefulWidget {
  final GetCaptainActivitiesModel getCaptainActivitiesModel;
  const ContainerListView({super.key, required this.getCaptainActivitiesModel});

  @override
  State<ContainerListView> createState() => _ContainerListViewState();
}

class _ContainerListViewState extends State<ContainerListView> {
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

    // Assume data list is not empty and has valid pages
    final ridesData = widget.getCaptainActivitiesModel.data
            ?.expand((page) => page.data ?? [])
            .toList() ??
        [];

    return ListView.builder(
      itemCount: ridesData.length, // Adjust based on the number of rides
      itemBuilder: (context, index) {
        final ride = ridesData[index]; // Access the correct ride by index
        final request = ride.offer?.request;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
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
              child: isArabic
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/time.png', // Ensure this asset exists
                              height: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              ride.createdAt?.substring(0, 10) ??
                                  'Unknown Date', // Use dynamic date
                              style: const TextStyle(
                                color: Color(0XFF919191),
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              request?.stLocation ?? 'Unknown Start Location',
                              style: const TextStyle(
                                color: Color(0XFF919191),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(": من"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              request?.enLocation ?? 'Unknown End Location',
                              style: const TextStyle(
                                color: Color(0XFF919191),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(": الي"),
                          ],
                        ),
                        const Divider(
                          color: Colors.black26,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'ج',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              ride.offer?.price?.toString() ??
                                  '0.00', // Use dynamic price
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0A8800),
                              ),
                            ),
                            const Text(
                              " : السعر",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("From :   "),
                            Text(
                              request?.stLocation ?? 'Unknown Start Location',
                              style: const TextStyle(
                                color: Color(0XFF919191),
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/images/time.png', // Ensure this asset exists
                              height: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              ride.createdAt?.substring(0, 10) ??
                                  'Unknown Date', // Use dynamic date
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
                            const Text("To :       "),
                            Text(
                              request?.enLocation ?? 'Unknown End Location',
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
                              "Price : ",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              ride.offer?.price?.toString() ??
                                  '0.00', // Use dynamic price
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
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
