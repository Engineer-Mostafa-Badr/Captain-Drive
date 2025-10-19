import 'package:captain_drive/business_logic/captain_activities_cubit/captain_activities_cubit.dart';
import 'package:captain_drive/core/components/constant.dart';
import 'package:captain_drive/core/components/widget.dart';
import 'package:captain_drive/data/models/get_captain_activities/get_captain_activities.dart';
import 'package:captain_drive/screens/captain/captain_activities_list_view.dart';
import 'package:captain_drive/features/map/driver/presentation/views/google_map_view.dart';
import 'package:captain_drive/screens/captain/captain_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../core/localization/localization_cubit.dart';
import '../../core/storage/cache_helper.dart';

class CaptainActivitiesScreen extends StatefulWidget {
  const CaptainActivitiesScreen({super.key});

  @override
  State<CaptainActivitiesScreen> createState() =>
      _CaptainActivitiesScreenState();
}

class _CaptainActivitiesScreenState extends State<CaptainActivitiesScreen> {
  int currentPage = 0;
  static const int itemsPerPage = 20;

  GetCaptainActivitiesModel? getCaptainActivitiesModel;

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

    return BlocProvider(
      create: (context) => CaptainActivitiesCubit()..getCaptainData(),
      child: BlocConsumer<CaptainActivitiesCubit, CaptainActivitiesState>(
        listener: (context, state) {
          if (state is CaptainActivitiesSuccess) {
            if (state.getCaptainActivitiesModel.status!) {
              setState(() {
                getCaptainActivitiesModel = state.getCaptainActivitiesModel;
              });
            } else {
              showToast(
                message: state.getCaptainActivitiesModel.message!,
                color: Colors.red,
              );
            }
          } else if (state is CaptainActivitiesFailure) {
            showToast(
              message: state.message,
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          if (getCaptainActivitiesModel == null) {
            return const Scaffold(
              backgroundColor: AppColor.backGroundColor,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Convert dynamic data to a List<Ride>
          final allRidesData = getCaptainActivitiesModel!.data
                  ?.expand((page) => page.data ?? [])
                  .whereType<Ride>() // Ensure the data is of type Ride
                  .cast<Ride>()
                  .toList() ??
              [];

          // Calculate total number of pages
          int numberOfPages = (allRidesData.length) ~/ itemsPerPage;

          // Ensure numberPages is at least 1 to avoid issues with the paginator
          numberOfPages = numberOfPages > 0 ? numberOfPages : 1;

          // Get the current page's items
          final paginatedData = allRidesData
              .skip(currentPage * itemsPerPage)
              .take(itemsPerPage)
              .toList();

          return Scaffold(
            backgroundColor: AppColor.backGroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header and notification bell
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
                                  color: AppColor.backGroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26, // Shadow color
                                      blurRadius: 2, // Softening the shadow
                                      spreadRadius: 0.5, // Extending the shadow
                                      offset: Offset(0,
                                          0), // No offset to center the shadow
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(189, 189, 189, 1),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  isArabic ? "مكانك" : 'Location',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text(
                                  isArabic ? 'مصر' : 'Egypt',
                                  style: const TextStyle(
                                      color: AppColor.primaryColor),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CaptainNotificationScreen()));
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColor.backGroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26, // Shadow color
                                      blurRadius: 2, // Softening the shadow
                                      spreadRadius: 0.5, // Extending the shadow
                                      offset: Offset(0,
                                          0), // No offset to center the shadow
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(189, 189, 189, 1),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.notifications_none_outlined,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Conditionally render the ContainerListView or a loading indicator
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.43,
                        child: paginatedData.isNotEmpty
                            ? ContainerListView(
                                getCaptainActivitiesModel:
                                    GetCaptainActivitiesModel(
                                  status: true,
                                  data: [
                                    Data(
                                      data: paginatedData,
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Text(isArabic
                                    ? 'لا توجد بيانات متاحة'
                                    : 'No Data Available'),
                              ),
                      ),

                      // Pagination widget
                      NumberPaginator(
                        numberPages: numberOfPages,
                        initialPage: currentPage, // Ensure initialPage is valid
                        config: const NumberPaginatorUIConfig(
                          buttonSelectedForegroundColor: Colors.white,
                          buttonUnselectedForegroundColor: Colors.black,
                          buttonSelectedBackgroundColor: Colors.blueGrey,
                        ),
                        onPageChange: (index) {
                          setState(() {
                            currentPage = index;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
